using bob.builder.recipe.plugin;
using bob.builder.recipe.project;

namespace bob.builder.recipe {

	public class BobBuildRecipeBuilder : Object {

		private List<BobBuildPluginRecipe> _plugins = new List<BobBuildPluginRecipe>();
		private BobBuildProjectRecipe _projectRecipe = new BobBuildProjectRecipe.default();

		public BobBuildRecipeBuilder pluginRecipe(BobBuildPluginRecipe pluginRecipe) {
			_plugins.append(pluginRecipe);
			return this;
		}

		public BobBuildRecipeBuilder projectRecipe(BobBuildProjectRecipe projectRecipe) {
			_projectRecipe = projectRecipe;
			return this;
		}

		public BobBuildRecipe build() {
			BobBuildRecipe buildRecipe = new BobBuildRecipe();

			buildRecipe.project = _projectRecipe;
			foreach (BobBuildPluginRecipe plugin in _plugins) {
				buildRecipe.addPluginRecipe(plugin);
			}
			return buildRecipe;
		}
	}
}
