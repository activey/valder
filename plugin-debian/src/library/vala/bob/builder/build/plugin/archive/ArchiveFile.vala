using bob.builder.filesystem;
using Archive;

namespace bob.builder.build.plugin.archive {

    public class ArchiveFile : Object {

    	public string path { get; construct set; }
    	public int64 size { get; construct set; }
    	public FileObject fileObject { get; construct set; }

    	public ArchiveFile(FileObject fileObject, string path, int64 size) {
    		base(path:path, size:size, fileObject:fileObject);
    	}
    }

}