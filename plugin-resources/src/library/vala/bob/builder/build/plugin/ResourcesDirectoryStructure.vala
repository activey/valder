using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public class ResourcesDirectoryStructure {
		
        private Logger LOGGER = Logger.getLogger("ResourcesDirectoryStructure");

		private DirectoryObject _resourcesDirectory;
		private bool _readOnly = true;

		public static ResourcesDirectoryStructure libraryResources(DirectoryBuilder.DirectoryBuilderDelegate resourcesDirectoryDelegate) {
			ResourcesDirectoryStructure resourcesStructure = new ResourcesDirectoryStructure.forLibraryResources();
			resourcesStructure.traverse(resourcesDirectoryDelegate);
			return resourcesStructure;
		}

		public static ResourcesDirectoryStructure runtimeResources(DirectoryBuilder.DirectoryBuilderDelegate resourcesDirectoryDelegate) {
			ResourcesDirectoryStructure resourcesStructure = new ResourcesDirectoryStructure.forRuntimeResources();
			resourcesStructure.traverse(resourcesDirectoryDelegate);
			return resourcesStructure;
		}

		private ResourcesDirectoryStructure.forLibraryResources() {
			_resourcesDirectory = new DirectoryObject.fromGivenLocation(BobDirectories.DIRECTORY_SOURCE_LIBRARY_RESOURCES);
		}

		private ResourcesDirectoryStructure.forRuntimeResources() {
			_resourcesDirectory = new DirectoryObject.fromGivenLocation(BobDirectories.DIRECTORY_SOURCE_RUNTIME_RESOURCES);
		}

		private void traverse(DirectoryBuilder.DirectoryBuilderDelegate resourcesDirectoryDelegate) {
			if (!_resourcesDirectory.exists()) {
				LOGGER.logWarn(@"Can not find resources directory: $(_resourcesDirectory.getLocation()), skipping processing.");
				return;
			}
			DirectoryBuilder builder = new DirectoryBuilder.from(_resourcesDirectory, _readOnly);
			resourcesDirectoryDelegate(builder);
		}
	}
}