using com.futureprocessing.bob;
using Vala;

namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipe {

		public static BobBuildRecipe fromJSONObject(Json.Object jsonObject) {
			BobBuildRecipe buildRecipe = new BobBuildRecipe();
			buildRecipe.application =  BobRecipeApplication.fromJSONObject(jsonObject.get_member("application").get_object()); 
            buildRecipe.buildConfiguration = BobRecipeBuildConfiguration.fromJSONObject(jsonObject.get_member("build").get_object());
            return buildRecipe;
		}
		
		public BobRecipeApplication application { get; set;}
        public BobRecipeBuildConfiguration buildConfiguration { get; set; }
	}	
}