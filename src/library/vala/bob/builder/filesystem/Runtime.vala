namespace bob.builder.filesystem {
	
	public class Runtime {
	
		private const string SELF_LINK_PATH    = "/proc/self/exe";
		private const string DEFAULT_DIRECTORY = ".";
	
		public static string getRuntimeDirectory() {
			try {
				string runtimePath = GLib.FileUtils.read_link(SELF_LINK_PATH);
				return File.new_for_path(runtimePath).get_parent().get_path();
			}
			catch(Error e) {
				return DEFAULT_DIRECTORY;
			}
		}

		public static string resolveRuntimeRelativePath(string relativePath) {
			string runtimeDirectory = getRuntimeDirectory();

			return "%s/%s".printf(runtimeDirectory, relativePath);
		}

	}
}
