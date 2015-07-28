namespace bob.builder.ansi {

	public class AnsiPrinter {
		public AbstractAnsiPrinterSession startSession() {
			if (areColorsOff()) {
				return new PlainAnsiPrinterSession();
			}
			return new AnsiPrinterSession();
		} 

		private bool areColorsOff() {
			return Environment.get_variable("ANSI_COLORS") == "off";
		}
	}
}
