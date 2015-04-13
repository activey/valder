using com.futureprocessing.bob.json;
namespace com.futureprocessing.bob.recipe.plugin
{
public class BobBuildPluginRecipe : Object {
   private const string NAME_DEFAULT = "app";
   public string        name {
      get;
      set construct;
   }
   public JsonObject jsonConfiguration {
      get;
      set construct;
   }
   public BobBuildPluginRecipe(string name, JsonObject jsonConfiguration){
      Object(name: name, jsonConfiguration: jsonConfiguration);
   }

   public BobBuildPluginRecipe.default (){
      this(NAME_DEFAULT, new JsonObject());
   }
}
}
