using com.futureprocessing.bob.build.plugin;
using com.futureprocessing.bob.log;

namespace com.futureprocessing.bob.build.plugin {

	public class UncrustifyRunner : Object {

        public signal void valaFileFound(File valaFile);

        private const string COMMAND_UNCRUSTIFY = "uncrustify";
        private const string PARAMETER_HELP = "--help";
        private const string PARAMETER_CONFIGURATION = "-c";
        private const string PARAMETER_REPLACE= "--replace";
        private const string PARAMETER_NO_BACKUP= "--no-backup";

        private const string PARAMETER_OUTPUT_PREFFIX = "--prefix";

        private Logger LOGGER = Logger.getLogger("UncrustifyRunner");

        private string configurationFile;
        private bool verbose = false;
        public bool backup { get; set; default = true; }

        public UncrustifyRunner(string configurationFile, bool verbose) {
            this.configurationFile = configurationFile;
            this.verbose = verbose;
        }

        public void checkUncrustifyAvailable() throws SpawnError {
            spawnProcess(COMMAND_UNCRUSTIFY, {PARAMETER_HELP});
        }

        public void run(List<string> filesToProcess, string? outputPreffix, bool replaceOriginal) throws SpawnError {
            string[] uncrustifyArguments = {PARAMETER_CONFIGURATION, configurationFile};
            if (outputPreffix != null) {
                uncrustifyArguments += PARAMETER_OUTPUT_PREFFIX;
                uncrustifyArguments += outputPreffix;
            }
            if (replaceOriginal) {
                uncrustifyArguments += PARAMETER_REPLACE;
            }
            if (!backup) {
                uncrustifyArguments += PARAMETER_NO_BACKUP;
            }
            foreach (string fileToProcess in filesToProcess) {
                uncrustifyArguments += fileToProcess;
            }
            string result = spawnProcess(COMMAND_UNCRUSTIFY, uncrustifyArguments);
            if (verbose) {
                LOGGER.logInfo(result);
            }
        }

        private string spawnProcess(string executable, string[] parametersWithValues) throws SpawnError {
            string[] spawnArguments = {executable};
            foreach (string parameter in parametersWithValues) {
                spawnArguments += parameter;
            }

            string outputBuffer;
            string errorBuffer;
            int exitStatus;
            Process.spawn_sync(".", spawnArguments, Environ.get(), SpawnFlags.SEARCH_PATH, null, out outputBuffer, out errorBuffer, out exitStatus);
            return errorBuffer;
        }
	}
}