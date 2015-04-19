using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class LibraryFileFilter : FileExtensionFilter {
		public LibraryFileFilter() {
			base(".so");
		}
	}
}