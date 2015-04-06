using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;

namespace com.futureprocessing.bob.build.plugin {
	
	public abstract class AbstractBobBuildPlugin : Object {

		public string name { construct set; get; }

		public AbstractBobBuildPlugin(string pluginName) {
			Object(name: pluginName);
		}

	    public abstract void initialize(BobBuildPluginRecipe pluginRecipe);
	    public abstract void run(BobBuildProjectRecipe projectRecipe);
	}
}
