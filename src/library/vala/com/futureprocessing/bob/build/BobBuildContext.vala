using com.futureprocessing.bob.log;
using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.build.plugin;

namespace com.futureprocessing.bob.build {
	
	public class BobBuildContext : Object {

        private Logger LOGGER = Logger.getLogger("BobBuildContext");

		public bool buildLibrary { get; set; }
		public bool buildMain { get; set; }
		private BobBuildRecipe buildRecipe;
		private BobBuildPluginExecutionChain pluginChain;

		public BobBuildContext() {
			this.buildRecipe = new BobBuildRecipe();
			initializePluginChain();
		}	

		public BobBuildContext.withRecipe(BobBuildRecipe buildRecipe) {
			this.buildRecipe = buildRecipe;
			initializePluginChain();
		}

		private void initializePluginChain() {
			pluginChain = new BobBuildPluginExecutionChain();
		}

		public void addPlugin(string buildPlugin) {
			pluginChain.addPlugin(buildPlugin);
		}

		public void proceed() {
			printRecipeSummary();
			prepareBuildPlugins();
		}

		private void prepareBuildPlugins() {
			LOGGER.logInfo("Preparing plugins");
			foreach (BobBuildPluginRecipe pluginRecipe in buildRecipe.plugins) {
				pluginChain.preparePlugin(pluginRecipe);
			}
		}

		private void printRecipeSummary() {
			LOGGER.logInfo("Building project: %s-%s (%s)", buildRecipe.project.shortName, buildRecipe.project.version, buildRecipe.project.name);
		}
	}
}
