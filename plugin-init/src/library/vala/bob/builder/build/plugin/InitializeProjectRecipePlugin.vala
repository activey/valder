using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public class InitializeProjectRecipePlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "initialize:recipe";
        const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("InitializeProjectRecipePlugin");

        private bool verbose = false; 

        public InitializeProjectRecipePlugin() {
        	base(PLUGIN_NAME);
        }

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);
		}

	    public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
	    	LOGGER.logInfo("Initializing project build recipe.");

	    	
	    }
	}
}