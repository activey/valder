using bob.builder.json;
using bob.builder.filesystem;
using bob.builder.filesystem.visitor;

namespace bob.builder.recipe {

	public class BobBuildRecipeLoader {
	
		public static BobBuildRecipe loadFromJSON() throws Error {
			return new BobBuildRecipeLoader().loadFromJSONFileName(BobFiles.FILE_PROJECT_RECIPE);
		}

		public static BobBuildRecipe loadFromJSONFileObject(FileObject fileObject) throws Error {
			return new BobBuildRecipeLoader().loadFromJSONFile(fileObject);
		}

		private BobBuildRecipeLoader() {}

		public BobBuildRecipe? loadFromJSONFile(FileObject jsonFileObject) throws Error {
			if (!jsonFileObject.exists()) {
				return null;
			}
			return loadRecipe(jsonFileObject.getLocation());
		}

		public BobBuildRecipe? loadFromJSONFileName(string jsonFileName) throws Error {
			File? jsonFile = locateRecipeFile(jsonFileName);
			if (jsonFile == null) {
				return null;
			}
			return loadRecipe(jsonFile.get_path());
		}

		private BobBuildRecipe? loadRecipe(string recipeFileLocation) throws Error {
			Json.Parser parser = new Json.Parser();
			parser.load_from_file(recipeFileLocation);
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
