namespace com.futureprocessing.bob.json
{
public class JsonArray : Object {
   public delegate void EachMemberDelegate(JsonObject jsonObject);


   private Json.Array jsonArray;
   public JsonArray.fromJsonArray(Json.Array jsonArray){
      this.jsonArray = jsonArray;
   }
   public void forEachMember(EachMemberDelegate eachMemberDelegate){
      foreach (Json.Node memberNode in jsonArray.get_elements())
      {
         JsonObject jsonObject = new JsonObject.fromJsonObject(
            memberNode.get_object());
         eachMemberDelegate(jsonObject);
      }
   }              /* forEachMember */
}
}
