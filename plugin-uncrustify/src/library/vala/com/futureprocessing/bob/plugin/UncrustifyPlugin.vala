using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.log;
using com.futureprocessing.bob.json;

namespace com.futureprocessing.bob.build.plugin {

	public class UncrustifyPlugin : AbstractBobBuildPlugin {

        private const string PLUGIN_NAME = "uncrustify";
        private const string RECIPE_ENTRY_VERBOSE = "verbose";
        private const string RECIPE_ENTRY_REPLACE = "replace";
        private const string RECIPE_ENTRY_BACKUP = "backup";
        private const string RECIPE_ENTRY_CONFIGURATION = "configuration";
        private const string RECIPE_OUTPUT_PREFFIX_CONFIGURATION = "outputPreffix";

        private Logger LOGGER = Logger.getLogger("UncrustifyPlugin");
        private bool verbose = false;
        private bool replaceOriginal = false;
        private bool backup = true;
        private string uncrustifyConfiguration;
        private string outputPreffix;

        public UncrustifyPlugin() {
        	base(PLUGIN_NAME);
        }

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);
			replaceOriginal = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_REPLACE, false);
			backup = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_BACKUP, true);	

			if (replaceOriginal) {
				LOGGER.logInfo("Original files will be replaced, there is no turn back! oh noez!");
			} else {
				outputPreffix = pluginRecipe.jsonConfiguration.getStringEntry(RECIPE_OUTPUT_PREFFIX_CONFIGURATION, "");
			}
			uncrustifyConfiguration = pluginRecipe.jsonConfiguration.getStringEntry(RECIPE_ENTRY_CONFIGURATION, null);
			if (uncrustifyConfiguration == null) {
				throw new BobBuildPluginError.INITIALIZATION_ERROR("Uncrustify configuration file not set!");
			} else {
				LOGGER.logInfo("Using uncrustify configuration file: %s", uncrustifyConfiguration);
			}
		}

	    public override void run(BobBuildProjectRecipe projectRecipe) throws BobBuildPluginError {
	    	try {
	    		UncrustifyRunner runner = new UncrustifyRunner(uncrustifyConfiguration, verbose);
	    		runner.checkUncrustifyAvailable();
	    		runner.backup = backup;
	    		
	    		LOGGER.logInfo("Running uncrustify on library source files");
	    		runUncrustify(runner, projectRecipe.libSourceFiles);
    		} catch (Error e) {
    			throw new BobBuildPluginError.RUN_ERROR(e.message);
    		}
	    }

		private void runUncrustify(UncrustifyRunner runner, List<BobBuildProjectSourceFile> sourceFiles) throws SpawnError {
			List<string> filesToProcess = new List<string>();
			foreach (BobBuildProjectSourceFile sourceFile in sourceFiles) {
				filesToProcess.append(sourceFile.fileLocation);
			}
			if (filesToProcess.length() == 0) {
				LOGGER.logInfo("No files available for uncrustify, skipping execution.");
				return;
			}
			runner.run(filesToProcess, outputPreffix, replaceOriginal);
		}
	}
}