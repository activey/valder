using com.futureprocessing.bob.recipe.project;
using com.futureprocessing.bob.recipe.plugin;
namespace com.futureprocessing.bob.recipe
{
public class BobBuildRecipeBuilder : Object {
   private List<BobBuildPluginRecipe> plugins;
   private BobBuildProjectRecipe      projectRecipe;
   public BobBuildRecipeBuilder plugin(BobBuildPluginRecipe pluginRecipe){
      if (plugins == null) {
         plugins = new List<BobBuildPluginRecipe>();
      }
      plugins.append(pluginRecipe);
      return this;
   }              /* plugin */

   public BobBuildRecipeBuilder project(string name,
                                        string shortName,
                                        string version){
      projectRecipe           = new BobBuildProjectRecipe();
      projectRecipe.name      = name;
      projectRecipe.shortName = shortName;
      projectRecipe.version   = version;
      return this;
   }              /* project */

   public BobBuildRecipe build(){
      BobBuildRecipe buildRecipe = new BobBuildRecipe();

      buildRecipe.project = projectRecipe;
      foreach (BobBuildPluginRecipe plugin in plugins)
      {
         buildRecipe.addPluginRecipe(plugin);
      }
      return buildRecipe;
   }              /* build */
}
}
