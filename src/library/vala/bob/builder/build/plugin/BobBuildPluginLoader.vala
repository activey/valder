using Gee;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public errordomain BuildPluginError {
		PLUGINS_FOLDER_MISSING, MODULE_NOT_FOUND_ERROR,
		MODULE_TYPE_FUNCTION_MISSING_ERROR, DEPENDENCY_MISSING
	}

	public class BobBuildPluginLoader {
		
		private Logger LOGGER = Logger.getLogger("BobBuildPluginsLoader");
		
		private const string PLUGINS_DIRECTORY  = BobDirectories.DIRECTORY_PLUGINS;
		private const string PLUGIN_INIT_METHOD = "initializePlugin";
		private const string PLUGIN_DEPS_METHOD = "getDependencies";

		private HashMap<string, AbstractBobBuildPlugin> loadedPlugins = new HashMap<string, AbstractBobBuildPlugin>();

		private delegate void ModuleInitFunction(BobBuildPluginLoader pluginLoader);
		private delegate string[] GetPluginDependenciesFunction();

		public BobBuildPluginLoader.for_plugins_directory(string? pluginsDirectoryLocation) {
			try {
				loadPluginsFromDirectory(pluginsDirectoryLocation ?? PLUGINS_DIRECTORY);
			}
			catch(BuildPluginError error) {
				LOGGER.logError("Something wrong happened: %s", error.message);
			}
		}

		public BobBuildPluginLoader() {
			BobBuildPluginLoader.for_plugins_directory(null);
		}

		private void loadPluginsFromDirectory(string pluginsDirectoryLocation) throws BuildPluginError {
			validateModulesSupported();
			File pluginsDirectory = File.new_for_path(Runtime.resolveRuntimeRelativePath(pluginsDirectoryLocation));
			if (!pluginsDirectory.query_exists(null)) {
				throw new BuildPluginError.PLUGINS_FOLDER_MISSING("Plugins folder missing! Skipping further processing.");
			}

			LOGGER.logInfo("Loading plugins from directory: %s", pluginsDirectory.get_path());
			DirectoryObject plugins = new DirectoryObject(pluginsDirectory);
			plugins.accept(new BobBuildPluginVisitor(loadPluginFromFile), false);
		}

		private void validateModulesSupported() {
			assert(Module.supported());
		}

		private void loadPluginFromFile(File pluginFile) {
			try {
				Module module = loadPluginModule(pluginFile.get_path());
				loadPluginModuleType(module);
			} catch (BuildPluginError e) {
				LOGGER.logError("An error occurred while loading plugin from [%s] file: %s.", pluginFile.get_path(), e.message);
			}
		}

		private Module loadPluginModule(string modulePath) throws BuildPluginError {
			Module module = Module.open(modulePath, ModuleFlags.BIND_LOCAL);
			if (module == null) {
				throw new BuildPluginError.MODULE_NOT_FOUND_ERROR("Module not found for given path: %s".printf(modulePath));
			}
			LOGGER.logInfo("Loaded build plugin module: %s", module.name());
			module.make_resident();
			return module;
		}

		public void addPlugin(AbstractBobBuildPlugin buildPlugin) {
			LOGGER.logInfo("Registering new plugin: %s", buildPlugin.name);
			loadedPlugins.set(buildPlugin.name, buildPlugin);
		}

		public AbstractBobBuildPlugin? getPlugin(string pluginName) {
			return loadedPlugins.get(pluginName);
		}

		private void loadPluginModuleType(Module module) throws BuildPluginError {
			unowned ModuleInitFunction initFunction = (ModuleInitFunction) getModuleMethod(module, PLUGIN_INIT_METHOD);
			initFunction(this);
		}

		private void *getModuleMethod(Module module, string methodName) throws BuildPluginError {
			void *methodReference;
			module.symbol(methodName, out methodReference);
			if (methodReference == null) {
				throw new BuildPluginError.MODULE_TYPE_FUNCTION_MISSING_ERROR("'%s' method is missing in plugin module!".printf(methodName));
			}
			return methodReference;
		}
	}
}
