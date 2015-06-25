using bob.builder.filesystem.visitor;

namespace bob.builder.filesystem {

	public abstract class FileSystemObject {

		protected File file;

		public FileSystemObject(File file) {
			this.file = file;
		}

		public bool exists() {
			return file.query_exists();
		}

		public string getLocation() {
			return exists() ? file.get_path() : null;
		}
	}
}