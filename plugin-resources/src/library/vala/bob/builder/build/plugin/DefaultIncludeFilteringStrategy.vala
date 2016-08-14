namespace bob.builder.build.plugin {

	public class DefaultIncludeFilteringStrategy : ResourceFilteringStrategy, Object {
		
		private DirectoryMatchers _excludeMatchers;

		public DefaultIncludeFilteringStrategy(DirectoryMatchers excludeMatchers) {
			_excludeMatchers = excludeMatchers;
		}

		public bool matches(File file) {
			return true;
		}
	}

}