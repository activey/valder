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

		public ProjectDirectoryStructureBuilder directory(string name, DirectoryBuilder.DirectoryBuilderDelegate directoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(name, _projectDirectory, false);
			directoryBuilderDelegate(directoryBuilder);

			directoryBuilder.getOrCreate();

			return this;
		}
	}
}