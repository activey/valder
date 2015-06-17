using bob.builder.filesystem.visitor;

namespace bob.builder.build.plugin {

	public class BobBuildPluginVisitor : FileSystemFilteringVisitor {

		public delegate void LoadPluginLibraryFromFile(File pluginLibraryFile);

		private unowned LoadPluginLibraryFromFile _pluginLoader;

		public BobBuildPluginVisitor(LoadPluginLibraryFromFile pluginLoader) {
			base(new LibraryFileFilter());
			_pluginLoader = pluginLoader;
		}

		public override void visitFileFiltered(File file) {
			_pluginLoader(file);
        }
	}
}