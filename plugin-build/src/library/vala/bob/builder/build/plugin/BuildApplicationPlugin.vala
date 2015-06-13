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
			compileLibraryBinary(projectRecipe);
			compileRuntimeBinary(projectRecipe);	    	

	    	LOGGER.logInfo("Code compilation finished.");
	    }

	    private void compileLibraryBinary(BobBuildProjectRecipe projectRecipe) {
	    	ValaCodeCompiler libCompiler = initializeLibraryCodeCompiler(projectRecipe);
	    	try {
	    		LOGGER.logInfo("Generating library binary.");
	    		libCompiler.compile();
	    	} catch (CompilationError e) {
	    		LOGGER.logError("Compilation failed with message: %s.", e.message);
	    		return;
	    	}
	    }

	    private void compileRuntimeBinary(BobBuildProjectRecipe projectRecipe) {
	    	ValaCodeCompiler runtimeCompiler = initializeRuntimeCodeCompiler(projectRecipe);
	    	try {
	    		LOGGER.logInfo("Generating runtime binary.");
	    		runtimeCompiler.compile();
	    	} catch (CompilationError e) {
	    		LOGGER.logError("Compilation failed with message: %s.", e.message);
	    		return;
	    	}
	    }

	    private ValaCodeCompiler initializeLibraryCodeCompiler(BobBuildProjectRecipe projectRecipe) {
			BuildConfiguration buildConfiguration = libraryBuildConfigurationBuilder
				.dependencies(projectRecipe.dependencies)
				.sources(projectRecipe.libSourceFiles)
				.targetDirectory(BobDirectories.DIRECTORY_TARGET_LIB)
				.targetFileName("lib%s.so".printf(projectRecipe.shortName))
				.generateVapi()
				.vapiOutputDirectory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_VAPI)
				.vapiOutputFileName("%s.vapi".printf(projectRecipe.shortName))
				.cOutputDirectory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_C)
				.cHeaderFileName("%s.h".printf(projectRecipe.shortName))
				.ccOptions({"-fPIC", "-shared"})
				.build();
			return new ValaCodeCompiler(buildConfiguration);
		}

		private ValaCodeCompiler initializeRuntimeCodeCompiler(BobBuildProjectRecipe projectRecipe) {
			BuildConfiguration buildConfiguration = runtimeBuildConfigurationBuilder
				.dependencies(projectRecipe.dependencies)
				.sources(projectRecipe.mainSourceFiles)
				.addSourceFromRelativeLocation("%s%s%s.vapi".printf(BobDirectories.DIRECTORY_SOURCE_LIBRARY_VAPI, PATH_SEPARATOR, projectRecipe.shortName))
				.targetDirectory(BobDirectories.DIRECTORY_TARGET)
				.targetFileName(projectRecipe.shortName)
				.ccOptions({"-Wl,-rpath=\$ORIGIN/%s".printf(BobDirectories.DIRECTORY_LIB), "-L%s".printf(BobDirectories.DIRECTORY_TARGET_LIB), "-l%s".printf(projectRecipe.shortName), "-I%s".printf(BobDirectories.DIRECTORY_SOURCE_LIBRARY_C)})
				.build();
			return new ValaCodeCompiler(buildConfiguration);
		}
	}
}