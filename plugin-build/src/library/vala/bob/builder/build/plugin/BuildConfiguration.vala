using bob.builder.recipe.project;
using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public struct GirConfiguration {
		public bool generateGir;
		public string libraryName;	
		public string libraryVersion;	
		public string outputDirectory;	
	}

	public struct VapiConfiguration {
		public bool generateVapi;
		public string outputVapiFile;
	}

	public class BuildConfiguration {

		private List<BobBuildProjectDependency> _dependencies = new List<BobBuildProjectDependency>();
		private List<BobBuildProjectSourceFile> _sources = new List<BobBuildProjectSourceFile>();
		private CCOptions _ccOptions = new CCOptions();
		
		public string targetFile { get; set; }
		public GirConfiguration girConfiguration { get; set; default = GirConfiguration(); }
		public VapiConfiguration vapiConfiguration { get; set; default = VapiConfiguration(); }

		public string outputHFile { get; set; }

		public bool verbose { get; set; default = false; }

		public bool debug { get; set; default = false; }

		public BobBuildProjectDependencyScope scope { get; set; default = BobBuildProjectDependencyScope.BOTH; }

		public CCOptions ccOptions {
			get {
				return _ccOptions;
			}
			set {
				_ccOptions = value;
			}
		}

		public void addCcOption(string ccOption) {
			_ccOptions.addCcOption(ccOption);
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
	}
}
