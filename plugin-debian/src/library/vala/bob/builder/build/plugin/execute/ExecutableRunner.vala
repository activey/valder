using bob.builder.recipe.project;
using bob.builder.filesystem;

namespace bob.builder.build.plugin.execute {

	public errordomain ExecutableRunnerError {
		EXECUTABLE_ERROR
	}

	public class ExecutableRunner {

		private string _command;

		public ExecutableRunner(string command) {
			_command = command;
		}

		public string run() throws ExecutableRunnerError {
			string output;
			string error;
			int status;

			try {
				Process.spawn_command_line_sync(_command, out output, out error, out status);
			} catch (Error e) {
				throw new ExecutableRunnerError.EXECUTABLE_ERROR("An error occurred while running executable: %s.", e.message);
			}
			if (status > 0) {
				throw new ExecutableRunnerError.EXECUTABLE_ERROR(error);
			}
			return output;
		}
	}
}