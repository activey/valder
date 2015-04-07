using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.log;
using com.futureprocessing.bob.json;

namespace com.futureprocessing.bob.build.plugin {

	public class BuildApplicationPlugin : AbstractBobBuildPlugin {

		private const string PLUGIN_NAME = "build";
		private const string LIB_TARGET_DEFAULT = "./target/lib/";
		private const string MAIN_TARGET_DEFAULT = "./target/";

        private Logger LOGGER = Logger.getLogger("BuildApplicationPlugin");

		private BuildConfigurationBuilder buildConfigurationBuilder;

		public BuildApplicationPlugin() {
			base(PLUGIN_NAME);
		}

		public override void initialize(BobBuildPluginRecipe pluginRecipe) {
			buildConfigurationBuilder = new BuildConfigurationBuilder.fromJSONObject(pluginRecipe.jsonConfiguration);
		}

		public override void run(BobBuildProjectRecipe projectRecipe) {
	    	ValaCodeCompiler libCompiler = initializeLibraryCodeCompiler(projectRecipe);
	    	LOGGER.logInfo("Generating library binary.");
	    	libCompiler.build();
	    }

	    private ValaCodeCompiler initializeLibraryCodeCompiler(BobBuildProjectRecipe projectRecipe) {
			BuildConfiguration buildConfiguration = appendSourceFiles(projectRecipe.libSourceFiles)
				.targetDirectory(LIB_TARGET_DEFAULT)
				.targetFileName("lib%s.so".printf(projectRecipe.shortName))
				.ccOptions({"-fPIC", "-shared"})
				.build();
			return new ValaCodeCompiler(buildConfiguration);
		}

	    private BuildConfigurationBuilder appendSourceFiles(List<BobBuildProjectSourceFile> sourceFiles) {
			foreach (BobBuildProjectSourceFile source in sourceFiles) {
				buildConfigurationBuilder.addSource(source);
			}
			return buildConfigurationBuilder;
	    }
	}
}