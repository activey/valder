using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.execute;

namespace bob.builder.build.plugin.archive {

    public errordomain DebianDependencyError {
        INITIALIZATION_ERROR
    }

    public class DebianArchiveCreator {

        private const string COMMAND_DPKG = "dpkg";
        private const string MISSING_ERROR = "Unable to find '%s' command!";

        private Logger LOGGER = Logger.getLogger("DebianArchiveCreator");

        public void initialize() throws DebianDependencyError {
            WhichChecker checker = new WhichChecker(COMMAND_DPKG);
            if (!checker.success()) {
                throw new DebianDependencyError.INITIALIZATION_ERROR(MISSING_ERROR.printf(COMMAND_DPKG));
            }
        }

        public FileObject createDebianArchive(FileObject destinationFile, DirectoryObject sourceDirectory) throws Error {
            string result = new ExecutableRunner("%s -b %s %s".printf(COMMAND_DPKG, sourceDirectory.getLocation(), destinationFile.getLocation())).run();
            LOGGER.logInfo(result);
            return destinationFile;
        }

    }
}