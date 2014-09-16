using com.futureprocessing.bob.ansi;

namespace com.futureprocessing.bob.log {
	public class Logger {

		private AnsiPrinter ansiPrinter;
		private string loggerId;

		private Logger(string loggerId) {
			this.loggerId = loggerId;
			this.ansiPrinter = new AnsiPrinter();
		}

		public static Logger getLogger(string loggerId) {
			return new Logger(loggerId);
		}

		public void logError(string message, ...) {
			AnsiPrinterSession printerSession = ansiPrinter.startSession();
    		printLoggerId(printerSession, stderr);
			
			printerSession.setBold(true);
			printerSession.setColorRed();
			printerSession.commit(stderr);
			stderr.vprintf(message, va_list());
			printerSession.reset(stderr);

			stderr.printf(" ;( but ... Can we fix it? ");

			printerSession = ansiPrinter.startSession();
			printerSession.setBold(true);
			printerSession.commit(stderr);
			stderr.printf("Yes we can!\n");
			printerSession.reset(stderr);
		}

		public void logInfo(string message, ...) {
			AnsiPrinterSession printerSession = ansiPrinter.startSession();
			printLoggerId(printerSession, stdout);
		    
		    printerSession.setColorDefault();
			printerSession.commit(stdout);
			stdout.vprintf(message, va_list());
			
			printerSession.reset(stdout);
		}
		
		public void logSuccess(string message, ...) {
			AnsiPrinterSession printerSession = ansiPrinter.startSession();
			printLoggerId(printerSession, stdout);
			
			printerSession.setBold(true);
			printerSession.setColorGreen();
			printerSession.commit(stdout);
			stdout.vprintf(message, va_list());
			
			printerSession.reset(stdout);
		}
		
		private void printLoggerId(AnsiPrinterSession printerSession, FileStream stream) {
		    printerSession.setColorBlue();
			printerSession.flush(stream);			
			stream.printf("[%s] ", loggerId);
			printerSession.reset(stream);
		}
	}
}