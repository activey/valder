using bob.builder.log;

namespace bob.builder.recipe {

	public class BobBuildRecipeLoader {
	
		private const string JSON_RECEIPE = "recipe.bob";
		private Logger LOGGER = Logger.getLogger("BobBuildRecipeLoader");
	
		public static BobBuildRecipe loadFromJSON() throws Error {
			return new BobBuildRecipeLoader().loadFromJSONFile(JSON_RECEIPE);
		}

		private BobBuildRecipeLoader () {}

		public BobBuildRecipe ? loadFromJSONFile(string jsonFileName) throws Error {
			FileInfo ? jsonFile = locateRecipeFile(jsonFileName);
			if (jsonFile == null) {
				LOGGER.logError("Unable to locate %s file", JSON_RECEIPE);
				return null;
			}
			return BobBuildRecipeParser.parseFromJSONFile(jsonFile);
		}

		private FileInfo ? locateRecipeFile(string recipeFileName) {
			try {
				File workDirectory = getBobWorkDirectory();
				FileEnumerator enumerator = workDirectory.enumerate_children(FileAttribute.STANDARD_NAME, 0);
				FileInfo fileInfo;
				while ((fileInfo = enumerator.next_file()) != null) {
					if (fileInfo.get_name() == recipeFileName) {
						return fileInfo;
					}
				}
			}
			catch(Error e) {
				LOGGER.logError("An exception occurred while loading json file: ", e.message);
			}
			return null;
		}

		private File getBobWorkDirectory() {
			return File.new_for_path(".");
		}
	}
}
