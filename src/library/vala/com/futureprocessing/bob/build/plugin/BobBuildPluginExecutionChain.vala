using com.futureprocessing.bob.log;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.build.plugin {
	public class BobBuildPluginExecutionChain {

        private Logger LOGGER = Logger.getLogger("BobBuildPluginExecutionChain");
		private List<BobBuildPluginInstance> instantiatedPlugins = new List<BobBuildPluginInstance>();
		private List<string> missingPlugins = new List<string>();

		public void addPlugin(string pluginName) {
			collectPlugin(pluginName);
		}

		public BobBuildPluginInstance? getPlugin(string pluginName) {
			foreach (BobBuildPluginInstance pluginInstance in instantiatedPlugins) {
				if (pluginInstance.pluginName == pluginName) {
					return pluginInstance;
				}
			}
			return null;
		}

		public void preparePlugin(BobBuildPluginRecipe pluginRecipe) {
			BobBuildPluginInstance instantiatedPlugin = getPlugin(pluginRecipe.name);
			if (instantiatedPlugin == null) {
				return;
			} 
			LOGGER.logInfo("Preparing plugin '%s' with recipe data", pluginRecipe.name);
			instantiatedPlugin.preparePlugin(pluginRecipe);
		}

		private void collectPlugin(string pluginName) {
			try {
				LOGGER.logInfo("Initializing plugin: [%s]", pluginName);

				BuildPluginLoader pluginLoader = loadPlugin(pluginName);
				instantiatedPlugins.append(new BobBuildPluginInstance(pluginName, pluginLoader));
			} catch (BuildPluginError pluginError) {
				missingPlugins.append(pluginName);
				LOGGER.logError("An error occurred while loading plugin %s, error message: %s", pluginName, pluginError.message);
			}
		}

		private BuildPluginLoader loadPlugin(string pluginName) throws BuildPluginError  {
			BuildPluginLoader pluginLoader = new BuildPluginLoader(pluginName);
			pluginLoader.loadPlugin();

			resolvePluginDependencies(pluginName, pluginLoader.getPluginDependencies());
			return pluginLoader;
		}

		private void resolvePluginDependencies(string pluginName, string[] dependencies) {
			foreach (string dependency in dependencies) {
				LOGGER.logInfo("Checking dependency for '%s' plugin - %s", pluginName, dependency);
				if (isAlreadyMissing(dependency)) {
					LOGGER.logInfo("'%s' dependency is already marked as missing, skipping further processing", dependency);
					continue;
				}
				if (isAlreadyInstantiated(dependency)) {
					LOGGER.logInfo("'%s' dependency is already instantiated, skipping further processing", dependency);
					continue;
				}
				collectPlugin(dependency);
			}
		}

		private bool isAlreadyMissing(string pluginName) {
			foreach (string missingPlugin in missingPlugins) {
				if (missingPlugin == pluginName) {
					return true;
				}
			}
			return false;
		}

		private bool isAlreadyInstantiated(string pluginName) {
			return getPlugin(pluginName) != null;
		}
	}
}