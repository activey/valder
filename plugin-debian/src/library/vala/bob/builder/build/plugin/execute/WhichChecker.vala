using bob.builder.recipe.project;
using bob.builder.filesystem;

namespace bob.builder.build.plugin.execute {

	public class WhichChecker {

		private ExecutableRunner executableRunner;

		public WhichChecker(string commandToCheck) {
			executableRunner = new ExecutableRunner("which %s".printf(commandToCheck));
		}

		public bool success() {
			try {
				executableRunner.run();
				return true;
			} catch (ExecutableRunnerError e) {
				return false;
			}
		}
	}
}