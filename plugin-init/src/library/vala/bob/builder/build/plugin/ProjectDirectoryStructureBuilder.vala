using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class ProjectDirectoryStructureBuilder {
		
		private DirectoryObject _projectDirectory;

		private ProjectDirectoryStructureBuilder(DirectoryObject projectDirectory) {
			_projectDirectory = projectDirectory;
		}

		public static ProjectDirectoryStructureBuilder projectDirectory(DirectoryObject projectDirectory) {
			return new ProjectDirectoryStructureBuilder(projectDirectory);
		}

		public ProjectDirectoryStructureBuilder directory(DirectoryBuilder.DirectoryBuilderDelegate directoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(_projectDirectory);
			directoryBuilderDelegate(directoryBuilder);

			directoryBuilder.getOrCreate();

			return this;
		}
	}
}