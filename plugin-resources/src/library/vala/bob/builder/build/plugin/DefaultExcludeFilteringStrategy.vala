namespace bob.builder.build.plugin {

	public class DefaultExcludeFilteringStrategy : ResourceFilteringStrategy, Object {
		
		private DirectoryMatchers _includeMatchers;

		public DefaultExcludeFilteringStrategy(DirectoryMatchers includeMatchers) {
			_includeMatchers = includeMatchers;
		}

		public bool matches(File file) {
			return false;
		}
	}

}