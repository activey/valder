using com.futureprocessing.bob.build.plugin;
using com.futureprocessing.bob.filesystem;

namespace com.futureprocessing.bob.build.plugin {
	public class ValaFilesVisitor : FileSystemFilteringVisitor {

        public signal void valaFileFound(File valaFile);

        const string VALA_FILE_EXTENSION = ".vala";
        private string valaFilesDirectory;

        public ValaFilesVisitor(string valaFilesDirectory) {
            base(new FileExtensionFilter(VALA_FILE_EXTENSION));
            this.valaFilesDirectory = valaFilesDirectory;
        }

		public void collectSourceFiles() throws Error {
            DirectoryObject sourcesDirectory = new DirectoryObject.fromGivenLocation(valaFilesDirectory);
            sourcesDirectory.accept(this);
        }

        public override void visitFileFiltered(File file) {
            valaFileFound(file);
        }
	}
}