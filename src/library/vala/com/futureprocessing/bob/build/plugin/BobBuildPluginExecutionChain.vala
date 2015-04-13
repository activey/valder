using com.futureprocessing.bob.log;
using com.futureprocessing.bob.recipe.plugin;
using com.futureprocessing.bob.recipe.project;
namespace com.futureprocessing.bob.build.plugin
{
public class BobBuildPluginExecutionChain {
   public delegate void PluginToRunDelegate(
      AbstractBobBuildPlugin pluginToRun);


   private Logger               LOGGER = Logger.getLogger(
      "BobBuildPluginExecutionChain");
   private BobBuildPluginLoader PLUGIN_LOADER = new BobBuildPluginLoader();
   private List<string>         pluginsToRun  = new List<string>();
   public void addPlugin(string pluginToRun){
      LOGGER.logInfo("Using build plugin: %s.", pluginToRun);
      pluginsToRun.append(pluginToRun);
   }              /* addPlugin */

   public void preparePlugins(PluginToRunDelegate pluginToRunDelegate)
   throws
   BobBuildPluginError {
      foreach (string pluginToRun in pluginsToRun)
      {
         preparePlugin(pluginToRun, pluginToRunDelegate);
      }
   }              /* preparePlugins */

   private void preparePlugin(string              pluginName,
                              PluginToRunDelegate pluginToRunDelegate)
   throws
   BobBuildPluginError {
      if (!isPluginToRun(pluginName)) {
         return;
      }

      AbstractBobBuildPlugin instantiatedPlugin = getPlugin(pluginName);

      if (instantiatedPlugin == null) {
         LOGGER.logError(
            "Unable to find plugin: %s. Skipping plugin preparation.",
            pluginName);
         return;
      }

      LOGGER.logInfo("Initializing plugin '%s' with recipe data.",
                     pluginName);
      pluginToRunDelegate(instantiatedPlugin);
   }              /* preparePlugin */

   private AbstractBobBuildPlugin ? getPlugin(string pluginName){
      return PLUGIN_LOADER.getPlugin(pluginName);
   }
   public void runPlugins(BobBuildProjectRecipe projectRecipe) throws
   BobBuildPluginError {
      foreach (string pluginToRun in pluginsToRun)
      {
         runPlugin(pluginToRun, projectRecipe);
      }
   }              /* runPlugins */

   private void runPlugin(string                pluginName,
                          BobBuildProjectRecipe projectRecipe) throws
   BobBuildPluginError {
      if (!isPluginToRun(pluginName)) {
         return;
      }

      AbstractBobBuildPlugin instantiatedPlugin = getPlugin(pluginName);

      if (instantiatedPlugin == null) {
         LOGGER.logError(
            "Unable to find plugin: %s. Skipping plugin execution.",
            pluginName);
         return;
      }

      LOGGER.logInfo("Running plugin: %s", pluginName);
      instantiatedPlugin.run(projectRecipe);
   }              /* runPlugin */

   private bool isPluginToRun(string pluginName){
      foreach (string pluginToRun in pluginsToRun)
      {
         if (pluginName == pluginToRun) {
            return true;
         }
      }

      return false;
   }              /* isPluginToRun */
}
}
