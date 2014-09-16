namespace com.futureprocessing.bob.ansi {

	public class AnsiPrinterSession {

    	private AnsiColorGenerator colorGenerator = new AnsiColorGenerator();
		private string[] sessionModifiers = {};

		public AnsiPrinterSession() {
			startSession();
		}

		private void startSession() {
			collectModifier("\x1B[0");
		}

		public void commit(FileStream stream) {
			flush(stream);
			sessionModifiers = {};
		}
		
		public void flush(FileStream stream) {
		    stream.printf(string.joinv("", sessionModifiers));
			stream.printf("m");
		}

		public void setColorRed() {
			collectModifier(colorGenerator.getRed());
		}

		public void setColorGreen() {
			collectModifier(colorGenerator.getGreen());
		}
		
		public void setColorBlue() {
			collectModifier(colorGenerator.getBlue());
		}
		
		public void setColorDefault() {
			collectModifier(colorGenerator.getDefault());
		}

		public void setBold(bool bold) {
			if (bold == true) {
				collectModifier(";1");
			} else {
				collectModifier(";22");
			}
		}

		private void collectModifier(string modifier) {
			sessionModifiers += modifier;
		}

		public void reset(FileStream stream) {
			stream.printf("\x1B[0m");
		}

	}
}