using bob.builder.recipe.project;
using bob.builder.json;
using bob.builder.filesystem;

namespace bob.builder.build.plugin {

	public class BuildConfigurationLibraryUsageBuilder {
		
		public string name {
			get; set;
		}

		public string cHeadersDirectory {
			get; set;
		}

		public string vapiFile {
			get; set;
		}

		public void addLibraryUsageCcOptions(BuildConfigurationBuilder buildConfigurationBuilder) {
			buildConfigurationBuilder
				.ccOption("-l%s".printf(name))
				.ccOption("-I%s".printf(cHeadersDirectory));

			if (vapiFile != null) {
				buildConfigurationBuilder.addSourceFromRelativeLocation(vapiFile);
			}
		}
	}
}