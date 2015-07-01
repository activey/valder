using bob.builder.json;

namespace bob.builder.recipe.project {

	public enum BobBuildProjectDependencyScope {


		LIBRARY,
		RUNTIME,
		BOTH;

		public static BobBuildProjectDependencyScope[] values() {
			return {LIBRARY, RUNTIME, BOTH};
		}

		public static BobBuildProjectDependencyScope fromName(string? name) {
			if (name == null) {
				return BobBuildProjectDependencyScope.BOTH;
			}
			foreach (BobBuildProjectDependencyScope scope in BobBuildProjectDependencyScope.values()) {
				if (scope.name() == name.down()) {
					return scope;
				}
			}
			return BobBuildProjectDependencyScope.BOTH;
		}

		public string name() {
			string stringValue = to_string();
			int lastUnderscorePosition = stringValue.last_index_of("_", 0) + 1;
			return stringValue.substring(lastUnderscorePosition, stringValue.length - lastUnderscorePosition).down();
		}

		public bool matches(BobBuildProjectDependencyScope otherScope) {
			return this == BobBuildProjectDependencyScope.BOTH || name() == otherScope.name();
		}
	}
}