using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.filesystem.visitor;
using bob.builder.log;
using bob.builder.build.plugin.dependency;

namespace bob.builder.build.plugin.control {

    public class ControlFileGenerator {

        private Logger LOGGER = Logger.getLogger("ControlFileGenerator");

        private LddLibrariesInspector _librariesInspector;
        private DebianPackageDepedencyResolver _resolver;
        private ControlFileBuilder _fileBuilder;

        public void initialize() throws DependencyResolverError {
            initializeLibrariesInspector();
            initializeResolver();
            initializeFileBuilder();
        }

        private void initializeLibrariesInspector() {
            _librariesInspector = new LddLibrariesInspector();
        }

        private void initializeResolver() throws DependencyResolverError {
            _resolver = new DebianPackageDepedencyResolver();
            _resolver.initialize();
        }

        private void initializeFileBuilder() {
            _fileBuilder = ControlFileBuilder.controlFile();
        }

        public void generate(BobBuildProjectRecipe projectRecipe, FileObject controlFile) throws Error {
            _fileBuilder
                .package(projectRecipe.shortName)
                .version(projectRecipe.version)
                .section(projectRecipe.details.section)
                .optionalPriority()
                .architecture(projectRecipe.details.architecture)
                .description(projectRecipe.details.description);

            generateAuthors(projectRecipe.details);
            generateDependencies();

            _fileBuilder.build(controlFile);
        }

        private void generateDependencies() {
            WorkingDirectoryStructure
                .read()
                .target(targetDirectory => {
                    targetDirectory.directory(BobDirectories.DIRECTORY_LIB, libDirectory => {
                        libDirectory.getOrCreate().accept(new FileDelegateVisitor(generateLibraryDependencies), false);
                    });

                    targetDirectory.directory(BobDirectories.DIRECTORY_BIN, binDirectory => {
                        binDirectory.getOrCreate().accept(new FileDelegateVisitor(generateLibraryDependencies), false);
                    });
                });
        }

        private void generateLibraryDependencies(FileObject libraryFile) {
            LOGGER.logInfo("Analyzing library file dependencies for: %s.", libraryFile.getLocation());
            _librariesInspector.inspectLibraryDependencies(libraryFile, dependendLibraryFile => {
                LOGGER.logInfo("Found dependend library file: %s.", dependendLibraryFile.getLocation());

                string[] packages = _resolver.resolveDebianPackages(dependendLibraryFile);
                if (packages.length == 0) {
                    LOGGER.logWarn("No packages found for library file dependency: %s.",dependendLibraryFile.getLocation());
                    return;    
                }

                foreach (string package in packages) {
                    LOGGER.logInfo("Found debian package: %s.", package);
                    _fileBuilder.depends(new ControlFileDebianPackage.withName(package));
                }
            });
        }

        private void generateAuthors(BobBuildProjectDetails projectDetails) {
            foreach (string author in projectDetails.authors) {
                _fileBuilder.author(author);
            }
        }
    }
}