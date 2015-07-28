using bob.builder.log;
using bob.builder.filesystem.visitor;

namespace bob.builder.filesystem.copy {

	public class DirectoryCopier : FileSystemVisitor {

		private Logger LOGGER = Logger.getLogger("DirectoryCopier");

		private bool _overwrite = false;
		private DirectoryObject _from;
		private DirectoryObject _to;

		public DirectoryCopier(DirectoryObject from, DirectoryObject to, bool overwrite) {
			_overwrite = overwrite;
			_from = from;
			_to = to;
		} 

		public void copy() {
			_from.accept(this, false);
		}

		public void visitFile(File file) {
			FileObject fileObject = new FileObject(file);
			try {
				fileObject.copyTo(_to, _overwrite);
			} catch (Error e) {
				LOGGER.logError("An error occurred while copying [%s] file: %s.", fileObject.getLocation(), e.message);
			}
		}

		public void visitDirectory(File directory) {
			DirectoryObject fromDirectory = new DirectoryObject(directory);
			DirectoryObject toDirectory = _to.getDirectoryChild(fromDirectory.getName());
			if (!toDirectory.exists()) {
				try {
				
					toDirectory.createDirectory();
				} catch (Error e) {
					LOGGER.logError("An error occurred while creating directory [%s]: %s.", toDirectory.getLocation(), e.message);		
					return;
				}
			}
			DirectoryCopier copier = new DirectoryCopier(fromDirectory, toDirectory, _overwrite);
			copier.copy();
		} 
	}
}