using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.execute;

namespace bob.builder.build.plugin.dependency {

	public errordomain DependencyResolverError {
		INITIALIZATION_ERROR
	}

	public class DebianPackageDepedencyResolver {

		private const string COMMAND_APT_FILE = "apt-file";
		private const string MISSING_ERROR = "Unable to find '%s' command! If you are running Debian based distribution please install it by executing 'sudo apt-get install %s' command.";

        private Logger LOGGER = Logger.getLogger("DebianPackageDepedencyResolver");

		public void initialize() throws DependencyResolverError {
			WhichChecker checker = new WhichChecker(COMMAND_APT_FILE);
			if (!checker.success()) {
				throw new DependencyResolverError.INITIALIZATION_ERROR(MISSING_ERROR.printf(COMMAND_APT_FILE, COMMAND_APT_FILE));
			}
		}

		public string[] resolvePackages(BobBuildProjectDependency dependency) {
			LOGGER.logInfo("Resolving debian package for dependency: %s.", dependency.toString());
			return join(getVapiPackages(dependency), getCPackages(dependency));
		}

		private string[] getVapiPackages(BobBuildProjectDependency dependency) {
			try {
				ExecutableRunner executableRunner = new ExecutableRunner("%s search %s.vapi".printf(COMMAND_APT_FILE, dependency.toString()));
				string result = executableRunner.run();
				return result.split("\n");
			} catch (Error e) {
				LOGGER.logError("An error occurred while searching packages for VAPI [%s.vapi] file: %s.", dependency.toString(), e.message);
				return new string[0];
			}
		}

		private string[] getCPackages(BobBuildProjectDependency dependency) {
			try {
				ExecutableRunner executableRunner = new ExecutableRunner("%s search %s.h".printf(COMMAND_APT_FILE, dependency.toString()));
				string result = executableRunner.run();
				return result.split("\n");
			} catch (Error e) {
				LOGGER.logError("An error occurred while searching packages for C header [%s.h] file: %s.", dependency.toString(), e.message);
				return new string[0];
			}
		}

		private string[] join(string[] firstArray, string[] secondArray) {
			string[] joined = new string[0];
			foreach (string value in firstArray) {
				joined += value;
			}
			foreach (string value in secondArray) {
				joined += value;
			}
			return joined;
		}
	}
}