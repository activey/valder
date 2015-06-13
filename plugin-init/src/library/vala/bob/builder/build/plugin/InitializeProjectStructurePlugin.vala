using bob.builder.build;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public class InitializeProjectStructurePlugin : AbstractBobBuildPlugin {

        const string PLUGIN_NAME = "initialize";
        const string RECIPE_ENTRY_VERBOSE = "verbose";

        private Logger LOGGER = Logger.getLogger("InitializeProjectStructurePlugin");

        private bool verbose = false; 

        public InitializeProjectStructurePlugin() {
        	base(PLUGIN_NAME);
        }

		public override void initialize(BobBuildPluginRecipe pluginRecipe) throws BobBuildPluginError {
			verbose = pluginRecipe.jsonConfiguration.getBooleanEntry(RECIPE_ENTRY_VERBOSE, false);
		}

	    public override void run(BobBuildProjectRecipe projectRecipe, DirectoryObject projectDirectory) throws BobBuildPluginError {
	    	ProjectDirectoryStructureBuilder
	    		.projectDirectory(projectDirectory)
	    		.directory(src => {
	    			src.name("src");

    				src.directory(library => {
    					library.name("library");
    					
    					library.directory(vala => vala.name("vala"));
    					library.directory(vapi => vapi.name("vapi"));
    					library.directory(vapi => vapi.name("c"));	
					});

	    			src.directory(main => {
	    				main.name("main");

	    				main.directory(vala => vala.name("vala"));
    				});
    			});
	    }
	}
}