using bob.builder.json;

namespace bob.builder.recipe.project {

    public class BobBuildProjectDependency {

        private const string MEMBER_DEPENDENCY = "dependency";
        private const string MEMBER_VERSION = "version";
        private const string MEMBER_TYPE = "type";

        private const string TYPE_PKG = "pkg";

        public BobBuildProjectDependency.fromJsonObject(JsonObject jsonObject) {
    		dependency = jsonObject.getStringEntry(MEMBER_DEPENDENCY, null);
    		version = jsonObject.getStringEntry(MEMBER_VERSION, null);
    		dependencyType = jsonObject.getStringEntry(MEMBER_TYPE, null);
        }

        public BobBuildProjectDependency.newPkgDependency() {
            dependencyType = TYPE_PKG;
        }
        
        public string to_string() {
            return "%s-%s".printf(dependency, version);
        }

        public string dependency { get; set; }
        public string version { get; set; }
    	public string dependencyType { get; set; }

        public JsonObject toJsonObject() {
            JsonObject jsonObject = new JsonObject();
            jsonObject.setStringEntry(MEMBER_DEPENDENCY, dependency);
            jsonObject.setStringEntry(MEMBER_VERSION, version);
            jsonObject.setStringEntry(MEMBER_TYPE, dependencyType);

            return jsonObject; 
        }
    }

}