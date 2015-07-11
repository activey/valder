using bob.builder.recipe.project;
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
			_properties.setSection(section);
			return this;
		}

		public ControlFileBuilder optionalPriority() {
			_properties.setPriority(ControlFilePriorityEnum.OPTIONAL);
			return this;
		}

		public ControlFileBuilder architecture(string architecture) {
			_properties.setArchitecture(ControlFileArchitectureEnum.fromName(architecture));
			return this;
		}

		public ControlFileBuilder description(string description) {
			_properties.setDescription(description);
			return this;
		}

		public ControlFileBuilder depends(BobBuildProjectDependency dependency) {

			return this;
		}

		public FileObject build() {
			return new FileObject(File.new_for_path("."));	
		}
	}	
}