using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.build.plugin {
	public class BuildApplicationPlugin : Object, BobBuildPlugin {

		public void initialize(BobBuildPluginConfiguration pluginConfiguration) {

		}

	    public void run(BobBuildContext buildContext) {

	    }

	    public string[] getRunAfter() {
	    	return {};
	    }
	}
}