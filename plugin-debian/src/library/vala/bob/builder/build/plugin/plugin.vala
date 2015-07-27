using bob.builder.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginLoader) {
	pluginLoader.addPlugin(new BuildDebianPackagePlugin());
	pluginLoader.addPlugin(new BuildDebianDevPackagePlugin());
}

public string[] getDependencies() {
	return {""};
}