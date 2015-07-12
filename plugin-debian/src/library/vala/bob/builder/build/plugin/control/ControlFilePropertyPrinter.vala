using bob.builder.build.plugin.properties;

namespace bob.builder.build.plugin.control {

	public class ControlFilePropertyPrinter : AbstractPropertyPrinter {

		protected override string formatProperty(string name, string value) {
			return "%s: %s".printf(name, value);
		}
	}
}