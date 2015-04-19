namespace bob.builder.json {

	public class JsonObject : Object {

		public delegate void ForEachMember(string key, JsonObject objectMember);
	
		private Json.Object jsonObject;
	
		public JsonObject () {
			this.jsonObject = new Json.Object();
		}

		public JsonObject.fromJsonObject(Json.Object jsonObject) {
			this.jsonObject = jsonObject;
		}
	
		public string getStringEntry(string key, string ? defaultIfNull) {
			if (keyMissingOrNull(key)) {
				return defaultIfNull;
			}
			return jsonObject.get_string_member(key);
		}

		public bool getBooleanEntry(string key, bool defaultIfNull) {
			if (keyMissingOrNull(key)) {
				return defaultIfNull;
			}
			return jsonObject.get_boolean_member(key);
		}

		public JsonObject? getJsonObjectEntry(string key) {
			if (keyMissingOrNull(key)) {
				return null;
			}
			return new JsonObject.fromJsonObject(jsonObject.get_object_member(key));
		}

		public JsonArray? getObjectArrayEntry(string key) {
			if (keyMissingOrNull(key)) {
				return null;
			}
			return new JsonArray.fromJsonArray(jsonObject.get_array_member(key));
		}

		public void forEachMember(ForEachMember forEachMemberDelegate) {
			jsonObject.foreach_member((jsonObject, key, jsonNode) => {
				forEachMemberDelegate(key, new JsonObject.fromJsonObject(jsonObject));
			});
		}

		public bool keyMissing(string key) {
			return keyMissingOrNull(key);
		}

		private bool keyMissingOrNull(string key) {
			return !jsonObject.has_member(key) || jsonObject.get_null_member(key);
		}

	}
}
