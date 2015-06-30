using bob.builder.build.plugin;
using bob.builder.log;
using bob.builder.recipe.plugin;
using bob.builder.recipe;
using bob.builder;

namespace bob.builder.build {

	public class BobBuildContext : Object {

		private Logger LOGGER = Logger.getLogger("BobBuildContext");
		private BobBuildRecipe buildRecipe;
		private BobBuildPluginExecutionChain pluginChain;

		public BobBuildContext () {
			BobBuildContext.withRecipe(new BobBuildRecipe());
		}

		public BobBuildContext.withRecipe(BobBuildRecipe buildRecipe) {
			this.buildRecipe = buildRecipe;
			initializePluginChain();
		}

		private void initializePluginChain() {
			pluginChain = new BobBuildPluginExecutionChain();
		}

		public void usePlugin(string buildPlugin) {
			pluginChain.usePlugin(buildPlugin);
		}

		public void proceed() {
			Timer executionTimer = new Timer();

			printRecipeSummary();
			try {
				prepareProjectPlugins();
				runProjectPlugins();
			} catch(Error e) {
				LOGGER.logError("Build process failed because of unforseen problem: %s.", e.message);
			}

			executionTimer.stop();
			LOGGER.logInfo("Took time: %f seconds.", executionTimer.elapsed());
		}

		private void printRecipeSummary() {
			LOGGER.logInfo("Building project: %s-%s (%s)", buildRecipe.project.shortName, buildRecipe.project.version, buildRecipe.project.name);
		}

		private void prepareProjectPlugins() throws BobBuildPluginError {
			LOGGER.logInfo("Loading project plugins recipies...");
			pluginChain.preparePlugins((pluginToRun) => {
					BobBuildPluginRecipe? pluginRecipe = buildRecipe.getPluginRecipe(pluginToRun.name);
					if (pluginRecipe == null) {
				        pluginRecipe = new BobBuildPluginRecipe.default();
					}
					
					pluginToRun.initialize(pluginRecipe);
				}
	        );
		}

		private void runProjectPlugins() throws BobBuildPluginError {
			LOGGER.logInfo("Running project plugins");
			pluginChain.runPlugins(buildRecipe.project);
		}
	}
}
