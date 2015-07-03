using bob.builder.build;
using bob.builder.recipe;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public class RepositoryDependencyScanner {

		public delegate void AdditionalDependencyFoundDelegate(BobBuildProjectDependency dependency);

        private Logger LOGGER = Logger.getLogger("RepositoryDependencyScanner");

        private DirectoryObject repositoryDirectory;
		private DirectoryObject projectDirectory;
        private DirectoryObject vapiDirectory;
        private DirectoryObject cDirectory;

        public void initialize() throws RepositoryScannerError {
            RepositoryProjectDirectoryStructure
                .read(repository => {
                    repositoryDirectory = repository.getOrCreate();
                });

            if (!repositoryDirectory.exists()) {
                throw new RepositoryScannerError.INITIALIZATION_ERROR("Unable to find repository directory under location: %s", repositoryDirectory.getLocation());
            }
            LOGGER.logInfo("Found repository directory: %s.", repositoryDirectory.getLocation());
        }

		public void scanDependenciesInRepository(BobBuildProjectRecipe projectRecipe, AdditionalDependencyFoundDelegate additionalDependencyDelegate) {
            projectRecipe.dependencies.foreach(dependency => {
                scanProjectDependencyMatch(dependency, additionalDependencyDelegate);    

                additionalDependencyDelegate(dependency);
            });
		}

        private void scanProjectDependencyMatch(BobBuildProjectDependency dependency, AdditionalDependencyFoundDelegate additionalDependencyDelegate) {
            LOGGER.logInfo("Scanning for depedency match in local repository: %s", dependency.toString());
            
            RepositoryProjectDirectoryStructure.
                readFrom(repositoryDirectory, repository => {
                    repository.directory(dependency.dependency, project => {
                        projectDirectory = project.directory(dependency.version, versionDirectory => {
                            vapiDirectory = versionDirectory.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_VAPI_NAME, null);
                            cDirectory = versionDirectory.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_C_NAME, null); 
                        });
                    });
                });

            if (!projectDirectory.exists()) {
                LOGGER.logWarn("Repository directory for %s does not exist.", dependency.toString());
                return;
            }

            assignVapiDirectory(dependency, vapiDirectory);
            assignCHeadersDirectory(dependency, cDirectory);
            processRecipeFile(projectDirectory.getFileChild(BobFiles.FILE_PROJECT_RECIPE), additionalDependencyDelegate);
        }

        private void assignVapiDirectory(BobBuildProjectDependency dependency, DirectoryObject vapiDirectory) {
            if (!vapiDirectory.exists()) {
                LOGGER.logWarn("VAPI directory does not exist.");
                return;
            }
            dependency.vapiDirectory = vapiDirectory.getLocation();
        }

        private void assignCHeadersDirectory(BobBuildProjectDependency dependency, DirectoryObject cDirectory) {
            if (!cDirectory.exists()) {
                LOGGER.logWarn("C headers directory does not exist.");
                return;
            }
            dependency.cHeadersDirectory = cDirectory.getLocation();
        }

        private void processRecipeFile(FileObject recipeFile, AdditionalDependencyFoundDelegate additionalDependency) {
            if (!recipeFile.exists()) {
                LOGGER.logWarn("Recipe file does not exist.");
                return;
            }

            LOGGER.logInfo("Scanning recipe file: %s", recipeFile.getLocation());
            try {
                BobBuildRecipe recipe = BobBuildRecipeLoader.loadFromJSONFileObject(recipeFile);
                
                RepositoryDependencyScanner scanner = new RepositoryDependencyScanner();
                scanner.initialize();
                scanner.scanDependenciesInRepository(recipe.project, additionalDependency);
            } catch (Error e) {
                LOGGER.logError("An error occurred while parsing recipe file: %.", e.message);
            }
        }
	}
}