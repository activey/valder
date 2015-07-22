using bob.builder.filesystem;
using Archive;

namespace bob.builder.build.plugin.archive {

    public class ArchiveCreator {
        
        private Write _writeOperation;
        private ArchiveFile[] _files = new ArchiveFile[0];

        public ArchiveCreator.tarFormat() {
            this(Format.TAR);
        }

        public ArchiveCreator.arFormat() {
            this(Format.AR);
        }

        public ArchiveCreator(Format format) {
            initializeWriteOperation(format);
        }

        private void initializeWriteOperation(Format format) {
            _writeOperation = new Write();
            _writeOperation.set_format(format);
            _writeOperation.set_format_pax_restricted();
        }

        public void addGzipFilter() {
            _writeOperation.add_filter(Filter.GZIP);
        }

        public FileObject createArchive(string name, DirectoryObject outputDirectory) throws Error {
            FileObject outputFile = outputDirectory.newFileChild(name);
            _writeOperation.open_filename(outputFile.getLocation());
            foreach (ArchiveFile file in _files) {
                addEntry(file);
            }
            _writeOperation.close();
            return outputFile;
        }

        public void addFile(FileObject file) {
            _files += new ArchiveFile(file, file.getLocation(), file.getSize());
        }

        public void addFileRelative(FileObject file, DirectoryObject relativeDirectory) {
            _files += new ArchiveFile(file, file.getLocationRelative(relativeDirectory), file.getSize());
        }

        private void addEntry(ArchiveFile file) throws Error {
            Entry entry = new Entry();
            entry.set_pathname(file.path);
            entry.set_size(file.size);
            entry.set_filetype(0100000); // wtf is that?
            entry.set_perm(0644);
            _writeOperation.write_header(entry);

            ssize_t written = feed(_writeOperation, file.fileObject.getInputStream());

            _writeOperation.finish_entry();
        }

        private ssize_t feed(Write write, FileInputStream input) throws Error {
            uint8[] buffer = new uint8[4096];
            size_t size;
            while ((size = input.read(buffer)) > 0) {
                ssize_t written = write.write_data(buffer, size);
            }
            return 0;
        }
    }
}