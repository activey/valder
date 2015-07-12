using bob.builder.log;

namespace bob.builder.filesystem.visitor {

	public class FileObjectLookupVisitor : FileSystemVisitor {

		private FileObject _file;
		private DirectoryObject _parent;
		private string _childName;

		public FileObjectLookupVisitor(DirectoryObject parent, string childName) {
			_parent = parent;
			_childName = childName;
		}

		public void visitFile(File file) {
			if (file.get_basename() == _childName) {
				_file= new FileObject(file);
			}
		}

		public void visitDirectory(File directory) {}

		public FileObject getFile() {
			if (_file == null) {
				return _parent.newFileChild(_childName);
			}
			return _file;
		}
	}
}