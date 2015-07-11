using bob.builder.json;
using bob.builder.enums;

namespace bob.builder.recipe.project {

	public enum BobBuildProjectDependencyScope {

		BOTH = 0,
		LIBRARY = 1,
		RUNTIME = 2;

		public static BobBuildProjectDependencyScope fromName(string? name) {
			EnumValue? enumValue = EnumReader.fromName(typeof(BobBuildProjectDependencyScope), name);
			if (enumValue == null) {
				return BobBuildProjectDependencyScope.BOTH;
			}
			return (BobBuildProjectDependencyScope) enumValue.value;
		}

		public string name() {
			return EnumReader.readName(to_string());
		}

		public bool matches(BobBuildProjectDependencyScope otherScope) {
			return this == BobBuildProjectDependencyScope.BOTH || name() == otherScope.name();
		}
	}
}