using bob.builder.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginLoader) {
	pluginLoader.addPlugin(new BuildDebianPackagePlugin());
}

public string[] getDependencies() {
	return {""};
}