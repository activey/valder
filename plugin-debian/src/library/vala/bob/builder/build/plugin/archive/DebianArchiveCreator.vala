using bob.builder.filesystem;
using bob.builder.filesystem.visitor;

namespace bob.builder.build.plugin.archive {

    public class DebianArchiveCreator {

        public DirectoryObject debianLibraryDirectory { get; set; }
        public DirectoryObject debianBinaryDirectory { get; set; }
        public DirectoryObject debianIncludeDirectory { get; set; }
        public DirectoryObject debianVapiDirectory { get; set; }
        public FileObject debianControlFile { get; set; }

        private DirectoryObject _relativeDirectory;

        public DebianArchiveCreator(DirectoryObject relativeDirectory) {
            _relativeDirectory = relativeDirectory;
        }

        public FileObject createDebianArchive(string debianPackageFileName) {
            ArchiveCreator debianArchiveCreator = new ArchiveCreator.arFormat();
            debianArchiveCreator.addFileRelative(createControlArchive(), _relativeDirectory);
            debianArchiveCreator.addFileRelative(createDataArchive(), _relativeDirectory);
            return debianArchiveCreator.createArchive(debianPackageFileName, new DirectoryObject.fromTemporaryDirectory());
        }

        private FileObject createDataArchive() {
            ArchiveCreator dataArchiveCreator = newTarGzArchiveCreator();
            debianLibraryDirectory.accept(new FileDelegateVisitor(file => {
                dataArchiveCreator.addFileRelative(file, _relativeDirectory);    
            }), true);
            debianBinaryDirectory.accept(new FileDelegateVisitor(file => {
                dataArchiveCreator.addFileRelative(file, _relativeDirectory);    
            }), true);
            debianIncludeDirectory.accept(new FileDelegateVisitor(file => {
                dataArchiveCreator.addFileRelative(file, _relativeDirectory);    
            }), true);
            debianVapiDirectory.accept(new FileDelegateVisitor(file => {
                dataArchiveCreator.addFileRelative(file, _relativeDirectory);    
            }), true);
            return dataArchiveCreator.createArchive("data.tar.gz", new DirectoryObject.fromTemporaryDirectory());
        }

        private FileObject createControlArchive() {
            ArchiveCreator controlArchiveCreator = newTarGzArchiveCreator();
            controlArchiveCreator.addFileRelative(debianControlFile, _relativeDirectory);

            return controlArchiveCreator.createArchive("control.tar.gz", new DirectoryObject.fromTemporaryDirectory());
        }

        private ArchiveCreator newTarGzArchiveCreator() {
            ArchiveCreator tarGzArchiveCreator = new ArchiveCreator.tarFormat();    
            tarGzArchiveCreator.addGzipFilter();
            return tarGzArchiveCreator;
        }
    }

}