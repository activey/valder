using bob.builder.filesystem;
using bob.builder.filesystem.visitor;

namespace bob.builder.build.plugin.md5 {

    public class MD5ChecksumsFileGenerator {

        private MD5ChecksumsEntry[] _entries = new MD5ChecksumsEntry[0];

        public void scanDirectory(DirectoryObject sourceDirectory, DirectoryObject relativeDirectory) {
            sourceDirectory.accept(new FileDelegateVisitor(file => {
                size_t printedSize;
                _entries += new MD5ChecksumsEntry(file.getLocationRelative(relativeDirectory), md5Sum(file));
            }), true);
        }

    	public void generate(FileObject outputFile) throws Error {
    		FileIOStream stream = outputFile.getStreamOverwrite();
			FileOutputStream outputStream = stream.output_stream as FileOutputStream;

            foreach (MD5ChecksumsEntry entry in _entries) {
                size_t printedSize;
                outputStream.write_all(getFileLine(entry).data, out printedSize);        
            }

			outputStream.flush();
			outputStream.close();
    	}

    	private string getFileLine(MD5ChecksumsEntry entry) throws Error {
    		return "%s %s\n".printf(entry.checksum, entry.filePath);
    	}

    	private string md5Sum(FileObject file) throws Error {
    		Checksum checksum = new Checksum(ChecksumType.MD5);
			InputStream stream = file.getInputStream();
			uint8 fbuf[100];
			size_t size;
			while ((size = stream.read(fbuf)) > 0) {
				checksum.update (fbuf, size);
			}
			return checksum.get_string ();
    	}
    }
}