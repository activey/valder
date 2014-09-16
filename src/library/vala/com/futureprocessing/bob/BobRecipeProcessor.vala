using com.futureprocessing.bob.log;
using com.futureprocessing.bob.recipe;
using com.futureprocessing.bob.recipe.plugin;

namespace com.futureprocessing.bob {
	public class BobRecipeProcessor : Object {

        private Logger LOGGER = Logger.getLogger("BobBuildProcessor");

		public void processRecipe(FileInfo recipeFile) throws Error {
    		LOGGER.logInfo("Bob is processing recipe: %s\n", recipeFile.get_name());

		    BobBuildRecipe buildRecipe = BobBuildRecipeParser.parseFromJSONFile(recipeFile);

		    //collectRecipeSources(buildRecipe);
			printRecipeSummary(buildRecipe);
		    //followBuildRecipe(buildRecipe);
		}
		
        /*private void collectRecipeSources(BobBuildRecipe recipe) throws Error {
            new BobRecipeSourcesVisitor(recipe).collectSourceFiles();
        }*/
        
		private void printRecipeSummary(BobBuildRecipe buildRecipe) {
			LOGGER.logInfo("-----------------------------------\n");
			LOGGER.logInfo("Available plugins configurations: \n");
			foreach (BobBuildPluginConfiguration plugin in buildRecipe.plugins) {
			    LOGGER.logInfo(@" -> $(plugin.name)\n");
			}
		}

		/*private void followBuildRecipe(BobBuildRecipe buildRecipe) throws CompilationError {
            new BobRecipeBuilder(buildRecipe.buildConfiguration).build();
		}*/
	}
}