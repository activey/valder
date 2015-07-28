using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.execute;
using Gee;

namespace bob.builder.build.plugin.properties {

	public class Properties {

		public delegate void ForEachPropertyDelegate(string name, string value);

		private Map<string, string> _properties = new HashMap<string, string>();
	
		public void setProperty(string name, string value) {
			_properties.set(name, value);
		}

		public string? getProperty(string name, string? defaultIfNull) {
			if (!_properties.has_key(name)) {
				return defaultIfNull;
			}
			return _properties.get(name);
		}

		public void forEach(ForEachPropertyDelegate propertyDelegate) {
			foreach (string key in _properties.keys) {
				propertyDelegate(key, getProperty(key, null));
			}
		}

		public void writeToFile(FileObject outputFile, AbstractPropertyPrinter propertyPrinter) throws Error {
			PropertiesFileWriter writer = new PropertiesFileWriter(propertyPrinter);
			writer.write(outputFile, this);
		}
	}
}