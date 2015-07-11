using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class TemporaryDebianArchiveDirectoryStructure {
		
		private DirectoryObject _temporaryDirectory;

		private TemporaryDebianArchiveDirectoryStructure.forWrite() {
			_temporaryDirectory = new DirectoryObject.fromTemporaryDirectory();
		}

		public static void debianDirectory(string directoryName, DirectoryBuilder.DirectoryBuilderDelegate directoryDelegate) {
			TemporaryDebianArchiveDirectoryStructure structure = new TemporaryDebianArchiveDirectoryStructure.forWrite();
			structure.directory(directoryName, directory => {
				directoryDelegate(directory);	
			});
		}		

		private void directory(string directoryName, DirectoryBuilder.DirectoryBuilderDelegate directoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(directoryName, _temporaryDirectory, false);
			directoryBuilderDelegate(directoryBuilder);
		}
	}
}