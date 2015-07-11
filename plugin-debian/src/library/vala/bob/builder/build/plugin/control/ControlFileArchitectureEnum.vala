using bob.builder.enums;

namespace bob.builder.build.plugin.control {
	
	public enum ControlFileArchitectureEnum {

		ANY,
		ALL,
		ALPHA,
		AMD64,
		ARM64,
		ARMEL,
		ARMHF,
		HPPA,
		HURD_I386,
		I386,
		KFREEBSD_AMD64,
		KFREEBSD_I386,
		M68K,
		MIPS,
		MIPSEL,
		POWERPC,
		POWERPCSPE,
		PPC64,
		PPC64EL,
		S390X,
		SH4,
		SPARC,
		SPARC64,
		X32;

		public string name() {
			return EnumReader.readName(to_string());
		}

		public static ControlFileArchitectureEnum? fromName(string? name) {
			EnumValue? enumValue = EnumReader.fromName(typeof(ControlFileArchitectureEnum), name);
			if (enumValue == null) {
				return null;
			}
			return (ControlFileArchitectureEnum) enumValue.value;
		}
	}
}