using com.futureprocessing.bob.log;
using com.futureprocessing.bob.filesystem;

namespace com.futureprocessing.bob.build.plugin {
	
	public errordomain BuildPluginError {
        MODULE_NOT_FOUND_ERROR, MODULE_TYPE_FUNCTION_MISSING_ERROR
    }

	public class BuildPluginLoader<T> {
        private Logger LOGGER = Logger.getLogger("BuildPluginLoader");
        private const string PLUGINS_DIRECTORY = "plugins";
        private const string PLUGIN_INIT_METHOD = "getPluginType";

		public string path { get; private set; }

	    private Type type;
	    private Module module;

	    private delegate Type GetPluginTypeFunction();

	    public static BuildPluginLoader<BobBuildPlugin> loadPlugin(string name) throws BuildPluginError {
	    	BuildPluginLoader<BobBuildPlugin> pluginLoader = new BuildPluginLoader<BobBuildPlugin>(name);
	    	pluginLoader.loadBuildPlugin();
	    	return pluginLoader;
	    }

	    private BuildPluginLoader(string name) {
	        initializeModulePath(name);
	    }

	    private void initializeModulePath(string moduleName) {
	    	validateModulesSupported();
	    	path = Module.build_path(Runtime.resolveRuntimeRelativePath(PLUGINS_DIRECTORY), moduleName);
	    }

	    private void validateModulesSupported() {
	    	assert(Module.supported());
	    }

	    private void loadBuildPlugin() throws BuildPluginError {
	        LOGGER.logInfo("Loading Bob build plugin from location: %s", path);

	        loadPluginModule();
	        loadPluginModuleType();
	    }

	    private void loadPluginModule() throws BuildPluginError {
	    	module = Module.open(path, ModuleFlags.BIND_LAZY);
	        if (module == null) {
	            throw new BuildPluginError.MODULE_NOT_FOUND_ERROR("Module not found for given path: '%s'".printf(path));
	        }
	        LOGGER.logInfo("Loaded build plugin module: '%s'", module.name());
	    }

		private void loadPluginModuleType() throws BuildPluginError {
			void* getPluginTypeFunctionReference;
			module.symbol(PLUGIN_INIT_METHOD, out getPluginTypeFunctionReference);
			if (getPluginTypeFunctionReference == null) {
				throw new BuildPluginError.MODULE_TYPE_FUNCTION_MISSING_ERROR("'getPluginType' method is missing in plugin module!");
			}
			unowned GetPluginTypeFunction getPluginTypeFunction = (GetPluginTypeFunction) getPluginTypeFunctionReference;
			type = getPluginTypeFunction();
			LOGGER.logInfo("Build plugin type loaded: %s", type.name());
	    }

	    public T instantiatePlugin() {
	        return Object.new(type);
	    }
	}
}
