namespace com.futureprocessing.bob.filesystem {
	public interface FileSystemObject {
        
        public abstract void accept(FileSystemVisitor visitor);
	}
}