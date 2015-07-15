namespace bob.builder.ansi {

	public abstract class AbstractAnsiPrinterSession {

		public virtual void commit(FileStream stream) {}

		public virtual void flush(FileStream stream) {}

		public virtual void setColorRed() {}

		public virtual void setColorGreen() {}

		public virtual void setColorBlue() {}

		public virtual void setColorYellow() {}

		public virtual void setColorDefault() {}

		public virtual void setBold(bool bold) {}

		public virtual void reset(FileStream stream) {}
	}
}
