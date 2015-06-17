using bob.builder.log;
using bob.builder.filesystem;
using bob.builder.filesystem.visitor;

namespace bob.builder.recipe {

	public class BobBuildRecipeLocatingVisitor : FileSystemFilteringVisitor {

		private File recipeFile;

		public BobBuildRecipeLocatingVisitor(string recipeFileName) {
			base(new RecipeFilter(recipeFileName));
		}

		public File? getRecipeFile() {
			return recipeFile;
		}

		public override void visitFileFiltered(File file) {
			recipeFile = file;
		} 
	}

	private class RecipeFilter : FileExtensionFilter {
		
		public RecipeFilter(string recipeFileName) {
			base(recipeFileName);
		}
	}
}