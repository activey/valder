using com.futureprocessing.bob.log;
using com.futureprocessing.bob;
using com.futureprocessing.bob.recipe;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.build.plugin;
namespace com.futureprocessing.bob.build
{
public class BobBuildContext : Object {
   private Logger                       LOGGER =
      Logger.getLogger("BobBuildContext");
   private BobBuildRecipe               buildRecipe;
   private BobBuildPluginExecutionChain pluginChain;
   public BobBuildContext(){
      this.buildRecipe = new BobBuildRecipe();
      initializePluginChain();
   }

   public BobBuildContext.withRecipe(BobBuildRecipe buildRecipe){
      this.buildRecipe = buildRecipe;
      initializePluginChain();
   }
   private void initializePluginChain(){
      pluginChain = new BobBuildPluginExecutionChain();
   }              /* initializePluginChain */

   public void addPlugin(string buildPlugin){
      pluginChain.addPlugin(buildPlugin);
   }              /* addPlugin */

   public void proceed(){
      printRecipeSummary();
      try {
         prepareProjectPlugins();
         runProjectPlugins();
      }
      catch(Error e){
         LOGGER.logError(
            "Build process failed because of unforseen problem: %s.",
            e.message);
      }
   }              /* proceed */

   private void printRecipeSummary(){
      LOGGER.logInfo("Building project: %s-%s (%s)",
                     buildRecipe.project.shortName,
                     buildRecipe.project.version,
                     buildRecipe.project.name);
   }              /* printRecipeSummary */

   private void prepareProjectPlugins() throws BobBuildPluginError {
      LOGGER.logInfo("Loading project plugins recipies...");
      pluginChain.preparePlugins((pluginToRun) => {
                                    BobBuildPluginRecipe ? pluginRecipe = buildRecipe.getPluginRecipe(
                                       pluginToRun.name);
                                    if (pluginRecipe == null) {
                                       pluginRecipe = new BobBuildPluginRecipe.default ();
                                    }
                                    pluginToRun.initialize(pluginRecipe);
                                 }
                                 );
   }              /* prepareProjectPlugins */

   private void runProjectPlugins() throws BobBuildPluginError {
      LOGGER.logInfo("Running project plugins");
      pluginChain.runPlugins(buildRecipe.project);
   }              /* runProjectPlugins */
}
}
