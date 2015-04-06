using com.futureprocessing.bob.log;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;

namespace com.futureprocessing.bob.build.plugin {
	public class BobBuildPluginExecutionChain {

        private Logger LOGGER = Logger.getLogger("BobBuildPluginExecutionChain");
        private BobBuildPluginLoader pluginLoader = new BobBuildPluginLoader();
		private List<string> missingPlugins = new List<string>();
		private List<string> pluginsToRun = new List<string>();

		public void addPlugin(string pluginToRun) {
			LOGGER.logInfo("Using build plugin: %s.", pluginToRun);
			pluginsToRun.append(pluginToRun);
		}

		public void preparePlugin(BobBuildPluginRecipe pluginRecipe) {
			if (!isPluginToRun(pluginRecipe.name)) {
				return;
			}
			AbstractBobBuildPlugin instantiatedPlugin = getPlugin(pluginRecipe.name);
			if (instantiatedPlugin == null) {
				LOGGER.logError("Unable to find plugin: %s. Skipping plugin preparation.", pluginRecipe.name);
				return;
			} 
			LOGGER.logInfo("Initializing plugin '%s' with recipe data.", pluginRecipe.name);
			instantiatedPlugin.initialize(pluginRecipe);
		}

		private AbstractBobBuildPlugin? getPlugin(string pluginName) {
			return pluginLoader.getPlugin(pluginName);
		}

		public void runPlugins(BobBuildProjectRecipe projectRecipe) {
			foreach (string pluginToRun in pluginsToRun) {
				runPlugin(pluginToRun, projectRecipe);
			}
		}

		private void runPlugin(string pluginName, BobBuildProjectRecipe projectRecipe) {
			if (!isPluginToRun(pluginName)) {
				return;
			}
			AbstractBobBuildPlugin instantiatedPlugin = getPlugin(pluginName);
			if (instantiatedPlugin == null) {
				LOGGER.logError("Unable to find plugin: %s. Skipping plugin execution.", pluginName);
				return;
			}
			LOGGER.logInfo("Running plugin: %s", pluginName);
			instantiatedPlugin.run(projectRecipe);
		}

		private bool isPluginToRun(string pluginName) {
			foreach (string pluginToRun in pluginsToRun) {
				if (pluginName == pluginToRun) {
					return true;
				}
			}
			return false;
		}

		// private void resolvePluginDependencies(string pluginName, string[] dependencies) {
		// 	foreach (string dependency in dependencies) {
		// 		LOGGER.logInfo("Checking dependency for '%s' plugin - %s", pluginName, dependency);
		// 		if (isAlreadyMissing(dependency)) {
		// 			LOGGER.logInfo("'%s' dependency is already marked as missing, skipping further processing", dependency);
		// 			continue;
		// 		}
		// 		if (isAlreadyInstantiated(dependency)) {
		// 			LOGGER.logInfo("'%s' dependency is already instantiated, skipping further processing", dependency);
		// 			continue;
		// 		}
		// 		collectPlugin(dependency);
		// 	}
		// }

		// private bool isAlreadyMissing(string pluginName) {
		// 	foreach (string missingPlugin in missingPlugins) {
		// 		if (missingPlugin == pluginName) {
		// 			return true;
		// 		}
		// 	}
		// 	return false;
		// }

		// private bool isAlreadyInstantiated(string pluginName) {
		// 	return getPlugin(pluginName) != null;
		// }
	}
}