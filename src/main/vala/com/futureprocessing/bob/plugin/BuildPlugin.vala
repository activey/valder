namespace com.futureprocessing.bob.plugin {
	
	public interface BuildPlugin {
	    public abstract void initializeFromJSON(Json.Object jsonProperties);
	}
}
