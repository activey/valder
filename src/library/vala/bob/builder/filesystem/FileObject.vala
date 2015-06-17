using bob.builder.filesystem.visitor;

namespace bob.builder.filesystem {

	public class FileObject {

		private File file;

		public FileObject(File file) {
			this.file = file;
		}

		public void accept(FileSystemVisitor visitor) {
			visitor.visitFile(file);
		}

		public FileIOStream getStream() throws Error {
			FileIOStream stream = null;
			if (!file.query_exists()) {
				stream = file.create_readwrite(FileCreateFlags.PRIVATE);
			} else {
				stream = file.open_readwrite();
			}
			return stream;
		}
	}
}
