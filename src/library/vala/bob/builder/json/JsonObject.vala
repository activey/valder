using bob.builder.log;
using bob.builder.filesystem;

namespace bob.builder.json {

	public class JsonObject : Object {

		public delegate void ForEachMember(string key, JsonObject objectMember);
	
		private Logger LOGGER = Logger.getLogger("BobBuildRecipe");

		private Json.Object jsonObject;

		public JsonObject() {
			this.jsonObject = new Json.Object();
		}

		public JsonObject.fromJsonObject(Json.Object jsonObject) {
			this.jsonObject = jsonObject;
		}
	
		public string getStringEntry(string key, string? defaultIfNull) {
			if (!jsonObjectSet() || keyMissingOrNull(key)) {
				return defaultIfNull;
			}
			return jsonObject.get_string_member(key);
		}

		public void setStringEntry(string key, string value) {
			if (!jsonObjectSet()) {
				return;
			}
			jsonObject.set_string_member(key, value);
		}

		public bool getBooleanEntry(string key, bool defaultIfNull) {
			if (!jsonObjectSet() || keyMissingOrNull(key)) {
				return defaultIfNull;
			}
			return jsonObject.get_boolean_member(key);
		}

		public JsonObject? getJsonObjectEntry(string key) {
			if (!jsonObjectSet() || keyMissingOrNull(key)) {
				return null;
			}
			return new JsonObject.fromJsonObject(jsonObject.get_object_member(key));
		}

		public void addJsonObjectEntry(string key, Json.Object object) {
			if (!jsonObjectSet()) {
				return;
			}
			jsonObject.set_object_member(key, object);
		}

		public void addToParent(string key, JsonObject parentJsonObject) {
			if (!jsonObjectSet() || key == null || parentJsonObject == null) {
				return;
			}
			parentJsonObject.addJsonObjectEntry(key, jsonObject);
		}

		public void addToArray(JsonArray jsonArray) {
			jsonArray.addEntry(jsonObject);
		}

		public JsonArray? getObjectArrayEntry(string key) {
			if (!jsonObjectSet() || keyMissingOrNull(key)) {
				return null;
			}
			return new JsonArray.fromJsonArray(jsonObject.get_array_member(key));
		}

		public void addObjectArrayEntry(string key, Json.Array objectArray) {
			if (!jsonObjectSet()) {
				return;
			}
			jsonObject.set_array_member(key, objectArray);
		}

		public void forEachMember(ForEachMember forEachMemberDelegate) {
			jsonObject.foreach_member((jsonObject, key, jsonNode) => {
				if (jsonNode.get_node_type() != Json.NodeType.OBJECT) {
					return;
				}
				Json.Object? memberObject = jsonNode.dup_object();
				if (memberObject == null) {
					return;
				}
				forEachMemberDelegate(key, new JsonObject.fromJsonObject(memberObject));
			});
		}

		public bool keyMissing(string key) {
			return keyMissingOrNull(key);
		}

		private bool keyMissingOrNull(string key) {
			if (jsonObject == null || key == null) {
				return false;
			}
			return !jsonObject.has_member(key) || jsonObject.get_null_member(key);
		}

		private bool jsonObjectSet() {
			return jsonObject != null;
		}

		public void writeToFile(FileObject file) throws Error {
			Json.Node rootNode = new Json.Node(Json.NodeType.OBJECT);
			rootNode.set_object(jsonObject);

			Json.Generator generator = new Json.Generator();
			generator.set_pretty(true);
			generator.set_root(rootNode);

			FileIOStream stream = file.getStreamOverwrite();
			if (!generator.to_stream(stream.output_stream)) {
				LOGGER.logError("Was not able to write JsonObject to file due to some system problem.");				
			}
		}
	}
}
