namespace com.futureprocessing.bob.recipe.plugin {
	
	public class BobBuildPluginRecipe : Object {
		
		public string name { get; set construct; }
		private Json.Object jsonConfiguration;

		public BobBuildPluginRecipe(string name, Json.Object jsonConfiguration) {
			Object(name: name);
			this.jsonConfiguration = jsonConfiguration;
		}

		public string getStringEntry(string key, string defaultIfNull) {
			if (keyMissingOrNull(key)) {
				return defaultIfNull;
			}
			return jsonConfiguration.get_string_member(key);
		}

		public bool getBooleanEntry(string key, bool defaultIfNull) {
			if (keyMissingOrNull(key)) {
				return defaultIfNull;
			}
			return jsonConfiguration.get_boolean_member(key);
		}

		private bool keyMissingOrNull(string key) {
			stdout.printf("%s \n", key);
			return !jsonConfiguration.has_member(key) || jsonConfiguration.get_null_member(key);
		}
	}
}