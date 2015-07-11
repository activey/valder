using bob.builder.enums;

namespace bob.builder.build.plugin.control {
	
	public enum ControlFilePriorityEnum {

		OPTIONAL,
		REQUIRED,
		IMPORTANT,
		STANDARD,
		EXTRA;

		public string name() {
			return EnumReader.readName(to_string());
		}

		public ControlFilePriorityEnum? fromName(string? name) {
			EnumValue? enumValue = EnumReader.fromName(typeof(ControlFilePriorityEnum), name);
			if (enumValue == null) {
				return null;
			}
			return (ControlFilePriorityEnum) enumValue.value;
		}
	}
}