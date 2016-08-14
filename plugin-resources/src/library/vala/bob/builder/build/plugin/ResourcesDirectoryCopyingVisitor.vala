using bob.builder.filesystem.visitor;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public class ResourcesDirectoryCopyingVisitor : FileSystemVisitor {

        private Logger LOGGER = Logger.getLogger("ResourcesDirectoryCopyingVisitor");

		private DirectoryMatchers _includeMatchers;
		private DirectoryMatchers _exludeMatchers;
		private ResourceFilteringStrategy _filteringStrategy;

		public ResourcesDirectoryCopyingVisitor(DirectoryMatchers includeMatchers, DirectoryMatchers exludeMatchers, bool defaultExclude) {
			_includeMatchers = includeMatchers;
			_exludeMatchers = exludeMatchers;

			initializeFilteringStrategy(defaultExclude);
		}

		private void initializeFilteringStrategy(bool defaultExclude) {
			if (defaultExclude) {
				_filteringStrategy = new DefaultExcludeFilteringStrategy(_includeMatchers);
				return;
			}
			_filteringStrategy = new DefaultIncludeFilteringStrategy(_exludeMatchers);
		}

		public void visitFile(File file) {
			if (_filteringStrategy.matches(file)) {
				LOGGER.logInfo("copying file ---> %s \n", file.get_path());
				return;
			}
			LOGGER.logInfo("skipping file ---> %s \n", file.get_path());
		}

		public void visitDirectory(File directory) {
			stdout.printf(" ---> %s \n", directory.get_path());
		}
	}
}