public class BobBuildPluginInfo : Object {
	public Module module;
	public Type type;

	public BobBuildPluginInfo(Type type, owned Module module) {
		this.module = (owned) module;
		this.type = type;
	}
}