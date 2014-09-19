using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe;
using com.futureprocessing.bob.log;

namespace com.futureprocessing.bob.build {
	
	public class BobBuildContext : Object {

        private Logger LOGGER = Logger.getLogger("BobBuildContext");

		public BobBuildContext() {
			this.buildRecipe = new BobBuildRecipe();
		}	

		public BobBuildContext.withRecipe(BobBuildRecipe buildRecipe) {
			this.buildRecipe = buildRecipe;
		}

		public void addPlugin(string buildPlugin) {
			LOGGER.logInfo("Initializing plugin: [%s]", buildPlugin);
		}

		public void proceed() {
			printRecipeSummary();
		}

		private void printRecipeSummary() {
			LOGGER.logInfo("Building project: %s-%s (%s)", buildRecipe.project.shortName ?? "", buildRecipe.project.version ?? "", buildRecipe.project.name ?? "");
		}

		public bool buildLibrary { get; set; }
		public bool buildMain { get; set; }
		
		private BobBuildRecipe buildRecipe;
	}
}
