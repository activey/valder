using bob.builder.recipe.project;
using bob.builder.json;
using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class BuildConfigurationLibraryUsageBuilder {
		
		public string name {
			get; set;
		}

		public string version {
			get; set;
		}

		public string cHeadersDirectory {
			get; set;
		}

		public string vapiDirectory {
			get; set;
		}

		public void addLibraryUsageCcOptions(BuildConfigurationBuilder buildConfigurationBuilder) {
			buildConfigurationBuilder
				.dependency(dependency => {
					dependency.name = name;
					dependency.version = version;
					dependency.vapiDirectory = vapiDirectory;	
					dependency.cHeadersDirectory = cHeadersDirectory;
				});
		}
	}
}