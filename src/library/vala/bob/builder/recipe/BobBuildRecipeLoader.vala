using bob.builder.json;
using bob.builder.filesystem;
using bob.builder.filesystem.visitor;

namespace bob.builder.recipe {

	public class BobBuildRecipeLoader {
	
		public static BobBuildRecipe loadFromJSON() throws Error {
			return new BobBuildRecipeLoader().loadFromJSONFile(BobFiles.FILE_PROJECT_RECIPE);
		}

		private BobBuildRecipeLoader () {}

		public BobBuildRecipe? loadFromJSONFile(string jsonFileName) throws Error {
			File? jsonFile = locateRecipeFile(jsonFileName);
			if (jsonFile == null) {
				return null;
			}
			
			Json.Parser parser = new Json.Parser();
			parser.load_from_file(jsonFile.get_path());
			return new BobBuildRecipe.fromJsonObject(new JsonObject.fromJsonObject(parser.get_root().get_object()));
		}

		private File? locateRecipeFile(string recipeFileName) {
			DirectoryObject workDirectory = new DirectoryObject.fromCurrentLocation();
			BobBuildRecipeLocatingVisitor recipeVisitor = new BobBuildRecipeLocatingVisitor(recipeFileName);
			workDirectory.accept(recipeVisitor);
			return recipeVisitor.getRecipeFile();
		}
	}
}
