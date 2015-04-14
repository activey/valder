using bob.builder.recipe.plugin;
using bob.builder.recipe.project;

namespace bob.builder.recipe {

	public class BobBuildRecipeBuilder : Object {

		private List<BobBuildPluginRecipe> plugins;
		private BobBuildProjectRecipe projectRecipe;

		public BobBuildRecipeBuilder plugin(BobBuildPluginRecipe pluginRecipe) {
			if (plugins == null) {
				plugins = new List<BobBuildPluginRecipe>();
			}
			plugins.append(pluginRecipe);
			return this;
		}

		public BobBuildRecipeBuilder project(string name, string shortName, string version) {
			projectRecipe = new BobBuildProjectRecipe();
			projectRecipe.name = name;
			projectRecipe.shortName = shortName;
			projectRecipe.version = version;
			return this;
		}

		public BobBuildRecipe build() {
			BobBuildRecipe buildRecipe = new BobBuildRecipe();

			buildRecipe.project = projectRecipe;
			foreach (BobBuildPluginRecipe plugin in plugins) {
				buildRecipe.addPluginRecipe(plugin);
			}
			return buildRecipe;
		}
	}
}
