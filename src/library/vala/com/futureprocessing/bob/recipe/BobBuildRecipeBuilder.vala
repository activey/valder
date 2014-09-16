using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipeBuilder : Object {

		private BobBuildRecipe buildRecipe = new BobBuildRecipe();

		public BobBuildRecipeBuilder addPlugin(BobBuildPluginConfiguration pluginConfiguration) {
			buildRecipe.plugins.append(pluginConfiguration);
			return this;
		}

		public BobBuildRecipe build() {
			return buildRecipe;
		}
	}
}