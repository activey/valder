namespace com.futureprocessing.bob.recipe.project {

	public class BobBuildProjectRecipe {

		private List<BobBuildProjectSourceFile> _sourceFiles = new List<BobBuildProjectSourceFile>();

		public string name { 
			get; 
			set; 
		}

		public string shortName { 
			get; 
			set; 
		}

		public string version { 
			get; 
			set; 
		}

		public void addSourceFile(File projectSourceFile) {
			_sourceFiles.append(new BobBuildProjectSourceFile.fromFileSystem(projectSourceFile));
		}

		public List<BobBuildProjectSourceFile> sourceFiles {
			get {
				return _sourceFiles;
			}
		}
	}
}