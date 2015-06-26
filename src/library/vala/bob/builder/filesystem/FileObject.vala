using bob.builder.filesystem.visitor;

namespace bob.builder.filesystem {

	public class FileObject : FileSystemObject {

		public FileObject(File file) {
			base(file);
		}

		public void accept(FileSystemVisitor visitor) {
			visitor.visitFile(file);
		}

		public FileIOStream getStream() throws Error {
			FileIOStream stream = null;
			if (!file.query_exists()) {
				stream = file.create_readwrite(FileCreateFlags.PRIVATE);
			} else {
				stream = file.open_readwrite();
			}
			return stream;
		}

		public void copyTo(DirectoryObject directory, bool overwrite) throws Error {
			FileObject fileCopy = directory.newFileChild(file.get_basename());
			fileCopy.copyFrom(file, overwrite);
		}

		public void copyFrom(File originalFile, bool overwrite) throws Error {
			originalFile.copy(file, (overwrite) ? FileCopyFlags.OVERWRITE : FileCopyFlags.NONE);
		}
	}
}
