namespace bob.builder.filesystem {
	public interface FileSystemObject {
		public abstract void accept(FileSystemVisitor visitor);
	}
}
