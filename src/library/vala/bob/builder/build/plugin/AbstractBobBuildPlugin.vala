using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public errordomain BobBuildPluginError {
		INITIALIZATION_ERROR, RUN_ERROR
	}

	public abstract class AbstractBobBuildPlugin : Object {

		public string name {
			construct set;
			get;
		}

		public AbstractBobBuildPlugin(string pluginName) {
			Object(name: pluginName);
		}

		public abstract void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError;

		public abstract void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError;
	}
}