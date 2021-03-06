namespace bob.builder.filesystem.visitor {

	public abstract class FileSystemFilteringVisitor : FileSystemVisitor {

		private FileFilter filter;

		public FileSystemFilteringVisitor(FileFilter filter) {
			this.filter = filter;
		}

		protected abstract void visitFileFiltered(File file);

		public void visitFile(File file) {
			if (filter.fileMatchesCriteria(file)) {
				visitFileFiltered(file);
			}
		}

		public void visitDirectory(File directory) {}
	}
}
