using bob.builder.json;
using bob.builder.log;

namespace bob.builder.recipe.project {

	public class BobBuildProjectRecipe {
	
		private const string MEMBER_NAME = "name";
		private const string MEMBER_SHORTNAME = "shortName";
		private const string MEMBER_VERSION = "version";
		private const string MEMBER_DETAILS = "details";
		private const string MEMBER_DEPENDENCIES = "dependencies";
		private const string MEMBER_SOURCES = "sources";
		private const string MEMBER_SOURCES_LIBRARY = "library";
		private const string MEMBER_SOURCES_RUNTIME = "runtime";
		private const string MEMBER_NAME_DEFAULT = "unknown";
		private const string MEMBER_SHORTNAME_DEFAULT = "unknown";
		private const string MEMBER_VERSION_DEFAULT = "0.0.1";

		private Logger LOGGER = Logger.getLogger("BobBuildProjectRecipe");

		private List<BobBuildProjectDependency> _dependencies = new List<BobBuildProjectDependency>();
		private List<BobBuildProjectSourceFile> _libSourceFiles = new List<BobBuildProjectSourceFile>();
		private List<BobBuildProjectSourceFile> _mainSourceFiles = new List<BobBuildProjectSourceFile>();
		
		public string name {
			get;
			set;
			default = MEMBER_NAME_DEFAULT;
		}
		
		public string shortName {
			get;
			set;
			default = MEMBER_SHORTNAME_DEFAULT;
		}
		
		public string version {
			get;
			set;
			default = MEMBER_VERSION_DEFAULT;
		}

		public BobBuildProjectDetails details {
			get;
			set;
			default = new BobBuildProjectDetails();
		}

		public List<BobBuildProjectDependency> dependencies {
			get {
				return _dependencies;
			}
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

		public BobBuildProjectRecipe.fromJsonObject(JsonObject jsonObject) {
			name = jsonObject.getStringEntry(MEMBER_NAME, MEMBER_NAME_DEFAULT);
			shortName = jsonObject.getStringEntry(MEMBER_SHORTNAME, MEMBER_SHORTNAME_DEFAULT);
	        version = jsonObject.getStringEntry(MEMBER_VERSION, MEMBER_VERSION_DEFAULT);

	        parseProjectDetails(jsonObject);
	        parseProjectSources(jsonObject);
	        parseProjectDependencies(jsonObject);
		}

		private void parseProjectDetails(JsonObject projectJsonObject) {
			if (projectJsonObject.keyMissing(MEMBER_DETAILS)) {
				return;
			}
			LOGGER.logInfo("Parsing project details.");
			JsonObject? detailsObject = projectJsonObject.getJsonObjectEntry(MEMBER_DETAILS);
			details = new BobBuildProjectDetails.fromJsonObject(detailsObject);
		}

		private void parseProjectDependencies(JsonObject projectJsonObject) {
			if (projectJsonObject.keyMissing(MEMBER_DEPENDENCIES)) {
				LOGGER.logInfo("No project dependencies defined.");
				return;
			}
			LOGGER.logInfo("Parsing project dependencies.");
			JsonArray dependenciesJsonArray = projectJsonObject.getObjectArrayEntry(MEMBER_DEPENDENCIES);
			dependenciesJsonArray.forEachMember(parseProjectDependency);
		}

		private void parseProjectDependency(JsonObject dependencyJsonObject) {
			addDependency(new BobBuildProjectDependency.fromJsonObject(dependencyJsonObject));
		}

		private void parseProjectSources(JsonObject projectJsonObject) {
			if (projectJsonObject.keyMissing(MEMBER_SOURCES)) {
				LOGGER.logInfo("No project sources defined.");
				return;
			}
			LOGGER.logInfo("Parsing project source files.");

			JsonObject sourcesJsonObject = projectJsonObject.getJsonObjectEntry(MEMBER_SOURCES);
			parseProjectSourcesLibrary(sourcesJsonObject);
			parseProjectSourcesRuntime(sourcesJsonObject);
		}

		private void parseProjectSourcesLibrary(JsonObject sourcesJsonObject) {
			if (sourcesJsonObject.keyMissing(MEMBER_SOURCES_LIBRARY)) {
				LOGGER.logInfo("No project sources for library defined.");
				return;
			}
			JsonArray sourcesLibraryJsonArray = sourcesJsonObject.getObjectArrayEntry(MEMBER_SOURCES_LIBRARY);
			sourcesLibraryJsonArray.forStringEachValue(parseLibrarySourceFile);
		}

		private void parseLibrarySourceFile(string librarySourceLocation) {
			addLibSourceFile(new BobBuildProjectSourceFile.fromLocation(librarySourceLocation));
		}

		private void parseProjectSourcesRuntime(JsonObject sourcesJsonObject) {
			if (sourcesJsonObject.keyMissing(MEMBER_SOURCES_RUNTIME)) {
				LOGGER.logInfo("No project sources for runtime defined.");
				return;
			}
			JsonArray sourcesRuntimeJsonArray = sourcesJsonObject.getObjectArrayEntry(MEMBER_SOURCES_RUNTIME);
			sourcesRuntimeJsonArray.forStringEachValue(parseRuntimeSourceFile);
		}

		private void parseRuntimeSourceFile(string runtimeSourceLocation) {
			addMainSourceFile(new BobBuildProjectSourceFile.fromLocation(runtimeSourceLocation));
		}

		public void addDependency(BobBuildProjectDependency dependency) {
			if (hasDependency(dependency)) {
				LOGGER.logInfo("Dependency [%s] already on dependencies list.", dependency.toString());
				return;
			}
			_dependencies.append(dependency);
		}

		public bool hasDependency(BobBuildProjectDependency dependency) {
			foreach (BobBuildProjectDependency existingDependency in _dependencies) {
				if (existingDependency.equals(dependency)) {
					return true;
				}
			}
			return false;
		}
		
		public void addLibSourceFile(BobBuildProjectSourceFile projectSourceFile) {
			_libSourceFiles.append(projectSourceFile);
		}

		public void addMainSourceFile(BobBuildProjectSourceFile projectSourceFile) {
			_mainSourceFiles.append(projectSourceFile);
		}

		public JsonObject toJsonObject() {
			JsonObject jsonObject = new JsonObject();
			jsonObject.setStringEntry(MEMBER_NAME, name);
			jsonObject.setStringEntry(MEMBER_SHORTNAME, shortName);
			jsonObject.setStringEntry(MEMBER_VERSION, version);

			writeProjectDependencies(jsonObject);
			writeProjectSources(jsonObject);

			return jsonObject;
		}

		private void writeProjectDependencies(JsonObject outputJson) {
			JsonArray dependenciesArray = new JsonArray();
			foreach (BobBuildProjectDependency dependency in _dependencies) {
				JsonObject dependencyJson = dependency.toJsonObject();
				dependencyJson.addToArray(dependenciesArray);
			}
			dependenciesArray.addToParent(MEMBER_DEPENDENCIES, outputJson);
		}

		private void writeProjectSources(JsonObject outputJson) {
			JsonObject projectSourcesObject = new JsonObject();

			JsonArray librarySourcesArray = new JsonArray();
			foreach (BobBuildProjectSourceFile sourceFile in _libSourceFiles) {
				librarySourcesArray.addStringEntry(sourceFile.fileLocation);
			}
			librarySourcesArray.addToParent(MEMBER_SOURCES_LIBRARY, projectSourcesObject);

			JsonArray runtimeSourcesArray = new JsonArray();
			foreach (BobBuildProjectSourceFile sourceFile in _mainSourceFiles) {
				runtimeSourcesArray.addStringEntry(sourceFile.fileLocation);
			}
			runtimeSourcesArray.addToParent(MEMBER_SOURCES_RUNTIME, projectSourcesObject);

			projectSourcesObject.addToParent(MEMBER_SOURCES, outputJson);
		}
	}
}
