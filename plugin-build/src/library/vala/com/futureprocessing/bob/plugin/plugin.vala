using com.futureprocessing.bob.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginLoader) {
	var plugin = new BuildApplicationPlugin();
	pluginLoader.addPlugin(plugin);
}

public string[] getDependencies() {
	return {"collect-sources"};
}