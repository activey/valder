namespace com.futureprocessing.bob.recipe.plugin {
	
	public class BobBuildPluginConfiguration : Object {
		
		public BobBuildPluginConfiguration(string name) {
			Object(name: name);
		}

		public string name { get; set construct; }
	}
}