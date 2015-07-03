using bob.builder.build;
using bob.builder.recipe;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

    public class ScanLocalRepositoryPlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "repository:scan";
        const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("ScanLocalRepositoryPlugin");

        private RepositoryDependencyScanner scanner;
        private bool verbose = false; 

        public ScanLocalRepositoryPlugin() {
            base(PLUGIN_NAME);
        }

        public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
            verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);
            
            try {
                initializeRepositoryScanner();
            } catch (RepositoryScannerError e) {
                throw new BobBuildPluginError.INITIALIZATION_ERROR(e.message);
            }
        }

        private void initializeRepositoryScanner() throws RepositoryScannerError {
            scanner = new RepositoryDependencyScanner();
            scanner.initialize();
        }

        public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
            LOGGER.logInfo("Scanning local repository for project dependencies.");
            
            scanner.scanDependenciesInRepository(projectRecipe, additionalDependency => {
                if (!projectRecipe.hasDependency(additionalDependency)) {
                    LOGGER.logInfo("Adding new dependency: %s.", additionalDependency.toString());
                    projectRecipe.addDependency(additionalDependency);
                }
            });
        }
    }
}