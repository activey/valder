using bob.builder.recipe.project;
using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class BuildConfiguration {

		private List<BobBuildProjectDependency> _dependencies = new List<BobBuildProjectDependency>();
		private List<BobBuildProjectSourceFile> _sources = new List<BobBuildProjectSourceFile>();
		private List<DirectoryObject> _vapiDirectories = new List<DirectoryObject>();

		private string[] _ccOptions = new string[0];

		public string targetFile {
			get;
			set;
		}

		public bool generateVapi {
			get;
			set;
		}

		public string outputVapiFile {
			get;
			set;
		}

		public string outputHFile {
			get;
			set;
		}

		public bool verbose {
			get;
			set;
			default = false;
		}

		public string[] ccOptions {
			get {
				return _ccOptions;
			}
			set {
				_ccOptions = value;
			}
		}

		public void addCcOption(string ccOption) {
			_ccOptions += ccOption;
		}

		public List<BobBuildProjectDependency> dependencies {
			get {
				return _dependencies;
			}
		}

		public void addDependency(BobBuildProjectDependency dependency) {
			_dependencies.append(dependency);
		}

		public List<BobBuildProjectSourceFile> sources {
			get {
				return _sources;
			}
		}

		public void addSource(BobBuildProjectSourceFile source) {
			_sources.append(source);
		}

		public bool hasAnySources(string fileSuffix) {
			foreach (BobBuildProjectSourceFile sourceFile in _sources) {
				if (sourceFile.fileLocation.has_suffix(fileSuffix)) {
					return true;
				}
			}
			return false;
		}
		
		public string[] getVapiDirectoriesLocations() {
			string[] locations = new string[0];
			foreach (DirectoryObject vapiDirectory in _vapiDirectories) {
				locations += vapiDirectory.getLocation();
			}
			return locations;
		}

		public void addVapiDirectory(DirectoryObject vapiDirectory) {
			_vapiDirectories.append(vapiDirectory);
		}
	}
}
