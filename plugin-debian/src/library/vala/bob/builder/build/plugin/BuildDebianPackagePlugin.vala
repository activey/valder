using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.json;
using bob.builder.build.plugin.md5;
using bob.builder.build.plugin.control;
using bob.builder.build.plugin.archive;

namespace bob.builder.build.plugin {

    public class BuildDebianPackagePlugin : AbstractBobBuildPlugin {

        private const string PLUGIN_NAME = "debian:package";
        const string RECIPE_ENTRY_VERBOSE = "verbose";
        
        private Logger LOGGER = Logger.getLogger("BuildDebianPackagePlugin");

        private DirectoryObject debianPackageDirectory;
        private FileObject destinationDebianFile;

        private FileObject debianControlFile;
        private FileObject md5ChecksumsFile;
        private FileObject debianBinaryFile;
        private DirectoryObject debianLibraryDirectory;
        private DirectoryObject debianBinaryDirectory;
        
        private DebianArchiveCreator _archiveCreator;
        private ControlFileGenerator _controlGenerator;
        private MD5ChecksumsFileGenerator _md5Generator;

        private bool verbose = false; 

        public BuildDebianPackagePlugin() {
            base(PLUGIN_NAME);
        }

        public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
            verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, verbose);

            try {
                initializeDebianArchiveCreator();
                initializeMD5Generator();
                initializeControlGenerator();
            } catch (Error e) {
                throw new BobBuildPluginError.INITIALIZATION_ERROR(e.message);
            }
        }

        private void initializeDebianArchiveCreator() throws Error {
            _archiveCreator = new DebianArchiveCreator();
            _archiveCreator.initialize();
        }

        private void initializeMD5Generator() {
            _md5Generator = new MD5ChecksumsFileGenerator();
        }

        private void initializeControlGenerator() throws Error {
            _controlGenerator = new ControlFileGenerator();
            _controlGenerator.initialize();
        }

        public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
            createTemporaryDebianDirectory(projectRecipe);
            copyProjectFiles();

            try {
                generateMd5ChecksumsFile();
                generateControlFile(projectRecipe);
                
                LOGGER.logSuccess("Generated debian archive: %s.", generateDebianArchive(projectRecipe).getLocation());
            } catch (Error e) {
                throw new BobBuildPluginError.RUN_ERROR(e.message);
            }
        }

        private void createTemporaryDebianDirectory(BobBuildProjectRecipe projectRecipe) {
            TemporaryDebianArchiveDirectoryStructure.debianDirectory(debianTemporaryDirectoryName(projectRecipe), debianDirectory => {

                destinationDebianFile = debianDirectory.getOrCreate().getFileChild(debianFileName(projectRecipe));

                debianDirectory.directory(debianFileName(projectRecipe) + ".tmp", sourceDirectory => {
                    debianPackageDirectory = sourceDirectory.getOrCreate();
                    debianBinaryFile = sourceDirectory.getOrCreate().getFileChild("debian-binary");

                    sourceDirectory.directory("DEBIAN", control => {
                        debianControlFile = control.getOrCreate().getFileChild("control");
                        md5ChecksumsFile = control.getOrCreate().getFileChild("md5sums");
                    });

                    sourceDirectory.directory("usr", usr => {
                        debianBinaryDirectory = usr.directory("bin", null);
                        debianLibraryDirectory = usr.directory("lib", null);
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
                        _md5Generator.scanDirectory(debianLibraryDirectory, debianPackageDirectory);
                    });
                    targetDirectory.directory(BobDirectories.DIRECTORY_BIN, binDirectory => {
                        binDirectory.getOrCreate().copyTo(debianBinaryDirectory, true);
                        _md5Generator.scanDirectory(debianBinaryDirectory, debianPackageDirectory);
                    });
                });
        }

        private string debianFileName(BobBuildProjectRecipe projectRecipe) {
            return "%s-%s.deb".printf(projectRecipe.shortName, projectRecipe.version);
        }

        private string debianTemporaryDirectoryName(BobBuildProjectRecipe projectRecipe) {
            return "%s-%u.debian.package".printf(projectRecipe.shortName, new DateTime.now_local().get_microsecond());
        }

        private void generateMd5ChecksumsFile() throws Error {
            LOGGER.logInfo("Generating md5sums file.");
            _md5Generator.generate(md5ChecksumsFile);
        }

        private void generateControlFile(BobBuildProjectRecipe projectRecipe) throws Error {
            _controlGenerator.generate(projectRecipe, debianControlFile);
            LOGGER.logInfo("Generated control file: %s.", debianControlFile.getLocation());
        }

        private FileObject generateDebianArchive(BobBuildProjectRecipe projectRecipe) throws Error {
            return new DebianArchiveCreator().createDebianArchive(destinationDebianFile, debianPackageDirectory);
        }
    }
}