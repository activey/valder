using bob.builder.build;
using bob.builder.recipe;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

    public class CopyLibraryFromRepositoryPlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "repository:copy-libs";
        const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("CopyLibraryFromRepositoryPlugin");

        private bool verbose = false; 

        public CopyLibraryFromRepositoryPlugin() {
            base(PLUGIN_NAME);
        }

        public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
            verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);
        }

        public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
            DirectoryObject targetLibDirectory = projectDirectory.getDirectoryChildAtLocation(BobDirectories.DIRECTORY_TARGET_LIB);
            if (!targetLibDirectory.exists()) {
                LOGGER.logWarn("Unable to find project lib directory under location: %s.", targetLibDirectory.getLocation());
                return;
            }
            projectRecipe.dependencies.foreach(dependency => {
                copyDependencyLibrary(dependency, targetLibDirectory);    
            });
        }

        private void copyDependencyLibrary(BobBuildProjectDependency dependency, DirectoryObject targetLibDirectory) {
            RepositoryProjectDirectoryStructure
                .read(repository => {
                    repository.directory(dependency.dependency, project => {

                        project.directory(dependency.version, versionDirectory => {
                            DirectoryObject libDirectory = versionDirectory.directory(BobDirectories.DIRECTORY_LIB, null); 
                            copyDependencyLibraryToLibDirectory(dependency, libDirectory, targetLibDirectory);
                        });
                    });
                });
        }

        private void copyDependencyLibraryToLibDirectory(BobBuildProjectDependency dependency, DirectoryObject repositoryLibDirectory, DirectoryObject targetLibDirectory) {
            FileObject libFile = repositoryLibDirectory.getFileChild(BobFiles.FILE_TARGET_LIBRARY_NAME.printf(dependency.dependency));
            if (!libFile.exists()) {
                LOGGER.logWarn("Unable to locate library file under location: %s.", libFile.getLocation());
                return;
            }
            LOGGER.logInfo("Copying library [%s] file into location: %s.", libFile.getLocation(), targetLibDirectory.getLocation());
            try {
                libFile.copyTo(targetLibDirectory, true);
            } catch (Error e) {
                LOGGER.logError("An error occurred while copying library file: %s.", e.message);
            }
        }
    }
}