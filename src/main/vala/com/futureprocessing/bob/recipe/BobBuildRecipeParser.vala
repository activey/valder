namespace com.futureprocessing.bob.recipe {
	public class BobBuildRecipeParser {

		public delegate void JSONParsingFailed(Error errorMessage);	

		public delegate void JSONParsingSuccessed(BobBuildRecipe? parsedRecipe);	

		public BobBuildRecipe parseJsonBuildAsRecipe(FileInfo jsonFile) throws Error {
			Json.Parser parser = new Json.Parser();
			parser.load_from_file(jsonFile.get_name());
			return BobBuildRecipe.fromJSONObject(parser.get_root().get_object());
		}
	}
}