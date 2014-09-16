namespace com.futureprocessing.bob.recipe.plugin {
	
	public interface BobBuildPlugin {

	    public abstract void initialize(BobBuildPluginConfiguration pluginConfiguration);
	    public abstract string[] getRunAfter();
	}
}
