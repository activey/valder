using bob.builder.filesystem;
using bob.builder.build.plugin.properties;

namespace bob.builder.build.plugin.control {

	public class ControlFileProperties {

		private string[] _dependsPackages = new string[0];
		private string[] _uploaders = new string[0];
		private string _maintainer;

		private Properties _controlProperties = new Properties();

		public void setPackage(string package) { 
			_controlProperties.setProperty("Package", package);
		}

		public void setVersion(string version) {
			_controlProperties.setProperty("Version", version);
		}

		public void setSection(ControlFileSectionEnum section) {
			_controlProperties.setProperty("Section", section.name());
		}

		public void setPriority(ControlFilePriorityEnum priority) {
			_controlProperties.setProperty("Priority", priority.name());
		}

		public void setArchitecture(ControlFileArchitectureEnum architecture) {
			_controlProperties.setProperty("Architecture", architecture.name());
		}

		public void setDescription(string description) {
			_controlProperties.setProperty("Description", description);
		}

		public void addDependency(ControlFileDebianPackage dependency) {
			// TODO: check if already on list
			_dependsPackages += dependency.to_string();
		}

		public void addAuthor(string author) {
			if (_maintainer == null) {
				_maintainer = author;
				return;
			}
			_uploaders += author;
		}

		public void writeToFile(FileObject outputFile) throws Error {
			if (_maintainer != null) {
				_controlProperties.setProperty("Maintainer", _maintainer);
			}
			if (_uploaders.length > 0) {
				_controlProperties.setProperty("Uploaders", string.joinv(", ", _uploaders));
			}
			if (_dependsPackages.length > 0) {
				_controlProperties.setProperty("Depends", string.joinv(", ", _dependsPackages));
			}
			_controlProperties.writeToFile(outputFile, new ControlFilePropertyPrinter());
		}
	}
}