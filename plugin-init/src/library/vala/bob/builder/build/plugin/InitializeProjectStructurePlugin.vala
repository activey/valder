using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

    public class InitializeProjectStructurePlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "initialize:structure";
        const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("InitializeProjectStructurePlugin");

        private bool verbose = false; 

        public InitializeProjectStructurePlugin() {
            base(PLUGIN_NAME);
        }

        public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
            verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);
        }

        public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
            LOGGER.logInfo("Initializing project directory structure.");

            ProjectDirectoryStructureBuilder
                .projectDirectory(projectDirectory)
                .directory(BobDirectories.DIRECTORY_SOURCE, src => {
                    src.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_NAME, library => {
                        library.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_VALA_NAME, null);
                        library.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_VAPI_NAME, null);
                        library.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_C_NAME, null); 
                    });

                    src.directory(BobDirectories.DIRECTORY_SOURCE_RUNTIME_NAME, main => {
                        main.directory(BobDirectories.DIRECTORY_SOURCE_RUNTIME_VALA_NAME, null);
                    });
                })
                .directory(BobDirectories.DIRECTORY_TARGET, target => {
                    target.directory(BobDirectories.DIRECTORY_LIB, null);
                    target.directory(BobDirectories.DIRECTORY_BIN, null);
                });

            LOGGER.logSuccess("Base project directory structure created.");
        }
    }
}