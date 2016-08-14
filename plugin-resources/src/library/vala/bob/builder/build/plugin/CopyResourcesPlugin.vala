using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.json;

namespace bob.builder.build.plugin {

	public class CopyResourcesPlugin : AbstractBobBuildPlugin {

        private const string PLUGIN_NAME = "copy-resources";
        private const string RECIPE_ENTRY_VERBOSE = "verbose";
        private const string RECIPE_ENTRY_DEFAULT_EXCLUDE = "defaultExclude";
		private const string RECIPE_ENTRY_INCLUDE = "include";
		private const string RECIPE_ENTRY_EXCLUDE = "exclude";

        private Logger LOGGER = Logger.getLogger("CopyResourcesPlugin");

        private bool verbose = true; 
        private bool defaultExclude = true;
        private DirectoryMatchers includeMatchers;
        private DirectoryMatchers excludeMatchers;

        public CopyResourcesPlugin() {
        	base(PLUGIN_NAME);
        }

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, true);
			defaultExclude = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_DEFAULT_EXCLUDE, true);
		
			readIncludeMatchers(pluginRecipe.jsonConfiguration.getObjectArrayEntry(RECIPE_ENTRY_INCLUDE));
			readExcludeMatchers(pluginRecipe.jsonConfiguration.getObjectArrayEntry(RECIPE_ENTRY_EXCLUDE));
		}

		private void readIncludeMatchers(JsonArray? includeMatchersArray) {
			if (includeMatchersArray == null) {
				return;
			}
			includeMatchers = new DirectoryMatchers();
			includeMatchersArray.forStringEachValue(includeMatchers.addMatcher);
		}

		private void readExcludeMatchers(JsonArray? excludeMatchersArray) {
			if (excludeMatchersArray == null) {
				return;
			}
			excludeMatchers = new DirectoryMatchers();
			excludeMatchersArray.forStringEachValue(excludeMatchers.addMatcher);
		}

	    public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
	    	ResourcesDirectoryStructure.libraryResources(directoryBuilder => {
	    		directoryBuilder.accept(new ResourcesDirectoryCopyingVisitor(includeMatchers, excludeMatchers, defaultExclude), true);
    		});

    		ResourcesDirectoryStructure.runtimeResources(directoryBuilder => {
	    		directoryBuilder.accept(new ResourcesDirectoryCopyingVisitor(includeMatchers, excludeMatchers, defaultExclude), true);
    		});
	    }
	}
}