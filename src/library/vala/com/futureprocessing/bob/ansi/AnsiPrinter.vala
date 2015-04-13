namespace com.futureprocessing.bob.ansi
{
public class AnsiPrinter {
   public AnsiPrinterSession startSession(){
      return new AnsiPrinterSession();
   }              /* startSession */
}
}
