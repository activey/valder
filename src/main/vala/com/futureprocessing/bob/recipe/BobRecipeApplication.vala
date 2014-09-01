using com.futureprocessing.bob;

namespace com.futureprocessing.bob.recipe {
	public class BobRecipeApplication {

		public static BobRecipeApplication fromJSONObject(Json.Object jsonObject) {
			BobRecipeApplication bobRecipeApplication = new BobRecipeApplication();
			bobRecipeApplication.name = jsonObject.get_string_member("name");

			Json.Object desktopObject = jsonObject.get_member("desktop").get_object();
			bobRecipeApplication.generateDesktopEntry = desktopObject.get_boolean_member("generate");
			bobRecipeApplication.icon = desktopObject.get_string_member("icon");

			return bobRecipeApplication;
		}

		public string name { get; set; }

		public bool generateDesktopEntry { get; set; }

		public string icon { get; set; }
	}	
}