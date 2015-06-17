namespace bob.builder {
	
	public interface BobDirectories {

		public const string PATH_SEPARATOR = Path.DIR_SEPARATOR_S;

		public const string DIRECTORY_LIB = "lib";
		public const string DIRECTORY_PLUGINS = "plugins";

		public const string DIRECTORY_SOURCE = "src";
		public const string DIRECTORY_SOURCE_LIBRARY_NAME = "library";
		public const string DIRECTORY_SOURCE_LIBRARY = DIRECTORY_SOURCE + PATH_SEPARATOR + DIRECTORY_SOURCE_LIBRARY_NAME;
		public const string DIRECTORY_SOURCE_LIBRARY_VALA_NAME = "vala";
		public const string DIRECTORY_SOURCE_LIBRARY_VAPI_NAME = "vapi";
		public const string DIRECTORY_SOURCE_LIBRARY_VAPI = DIRECTORY_SOURCE_LIBRARY + PATH_SEPARATOR + DIRECTORY_SOURCE_LIBRARY_VAPI_NAME;
		public const string DIRECTORY_SOURCE_LIBRARY_C_NAME = "c";
		public const string DIRECTORY_SOURCE_LIBRARY_C = DIRECTORY_SOURCE_LIBRARY + PATH_SEPARATOR + DIRECTORY_SOURCE_LIBRARY_C_NAME;
	
		public const string DIRECTORY_SOURCE_RUNTIME_NAME = "main";
		public const string DIRECTORY_SOURCE_RUNTIME_VALA_NAME = "vala";
		
		public const string DIRECTORY_TARGET = "target";
		public const string DIRECTORY_TARGET_LIB = DIRECTORY_TARGET + PATH_SEPARATOR + DIRECTORY_LIB;
	}
}