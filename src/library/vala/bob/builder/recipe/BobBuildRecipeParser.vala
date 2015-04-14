using bob.builder.json;
using bob.builder.log;
using bob.builder.recipe.plugin;

namespace bob.builder.recipe {
	
	public class BobBuildRecipeParser : Object {

		private Logger LOGGER = Logger.getLogger("BobBuildRecipeParser");
		
		private const string MEMBER_PLUGINS = "plugins";
		private const string MEMBER_PROJECT = "project";
		private const string MEMBER_NAME = "name";
		private const string MEMBER_NAME_DEFAULT = "unknown";
		private const string MEMBER_SHORTNAME = "shortName";
		private const string MEMBER_SHORTNAME_DEFAULT = "unknown";
		private const string MEMBER_VERSION = "version";
		private const string MEMBER_VERSION_DEFAULT = "0.0.1";

		private BobBuildRecipeBuilder builder;
		
		public static BobBuildRecipe parseFromJSONFile(FileInfo jsonFile) throws Error {
			Json.Parser parser = new Json.Parser();
			parser.load_from_file(jsonFile.get_name());
			return new BobBuildRecipeParser().parseFromJSONObject(parser.get_root().get_object());
		}

		private BobBuildRecipeParser () {
			builder = new BobBuildRecipeBuilder();
		}

		public BobBuildRecipe parseFromJSONObject(Json.Object jsonObject) {
			parseProject(jsonObject);
			parsePlugins(jsonObject);
			return builder.build();
		}

		private void parseProject(Json.Object jsonObject) {
			if (keyMissing(jsonObject, MEMBER_PROJECT)) {
				LOGGER.logInfo("No project configuration found, using defaults");
				builder.project(MEMBER_NAME_DEFAULT, MEMBER_SHORTNAME_DEFAULT, MEMBER_VERSION_DEFAULT);
				return;
			}
			Json.Object projectObject = jsonObject.get_object_member(MEMBER_PROJECT);
			builder.project(getStringMember(projectObject, MEMBER_NAME, MEMBER_NAME_DEFAULT), 
				getStringMember(projectObject, MEMBER_SHORTNAME, MEMBER_SHORTNAME_DEFAULT),
		        getStringMember(projectObject, MEMBER_VERSION, MEMBER_VERSION_DEFAULT));
		}

		private void parsePlugins(Json.Object jsonObject) {
			if (keyMissing(jsonObject, MEMBER_PLUGINS)) {
				LOGGER.logInfo("No plugins configuration found, skipping");
				return;
			}
			Json.Object pluginsObject = jsonObject.get_object_member(MEMBER_PLUGINS);
			pluginsObject.foreach_member(parsePluginRecipe);
		}

		private void parsePluginRecipe(Json.Object jsonObject, string pluginName, Json.Node recipeFragmentNode) {
			LOGGER.logInfo("Parsing plugin recipe: %s", pluginName);
			Json.Object pluginRecipeJson = jsonObject.get_object_member(pluginName);
			BobBuildPluginRecipe pluginRecipe = new BobBuildPluginRecipe(pluginName, new JsonObject.fromJsonObject(pluginRecipeJson));
			builder.plugin(pluginRecipe);
		}

		private bool keyMissing(Json.Object jsonObject, string key) {
			return !jsonObject.has_member(key);
		}

		private string getStringMember(Json.Object jsonObject, string key, string defaultIfNull) {
			if (keyMissing(jsonObject, key)) {
				return defaultIfNull;
			}
			if (jsonObject.get_null_member(key)) {
				return defaultIfNull;
			}
			return jsonObject.get_string_member(key);
		}
	}
}
