using bob.builder.filesystem;

namespace bob.builder.build.plugin.control {

	public class ControlFileBuilder {
		
		private ControlFileProperties _properties;

		private ControlFileBuilder() {
			_properties = new ControlFileProperties();
		}

		public static ControlFileBuilder controlFile() {
			return new ControlFileBuilder();
		}

		public ControlFileBuilder package(string package) {
			_properties.setPackage(package);
			return this;
		}

		public ControlFileBuilder version(string version) {
			_properties.setVersion(version);
			return this;
		}

		public ControlFileBuilder section(string section) {
			_properties.setSection(ControlFileSectionEnum.fromName(section, ControlFileSectionEnum.UNKNOWN));
			return this;
		}

		public ControlFileBuilder optionalPriority() {
			_properties.setPriority(ControlFilePriorityEnum.OPTIONAL);
			return this;
		}

		public ControlFileBuilder architecture(string architecture) {
			_properties.setArchitecture(ControlFileArchitectureEnum.fromName(architecture, ControlFileArchitectureEnum.ANY));
			return this;
		}

		public ControlFileBuilder description(string description) {
			_properties.setDescription(description);
			return this;
		}

		public ControlFileBuilder depends(ControlFileDebianPackage dependsPackage) {
			_properties.addDependency(dependsPackage);
			return this;
		}

		public ControlFileBuilder author(string author) {
			_properties.addAuthor(author);
			return this;
		}

		public void build(FileObject outputControlFile) throws Error {
			_properties.writeToFile(outputControlFile);
		}
	}	
}