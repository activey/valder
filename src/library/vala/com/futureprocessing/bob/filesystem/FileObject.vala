namespace com.futureprocessing.bob.filesystem {
	public class FileObject : FileSystemObject {
	
	    private File file;
	
	    public FileObject(File file) {
	        this.file = file;
	    }
	
        public void accept(FileSystemVisitor visitor) {
            visitor.visitFile(file);        
        }
	}
}