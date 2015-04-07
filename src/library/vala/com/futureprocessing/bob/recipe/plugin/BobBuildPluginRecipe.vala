using com.futureprocessing.bob.json;

namespace com.futureprocessing.bob.recipe.plugin {
	
	public class BobBuildPluginRecipe : Object {
		
		public string name { get; set construct; }

		public JsonObject jsonConfiguration { get; set construct; }

		public BobBuildPluginRecipe(string name, JsonObject jsonConfiguration) {
			Object(name: name, jsonConfiguration: jsonConfiguration);
		}
	}
}