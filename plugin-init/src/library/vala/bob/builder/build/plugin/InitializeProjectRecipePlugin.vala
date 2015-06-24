using bob.builder.build;
using bob.builder.recipe;
using bob.builder.recipe.project;
using bob.builder.recipe.plugin;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public class InitializeProjectRecipePlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "initialize:recipe";
        const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("InitializeProjectRecipePlugin");

        private bool verbose = false; 

        public InitializeProjectRecipePlugin() {
        	base(PLUGIN_NAME);
        }

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);
		}

	    public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
	    	LOGGER.logInfo("Initializing project build recipe.");
	    	if (projectDirectory.hasChildWithName(BobFiles.FILE_PROJECT_RECIPE)) {
	    		LOGGER.logInfo("Project recipe file already present.");
	    		return;
	    	}

	    	LOGGER.logInfo("Generating empty build recipe file.");
	    	try {
		    	FileObject newRecipeFile = projectDirectory.newFileChild(BobFiles.FILE_PROJECT_RECIPE);
		    	BobBuildRecipe newRecipe = createEmptyRecipe();
		    	newRecipe.writeToFile(newRecipeFile);
	    	} catch (Error e) {
	    		throw new BobBuildPluginError.RUN_ERROR(e.message);
	    	}

	    	LOGGER.logSuccess("Recipe file generated successfully.");
	    }

	    private BobBuildRecipe createEmptyRecipe() {
	    	BobBuildRecipe newRecipe = new BobBuildRecipe();

	    	new EnvironmentPackagesDependenciesParser().parseDependencies((name, version) => {
	    		BobBuildProjectDependency dependency = new BobBuildProjectDependency.newPkgDependency();
	    		dependency.dependency = name;
	    		dependency.version = version;
	    		newRecipe.project.addDependency(dependency);
    		});

	    	return newRecipe;
	    }
	}
}