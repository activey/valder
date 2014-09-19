using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipe : Object {

		public BobBuildProjectConfiguration project { 
			get; 
			set; 
			default = new BobBuildProjectConfiguration(); 
		}
		
		public unowned List<BobBuildPluginConfiguration> plugins { 
			get; 
			set; 
			default = new List<BobBuildPluginConfiguration>(); 
		}
	}	
}