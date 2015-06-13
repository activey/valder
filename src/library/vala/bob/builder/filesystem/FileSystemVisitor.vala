namespace bob.builder.filesystem {
	
	public interface FileSystemVisitor {
		
		public abstract void visitFile(File file);

		public abstract void visitDirectory(File directory);
	}
}
