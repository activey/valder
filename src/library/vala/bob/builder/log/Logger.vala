using bob.builder.ansi;

namespace bob.builder.log {
	
	public class Logger {
	
		private AnsiPrinter ansiPrinter;
		private string loggerId;
		
		private Logger (string loggerId) {
			this.loggerId    = loggerId;
			this.ansiPrinter = new AnsiPrinter();
		}

		public static Logger getLogger(string loggerId) {
			return new Logger(loggerId);
		}

		public void logError(string message, ...) {
			AbstractAnsiPrinterSession printerSession = ansiPrinter.startSession();

			printLoggerId(printerSession, stderr);
			printerSession.setBold(true);
			printerSession.setColorRed();
			printerSession.commit(stderr);
			stderr.vprintf(message, va_list());
			stderr.printf("\n");
			printerSession.reset(stderr);
		}

		public void logWarn(string message, ...) {
			AbstractAnsiPrinterSession printerSession = ansiPrinter.startSession();

			printLoggerId(printerSession, stderr);
			printerSession.setBold(false);
			printerSession.setColorYellow();
			printerSession.commit(stderr);
			stderr.vprintf(message, va_list());
			stderr.printf("\n");
			printerSession.reset(stderr);
		}

		public void logInfo(string message, ...) {
			AbstractAnsiPrinterSession printerSession = ansiPrinter.startSession();

			printLoggerId(printerSession, stdout);
			printerSession.setColorDefault();
			printerSession.commit(stdout);
			stdout.vprintf(message, va_list());
			stdout.printf("\n");
			printerSession.reset(stdout);
		}

		public void logSuccess(string message, ...) {
			AbstractAnsiPrinterSession printerSession = ansiPrinter.startSession();

			printLoggerId(printerSession, stdout);
			printerSession.setBold(true);
			printerSession.setColorGreen();
			printerSession.commit(stdout);
			stdout.vprintf(message, va_list());
			stdout.printf("\n");
			printerSession.reset(stdout);
		}

		private void printLoggerId(AbstractAnsiPrinterSession printerSession,
		                           FileStream stream) {
			printerSession.setColorBlue();
			printerSession.flush(stream);
			stream.printf("[%s] ", loggerId);
			printerSession.reset(stream);
		}
	}
}
