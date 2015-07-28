using bob.builder.filesystem.visitor;
using bob.builder.log;

namespace bob.builder.filesystem {

	public class DirectoryBuilder {

        private Logger LOGGER = Logger.getLogger("DirectoryBuilder");

		public delegate void DirectoryBuilderDelegate(DirectoryBuilder directoryBuilder);
		
		private string _name;
		private bool _readOnly;
		private DirectoryObject _parentDirectory;
		private DirectoryObject _directory;

		public DirectoryBuilder(string name, DirectoryObject parentDirectory, bool readOnly) {
			_name = name;  
			_readOnly = readOnly;
			_parentDirectory = parentDirectory;
		}

		public DirectoryBuilder.from(DirectoryObject directory, bool readOnly) {
			this(directory.getName(), directory.getParent(), readOnly);
			_directory = directory;
		}

		public DirectoryObject? directory(string name, DirectoryBuilderDelegate? directoryBuilderDelegate) {
			DirectoryBuilder directoryBuilder = new DirectoryBuilder(name, getOrCreate(), _readOnly);
			if (directoryBuilderDelegate != null) {
				directoryBuilderDelegate(directoryBuilder);
			}
			return directoryBuilder.getOrCreate();
		}

		public DirectoryObject getOrCreate() {
			if (_directory != null) {
				return _directory;
			}

			DirectoryObject existingDirectory = _parentDirectory.getDirectoryChild(_name);
			if (existingDirectory.exists()) {
				_directory = existingDirectory;
				return existingDirectory;
			}

			_directory = _parentDirectory.newDirectoryChild(_name);
			if (_readOnly) {
				return _directory;
			}
			try {
				_directory.createDirectory();
			} catch (Error e) {
				LOGGER.logError("An error occurred while creating new directory with name %s: %s.", _name, e.message);
			}
			return _directory;
		}
	}
}