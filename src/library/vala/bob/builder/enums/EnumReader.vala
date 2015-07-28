namespace bob.builder.enums {
	
	public class EnumReader {
	
		private static EnumClass? enumClass(Type type) {
			if (!type.is_enum()) {
				return null;
			}
			return (EnumClass) type.class_ref();
		}

		public static string? readName(string fullEnumName) {
			int lastUnderscorePosition = fullEnumName.last_index_of("_", 0) + 1;
			return fullEnumName.substring(lastUnderscorePosition, fullEnumName.length - lastUnderscorePosition).down();
		}

		public static EnumValue? fromName(Type type, string? name) {
			if (name == null) {
				return null;
			}
			EnumClass? enumClass = enumClass(type);
			if (enumClass == null) {
				return null;
			}
			return enumClass.get_value_by_nick(name.down());
		}
	}
}