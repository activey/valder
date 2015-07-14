using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.dependency;

namespace bob.builder.build.plugin.control {

	public class ControlFileGenerator {

        private Logger LOGGER = Logger.getLogger("ControlFileGenerator");

        private DebianPackageDepedencyResolver _resolver;
		private ControlFileBuilder _fileBuilder;

		public void initialize() throws DependencyResolverError {
			initializeResolver();
			initializeFileBuilder();
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
            generateDependencies(projectRecipe);

            _fileBuilder.build(controlFile);
		}

		private void generateDependencies(BobBuildProjectRecipe projectRecipe) {
			projectRecipe.dependencies.foreach(dependency => {
                string[] packages = _resolver.resolveDebianPackages(dependency);
                if (packages.length == 0) {
                    LOGGER.logWarn("No packages found for dependency: %s.", dependency.toString());
                    return;    
                }

                string lastFound = "unknown";
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