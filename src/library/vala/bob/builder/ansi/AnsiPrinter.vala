namespace bob.builder.ansi {

	public class AnsiPrinter {
		public AnsiPrinterSession startSession() {
			return new AnsiPrinterSession();
		} 
	}
}
