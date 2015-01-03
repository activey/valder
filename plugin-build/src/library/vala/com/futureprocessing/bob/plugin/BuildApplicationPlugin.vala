using com.futureprocessing.bob.log;
using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.build.plugin {
	public class BuildApplicationPlugin : BobBuildPlugin, Object {

		private Logger LOGGER = Logger.getLogger("BuildApplicationPlugin");

		public void initialize(BobBuildPluginRecipe pluginRecipe) {
			LOGGER.logInfo("Reading recipe for plugin: %s", pluginRecipe.name);
		}

	    public void run(BobBuildContext buildContext) {

	    }
	}
}