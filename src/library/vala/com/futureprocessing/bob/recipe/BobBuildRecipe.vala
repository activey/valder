using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipe : Object {

		public BobBuildProjectRecipe project { 
			get; 
			set; 
			default = new BobBuildProjectRecipe(); 
		}
		
		public unowned List<BobBuildPluginRecipe> plugins { 
			get; 
			set; 
			default = new List<BobBuildPluginRecipe>(); 
		}
	}	
}