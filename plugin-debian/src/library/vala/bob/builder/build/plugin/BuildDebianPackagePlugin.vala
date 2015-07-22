using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.json;
using bob.builder.build.plugin.control;
using bob.builder.build.plugin.archive;

namespace bob.builder.build.plugin {

    public class BuildDebianPackagePlugin : AbstractBobBuildPlugin {

        private const string PLUGIN_NAME = "debian:package";
        const string RECIPE_ENTRY_VERBOSE = "verbose";
        
        private Logger LOGGER = Logger.getLogger("BuildDebianPackagePlugin");

        private DirectoryObject debianLibraryDirectory;
        private DirectoryObject debianBinaryDirectory;
        private DirectoryObject debianIncludeDirectory;
        private DirectoryObject debianVapiDirectory;
        private DirectoryObject debianPackageDirectory;
        private FileObject debianControlFile;

        private ControlFileGenerator _controlGenerator;
        private bool verbose = false; 

        public BuildDebianPackagePlugin() {
            base(PLUGIN_NAME);
        }

        public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
            verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, verbose);

            try {
                initializeControlGenerator();
            } catch (Error e) {
                throw new BobBuildPluginError.INITIALIZATION_ERROR(e.message);
            }
        }

        private void initializeControlGenerator() throws Error {
            _controlGenerator = new ControlFileGenerator();
            _controlGenerator.initialize();
        }

        public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
            createTemporaryDebianDirectory(projectRecipe);
            copyProjectFiles();

            try {
                generateControlFile(projectRecipe);
                
                LOGGER.logSuccess("Generated debian archive: %s.", generateDebianArchive(projectRecipe).getLocation());
            } catch (Error e) {
                throw new BobBuildPluginError.RUN_ERROR(e.message);
            }
        }

        private void createTemporaryDebianDirectory(BobBuildProjectRecipe projectRecipe) {
            TemporaryDebianArchiveDirectoryStructure.debianDirectory(generateDirectoryName(projectRecipe), debianDirectory => {
                debianPackageDirectory = debianDirectory.getOrCreate();

                debianDirectory.directory("control.tar.gz.tmp", controlDirectory => {
                    debianControlFile = controlDirectory.getOrCreate().getFileChild("control");
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
                .read()
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

        private void generateControlFile(BobBuildProjectRecipe projectRecipe) throws Error {
            _controlGenerator.generate(projectRecipe, debianControlFile);
            LOGGER.logInfo("Generated control file: %s.", debianControlFile.getLocation());
        }

        private FileObject generateDebianArchive(BobBuildProjectRecipe projectRecipe) throws Error {
            return DebianArchiveBuilder
                .relativeDirectory(debianPackageDirectory)
                .name("%s-%s.deb".printf(projectRecipe.shortName, projectRecipe.version))
                .debianControlFile(debianControlFile)
                .debianBinaryDirectory(debianBinaryDirectory)
                .debianLibraryDirectory(debianLibraryDirectory)
                .debianIncludeDirectory(debianIncludeDirectory)
                .debianVapiDirectory(debianVapiDirectory)
                .build();
        }
    }
}