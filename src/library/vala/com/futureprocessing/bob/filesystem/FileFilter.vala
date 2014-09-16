namespace com.futureprocessing.bob.filesystem {
	public interface FileFilter : Object {
        public abstract bool fileMatchesCriteria(File file);
	}
}