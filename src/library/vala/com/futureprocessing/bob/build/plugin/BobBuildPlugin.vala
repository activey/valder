using com.futureprocessing.bob.build;

namespace com.futureprocessing.bob.recipe.plugin {
	
	public interface BobBuildPlugin {

	    public abstract void initialize(BobBuildPluginConfiguration pluginConfiguration);
	    public abstract void run(BobBuildContext buildContext);
	    public abstract string[] getRunAfter();
	}
}
