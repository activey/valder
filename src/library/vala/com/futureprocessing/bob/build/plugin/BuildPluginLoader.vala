using com.futureprocessing.bob.log;
using com.futureprocessing.bob.filesystem;

namespace com.futureprocessing.bob.build.plugin {
	
	public errordomain BuildPluginError {
        MODULE_NOT_FOUND_ERROR, MODULE_TYPE_FUNCTION_MISSING_ERROR
    }

	public class BuildPluginLoader : TypeModule {
        private Logger LOGGER = Logger.getLogger("BuildPluginLoader");
        private const string PLUGINS_DIRECTORY = "plugins";
        private const string PLUGIN_INIT_METHOD = "getPluginType";
        private const string PLUGIN_DEPS_METHOD = "getDependencies";

		public string path { get; private set; }

	    private Module module;
	    private Type type;
	    private string[] dependencies = {};

	    private delegate Type GetPluginTypeFunction(TypeModule typeModule);
	    private delegate string[] GetPluginDependenciesFunction();

	    public BuildPluginLoader(string name) {
	        initializeModulePath(name);
	    }
	
	    public BobBuildPlugin instantiatePlugin() {
	    	return (BobBuildPlugin) Object.new(type);
	    }

		public string[] getPluginDependencies() {
	    	return dependencies;
	    }

	    private void initializeModulePath(string moduleName) {
	    	validateModulesSupported();
	    	path = Module.build_path(Runtime.resolveRuntimeRelativePath(PLUGINS_DIRECTORY), moduleName);
	    }

	    private void validateModulesSupported() {
	    	assert(Module.supported());
	    }

	    public void loadPlugin() {
	    	try {
		        LOGGER.logInfo("Loading Bob build plugin from location: %s", path);
		    	loadPluginModule();
		        loadPluginDependencies();
		        loadPluginModuleType();
	        } catch (BuildPluginError e) {
		    	LOGGER.logError("An error occurred while loading plugin: %s", e.message);
		    }
	    }

	    public override bool load() {
	        return true;
	    }

	    public override void unload() {
	    	//module = null;
	    }

	    private void loadPluginModule() throws BuildPluginError {
	    	module = Module.open(path, ModuleFlags.BIND_LAZY);
	        if (module == null) {
	            throw new BuildPluginError.MODULE_NOT_FOUND_ERROR("Module not found for given path: %s".printf(path));
	        }
	        LOGGER.logInfo("Loaded build plugin module: %s", module.name());
	    }

		private void loadPluginModuleType() throws BuildPluginError {
			unowned GetPluginTypeFunction getPluginType = (GetPluginTypeFunction) getModuleMethod(module, PLUGIN_INIT_METHOD);
			type = getPluginType(this);
	    }

	    private void loadPluginDependencies() throws BuildPluginError {
	    	unowned GetPluginDependenciesFunction getDependencies = (GetPluginDependenciesFunction) getModuleMethod(module, PLUGIN_DEPS_METHOD);
			dependencies = getDependencies();
	    }

	    private void* getModuleMethod(Module module, string methodName) throws BuildPluginError {
	    	void* methodReference;
			module.symbol(methodName, out methodReference);
			if (methodReference == null) {
				throw new BuildPluginError.MODULE_TYPE_FUNCTION_MISSING_ERROR("'%s' method is missing in plugin module!".printf(methodName));
			}
			return methodReference;
	    }
	}
}

