using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public class CollectSourcesPlugin : AbstractBobBuildPlugin {

        private const string PLUGIN_NAME = "collect-sources";
		private const string SOURCE_MAIN_FOLDER_LOCATION = "./src/main/vala";
        private const string SOURCE_LIB_FOLDER_LOCATION = "./src/library/vala";
        private const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("CollectSourcesPlugin");

        private bool verbose = true; 
        private ValaFilesVisitor valaLibVisitor;
        private ValaFilesVisitor valaMainVisitor;
        
        private BobBuildProjectRecipe currentProjectRecipe;

        public CollectSourcesPlugin() {
        	base(PLUGIN_NAME);
        }

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, true);

			valaLibVisitor = new ValaFilesVisitor(SOURCE_LIB_FOLDER_LOCATION);
			valaLibVisitor.valaFileFound.connect(this.collectValaLibSourceFile);
			valaMainVisitor = new ValaFilesVisitor(SOURCE_MAIN_FOLDER_LOCATION);
			valaMainVisitor.valaFileFound.connect(this.collectValaMainSourceFile);
		}

		private void collectValaLibSourceFile(File valaFile) {
			try {
				currentProjectRecipe.addLibSourceFile(new BobBuildProjectSourceFile.fromFileSystem(valaFile));
			} catch (Error e) {
				LOGGER.logError("An error occurred while adding Vala source file: %s", e.message);
			}
		}

		private void collectValaMainSourceFile(File valaFile) {
			try {
				currentProjectRecipe.addMainSourceFile(new BobBuildProjectSourceFile.fromFileSystem(valaFile));
			} catch (Error e) {
				LOGGER.logError("An error occurred while adding Vala source file: %s", e.message);
			}
		}

	    public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
	    	try {
	    		currentProjectRecipe = projectRecipe;

	    		collectValaSourceFiles();
    		} catch (Error e) {
    			LOGGER.logError("An error occurred while collecting vala source files: %s", e.message);
    		}
	    }

	    private void collectValaSourceFiles() throws Error {
	    	valaLibVisitor.collectSourceFiles();
    		valaMainVisitor.collectSourceFiles();
	    }
	}
}