namespace bob.builder.json {

	public class JsonArray : Object {

		public delegate void EachMemberDelegate(JsonObject jsonObject);

		private Json.Array jsonArray;

		public JsonArray() {
			jsonArray = new Json.Array();
		}

		public JsonArray.fromJsonArray(Json.Array jsonArray) {
			this.jsonArray = jsonArray;
		}

		public void addToParent(string key, JsonObject parent) {
			parent.addObjectArrayEntry(key, jsonArray);
		}

		public void addEntry(Json.Object entry) {
			jsonArray.add_object_element(entry);
		}

		public void forEachMember(EachMemberDelegate eachMemberDelegate) {
			foreach (Json.Node memberNode in jsonArray.get_elements()) {
				JsonObject jsonObject = new JsonObject.fromJsonObject(memberNode.get_object());
				eachMemberDelegate(jsonObject);
			}
		} 
	}
}
