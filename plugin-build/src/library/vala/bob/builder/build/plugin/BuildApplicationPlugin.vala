using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.log;
using bob.builder.json;

namespace bob.builder.build.plugin {

	public class BuildApplicationPlugin : AbstractBobBuildPlugin {

		private const string PLUGIN_NAME = "build";
		private const string LIB_TARGET_DEFAULT = "./target/lib/";
		private const string MAIN_TARGET_DEFAULT = "./target/";

        private Logger LOGGER = Logger.getLogger("BuildApplicationPlugin");

		private BuildConfigurationBuilder buildConfigurationBuilder;

		public BuildApplicationPlugin() {
			base(PLUGIN_NAME);
		}

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			buildConfigurationBuilder = new BuildConfigurationBuilder.fromJSONObject(pluginRecipe.jsonConfiguration);
		}

		public override void run(BobBuildProjectRecipe projectRecipe) throws BobBuildPluginError {
	    	ValaCodeCompiler libCompiler = initializeLibraryCodeCompiler(projectRecipe);
	    	LOGGER.logInfo("Generating library binary.");
	    	try {
	    		libCompiler.compile();
	    	} catch (CompilationError e) {
	    		LOGGER.logError("Compilation failed with message: %s.", e.message);
	    		return;
	    	}
	    	LOGGER.logInfo("Code compilation finished.");
	    }

	    private ValaCodeCompiler initializeLibraryCodeCompiler(BobBuildProjectRecipe projectRecipe) {
	    	appendSourceFiles(projectRecipe.libSourceFiles);
	    	appendDependencies(projectRecipe.dependencies);

			BuildConfiguration buildConfiguration = buildConfigurationBuilder
				.targetDirectory(LIB_TARGET_DEFAULT)
				.targetFileName("lib%s.so".printf(projectRecipe.shortName))
				.ccOptions({"-fPIC", "-shared"})
				.build();
			return new ValaCodeCompiler(buildConfiguration);
		}

		private void appendDependencies(List<BobBuildProjectDependency> dependencies) {
			foreach (BobBuildProjectDependency dependency in dependencies) {
				buildConfigurationBuilder.addDependency(dependency);
			}
		}

	    private void appendSourceFiles(List<BobBuildProjectSourceFile> sourceFiles) {
			foreach (BobBuildProjectSourceFile source in sourceFiles) {
				buildConfigurationBuilder.addSource(source);
			}
	    }
	}
}