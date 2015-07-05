using bob.builder.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginLoader) {
	pluginLoader.addPlugin(new BuildApplicationPlugin());
}

public string[] getDependencies() {
	return {"collect-sources"};
}