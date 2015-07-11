using bob.builder.enums;

namespace bob.builder.build.plugin.control {
	
	public enum ControlFileSectionEnum {

		UNKNOWN,
		ADMIN,
		CLI_MONO,
		COMM,
		DATABASE,
		DEBIAN_INSTALLER,
		DEBUG,
		DEVEL,
		DOC,
		EDITORS,
		ELECTRONICS,
		EMBEDDED,
		FONTS,
		GAMES,
		GNOME,
		GNU_R,
		GNUSTEP,
		GRAPHICS,
		HAMRADIO,
		HASKELL,
		HTTPD,
		INTERPRETERS,
		JAVA,
		KDE,
		KERNEL,
		LIBDEVEL,
		LIBS,
		LISP,
		LOCALIZATION,
		MAIL,
		MATH,
		MISC,
		NET,
		NEWS,
		OCAML,
		OLDLIBS,
		OTHEROSFS,
		PERL,
		PHP,
		PYTHON,
		RUBY,
		SCIENCE,
		SHELLS,
		SOUND,
		TEX,
		TEXT,
		TRANSLATIONS,
		UTILS,
		VCS,
		VIDEO,
		VIRTUAL,
		WEB,
		X11,
		XFCE,
		ZOPE;

		public string name() {
			return EnumReader.readName(to_string());
		}

		public ControlFileArchitectureEnum? fromName(string? name) {
			EnumValue? enumValue = EnumReader.fromName(typeof(ControlFileArchitectureEnum), name);
			if (enumValue == null) {
				return null;
			}
			return (ControlFileArchitectureEnum) enumValue.value;
		}
	}
}