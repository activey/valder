using bob.builder.recipe.project;
using bob.builder.filesystem;

namespace bob.builder.build.plugin.execute {

	public errordomain PipedExecutableRunnerError {
		EXECUTABLE_ERROR
	}

	public class PipedExecutableRunner {

		public delegate void PipedExecutableFinishedDelegate(PipedExecutableOutput output);

		private string[] _arguments = new string[0];

		public PipedExecutableRunner(string argument, ...) {
			setArguments(argument, va_list());
		}

		private void setArguments(string firstArgument, va_list arguments) {
			_arguments += firstArgument;
			for (string? arg = arguments.arg<string?>(); arg != null ; arg = arguments.arg<string?>()) {
				_arguments += arg;
			}
		}

		public void run(PipedExecutableFinishedDelegate finishedDelegate) throws PipedExecutableRunnerError {
			try {
				GLib.Subprocess subprocess = new GLib.SubprocessLauncher(SubprocessFlags.STDOUT_PIPE).spawnv(_arguments);
				if (subprocess.wait()) {
					finishedDelegate(new PipedExecutableOutput.fromStream(subprocess.get_stdout_pipe()));
				} else {
					throw new PipedExecutableRunnerError.EXECUTABLE_ERROR("An error occurred while processing command.");
				}
			} catch (Error e) {
				throw new PipedExecutableRunnerError.EXECUTABLE_ERROR("An error occurred while processing command: %s.".printf(e.message));
			}
		}

		public void runWithInput(InputStream input, PipedExecutableFinishedDelegate finishedDelegate) throws PipedExecutableRunnerError {
			try {
				GLib.Subprocess subprocess = new GLib.SubprocessLauncher(SubprocessFlags.STDIN_PIPE | SubprocessFlags.STDOUT_PIPE).spawnv(_arguments);
				OutputStream inputPipe = subprocess.get_stdin_pipe();
				size_t dataWritten = feed(input, inputPipe);
				if (dataWritten == 0) {
					return;
				}
				if (subprocess.wait()) {
					finishedDelegate(new PipedExecutableOutput.fromStream(subprocess.get_stdout_pipe()));
				} else {
					throw new PipedExecutableRunnerError.EXECUTABLE_ERROR("An error occurred while processing command.");
				}
			} catch (Error e) {
				throw new PipedExecutableRunnerError.EXECUTABLE_ERROR("An error occurred while processing command: %s.".printf(e.message));
			}
		}

		private size_t feed(InputStream input, OutputStream output) throws Error {
			size_t dataSize;
			uint8[] data = new uint8[sizeof(int)]; 
			if (input.read_all(data, out dataSize, null)) {
				input.close();
				if (dataSize == 0) {
					return dataSize;
				}
				data.resize((int) dataSize);
				
				size_t dataWritten;
				output.write_all(data, out dataWritten, null);

				output.flush();
				output.close();
			}
			return dataSize;
		}
	}
}