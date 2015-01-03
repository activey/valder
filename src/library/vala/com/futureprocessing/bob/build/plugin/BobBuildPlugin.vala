using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.build.plugin {
	
	public interface BobBuildPlugin : Object {

	    public abstract void initialize(BobBuildPluginRecipe pluginRecipe);
	    public abstract void run(BobBuildContext buildContext);
	}
}
