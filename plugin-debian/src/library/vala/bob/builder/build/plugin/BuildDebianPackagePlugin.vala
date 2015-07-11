using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.json;
using bob.builder.build.plugin.control;
using bob.builder.build.plugin.dependency;

namespace bob.builder.build.plugin {

    public class BuildDebianPackagePlugin : AbstractBobBuildPlugin {

        private const string PLUGIN_NAME = "debian:package";
        const string RECIPE_ENTRY_VERBOSE = "verbose";
        
        private Logger LOGGER = Logger.getLogger("BuildDebianPackagePlugin");

        private DirectoryObject debianLibraryDirectory;
        private DirectoryObject debianBinaryDirectory;
        private DirectoryObject debianIncludeDirectory;
        private DirectoryObject debianVapiDirectory;

        private DebianPackageDepedencyResolver resolver;
        private bool verbose = true; 

        public BuildDebianPackagePlugin() {
            base(PLUGIN_NAME);
        }

        public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
            verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, true);

            try {
                initializeResolver();
            } catch (Error e) {
                throw new BobBuildPluginError.INITIALIZATION_ERROR(e.message);
            }
        }

        private void initializeResolver() throws DependencyResolverError {
            resolver = new DebianPackageDepedencyResolver();
            resolver.initialize();
        }

        public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
            createTemporaryDebianDirectory(projectRecipe);
            copyProjectFiles();

            generateControlFile(projectRecipe);
        }

        private void createTemporaryDebianDirectory(BobBuildProjectRecipe projectRecipe) {
            TemporaryDebianArchiveDirectoryStructure.debianDirectory(generateDirectoryName(projectRecipe), debianDirectory => {
                debianDirectory.directory("control.tar.gz.tmp", controlDirectory => {

                });

                debianDirectory.directory("data.tar.gz.tmp", data => {
                    data.directory("usr", usr => {

                        debianBinaryDirectory = usr.directory("bin", null);
                        debianLibraryDirectory = usr.directory("lib", null);
                        debianIncludeDirectory = usr.directory("include", null);

                        usr.directory("share", share => {
                            share.directory("vala", vala => {
                                debianVapiDirectory = vala.directory("vapi", null);
                            }); 
                        });
                    });
                });
            });
        }

        private void copyProjectFiles() {
            WorkingDirectoryStructure
                .target(targetDirectory => {
                    targetDirectory.directory(BobDirectories.DIRECTORY_LIB, libDirectory => {
                        libDirectory.getOrCreate().copyTo(debianLibraryDirectory, true);
                    });
                    targetDirectory.directory(BobDirectories.DIRECTORY_BIN, binDirectory => {
                        binDirectory.getOrCreate().copyTo(debianBinaryDirectory, true);
                    });
                })
                .source(sourceDirectory => {
                    sourceDirectory.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_NAME, libDirectory => {
                        libDirectory.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_VAPI_NAME, vapiDirectory => {
                            vapiDirectory.getOrCreate().copyTo(debianVapiDirectory, true);
                        });

                        libDirectory.directory(BobDirectories.DIRECTORY_SOURCE_LIBRARY_C_NAME, cDirectory => {
                            cDirectory.getOrCreate().copyTo(debianIncludeDirectory, true);    
                        });
                    });
                });
        }

        private string generateDirectoryName(BobBuildProjectRecipe projectRecipe) {
            return "%s-%u.deb".printf(projectRecipe.shortName, new DateTime.now_local().get_microsecond());
        }

        private void generateControlFile(BobBuildProjectRecipe projectRecipe) {
            ControlFileBuilder builder = ControlFileBuilder.controlFile()
                .package(projectRecipe.shortName)
                .version(projectRecipe.version)
                .section(projectRecipe.details.section)
                .optionalPriority()
                .architecture(projectRecipe.details.architecture)
                .description(projectRecipe.details.description);

            projectRecipe.dependencies.foreach(dependency => {
                string[] packages = resolver.resolvePackages(dependency);
                foreach (string package in packages) {
                    stdout.printf(">>>> %s \n", package);
                }
                //builder.depends(dependency);    
            });

            FileObject controlFile = builder.build();
            LOGGER.logInfo("Generated control file: %s.", controlFile.getLocation());
        }
    }
}