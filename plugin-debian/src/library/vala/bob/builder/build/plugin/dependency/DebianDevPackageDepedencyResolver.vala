using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.execute;
using Vala;

namespace bob.builder.build.plugin.dependency {

    public class DebianDevPackageDepedencyResolver {

        private Logger LOGGER = Logger.getLogger("DebianDevPackageDepedencyResolver");

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

        public string[] resolveDebianPackages(BobBuildProjectDependency dependency) {
            LOGGER.logInfo("Resolving debian packages for dependency: %s.", dependency.toString());
            
            _codeContext = new CodeContext();
            CodeContext.push(_codeContext);
            
            VapiFileCodeVisitor codeVisitor = visitVapiPackage(dependency.toString());
            codeVisitor.forEachVapiFile(resolveVapiFilePackages);
            codeVisitor.forEachCHeader(resolveCHeaderFilePackages);

            CodeContext.pop();
            return _resolvedPackages;
        }

        private void resolveVapiFilePackages(string packageFilePath) {
            _dpkgResolver.resolveFilePackages(packageFilePath);
            if (!_dpkgResolver.anyFound()) {
                LOGGER.logWarn("Unable to find [%s] file in any of installed debian packages, trying other way ...", packageFilePath);

                _aptFileResolver.resolveFilePackages(packageFilePath);
                if (!_aptFileResolver.anyFound()) {
                    LOGGER.logError("Unable to find [%s] VAPI file in any remote repositories.", packageFilePath);
                } else {
                    _aptFileResolver.forEachResolved(addResolvedPackage);
                }
            } else {
                _dpkgResolver.forEachResolved(addResolvedPackage);
            }
        }

        private void resolveCHeaderFilePackages(CHeader cHeaderFile) {
            _dpkgResolver.resolveFilePackages(versionedPackageFilePath(cHeaderFile));
            if (!_dpkgResolver.anyFound()) {
                LOGGER.logWarn("Unable to find [%s] C header file in any of installed debian packages with GIR Version = [%s], looking up for non versioned file dependency.", versionedPackageFilePath(cHeaderFile), cHeaderFile.girVersion);
                _dpkgResolver.resolveFilePackages(nonVersionedPackageFilePath(cHeaderFile));
                if (!_dpkgResolver.anyFound()) {
                    LOGGER.logWarn("Unable to find [%s] C header file in any of installed debian packages, trying other way ...", nonVersionedPackageFilePath(cHeaderFile), cHeaderFile.girVersion);
                    _aptFileResolver.resolveFilePackages(versionedPackageFilePath(cHeaderFile));
                    if (!_aptFileResolver.anyFound()) {
                        LOGGER.logError("Unable to find [%s] file with GIR Version = [%s] in any remote repositories, trying non versioned file.", versionedPackageFilePath(cHeaderFile), cHeaderFile.girVersion);
                        _aptFileResolver.resolveFilePackages(nonVersionedPackageFilePath(cHeaderFile));
                        if(!_aptFileResolver.anyFound()) {
                            LOGGER.logError("Unable to find [%s] file in any remote repositories.", nonVersionedPackageFilePath(cHeaderFile));
                        } else {
                            _aptFileResolver.forEachResolved(addResolvedPackage);
                        }
                    } else {
                        _aptFileResolver.forEachResolved(addResolvedPackage);
                    }
                } else {
                    _dpkgResolver.forEachResolved(addResolvedPackage);
                } 
            } else {
                _dpkgResolver.forEachResolved(addResolvedPackage);
            }
        }

        private string versionedPackageFilePath(CHeader cHeaderFile) {
            return "/usr/include/*%s".printf(cHeaderFile.getVersionedFileName());
        }

        private string nonVersionedPackageFilePath(CHeader cHeaderFile) {
            return "/usr/include/*/%s".printf(cHeaderFile.path);
        }

        private void addResolvedPackage(string package) {
            if (package in _resolvedPackages) {
                return;
            }
            LOGGER.logInfo("Adding resolved debian package: %s.", package);
            _resolvedPackages += package;
        }

        private VapiFileCodeVisitor visitVapiPackage(string vapiPackage) {
            VapiFileCodeVisitor codeVisitor = new VapiFileCodeVisitor();
            _codeContext.add_external_package(vapiPackage);             
            new Parser().parse(_codeContext);
            _codeContext.accept(codeVisitor);

            return codeVisitor;
        }
    }
}