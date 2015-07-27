using bob.builder.filesystem;
using bob.builder.filesystem.visitor;

namespace bob.builder.build.plugin.md5 {

    public class MD5ChecksumsEntry : Object {

    	public string filePath { get; construct set; }
    	public string checksum { get; construct set; }

    	public MD5ChecksumsEntry(string filePath, string checksum) {
    		base(filePath: filePath, checksum: checksum);
    	}
    }
}