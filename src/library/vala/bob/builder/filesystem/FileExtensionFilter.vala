namespace bob.builder.filesystem {

	public class FileExtensionFilter : FileFilter, Object {

		private string fileExtension;

		public FileExtensionFilter(string fileExtension) {
			this.fileExtension = fileExtension;
		}

        public bool fileMatchesCriteria(File file) {
            return file.get_basename().has_suffix(fileExtension);
        }
	}
}