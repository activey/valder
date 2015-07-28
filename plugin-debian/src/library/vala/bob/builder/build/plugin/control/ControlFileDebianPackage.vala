using bob.builder.recipe.project;
using bob.builder.filesystem;

namespace bob.builder.build.plugin.control {

	public class ControlFileDebianPackage {

		public ControlFileDebianPackage.withName(string packageName) {
			name = packageName;
		}

		public string name { get; set; }
		// public string versionNumber { get; set; }
		// public string versionComparator { get; set; }

		public string to_string() {
			return name;
		}
	}
}