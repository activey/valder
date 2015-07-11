using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.build.plugin.execute;

namespace bob.builder.build.plugin.dependency {

	public errordomain DependencyResolverError {
		INITIALIZATION_ERROR
	}

	public class DebianPackageDepedencyResolver {

		private const string COMMAND_APT_FILE = "apt-file";

		public void initialize() throws DependencyResolverError {
			WhichChecker checker = new WhichChecker(COMMAND_APT_FILE);
			if (!checker.success()) {
				throw new DependencyResolverError.INITIALIZATION_ERROR("Unable to find '%s' command!".printf(COMMAND_APT_FILE));
			}
		}

		public string[] resolvePackages(BobBuildProjectDependency dependency) {
			try {
				ExecutableRunner executableRunner = new ExecutableRunner("%s search %s.vapi".printf(COMMAND_APT_FILE, dependency.toString()));
				string result = executableRunner.run();
				return result.split("\n");
			} catch (Error e) {
				return new string[0];
			}
		}
	}
}