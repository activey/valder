using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class RepositoryProjectDirectoryStructure {
		
		private DirectoryObject _homeDirectory;
		private bool readOnly = false;

		private RepositoryProjectDirectoryStructure.forWrite() {
			_homeDirectory = new DirectoryObject.fromUserHomeDirectory();
			readOnly = false;
		}

		private RepositoryProjectDirectoryStructure.forRead() {
			_homeDirectory = new DirectoryObject.fromUserHomeDirectory();
			readOnly = true;
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
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(RepositoryDirectories.DIRECTORY_REPOSITORY_NAME, _homeDirectory, readOnly);
			directoryBuilderDelegate(directoryBuilder);
		}
	}
}