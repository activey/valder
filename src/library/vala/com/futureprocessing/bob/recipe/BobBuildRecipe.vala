using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipe : Object {

		public unowned List<BobBuildPluginConfiguration> plugins { get; set; default = new List<BobBuildPluginConfiguration>(); }
	}	
}