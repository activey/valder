using bob.builder.log;

namespace bob.builder.filesystem {

	public class DirectoryBuilder {

        private Logger LOGGER = Logger.getLogger("DirectoryBuilder");

		public delegate void DirectoryBuilderDelegate(DirectoryBuilder directoryBuilder);
		
		private string _name;
		private DirectoryObject _parentDirectory;
		private DirectoryObject _directory;

		public DirectoryBuilder(DirectoryObject parentDirectory) {
			_parentDirectory = parentDirectory;
		}

		public DirectoryObject directory(DirectoryBuilderDelegate directoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(getOrCreate());
			directoryBuilderDelegate(directoryBuilder);

			return directoryBuilder.getOrCreate();
		}

		public DirectoryBuilder name(string directoryName) {
			_name = directoryName;
			return this;
		}

		public DirectoryObject getOrCreate() {
			if (_directory != null) {
				return _directory;
			}
			if (_parentDirectory.hasChildWithName(_name)) {
				LOGGER.logInfo(@"Directory with name $(_name) already exists, reusing.");
				_directory = _parentDirectory.getDirectoryChild(_name);
			} else {
				LOGGER.logInfo(@"Creating new directory: $(_name).");
				try {
					_directory = _parentDirectory.newDirectoryChild(_name);
				} catch (Error e) {
					LOGGER.logError("An error occurred while creating new directory with name %s: %s.", _name, e.message);
				}
			}
			return _directory;
		}
	}
}