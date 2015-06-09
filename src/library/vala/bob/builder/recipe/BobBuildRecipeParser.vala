using bob.builder.json;
using bob.builder.log;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;

namespace bob.builder.recipe {
	
	public class BobBuildRecipeParser : Object {

		private Logger LOGGER = Logger.getLogger("BobBuildRecipeParser");
		
		private const string MEMBER_PLUGINS = "plugins";
		private const string MEMBER_PROJECT = "project";

		private BobBuildRecipeBuilder builder;
		
		public static BobBuildRecipe parseFromJSONFile(FileInfo jsonFile) throws Error {
			Json.Parser parser = new Json.Parser();
			parser.load_from_file(jsonFile.get_name());
			return new BobBuildRecipeParser().parseFromJSONObject(new JsonObject.fromJsonObject(parser.get_root().get_object()));
		}

		private BobBuildRecipeParser() {
			builder = new BobBuildRecipeBuilder();
		}

		public BobBuildRecipe parseFromJSONObject(JsonObject jsonObject) {
			parseProject(jsonObject);
			parsePlugins(jsonObject);
			return builder.build();
		}

		private void parseProject(JsonObject jsonObject) {
			if (jsonObject.keyMissing(MEMBER_PROJECT)) {
				LOGGER.logInfo("No project configuration found, using defaults.");
				return;
			}
			JsonObject projectJsonObject = jsonObject.getJsonObjectEntry(MEMBER_PROJECT);
			builder.projectRecipe(new BobBuildProjectRecipe.fromJSONObject(projectJsonObject));
		}

		private void parsePlugins(JsonObject jsonObject) {
			if (jsonObject.keyMissing(MEMBER_PLUGINS)) {
				LOGGER.logInfo("No plugins configuration found, skipping");
				return;
			}
			JsonObject pluginsObject = jsonObject.getJsonObjectEntry(MEMBER_PLUGINS);
			pluginsObject.forEachMember(parsePluginRecipe);
		}

		private void parsePluginRecipe(string pluginName, JsonObject pluginRecipeJson) {
			LOGGER.logInfo("Parsing plugin recipe: %s", pluginName);	

			builder.pluginRecipe(new BobBuildPluginRecipe.fromJSONObject(pluginName, pluginRecipeJson));
		}
	}
}
