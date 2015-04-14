using bob.builder.recipe.project;
using bob.builder.json;

namespace bob.builder.build.plugin {

	public class BuildConfigurationBuilder {

		private const string PROPERTY_VERBOSE = "verbose";
		private const string PROPERTY_DEPENDENCIES = "dependencies";
		private string _targetDirectory = "";
		private string _targetFileName = "";

		private BuildConfiguration buildConfiguration;

		public BuildConfigurationBuilder.fromJSONObject(JsonObject jsonObject) {
			buildConfiguration = new BuildConfiguration();
			readJsonProperties(jsonObject);		
		}

		private void readJsonProperties(JsonObject jsonObject) {
			buildConfiguration.verbose = jsonObject.getBooleanEntry(PROPERTY_VERBOSE, false);
			readDependencies(jsonObject.getObjectArrayEntry(PROPERTY_DEPENDENCIES));
		}

		private void readDependencies(JsonArray dependencies) {
			if (dependencies == null) {
				return;
			}
			dependencies.forEachMember(readDependency);
		}

		private void readDependency(JsonObject jsonObject) {
			BuildDependency dependency = new BuildDependency.fromJSONObject(jsonObject);
			buildConfiguration.addDependency(dependency);
		}

		public BuildConfigurationBuilder addSource(BobBuildProjectSourceFile source) {
			buildConfiguration.addSource(source);
			return this;
		}

		public BuildConfigurationBuilder targetDirectory(string targetDirectory) {
			this._targetDirectory = targetDirectory;
			return this;
		} 

		public BuildConfigurationBuilder targetFileName(string targetFileName) {
			this._targetFileName = targetFileName;
			return this;
		} 

		public BuildConfigurationBuilder ccOptions(string[] ccOptions) {
			buildConfiguration.ccOptions = ccOptions;
			return this;
		} 

		public BuildConfiguration build() {
			buildConfiguration.targetFile = "%s%C%s".printf(_targetDirectory, Path.DIR_SEPARATOR, _targetFileName);
			return buildConfiguration;
		}
	}
}