using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipeBuilder : Object {

		private List<BobBuildPluginConfiguration> plugins;
		private BobBuildProjectConfiguration projectConfiguration;

		public BobBuildRecipeBuilder plugin(BobBuildPluginConfiguration pluginConfiguration) {
			if (plugins == null) {
				plugins = new List<BobBuildPluginConfiguration>();
			}
			plugins.append(pluginConfiguration);
			return this;
		}

		public BobBuildRecipeBuilder project(string name, string shortName, string version) {
			projectConfiguration = new BobBuildProjectConfiguration();
			projectConfiguration.name = name;
			projectConfiguration.shortName = shortName;
			projectConfiguration.version = version;
			return this;
		}

		public BobBuildRecipe build() {
			BobBuildRecipe buildRecipe = new BobBuildRecipe();
			buildRecipe.project = projectConfiguration;
			foreach (BobBuildPluginConfiguration plugin in plugins) {
				buildRecipe.plugins.append(plugin);
			}
			return buildRecipe;
		}
	}
}