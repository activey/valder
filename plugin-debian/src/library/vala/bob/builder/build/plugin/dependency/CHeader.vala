using bob.builder.log;

namespace bob.builder.build.plugin.dependency {

	public class CHeader : Object {

		public string path { get; set construct; }
		public string girVersion { get; set construct; }
	
		public CHeader(string path, string girVersion) {
			Object(path: path, girVersion: girVersion);
		}

		public string getVersionedFileName() {
			if (girVersion == null) {
				return path;
			}
			return "%s%C%s".printf(girVersion, Path.DIR_SEPARATOR, path);
		}
	}
}
