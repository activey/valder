using bob.builder.log;
using bob.builder.recipe.project;

using Vala;

namespace bob.builder.build.plugin {

	public class CCOptions {

		private string[] _ccOptions;

		public CCOptions(string[] ccOptions) {
			_ccOptions = ccOptions;
		}

		public void addCcOption(string ccOption) {
			_ccOptions += ccOption;
		}

		public void addCHeadersDirectoryLocation(string cHeadersDirectoryLocation) {
			addCcOption("-I%s".printf(cHeadersDirectoryLocation));
		}

		public void useLibrary(string name) {
			addCcOption("-l%s".printf(name));
		}

		public string[] getCcOptions() {
			return _ccOptions;
		}
	}
}