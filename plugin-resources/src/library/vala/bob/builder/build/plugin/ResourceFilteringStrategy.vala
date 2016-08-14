namespace bob.builder.build.plugin {

	public interface ResourceFilteringStrategy : Object {
		
		public abstract bool matches(File file);
	}

}