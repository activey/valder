using bob.builder.recipe.project;
using bob.builder.filesystem;
using Posix;

namespace bob.builder.build.plugin.execute {

	public class PipedExecutableOutput {

		private string _streamText = "";

		public PipedExecutableOutput.fromStream(InputStream stream) {
			readText(stream);
		}

		private void readText(InputStream stream) {
			DataInputStream dataStream = new DataInputStream(stream);
			string? line = null;
			while ((line = dataStream.read_line()) != null) {
				_streamText += line;
			}
		}

		public string? getText() {
			return _streamText;
		}

		public InputStream getStream() { 
			return new MemoryInputStream.from_data(_streamText.data, null);
		}
	}
}