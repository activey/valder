using bob.builder.build.plugin;

public void initializePlugin(BobBuildPluginLoader pluginsLoader) {
	pluginsLoader.addPlugin(new InstallInLocalRepositoryPlugin());
}

public string[] getDependencies() {
	return {};
}