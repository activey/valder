using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.build.plugin {
	
	public interface BobBuildPlugin : Object {

	    public abstract void initialize(BobBuildPluginConfiguration pluginConfiguration);
	    public abstract void run(BobBuildContext buildContext);
	    public abstract string[] getRunAfter();
	}
}
