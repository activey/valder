using bob.builder.json;

namespace bob.builder.recipe.plugin {

	public class BobBuildPluginRecipe : Object {
	
		private const string NAME_DEFAULT = "app";
	
		public string name {
			get;
			set construct;
		}
	
		public JsonObject jsonConfiguration {
			get;
			set construct;
		}
	
		public BobBuildPluginRecipe.fromJSONObject(string name, JsonObject jsonConfiguration) {
			Object(name: name, jsonConfiguration: jsonConfiguration);
		}

		public BobBuildPluginRecipe.default() {
			this.fromJSONObject(NAME_DEFAULT, new JsonObject());
		}
	}
}
