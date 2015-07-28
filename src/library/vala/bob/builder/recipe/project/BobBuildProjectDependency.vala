using bob.builder.json;

namespace bob.builder.recipe.project {

    public class BobBuildProjectDependency {

        private const string VERSION_NONE = "-";

        private const string MEMBER_DEPENDENCY = "dependency";
        private const string MEMBER_VERSION = "version";
        private const string MEMBER_SCOPE = "scope";
        private const string MEMBER_VAPI_DIRECTORY = "vapi-directory";
        private const string MEMBER_C_HEADERS_DIRECTORY = "c-headers-directory";

        public BobBuildProjectDependency.fromJsonObject(JsonObject jsonObject) {
    		dependency = jsonObject.getStringEntry(MEMBER_DEPENDENCY, null);
    		version = jsonObject.getStringEntry(MEMBER_VERSION, VERSION_NONE);
    		scope = BobBuildProjectDependencyScope.fromName(jsonObject.getStringEntry(MEMBER_SCOPE, BobBuildProjectDependencyScope.BOTH.name()));
            vapiDirectory = jsonObject.getStringEntry(MEMBER_VAPI_DIRECTORY, null);
            cHeadersDirectory = jsonObject.getStringEntry(MEMBER_C_HEADERS_DIRECTORY, null);
        }

        public string toString() {
            if (isNonVersion()) {
                return dependency;
            }
            return "%s-%s".printf(dependency, version);
        }

        public bool equals(BobBuildProjectDependency other) {
            return other.dependency == dependency &&
                other.version == version;
        }

        public string dependency { get; set; }
        public string version { get; set; }
    	public BobBuildProjectDependencyScope scope { get; set; default = BobBuildProjectDependencyScope.BOTH; }
        public string vapiDirectory { get; set; }
        public string cHeadersDirectory { get; set; }

        private bool isNonVersion() {
            return version == VERSION_NONE || version == null;
        }

        public JsonObject toJsonObject() {
            JsonObject jsonObject = new JsonObject();
            jsonObject.setStringEntry(MEMBER_DEPENDENCY, dependency);
            if (scope != BobBuildProjectDependencyScope.BOTH) {
                jsonObject.setStringEntry(MEMBER_SCOPE, scope.name());
            }
            if (vapiDirectory != null) {
                jsonObject.setStringEntry(MEMBER_VAPI_DIRECTORY, vapiDirectory);
            }
            if (cHeadersDirectory != null) {
                jsonObject.setStringEntry(MEMBER_C_HEADERS_DIRECTORY, cHeadersDirectory);
            }
            if (!isNonVersion()) {
                jsonObject.setStringEntry(MEMBER_VERSION, version);
            }
            return jsonObject; 
        }
    }

}