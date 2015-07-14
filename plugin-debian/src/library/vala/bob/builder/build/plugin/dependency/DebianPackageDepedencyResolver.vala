using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.execute;
using Vala;

namespace bob.builder.build.plugin.dependency {

    public errordomain DependencyResolverError {
        INITIALIZATION_ERROR
    }

    public class DebianPackageDepedencyResolver {

        private Logger LOGGER = Logger.getLogger("DebianPackageDepedencyResolver");

        private AptFilePackageResolver _aptFileResolver;
        private DpkgPackageResolver _dpkgResolver;
        private CodeContext _codeContext;
        private string[] _resolvedPackages = new string[0];

        public void initialize() throws DependencyResolverError {
            initializeDpkgResolver();
            initializeAptFileResolver();
            initializeCodeContext();
        }

        private void initializeAptFileResolver() throws DependencyResolverError {
            _aptFileResolver = new AptFilePackageResolver();
            _aptFileResolver.initialize();
        }

        private void initializeDpkgResolver() throws DependencyResolverError {
            _dpkgResolver= new DpkgPackageResolver();
            _dpkgResolver.initialize();
        }

        private void initializeCodeContext() {
            _codeContext = new CodeContext();
            CodeContext.push(_codeContext);
        }

        public string[] resolveDebianPackages(BobBuildProjectDependency dependency) {
            LOGGER.logInfo("Resolving debian packages for dependency: %s.", dependency.toString());
            VapiFileCodeVisitor codeVisitor = visitVapiPackage(dependency.toString());
            codeVisitor.forEachVapiFile(resolveFilePackages);
            codeVisitor.forEachCHeader(resolveFilePackages);

            finish();
            return _resolvedPackages;
        }

        private void resolveFilePackages(string packageFilePath) {
            _dpkgResolver.resolveFilePackages(packageFilePath);
            if (!_dpkgResolver.anyFound()) {
                LOGGER.logWarn("Unable to find [%s] file in any of installed debian packages, trying other way ...");

                _aptFileResolver.resolveFilePackages(packageFilePath);
                if (!_aptFileResolver.anyFound()) {
                    LOGGER.logError("Unable to find [%s] file in any remote repositories.");
                } else {
                    _aptFileResolver.forEachResolved(addResolvedPackage);
                }
            } else {
                _dpkgResolver.forEachResolved(addResolvedPackage);
            }
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

        private void finish() {
            CodeContext.pop();
        }
    }
}