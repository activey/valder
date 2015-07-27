using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.execute;
using Vala;

namespace bob.builder.build.plugin.dependency {

    public class DebianPackageDepedencyResolver {

        private Logger LOGGER = Logger.getLogger("DebianPackageDepedencyResolver");

        private AptFilePackageResolver _aptFileResolver;
        private DpkgPackageResolver _dpkgResolver;
        private CodeContext _codeContext;
        private string[] _resolvedPackages = new string[0];

        public void initialize() throws DependencyResolverError {
            initializeDpkgResolver();
            initializeAptFileResolver();
        }

        private void initializeAptFileResolver() throws DependencyResolverError {
            _aptFileResolver = new AptFilePackageResolver();
            _aptFileResolver.initialize();
        }

        private void initializeDpkgResolver() throws DependencyResolverError {
            _dpkgResolver= new DpkgPackageResolver();
            _dpkgResolver.initialize();
        }

        public string[] resolveDebianPackages(FileObject libraryFile) {
            string packageFilePath = libraryFile.getLocation();
            LOGGER.logInfo("Resolving debian packages for library file: %s.", packageFilePath);
            
            _dpkgResolver.resolveFilePackages(packageFilePath);
            if (!_dpkgResolver.anyFound()) {
                LOGGER.logWarn("Unable to find [%s] library file in any of installed debian packages, trying other way ...", packageFilePath);

                _aptFileResolver.resolveFilePackages(packageFilePath);
                if (!_aptFileResolver.anyFound()) {
                    LOGGER.logError("Unable to find [%s] library file in any remote repositories.", packageFilePath);
                } else {
                    _aptFileResolver.forEachResolved(addResolvedPackage);
                }
            } else {
                _dpkgResolver.forEachResolved(addResolvedPackage);
            }
            return _resolvedPackages;
        }

        private void addResolvedPackage(string package) {
            if (package in _resolvedPackages) {
                return;
            }
            LOGGER.logInfo("Adding resolved debian package: %s.", package);
            _resolvedPackages += package;
        }
    }
}