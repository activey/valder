using com.futureprocessing.bob.filesystem;

namespace com.futureprocessing.bob.recipe {
	public class BobRecipeSourcesVisitor : FileSystemFilteringVisitor {

        const string SOURCE_FOLDER_LOCATION = "./src/main/vala";
        
        private BobBuildRecipe recipe;

        public BobRecipeSourcesVisitor(BobBuildRecipe recipe) {
            base(new BobBuildSourceFilter());
            this.recipe = recipe;
        }

		public void collectSourceFiles() throws Error {
            DirectoryObject sourcesDirectory = new DirectoryObject.fromGivenLocation(SOURCE_FOLDER_LOCATION);
            sourcesDirectory.accept(this);
        }
		
		public override void visitFileFiltered(File file) {
            recipe.buildConfiguration.addSourceFile(file);		
		}		
	}
}