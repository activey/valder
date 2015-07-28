using bob.builder.log;

namespace bob.builder.filesystem.visitor {

	public class FileDelegateVisitor : FileSystemVisitor {

		public delegate void FileDelegate(FileObject fileObject);

		private FileDelegate _delegate;

		public FileDelegateVisitor(FileDelegate fileDelegate) {
			_delegate = fileDelegate;
		}

		public void visitFile(File file) {
			_delegate(new FileObject(file));
		}

		public void visitDirectory(File directory) {}
	}
}