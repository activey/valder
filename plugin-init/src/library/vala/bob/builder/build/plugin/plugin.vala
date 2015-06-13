using bob.builder.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginsLoader) {
	var plugin = new InitializeProjectStructurePlugin();
	pluginsLoader.addPlugin(plugin);
}

public string[] getDependencies() {
	return {};
}