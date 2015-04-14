namespace bob.builder.filesystem {
	
	public interface FileFilter : Object {
	
		public abstract bool fileMatchesCriteria(File file);
	}
}
