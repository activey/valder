using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;

namespace com.futureprocessing.bob.build.plugin {
	public class BuildApplicationPlugin : AbstractBobBuildPlugin {

		private const string PROPERTY_VERBOSE = "verbose";
		private const string PLUGIN_NAME = "build";

		private bool verbose = false;

		public BuildApplicationPlugin() {
			base(PLUGIN_NAME);
		}

		public override void initialize(BobBuildPluginRecipe pluginRecipe) {
			readBuildConfiguration(pluginRecipe);
		}

		public void readBuildConfiguration(BobBuildPluginRecipe pluginRecipe) {
			this.verbose = pluginRecipe.getBooleanEntry(PROPERTY_VERBOSE, this.verbose);
		}

	    public override void run(BobBuildProjectRecipe projectRecipe) {
	    	stdout.printf("AAAAAAAAAAAAAA");
	    }
	}
}