using com.futureprocessing.bob.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginsLoader) {
	var plugin = new CollectSourcesPlugin();
	pluginsLoader.addPlugin(plugin);
}

public string[] getDependencies() {
	return {};
}