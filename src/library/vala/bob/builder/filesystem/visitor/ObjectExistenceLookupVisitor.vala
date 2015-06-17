using bob.builder.log;

namespace bob.builder.filesystem.visitor {

	public class ObjectExistenceLookupVisitor : FileSystemVisitor {

		private string _childName;
		private bool _exists;

		public ObjectExistenceLookupVisitor(string childName) {
			_childName = childName;
		}

		public void visitFile(File file) {
			visitChild(file);
		}

		public void visitDirectory(File directory) {
			visitChild(directory);
		}

		private void visitChild(File file) {
			if (file.get_basename() == _childName) {
				_exists = true;
			}	
		}

		public bool exists() {
			return _exists;
		}
	}
}