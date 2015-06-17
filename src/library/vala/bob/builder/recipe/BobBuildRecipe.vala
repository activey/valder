using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.log;
using bob.builder.json;
using bob.builder.filesystem;
using bob.builder;

namespace bob.builder.recipe {

	public class BobBuildRecipe : Object {

		private const string MEMBER_PLUGINS = "plugins";
		private const string MEMBER_PROJECT = "project";

		private Logger LOGGER = Logger.getLogger("BobBuildRecipe");

		private List<BobBuildPluginRecipe> pluginsRecipies = new List<BobBuildPluginRecipe>();
		
		public BobBuildProjectRecipe project {
			get;
			set;
			default = new BobBuildProjectRecipe();
		}
		
		public BobBuildRecipe.fromJsonObject(JsonObject jsonObject) {
			parseProject(jsonObject);
			parsePlugins(jsonObject);
		}

		public BobBuildRecipe.default() {}		

		private void parseProject(JsonObject jsonObject) {
			if (jsonObject.keyMissing(MEMBER_PROJECT)) {
				LOGGER.logInfo("No project configuration found, using defaults.");
				return;
			}
			JsonObject projectJsonObject = jsonObject.getJsonObjectEntry(MEMBER_PROJECT);

			this.project = new BobBuildProjectRecipe.fromJsonObject(projectJsonObject);
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
			addPluginRecipe(new BobBuildPluginRecipe.fromJsonObject(pluginName, pluginRecipeJson));
		}

		public void addPluginRecipe(BobBuildPluginRecipe recipe) {
			pluginsRecipies.append(recipe);
		}

		public BobBuildPluginRecipe? getPluginRecipe(string pluginName) {
			foreach (BobBuildPluginRecipe pluginRecipe in pluginsRecipies) {
				if (pluginRecipe.name == pluginName) {
					return pluginRecipe;
				}
			}
			return null;
		}

		public JsonObject toJsonObject() {
			JsonObject jsonObject = new JsonObject();
			JsonObject projectJsonObject = project.toJsonObject();
			projectJsonObject.addToParent(MEMBER_PROJECT, jsonObject);
			return jsonObject;
		}

		public void writeToFile(FileObject fileObject) throws Error {
			JsonObject jsonObject = toJsonObject();
			jsonObject.writeToFile(fileObject);
		}
	}
}
