using com.futureprocessing.bob.log;

namespace com.futureprocessing.bob.plugin {
	
	public errordomain BuildPluginError {
        MODULE_NOT_FOUND_ERROR, MODULE_TYPE_FUNCTION_MISSING_ERROR
    }

	public class BuildPluginLoader<T> {
        private Logger LOGGER = Logger.getLogger("BuildPluginLoader");

		public string path { get; private set; }

	    private Type type;
	    private Module module;

	    private delegate Type GetPluginTypeFunction();

	    public BuildPluginLoader(string name) {
	    	validateModulesSupported();
	        initializeModulePath(name);
	    }

	    private void validateModulesSupported() {
	    	assert(Module.supported());
	    }

	    private void initializeModulePath(string moduleName) {
	    	path = Module.build_path(Environment.get_variable("PWD"), moduleName);
	    }

	    public void loadBuildPlugin() throws BuildPluginError {
	        LOGGER.logInfo("Loading Bob build plugin with path: '%s'\n", path);

	        loadPluginModule();
	        loadPluginModuleType();
	    }

	    private void loadPluginModule() throws BuildPluginError {
	    	module = Module.open(path, ModuleFlags.BIND_LAZY);
	        if (module == null) {
	            throw new BuildPluginError.MODULE_NOT_FOUND_ERROR("Module not found for given path: '%s'".printf(path));
	        }
	        LOGGER.logInfo("Loaded build plugin module: '%s'\n", module.name());
	    }

		private void loadPluginModuleType() throws BuildPluginError {
			void* getPluginTypeFunctionReference;
			module.symbol("getPluginType", out getPluginTypeFunctionReference);
			if (getPluginTypeFunctionReference == null) {
				throw new BuildPluginError.MODULE_TYPE_FUNCTION_MISSING_ERROR("'getPluginType' method is missing in plugin module!");
			}
			unowned GetPluginTypeFunction getPluginTypeFunction = (GetPluginTypeFunction) getPluginTypeFunctionReference;
			type = getPluginTypeFunction();
			LOGGER.logInfo("Build plugin type loaded: %s\n\n", type.name());
	    }

	    public T instantiatePlugin() {
	        return Object.new(type);
	    }
	}
}
