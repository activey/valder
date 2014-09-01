using com.futureprocessing.bob;
using com.futureprocessing.bob.log;

namespace com.futureprocessing.bob {
	public class BobBuilder {

		private Logger LOGGER = Logger.getLogger("BobBuilder");

		private BobRecipeProcessor recipeProcessor;

		public void initializeBuildProcessor() {
			this.recipeProcessor = new BobRecipeProcessor();
		}

		public void startBuild() {
			LOGGER.logInfo("Bob is starting his work ...\n");
			LOGGER.logInfo("Looking for bob recipe file ...\n");
            
			FileInfo recipeFile = locateRecipeFile();
			if (recipeFile == null) {
				LOGGER.logError("Unable to locate any any build recipe for Bob, quitting.");
				return;
			}
			processRecipeFile(recipeFile);
		}

		private FileInfo? locateRecipeFile() {
			try {
			    File workDirectory = getBobWorkDirectory();
		        FileEnumerator enumerator = workDirectory.enumerate_children(FileAttribute.STANDARD_NAME, 0);

		        FileInfo fileInfo;
		        while ((fileInfo = enumerator.next_file()) != null) {
		        	if (isBobRecipeFile(fileInfo)) {
		        		return fileInfo;
		        	}
		        }
		    } catch (Error e) {
		    	LOGGER.logError("An exception occurred while loading json file: ", e.message);
		    }
		    return null;
		}

		private File getBobWorkDirectory() {
			return File.new_for_path(".");
		}

		private void processRecipeFile(FileInfo recipeFile) {
			try {
				recipeProcessor.processRecipe(recipeFile);
				LOGGER.logSuccess("Bob has finished his work. It's better to do one job well, than to do two jobs not so well.\n");
			} catch (Error e) {
				LOGGER.logError("Bob failed at building: %s", e.message);
			}
		}

		private bool isBobRecipeFile(FileInfo fileInfo) {
			return fileInfo.get_name() == "receipe.bob";
		}
	}
}

public static void main(string[] args) {
	var builder = new BobBuilder();
	builder.initializeBuildProcessor();
	builder.startBuild();
}