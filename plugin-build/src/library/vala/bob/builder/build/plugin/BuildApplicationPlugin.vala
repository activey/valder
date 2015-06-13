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
		private const string TARGET_FOLDER_DEFAULT = "target";
		private const string SRC_FOLDER_DEFAULT = "src";
		private const string LIB_FOLDER_DEFAULT = "lib";
		private const string TARGET_LIB_FOLDER_DEFAULT = TARGET_FOLDER_DEFAULT + PATH_SEPARATOR + LIB_FOLDER_DEFAULT;
		private const string SRC_FOLDER_LIBRARY = SRC_FOLDER_DEFAULT + PATH_SEPARATOR + "library";
		private const string LIB_VAPI_OUTPUT_DEFAULT = SRC_FOLDER_LIBRARY + PATH_SEPARATOR + "vapi";
		private const string LIB_C_OUTPUT_DEFAULT = SRC_FOLDER_LIBRARY + PATH_SEPARATOR + "c";
		
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
				.targetDirectory(TARGET_LIB_FOLDER_DEFAULT)
				.targetFileName("lib%s.so".printf(projectRecipe.shortName))
				.generateVapi()
				.vapiOutputDirectory(LIB_VAPI_OUTPUT_DEFAULT)
				.vapiOutputFileName("%s.vapi".printf(projectRecipe.shortName))
				.cOutputDirectory(LIB_C_OUTPUT_DEFAULT)
				.cHeaderFileName("%s.h".printf(projectRecipe.shortName))
				.ccOptions({"-fPIC", "-shared"})
				.build();
			return new ValaCodeCompiler(buildConfiguration);
		}

		private ValaCodeCompiler initializeRuntimeCodeCompiler(BobBuildProjectRecipe projectRecipe) {
			BuildConfiguration buildConfiguration = runtimeBuildConfigurationBuilder
				.dependencies(projectRecipe.dependencies)
				.sources(projectRecipe.mainSourceFiles)
				.addSourceFromRelativeLocation("%s%s%s.vapi".printf(LIB_VAPI_OUTPUT_DEFAULT, PATH_SEPARATOR, projectRecipe.shortName))
				.targetDirectory(TARGET_FOLDER_DEFAULT)
				.targetFileName(projectRecipe.shortName)
				.ccOptions({"-Wl,-rpath=\$ORIGIN/%s".printf(LIB_FOLDER_DEFAULT), "-L%s".printf(TARGET_LIB_FOLDER_DEFAULT), "-l%s".printf(projectRecipe.shortName), "-I%s".printf(LIB_C_OUTPUT_DEFAULT)})
				.build();
			return new ValaCodeCompiler(buildConfiguration);
		}
	}
}