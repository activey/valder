using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.recipe {
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

		public List<BobBuildPluginRecipe> plugins { 
			get {
				return pluginsRecipies;
			}
		}
	}	
}