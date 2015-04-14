using bob.builder.json;

namespace bob.builder.build.plugin {

    public class BuildDependency {

        public BuildDependency.fromJSONObject(JsonObject jsonObject) {
    		dependency = jsonObject.getStringEntry("dependency", null);
    		version = jsonObject.getStringEntry("version", null);
    		dependencyType = jsonObject.getStringEntry("type", null);
        }
        
        public string to_string() {
            return "%s-%s".printf(dependency, version);
        }

        public string dependency { get; set; }
        public string version { get; set; }
    	public string dependencyType { get; set; }
    }

}