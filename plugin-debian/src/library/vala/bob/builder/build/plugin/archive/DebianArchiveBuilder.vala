using bob.builder.filesystem;

namespace bob.builder.build.plugin.archive {

    public class DebianArchiveBuilder {

        private const string NAME_DEFAULT = "unknown.deb";

        private string _name = NAME_DEFAULT;
        private DebianArchiveCreator _archiveCreator;

        public DebianArchiveBuilder(DirectoryObject relativeDirectory) {
            _archiveCreator = new DebianArchiveCreator(relativeDirectory);
        }

        public static DebianArchiveBuilder relativeDirectory(DirectoryObject relativeDirectory) {
            return new DebianArchiveBuilder(relativeDirectory);
        }

        public DebianArchiveBuilder name(string name) {
            _name = name;
            return this;
        }

        public DebianArchiveBuilder debianLibraryDirectory(DirectoryObject directory) {
            _archiveCreator.debianLibraryDirectory = directory;
            return this;
        }

        public DebianArchiveBuilder debianBinaryDirectory(DirectoryObject directory) {
            _archiveCreator.debianBinaryDirectory = directory;
            return this;
        }

        public DebianArchiveBuilder debianIncludeDirectory(DirectoryObject directory) {
            _archiveCreator.debianIncludeDirectory = directory;
            return this;
        }

        public DebianArchiveBuilder debianVapiDirectory(DirectoryObject directory) {
            _archiveCreator.debianVapiDirectory = directory;
            return this;
        }

        public DebianArchiveBuilder debianControlFile(FileObject file) {
            _archiveCreator.debianControlFile = file;
            return this;
        }

        public FileObject build() {
            return _archiveCreator.createDebianArchive(_name);
        }
    }

}