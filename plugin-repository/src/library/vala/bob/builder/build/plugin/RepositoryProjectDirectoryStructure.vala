using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class RepositoryProjectDirectoryStructure {
		
		private DirectoryObject _homeDirectory;
		private bool _readOnly = false;

		private RepositoryProjectDirectoryStructure.forWrite() {
			_homeDirectory = new DirectoryObject.fromUserHomeDirectory();
			_readOnly = false;
		}

		private RepositoryProjectDirectoryStructure.forRead() {
			_homeDirectory = new DirectoryObject.fromUserHomeDirectory();
			_readOnly = true;
		}

		public static void readFrom(DirectoryObject directory, DirectoryBuilder.DirectoryBuilderDelegate repositoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder.from(directory, true);
			repositoryBuilderDelegate(directoryBuilder);
		}

		public static void read(DirectoryBuilder.DirectoryBuilderDelegate repositoryBuilderDelegate) {
			RepositoryProjectDirectoryStructure builder = new RepositoryProjectDirectoryStructure.forRead();
			builder.repository(repositoryDirectory => {
				repositoryBuilderDelegate(repositoryDirectory);	
			});
		}

		public static void write(DirectoryBuilder.DirectoryBuilderDelegate repositoryBuilderDelegate) {
			RepositoryProjectDirectoryStructure builder = new RepositoryProjectDirectoryStructure.forWrite();
			builder.repository(repositoryDirectory => {
				repositoryBuilderDelegate(repositoryDirectory);	
			});
		}		

		private void repository(DirectoryBuilder.DirectoryBuilderDelegate directoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(RepositoryDirectories.DIRECTORY_REPOSITORY_NAME, _homeDirectory, _readOnly);
			directoryBuilderDelegate(directoryBuilder);
		}
	}
}