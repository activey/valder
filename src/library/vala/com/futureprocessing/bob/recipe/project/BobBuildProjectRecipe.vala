namespace com.futureprocessing.bob.recipe.project {

	public class BobBuildProjectRecipe {

		private List<BobBuildProjectSourceFile> _libSourceFiles = new List<BobBuildProjectSourceFile>();
		private List<BobBuildProjectSourceFile> _mainSourceFiles = new List<BobBuildProjectSourceFile>();


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

		public void addLibSourceFile(File projectSourceFile) {
			_libSourceFiles.append(new BobBuildProjectSourceFile.fromFileSystem(projectSourceFile));
		}

		public void addMainSourceFile(File projectSourceFile) {
			_mainSourceFiles.append(new BobBuildProjectSourceFile.fromFileSystem(projectSourceFile));
		}

		public List<BobBuildProjectSourceFile> libSourceFiles {
			get {
				return _libSourceFiles;
			}
		}

		public List<BobBuildProjectSourceFile> mainSourceFiles {
			get {
				return _mainSourceFiles;
			}
		}
	}
}