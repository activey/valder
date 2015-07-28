using bob.builder.filesystem;

namespace bob.builder.build.plugin {

    public class WorkingDirectoryStructure {
        
        private DirectoryObject _workingDirectory;

        private WorkingDirectoryStructure.forRead() {
            _workingDirectory = new DirectoryObject.fromCurrentLocation();
        }

        public static WorkingDirectoryStructure read() {
            return new WorkingDirectoryStructure.forRead();
        }

        public WorkingDirectoryStructure target(DirectoryBuilder.DirectoryBuilderDelegate directoryDelegate) {
            WorkingDirectoryStructure structure = new WorkingDirectoryStructure.forRead();
            structure.directory(BobDirectories.DIRECTORY_TARGET, directoryDelegate);
            return structure;
        }

        public WorkingDirectoryStructure source(DirectoryBuilder.DirectoryBuilderDelegate directoryDelegate) {
            WorkingDirectoryStructure structure = new WorkingDirectoryStructure.forRead();
            structure.directory(BobDirectories.DIRECTORY_SOURCE, directoryDelegate);
            return structure;
        }

        private void directory(string name, DirectoryBuilder.DirectoryBuilderDelegate directoryDelegate) {
            DirectoryBuilder directoryBuilder = new DirectoryBuilder(name, _workingDirectory, true);
            directoryDelegate(directoryBuilder);
        }   
    }
}