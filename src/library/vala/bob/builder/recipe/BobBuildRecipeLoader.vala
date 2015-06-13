using bob.builder.log;
using bob.builder.filesystem;
using bob.builder.filesystem.visitor;

namespace bob.builder.recipe {

	public class BobBuildRecipeLoader {
	
		private const string JSON_RECEIPE = "recipe.bob";

		private Logger LOGGER = Logger.getLogger("BobBuildRecipeLoader");
	
		public static BobBuildRecipe loadFromJSON() throws Error {
			return new BobBuildRecipeLoader().loadFromJSONFile(JSON_RECEIPE);
		}

		private BobBuildRecipeLoader () {}

		public BobBuildRecipe? loadFromJSONFile(string jsonFileName) throws Error {
			File? jsonFile = locateRecipeFile(jsonFileName);
			if (jsonFile == null) {
				return null;
			}
			return BobBuildRecipeParser.parseFromJSONFile(jsonFile);
		}

		private File? locateRecipeFile(string recipeFileName) {
			DirectoryObject workDirectory = new DirectoryObject.fromCurrentLocation();
			BobBuildRecipeLocatingVisitor recipeVisitor = new BobBuildRecipeLocatingVisitor(recipeFileName);
			workDirectory.accept(recipeVisitor);
			return recipeVisitor.getRecipeFile();
		}
	}
}
