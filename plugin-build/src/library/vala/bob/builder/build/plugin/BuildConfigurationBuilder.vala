using bob.builder.recipe.project;
using bob.builder.json;
using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class BuildConfigurationBuilder {

		public delegate void BuildConfigurationLibraryUsageBuilderDelegate(BuildConfigurationLibraryUsageBuilder libraryUsageBuilder);
		public delegate void BuildConfigurationDependencyBuilderDelegate(BuildConfigurationDependencyBuilder dependencyBuilder);

		private const string PROPERTY_VERBOSE = "verbose";
		private const string PROPERTY_DEBUG = "debug";

		private string _targetDirectory = "";
		private string _targetFileName = "";
		private bool _generateVapi = false;
		private string _outputVapiDirectory = "";
		private string _outputVapiFileName = "";
		private string _cOutputDirectory = "";
		private string _cHeaderFileName = "";

		private BuildConfiguration buildConfiguration;

		public BuildConfigurationBuilder.fromJSONObject(JsonObject jsonObject) {
			buildConfiguration = new BuildConfiguration();
			readJsonProperties(jsonObject);		
		}

		private void readJsonProperties(JsonObject jsonObject) {
			buildConfiguration.verbose = jsonObject.getBooleanEntry(PROPERTY_VERBOSE, false);
			buildConfiguration.debug = jsonObject.getBooleanEntry(PROPERTY_DEBUG, false);
		}

		public BuildConfigurationBuilder sources(List<BobBuildProjectSourceFile> sources) {
			foreach (BobBuildProjectSourceFile source in sources) {
				buildConfiguration.addSource(source);
			}
			return this;
		}

		public BuildConfigurationBuilder runtimeScope() {
			buildConfiguration.scope = BobBuildProjectDependencyScope.RUNTIME;
			return this;
		}

		public BuildConfigurationBuilder libraryScope() {
			buildConfiguration.scope = BobBuildProjectDependencyScope.LIBRARY;
			return this;
		}

		public BuildConfigurationBuilder dependency(BuildConfigurationDependencyBuilderDelegate dependencyBuilderDelegate) {
			BuildConfigurationDependencyBuilder dependencyBuilder = new BuildConfigurationDependencyBuilder();
			dependencyBuilderDelegate(dependencyBuilder);

			buildConfiguration.addDependency(dependencyBuilder.build());
			return this;
		}

		public BuildConfigurationBuilder dependencies(List<BobBuildProjectDependency> dependencies) {
			foreach (BobBuildProjectDependency dependency in dependencies) {
				buildConfiguration.addDependency(dependency);
			}
			return this;
		}

		public BuildConfigurationBuilder targetDirectory(string targetDirectory) {
			_targetDirectory = targetDirectory;
			return this;
		} 

		public BuildConfigurationBuilder targetFileName(string targetFileName) {
			_targetFileName = targetFileName;
			return this;
		} 

		public BuildConfigurationBuilder generateVapiAndC() {
			_generateVapi = true;
			return this;
		}

		public BuildConfigurationBuilder vapiOutputDirectory(string vapiOutputDirectory) {
			_outputVapiDirectory = vapiOutputDirectory;
			return this;
		}

		public BuildConfigurationBuilder vapiOutputFileName(string vapiOutputFileName) {
			_outputVapiFileName = vapiOutputFileName;
			return this;
		}

		public BuildConfigurationBuilder ccOptions(string[] ccOptions) {
			buildConfiguration.ccOptions = ccOptions;
			return this;
		} 

		public BuildConfigurationBuilder ccOption(string ccOption) {
			buildConfiguration.addCcOption(ccOption);
			return this;
		}

		public BuildConfigurationBuilder cOutputDirectory(string cOutputDirectory) {
			_cOutputDirectory = cOutputDirectory;
			return this;
		}

		public BuildConfigurationBuilder cHeaderFileName(string cHeaderFileName) {
			_cHeaderFileName = cHeaderFileName;
			return this;
		}

		public BuildConfigurationBuilder useLibrary(BuildConfigurationLibraryUsageBuilderDelegate libraryUsageDelegate) {
			BuildConfigurationLibraryUsageBuilder libraryUsageBuilder = new BuildConfigurationLibraryUsageBuilder();
			libraryUsageDelegate(libraryUsageBuilder);

			libraryUsageBuilder.addLibraryUsageCcOptions(this);

			return this;
		}

		public BuildConfiguration build() {
			buildConfiguration.targetFile = "%s%C%s".printf(_targetDirectory, Path.DIR_SEPARATOR, _targetFileName);
			if (_generateVapi) {
				buildConfiguration.generateVapi = true;
				buildConfiguration.outputVapiFile = "%s%C%s".printf(_outputVapiDirectory, Path.DIR_SEPARATOR, _outputVapiFileName);
				buildConfiguration.outputHFile = "%s%C%s".printf(_cOutputDirectory, Path.DIR_SEPARATOR, _cHeaderFileName);
			}
			return buildConfiguration;
		}
	}
}