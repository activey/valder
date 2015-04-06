using com.futureprocessing.bob.build;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.filesystem;
using com.futureprocessing.bob.log;

namespace com.futureprocessing.bob.build.plugin {
	public class CollectSourcesPlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "collect-sources";
		const string SOURCE_APP_FOLDER_LOCATION = "./src/main/vala";
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

		public override void initialize(BobBuildPluginRecipe pluginRecipe) {
			verbose = pluginRecipe.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);

			valaLibVisitor = new ValaFilesVisitor(SOURCE_LIB_FOLDER_LOCATION);
			valaLibVisitor.valaFileFound.connect(this.collectValaSourceFile);
			valaMainVisitor = new ValaFilesVisitor(SOURCE_LIB_FOLDER_LOCATION);
			valaLibVisitor.valaFileFound.connect(this.collectValaSourceFile);
		}

		private void collectValaSourceFile(File valaFile) {
			currentProjectRecipe.addSourceFile(valaFile);
		}

	    public override void run(BobBuildProjectRecipe projectRecipe) {
	    	try {
	    		currentProjectRecipe = projectRecipe;
	    		collectValaSourceFiles();
	    		printValaSourceFiles();
	    		currentProjectRecipe = null;
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
	    	foreach (BobBuildProjectSourceFile file in currentProjectRecipe.sourceFiles) {
	    		LOGGER.logInfo("%s (%d bytes)", file.fileLocation, file.fileSize);
	    		totalLength++;
	    		totalSize = totalSize + file.fileSize;
	    	}
	    	LOGGER.logInfo("Using %d project source files with %d bytes in total.", totalLength, totalSize);
	    }
	}
}