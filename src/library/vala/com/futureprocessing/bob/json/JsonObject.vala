namespace com.futureprocessing.bob.json
{
public class JsonObject : Object {
   private Json.Object jsonObject;
   public JsonObject(){
      this.jsonObject = new Json.Object();
   }

   public JsonObject.fromJsonObject(Json.Object jsonObject){
      this.jsonObject = jsonObject;
   }
   public string getStringEntry(string key, string ? defaultIfNull){
      if (keyMissingOrNull(key)) {
         return defaultIfNull;
      }
      return jsonObject.get_string_member(key);
   }              /* getStringEntry */

   public bool getBooleanEntry(string key, bool defaultIfNull){
      if (keyMissingOrNull(key)) {
         return defaultIfNull;
      }
      return jsonObject.get_boolean_member(key);
   }              /* getBooleanEntry */

   public JsonObject ? getJsonObjectEntry(string key){
      if (keyMissingOrNull(key)) {
         return null;
      }
      return new JsonObject.fromJsonObject(jsonObject.get_object_member(
                                              key));
   }
   public JsonArray ? getObjectArrayEntry(string key){
      if (keyMissingOrNull(key)) {
         return null;
      }
      return new JsonArray.fromJsonArray(jsonObject.get_array_member(key));
   }
   private bool keyMissingOrNull(string key){
      return !jsonObject.has_member(key) ||
             jsonObject.get_null_member(key);
   }              /* keyMissingOrNull */
}
}
