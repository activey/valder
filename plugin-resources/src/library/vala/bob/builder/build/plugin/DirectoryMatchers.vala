namespace bob.builder.build.plugin {

	public class DirectoryMatchers {

		private string[] patterns = {};

		public void addMatcher(string matcherPattern) {
			patterns += matcherPattern;
		} 
	}
}