using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipeParser : Object {

		private BobBuildRecipeBuilder builder;

		public static BobBuildRecipe parseFromJSONFile(FileInfo jsonFile) throws Error {
			Json.Parser parser = new Json.Parser();
			parser.load_from_file(jsonFile.get_name());
			return new BobBuildRecipeParser().parseFromJSONObject(parser.get_root().get_object());
		}

		private BobBuildRecipeParser() { 
			builder = new BobBuildRecipeBuilder();
		}

		public BobBuildRecipe parseFromJSONObject(Json.Object jsonObject) {
			jsonObject.foreach_member(parsePluginConfiguration);
			return builder.build();
		}

		private void parsePluginConfiguration(Json.Object jsonObject, string pluginName, Json.Node recipeFragmentNode) {
			BobBuildPluginConfiguration pluginConfiguration = new BobBuildPluginConfiguration(pluginName);
			stdout.printf(@"Plugin name: $(pluginConfiguration.name)\n");
			builder.addPlugin(pluginConfiguration);
		}
	}
}