using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder;

namespace bob.builder.recipe {

	public class BobBuildRecipe : Object {

		private List<BobBuildPluginRecipe> pluginsRecipies = new List<BobBuildPluginRecipe>();
		
		public BobBuildProjectRecipe project {
			get;
			set;
			default = new BobBuildProjectRecipe();
		}
		
		public void addPluginRecipe(BobBuildPluginRecipe recipe) {
			pluginsRecipies.append(recipe);
		}

		public BobBuildPluginRecipe ? getPluginRecipe(string pluginName) {
			foreach (BobBuildPluginRecipe pluginRecipe in pluginsRecipies) {
				if (pluginRecipe.name == pluginName) {
					return pluginRecipe;
				}
			}
			return null;
		}
	}
}
