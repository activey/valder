using bob.builder;
using bob.builder.build;
using bob.builder.build.plugin;
using bob.builder.recipe;
using bob.builder.log;

namespace bob.builder {

	public class BobBuilder {

        private Logger LOGGER = Logger.getLogger("BobBuilder");
		private string[] DEFAULT_PLUGINS = { "build" };

		private BobBuildContext buildContext;
		private BobBuildRecipe buildRecipe;

		public BobBuilder(string[] buildPlugins) throws BuildPluginError {
			initializeBuildRecipe();
			initializeBuildContext();
			initializeBuildContextPlugins(buildPlugins);
		}

		private void initializeBuildRecipe() {
			try {
				buildRecipe = BobBuildRecipeLoader.loadFromJSON();
				if (buildRecipe == null) {
					LOGGER.logInfo("Could not find any kind of recipe file, continuing without it");
					return;
				}
			} catch (Error e) {
				LOGGER.logError("An error occurred while processing build recipe: %s", e.message);
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
			if (buildPlugins.length == 0) {
				LOGGER.logInfo("No user defined plugins to run, going with defaults");
				initializeBuildContextPlugins(DEFAULT_PLUGINS);
				return;
			}
			foreach (string plugin in buildPlugins) {
				buildContext.addPlugin(plugin);
			}
		}

		public void startBuild() {
			buildContext.proceed();
		}
	}
}

public static int main(string[] args) {
	try {
		BobBuilder builder = new BobBuilder(args[1:args.length]);
		builder.startBuild();
		return 0;
	} catch (Error e) {
		return 1;
	}
}