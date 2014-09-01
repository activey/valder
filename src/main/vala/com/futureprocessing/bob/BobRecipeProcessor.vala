using com.futureprocessing.bob.log;
using com.futureprocessing.bob.recipe;

namespace com.futureprocessing.bob {
	public class BobRecipeProcessor {

        private Logger LOGGER = Logger.getLogger("BobBuildProcessor");

		public void processRecipe(FileInfo recipeFile) throws Error {
    		LOGGER.logInfo("Bob is processing recipe: %s\n", recipeFile.get_name());
		    
    		/*
				1. Przygotowac lista wtyczek "pre-built" (np: ground),
				2. collect sources
				3. przekazac liste wtyczek z args[]
				4. dla kazdej odnalezionej wtyczki wykonac jej inicjalizacje odpowiednim blokiem z jsona,

				
    		*/
		    BobBuildRecipe buildRecipe = new BobBuildRecipeParser().parseJsonBuildAsRecipe(recipeFile);
		    collectRecipeSources(buildRecipe);
			printRecipeSummary(buildRecipe);
		    followBuildRecipe(buildRecipe, buildSuccessed, buildFailed);
		}
		
        private void collectRecipeSources(BobBuildRecipe recipe) throws Error {
            new BobRecipeSourcesVisitor(recipe).collectSourceFiles();
        }
        
		private void printRecipeSummary(BobBuildRecipe buildRecipe) {
			LOGGER.logInfo("-----------------------------------\n");
			LOGGER.logInfo("Building project: %s\n", buildRecipe.application.name);
			LOGGER.logInfo("Target binary location: %s\n", buildRecipe.buildConfiguration.target);
			LOGGER.logInfo("Creating desktop file: %s\n", buildRecipe.application.generateDesktopEntry.to_string());
			LOGGER.logInfo("Desktop icon: %s\n", buildRecipe.application.icon ?? "<not set>");
			LOGGER.logInfo("Dependencies: \n");
			foreach (BobRecipeBuildDependency dependency in buildRecipe.buildConfiguration.dependencies) {
			    LOGGER.logInfo(@" -> $(dependency.dependency), version: $(dependency.version)\n");
			}
			LOGGER.logInfo(@"About to process $(buildRecipe.buildConfiguration.sources.length()) source files.\n");
			LOGGER.logInfo("-----------------------------------\n");
		}

		private void followBuildRecipe(BobBuildRecipe buildRecipe, BuildSuccessed buildSuccessed, BuildFailed buildFailed) {
            try {
                new BobRecipeBuilder(buildRecipe.buildConfiguration).build();
                buildSuccessed();
            } catch (CompilationError e) {
                buildFailed(e.message);
            }			
		}

	}
}