namespace bob.builder.ansi {

	public class AnsiPrinterSession : AbstractAnsiPrinterSession {

		private AnsiColorGenerator colorGenerator = new AnsiColorGenerator();
		private string[]  sessionModifiers = {};

		public AnsiPrinterSession () {
			startSession();
		}

		private void startSession() {
			collectModifier("\x1B[0");
		}

		public override void commit(FileStream stream) {
			flush(stream);
			sessionModifiers = {};
		}

		public override void flush(FileStream stream) {
			stream.printf(string.joinv("", sessionModifiers));
			stream.printf("m");
		}

		public override void setColorRed() {
			collectModifier(colorGenerator.getRed());
		}

		public override void setColorGreen() {
			collectModifier(colorGenerator.getGreen());
		}

		public override void setColorBlue() {
			collectModifier(colorGenerator.getBlue());
		}

		public override void setColorYellow() {
			collectModifier(colorGenerator.getYellow());
		}

		public override void setColorDefault() {
			collectModifier(colorGenerator.getDefault());
		}

		public override void setBold(bool bold) {
			if (bold == true) {
				collectModifier(";1");
			} else {
				collectModifier(";22");
			}
		}

		private void collectModifier(string modifier) {
			sessionModifiers += modifier;
		}

		public override void reset(FileStream stream) {
			stream.printf("\x1B[0m");
		}

	}
}
