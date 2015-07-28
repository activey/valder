using bob.builder.log;

namespace bob.builder.build.plugin.properties {

	public abstract class AbstractPropertyPrinter {

        private Logger LOGGER = Logger.getLogger("AbstractPropertyPrinter");

		public size_t printProperty(OutputStream stream, string name, string value) {
			size_t printedSize;
			string propertyLine = "%s\n".printf(formatProperty(name, value));
			try {
				stream.write_all(propertyLine.data, out printedSize);
			} catch (Error e) {
				LOGGER.logError("An error occurred while writing property line: %s.", e.message);
			}
			return printedSize;
		}

		protected abstract string formatProperty(string name, string value);
	}

}