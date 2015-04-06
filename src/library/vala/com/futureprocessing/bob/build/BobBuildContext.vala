using com.futureprocessing.bob.log;
using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.build.plugin;

namespace com.futureprocessing.bob.build {
	
	public class BobBuildContext : Object {

        private Logger LOGGER = Logger.getLogger("BobBuildContext");

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
			loadProjectPluginsRecipies();
			runProjectPlugins();
		}

		private void printRecipeSummary() {
			LOGGER.logInfo("Building project: %s-%s (%s)", buildRecipe.project.shortName, buildRecipe.project.version, buildRecipe.project.name);
		}

		private void loadProjectPluginsRecipies() {
			LOGGER.logInfo("Loading project plugins recipies...");
			foreach (BobBuildPluginRecipe pluginRecipe in buildRecipe.plugins) {
				pluginChain.preparePlugin(pluginRecipe);
			}
		}

		private void runProjectPlugins() {
			LOGGER.logInfo("Running project plugins");
			pluginChain.runPlugins(buildRecipe.project);
		}
	}
}
