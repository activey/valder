using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.build.plugin {
	public class BobBuildPluginInstance : Object {

		private static BuildPluginLoader pluginLoader;
		public string pluginName {
			get;
			construct set;
		}

		public BobBuildPluginInstance(string pluginName, BuildPluginLoader pluginLoader) {
			Object(pluginName: pluginName);
			this.pluginLoader = pluginLoader;
		}

		public void preparePlugin(BobBuildPluginRecipe pluginRecipe) {
			BobBuildPlugin loadedPlugin = pluginLoader.instantiatePlugin();
			loadedPlugin.initialize(pluginRecipe);
		}
	}
}
