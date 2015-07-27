using bob.builder.log;
using bob.builder.filesystem;
using bob.builder.build.plugin.execute;

namespace bob.builder.build.plugin.dependency {

    public class LddLibrariesInspector {

        private const string COMMAND_LDD = "ldd";

        public delegate void LddLibraryUsedDelegate(FileObject usedLibraryFile);

        private Logger LOGGER = Logger.getLogger("LddLibrariesInspector");

        public void inspectLibraryDependencies(FileObject libraryFile, LddLibraryUsedDelegate usedLibraryDelegate) {
        	LOGGER.logInfo("Scanning file for dependend libraries: %s.", libraryFile.getLocation());

            new PipedExecutableRunner(COMMAND_LDD, libraryFile.getLocation()).run(output => {
                new PipedExecutableRunner("awk", "{print $3}").runWithInput(output.getStream(), finalOutput => {
                    string[] librariesFiles = finalOutput.getText().split("\n");

                    foreach (string libraryFileLocation in librariesFiles) {
                        if (libraryFileLocation == null || libraryFileLocation.length == 0) {
                            continue;
                        }
                        inspectLibrary(libraryFileLocation, usedLibraryDelegate);
                    }
                });
            });
        }

        private void inspectLibrary(string libraryFileLocation, LddLibraryUsedDelegate usedLibraryDelegate) {
        	FileObject libraryFile = new FileObject.fromLocation(libraryFileLocation);
        	if (!libraryFile.exists()) {
        		LOGGER.logWarn("Unable to locate library file: %s.", libraryFile.getLocation());
        		return;
        	}
        	usedLibraryDelegate(libraryFile);
        }
	}
}