using bob.builder;
using bob.builder.build;
using bob.builder.build.plugin;
using bob.builder.recipe;
using bob.builder.log;

namespace bob.builder {

	public class BobBuilder {

        private Logger LOGGER = Logger.getLogger("BobBuilder");

		private BobBuildContext buildContext;
		private BobBuildRecipe buildRecipe;

		public BobBuilder() throws Error {
			try {
				initializeBuildRecipe();
			} catch (Error e) {
				LOGGER.logError("An error occurred while processing build recipe: %s", e.message);
				throw e;
			}
			initializeBuildContext();
		}

		public void usePlugins(string[] buildPlugins) throws BuildPluginError  {
			initializeBuildContextPlugins(buildPlugins);
		}

		private void initializeBuildRecipe() throws Error {
			buildRecipe = BobBuildRecipeLoader.loadFromJSON();
			if (buildRecipe == null) {
				LOGGER.logInfo("Could not find any kind of recipe file, continuing without it");
				return;
			}
		}

		private void initializeBuildContext() {
			if (buildRecipe == null) {
				buildContext = new BobBuildContext();
			} else {
				buildContext = new BobBuildContext.withRecipe(buildRecipe);
			}
		}

		private void initializeBuildContextPlugins(string[] buildPlugins) throws BuildPluginError {
			foreach (string plugin in buildPlugins) {
				buildContext.usePlugin(plugin);
			}
		}

		public void startBuild() {
			buildContext.proceed();
		}

		public void printMetaData() {
			LOGGER.logInfo("Bob the Builder, version = %s", BobBuilderMetadata.VERSION);
		}
	}
}

public static int main(string[] args) {
	try {
		BobBuilder builder = new BobBuilder();
		if (args.length > 1) {
			builder.usePlugins(args[1:args.length]);
			builder.startBuild();
		} else {
			builder.printMetaData();
		}
		return 0;
	} catch (Error e) {
		return 1;
	}
}