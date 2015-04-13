using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.filesystem;
using com.futureprocessing.bob.log;

namespace com.futureprocessing.bob.build.plugin {
	public class CollectSourcesPlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "collect-sources";
		const string SOURCE_MAIN_FOLDER_LOCATION = "./src/main/vala";
        const string SOURCE_LIB_FOLDER_LOCATION = "./src/library/vala";
        const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("CollectSourcesPlugin");
        private bool verbose = false; 
        private ValaFilesVisitor valaLibVisitor;
        private ValaFilesVisitor valaMainVisitor;
        
        private BobBuildProjectRecipe currentProjectRecipe;

        public CollectSourcesPlugin() {
        	base(PLUGIN_NAME);
        }

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);

			valaLibVisitor = new ValaFilesVisitor(SOURCE_LIB_FOLDER_LOCATION);
			valaLibVisitor.valaFileFound.connect(this.collectValaLibSourceFile);
			valaMainVisitor = new ValaFilesVisitor(SOURCE_MAIN_FOLDER_LOCATION);
			valaMainVisitor.valaFileFound.connect(this.collectValaMainSourceFile);
		}

		private void collectValaLibSourceFile(File valaFile) {
			currentProjectRecipe.addLibSourceFile(valaFile);
		}

		private void collectValaMainSourceFile(File valaFile) {
			currentProjectRecipe.addMainSourceFile(valaFile);
		}

	    public override void run(BobBuildProjectRecipe projectRecipe) throws BobBuildPluginError {
	    	try {
	    		currentProjectRecipe = projectRecipe;
	    		collectValaSourceFiles();
	    		printValaSourceFiles();
    		} catch (Error e) {
    			LOGGER.logError("An error occurred while collecting vala source files: %s", e.message);
    		}
	    }

	    private void collectValaSourceFiles() {
	    	valaLibVisitor.collectSourceFiles();
    		valaMainVisitor.collectSourceFiles();
	    }

	    private void printValaSourceFiles() {
	    	if (!verbose) {
	    		return;
	    	}
	    	int totalLength = 0;
	    	uint64 totalSize = 0;
	    	foreach (BobBuildProjectSourceFile file in currentProjectRecipe.libSourceFiles) {
	    		if (verbose) {
	    			LOGGER.logInfo("%s (%d bytes)", file.fileLocation, file.fileSize);
	    		}
	    		totalLength++;
	    		totalSize = totalSize + file.fileSize;
	    	}
	    	foreach (BobBuildProjectSourceFile file in currentProjectRecipe.mainSourceFiles) {
	    		if (verbose) {
	    			LOGGER.logInfo("%s (%d bytess)", file.fileLocation, file.fileSize);
	    		}
	    		totalLength++;
	    		totalSize = totalSize + file.fileSize;
	    	}
	    	LOGGER.logInfo("Using %d project source files with %d bytes in total.", totalLength, totalSize);
	    }
	}
}