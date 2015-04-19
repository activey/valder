using bob.builder.json;

namespace bob.builder.recipe.project {

    public class BobBuildProjectDependency {

        private const string MEMBER_DEPENDENCY = "dependency";
        private const string MEMBER_VERSION = "version";
        private const string MEMBER_TYPE = "type";

        public BobBuildProjectDependency.fromJSONObject(JsonObject jsonObject) {
    		dependency = jsonObject.getStringEntry(MEMBER_DEPENDENCY, null);
    		version = jsonObject.getStringEntry(MEMBER_VERSION, null);
    		dependencyType = jsonObject.getStringEntry(MEMBER_TYPE, null);
        }
        
        public string to_string() {
            return "%s-%s".printf(dependency, version);
        }

        public string dependency { get; set; }
        public string version { get; set; }
    	public string dependencyType { get; set; }
    }

}