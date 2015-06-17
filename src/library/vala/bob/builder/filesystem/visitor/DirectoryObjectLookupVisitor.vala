using bob.builder.log;

namespace bob.builder.filesystem.visitor {

	public class DirectoryObjectLookupVisitor : FileSystemVisitor {

		private DirectoryObject _directory;
		private string _childName;

		public DirectoryObjectLookupVisitor(string childName) {
			_childName = childName;
		}

		public void visitFile(File file) {}

		public void visitDirectory(File directory) {
			if (directory.get_basename() == _childName) {
				_directory = new DirectoryObject(directory);
			}
		}

		public DirectoryObject? getDirectory() {
			return _directory;
		}
	}
}