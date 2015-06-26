using bob.builder.log;

namespace bob.builder.filesystem.visitor {

	public class FileObjectLookupVisitor : FileSystemVisitor {

		private FileObject _file;
		private string _childName;

		public FileObjectLookupVisitor(string childName) {
			_childName = childName;
		}

		public void visitFile(File file) {
			if (file.get_basename() == _childName) {
				_file= new FileObject(file);
			}
		}

		public void visitDirectory(File directory) {}

		public FileObject? getFile() {
			return _file;
		}
	}
}