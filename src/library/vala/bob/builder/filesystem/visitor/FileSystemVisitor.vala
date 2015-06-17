namespace bob.builder.filesystem.visitor {
	
	public interface FileSystemVisitor {
		
		public abstract void visitFile(File file);

		public abstract void visitDirectory(File directory);
	}
}
