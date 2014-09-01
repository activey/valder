using com.futureprocessing.bob.filesystem;

namespace com.futureprocessing.bob {
	public class BobBuildSourceFilter : FileFilter, Object {

        public bool fileMatchesCriteria(File file) {
            return file.get_basename().has_suffix(".vala");
        }
	}
}