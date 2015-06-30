using bob.builder.build;
using bob.builder.recipe;
using bob.builder.recipe.plugin;
using bob.builder.recipe.project;
using bob.builder.filesystem;
using bob.builder.log;

namespace bob.builder.build.plugin {

	public interface RepositoryDirectories {

		public const string DIRECTORY_REPOSITORY_NAME = ".bob";
	}
}