using bob.builder.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginsLoader) {
	pluginsLoader.addPlugin(new InitializeProjectStructurePlugin());
	pluginsLoader.addPlugin(new InitializeProjectRecipePlugin());
}

public string[] getDependencies() {
	return {};
}