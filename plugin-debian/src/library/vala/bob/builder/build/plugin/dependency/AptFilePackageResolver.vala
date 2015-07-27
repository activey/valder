using bob.builder.log;
using bob.builder.build.plugin.execute;

namespace bob.builder.build.plugin.dependency {

    public class AptFilePackageResolver {

        public delegate void AptFilePackageResolvedDelegate(string resolvedPackage);

        private Logger LOGGER = Logger.getLogger("AptFilePackageResolver");
        
        private const string COMMAND_APT_FILE = "apt-file";
        private const string MISSING_ERROR = "Unable to find '%s' command! If you are running Debian based distribution please install it by executing 'sudo apt-get install %s' command.";

        private string[] _resolvedPackages = new string[0];

        public void initialize() throws DependencyResolverError {
            validateAptFileExists();
        }

        private void validateAptFileExists() throws DependencyResolverError {
            WhichChecker checker = new WhichChecker(COMMAND_APT_FILE);
            if (!checker.success()) {
                throw new DependencyResolverError.INITIALIZATION_ERROR(MISSING_ERROR.printf(COMMAND_APT_FILE, COMMAND_APT_FILE));
            }
        }

        public void resolveFilePackages(string file) {
            try {
                LOGGER.logInfo("Resolving '%s' dependency for file: %s.", COMMAND_APT_FILE, file);
                
                ExecutableRunner executableRunner = new ExecutableRunner("%s search '%s' -l".printf(COMMAND_APT_FILE, file));
                foreach (string package in executableRunner.run().split("\n")) {
                    if (package == null || package.length == 0) {
                        continue;
                    }
                    _resolvedPackages += package;
                }
            } catch (Error e) {
                LOGGER.logError("An error occurred while searching packages for [%s] file: %s.", file, e.message);
            }
        }

        public bool anyFound() {
            return _resolvedPackages.length > 0;
        }

        public void forEachResolved(AptFilePackageResolvedDelegate resolvedDelegate) {
            foreach (string resolvedPackage in _resolvedPackages) {
                resolvedDelegate(resolvedPackage);
            }
        }
    }
}