using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;
using bob.builder.build.plugin.execute;
using Gee;

namespace bob.builder.build.plugin.properties {

	public class PropertiesFileWriter {

		private AbstractPropertyPrinter _propertyPrinter;

		public PropertiesFileWriter(AbstractPropertyPrinter propertyPrinter) {
			_propertyPrinter = propertyPrinter;
		}

		public void write(FileObject output, Properties properties) throws Error {
			FileIOStream stream = output.getStreamOverwrite();
			FileOutputStream outputStream = stream.output_stream as FileOutputStream;

			properties.forEach((name, value) => {
				_propertyPrinter.printProperty(outputStream, name, value);
			});
		}
	}
}