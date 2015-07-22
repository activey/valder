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
			return file.get_path();
		}

		public string getLocationRelative(DirectoryObject relativeDirectory) {
			return relativeDirectory.getRelativeLocation(file);			
		}

		public string getName() {
			return file.get_basename();
		}

		public DirectoryObject getParent() {
			return new DirectoryObject(file.get_parent());
		}		
	}
}