using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.json;

namespace bob.builder.build.plugin {

	public class BuildApplicationPlugin : AbstractBobBuildPlugin {

		private const string PATH_SEPARATOR = Path.DIR_SEPARATOR_S;
		private const string PLUGIN_NAME = "build";
		
        private Logger LOGGER = Logger.getLogger("BuildApplicationPlugin");

		private BuildConfigurationBuilder libraryBuildConfigurationBuilder;
		private BuildConfigurationBuilder runtimeBuildConfigurationBuilder;

		public BuildApplicationPlugin() {
			base(PLUGIN_NAME);
		}

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			libraryBuildConfigurationBuilder = new BuildConfigurationBuilder.fromJSONObject(pluginRecipe.jsonConfiguration);
			runtimeBuildConfigurationBuilder = new BuildConfigurationBuilder.fromJSONObject(pluginRecipe.jsonConfiguration);
		}

		public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
			try {
				ValaCodeCompilerOutcome libraryCompilationOutcome = compileLibraryBinary(projectRecipe);
				compileRuntimeBinary(projectRecipe, libraryCompilationOutcome);
			} catch (CompilationError e) {
	    		LOGGER.logError("Compilation failed with message: %s.", e.message);
	    		return;
	    	}
	    	LOGGER.logSuccess("Code compilation finished.");
	    }

	    private ValaCodeCompilerOutcome compileLibraryBinary(BobBuildProjectRecipe projectRecipe) throws CompilationError {
    		LOGGER.logInfo("Generating library binary.");
	    	ValaCodeCompiler libCompiler = initializeLibraryCodeCompiler(projectRecipe);
    		ValaCodeCompilerOutcome libraryCompilationOutcome = libCompiler.compile();
    		if (libraryCompilationOutcome.binaryGenerated) {
    			LOGGER.logSuccess("Library binary compilation finished.");
    		}
    		return libraryCompilationOutcome;
	    }

	    private void compileRuntimeBinary(BobBuildProjectRecipe projectRecipe, ValaCodeCompilerOutcome libraryCompilationOutcome) throws CompilationError {
    		LOGGER.logInfo("Generating runtime binary.");
	    	ValaCodeCompiler runtimeCompiler = initializeRuntimeCodeCompiler(projectRecipe, libraryCompilationOutcome);
    		ValaCodeCompilerOutcome binaryCompilationOutcome = runtimeCompiler.compile();
    		if (binaryCompilationOutcome.binaryGenerated) {
	    		LOGGER.logSuccess("Runtime binary compilation finished.");
    		}
	    }

	    private ValaCodeCompiler initializeLibraryCodeCompiler(BobBuildProjectRecipe projectRecipe) {
			BuildConfiguration buildConfiguration = libraryBuildConfigurationBuilder
				.libraryScope()
				.dependencies(projectRecipe.dependencies)
				.sources(projectRecipe.libSourceFiles)
				.targetDirectory(BobDirectories.DIRECTORY_TARGET_LIB)
				.targetFileName(BobFiles.FILE_TARGET_LIBRARY_NAME.printf(projectRecipe.shortName))
				.generateVapiAndC()
				.vapiOutputDirectory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_VAPI)
				.vapiOutputFileName(BobFiles.FILE_SOURCE_VAPI_NAME.printf(projectRecipe.shortName, projectRecipe.version))
				.cOutputDirectory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_C)
				.cHeaderFileName(BobFiles.FILE_SOURCE_C_HEADER_NAME.printf(projectRecipe.shortName, projectRecipe.version))
				.ccOptions({"-fPIC", "-shared"})
				.build();
			return new ValaCodeCompiler(buildConfiguration);
		}

		private ValaCodeCompiler initializeRuntimeCodeCompiler(BobBuildProjectRecipe projectRecipe, ValaCodeCompilerOutcome libraryCompilationOutcome) {
			runtimeBuildConfigurationBuilder
				.runtimeScope()
				.dependencies(projectRecipe.dependencies)
				.sources(projectRecipe.mainSourceFiles)
				.targetDirectory(BobDirectories.DIRECTORY_TARGET)
				.targetFileName(projectRecipe.shortName)
				.ccOption("-Wl,-rpath=\$ORIGIN/%s".printf(BobDirectories.DIRECTORY_LIB))
				.ccOption("-L%s".printf(BobDirectories.DIRECTORY_TARGET_LIB));

			if (libraryCompilationOutcome.binaryGenerated) {
				LOGGER.logInfo("Using generated library as dependency.");

				runtimeBuildConfigurationBuilder.useLibrary(bobLibrary => {
					bobLibrary.name = projectRecipe.shortName;
					bobLibrary.version = projectRecipe.version;
					bobLibrary.cHeadersDirectory = BobDirectories.DIRECTORY_SOURCE_LIBRARY_C;
					bobLibrary.vapiDirectory = BobDirectories.DIRECTORY_SOURCE_LIBRARY_VAPI;
					bobLibrary.scope = BobBuildProjectDependencyScope.RUNTIME;
				});
			}
				
			return new ValaCodeCompiler(runtimeBuildConfigurationBuilder.build());
		}
	}
}