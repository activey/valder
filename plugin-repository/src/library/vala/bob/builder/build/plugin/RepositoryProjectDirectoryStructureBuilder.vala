using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class RepositoryProjectDirectoryStructureBuilder {
		
		private DirectoryObject _projectDirectory;

		private RepositoryProjectDirectoryStructureBuilder(DirectoryObject projectDirectory) {
			_projectDirectory = projectDirectory;
		}

		public static RepositoryProjectDirectoryStructureBuilder projectDirectory() {
			return new RepositoryProjectDirectoryStructureBuilder(new DirectoryObject.fromUserHomeFolder());
		}

		public RepositoryProjectDirectoryStructureBuilder directory(DirectoryBuilder.DirectoryBuilderDelegate directoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(_projectDirectory);
			directoryBuilderDelegate(directoryBuilder);

			directoryBuilder.getOrCreate();

			return this;
		}
	}
}