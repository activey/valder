using bob.builder.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginsLoader) {
	pluginsLoader.addPlugin(new InstallInLocalRepositoryPlugin());
	pluginsLoader.addPlugin(new ScanLocalRepositoryPlugin());
}

public string[] getDependencies() {
	return {};
}