namespace bob.builder {
	
	public interface BobFiles {

		public const string FILE_PROJECT_RECIPE = "recipe.bob";
		public const string FILE_SOURCE_VAPI_NAME = "%s-%s.vapi";
		public const string FILE_SOURCE_C_HEADER_NAME = "%s-%s.h";
		public const string FILE_TARGET_GIR_NAME = "%s-%s.gir";
		public const string FILE_TARGET_LIBRARY_NAME = "lib%s.so";
	}
}