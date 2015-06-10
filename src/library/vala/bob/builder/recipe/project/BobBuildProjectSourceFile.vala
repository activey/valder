namespace bob.builder.recipe.project {
	public class BobBuildProjectSourceFile : Object {

		public string fileLocation {
			get;
			set;
		}
		
		public int64 fileSize {
			get;
			set;
		}
		
		public BobBuildProjectSourceFile.fromFileSystem(File projectSourceFile) throws Error {
			base(fileLocation: projectSourceFile.get_path());
			FileInfo fileInfo = projectSourceFile.query_info("*", FileQueryInfoFlags.NONE);
			fileSize = fileInfo.get_size();
		}

		public BobBuildProjectSourceFile.fromLocation(string sourceFileLocation) {
			base(fileLocation: sourceFileLocation);
			fileSize = -1;
		}
	}
}
