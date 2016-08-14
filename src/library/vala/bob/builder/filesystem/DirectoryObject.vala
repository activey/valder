using bob.builder.log;
using bob.builder.filesystem.visitor;
using bob.builder.filesystem.copy;

namespace bob.builder.filesystem {

	public class DirectoryObject : FileSystemObject {

		private const string CURRENT_DIRECTORY = ".";

		private Logger LOGGER = Logger.getLogger("DirectoryObject");

		public DirectoryObject(File directory) {
			base(directory);
		}

		public DirectoryObject.fromGivenLocation(string directoryLocation) {
			base(File.new_for_path(directoryLocation));
		}

		public DirectoryObject.fromCurrentLocation() {
			this.fromGivenLocation(CURRENT_DIRECTORY);
		}

		public DirectoryObject.fromUserHomeDirectory() {
			this.fromGivenLocation(Environment.get_home_dir());
		}

		public DirectoryObject.fromTemporaryDirectory() {
			this.fromGivenLocation(Environment.get_tmp_dir());
		}

		public void accept(FileSystemVisitor visitor, bool recursive) {
			if (!exists()) {
				return;
			}
			try {
				FileEnumerator enumerator = file.enumerate_children(FileAttribute.STANDARD_NAME, 0);
				FileInfo fileInfo;
				while ((fileInfo = enumerator.next_file()) != null) {
					File file = enumerator.get_child(fileInfo);
					if (isDirectory(fileInfo)) {
						DirectoryObject directory = new DirectoryObject(file);
						directory.acceptDirectory(visitor);
						if (recursive) {
							directory.accept(visitor, true);
							continue;
						}
						continue;
					}
					new FileObject(file).accept(visitor);
				}
			}
			catch(Error e) {
				LOGGER.logError("An error occurred: %s", e.message);
			}
		}

		public void acceptDirectory(FileSystemVisitor visitor) {
			visitor.visitDirectory(file);
		}

		private bool isDirectory(FileInfo fileInfo) {
			return fileInfo.get_file_type() == FileType.DIRECTORY;
		}

		public void createDirectory() throws Error {
			file.make_directory();
		}

		public bool hasChildWithName(string childName) {
			ObjectExistenceLookupVisitor existenceLookup = new ObjectExistenceLookupVisitor(childName);
			accept(existenceLookup, false);

			return existenceLookup.exists();
		}

		public DirectoryObject getDirectoryChild(string childName) {
			DirectoryObjectLookupVisitor directoryLookup = new DirectoryObjectLookupVisitor(childName);
			accept(directoryLookup, false);

			DirectoryObject? directory = directoryLookup.getDirectory();
			if (directory == null) {
				return new DirectoryObject(newChild(childName));
			}
			return directory;
		}

		public DirectoryObject getDirectoryChildAtLocation(string relativeLocation) {
			string nestedDirectoryLocation = "%s%C%s".printf(getLocation(), Path.DIR_SEPARATOR, relativeLocation);
			return new DirectoryObject.fromGivenLocation(nestedDirectoryLocation);
		}

		public DirectoryObject newDirectoryChild(string childName) {
			return new DirectoryObject(newChild(childName));
		}

		public FileObject getFileChild(string childName) {
			FileObjectLookupVisitor fileLookup = new FileObjectLookupVisitor(this, childName);
			accept(fileLookup, false);
			return fileLookup.getFile();
		}

		public FileObject newFileChild(string childName) {
			File fileChild = newChild(childName);
			
			return new FileObject(fileChild);
		}

		private File newChild(string childName) {
			return File.new_for_path("%s%C%s".printf(file.get_path(), Path.DIR_SEPARATOR, childName));
		}

		public void copyTo(DirectoryObject directory, bool overwrite) {
			new DirectoryCopier(this, directory, overwrite).copy();
		}

		public string getRelativeLocation(File fileToLocate) {
			return file.get_relative_path(fileToLocate);
		}
	}
}
