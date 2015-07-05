using bob.builder.log;
using bob.builder.recipe.project;

using Vala;

namespace bob.builder.build.plugin {

	public class CCOptions {

		private const string OPTION_HEADERS_DIRECTORY = "-I%s";
		private const string OPTION_USE_LIBRARY = "-l%s";
		private const string OPTION_DEBUG_FLAG = "-rdynamic";

		private string[] _ccOptions;

		public CCOptions(string[] ccOptions) {
			_ccOptions = ccOptions;
		}

		public void addCcOption(string ccOption) {
			_ccOptions += ccOption;
		}

		public void addCHeadersDirectoryLocation(string cHeadersDirectoryLocation) {
			addCcOption(OPTION_HEADERS_DIRECTORY.printf(cHeadersDirectoryLocation));
		}

		public void useLibrary(string name) {
			addCcOption(OPTION_USE_LIBRARY.printf(name));
		}

		public void addDebugFlag() {
			addCcOption(OPTION_DEBUG_FLAG);
		}

		public string[] getCcOptions() {
			return _ccOptions;
		}
	}
}