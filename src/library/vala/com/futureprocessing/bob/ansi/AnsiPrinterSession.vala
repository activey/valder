namespace com.futureprocessing.bob.ansi
{
public class AnsiPrinterSession {
   private AnsiColorGenerator colorGenerator   = new AnsiColorGenerator();
   private string[]           sessionModifiers = {};
   public AnsiPrinterSession(){
      startSession();
   }

   private void startSession(){
      collectModifier("\x1B[0");
   }              /* startSession */

   public void commit(FileStream stream){
      flush(stream);
      sessionModifiers = {};
   }              /* commit */

   public void flush(FileStream stream){
      stream.printf(string.joinv("", sessionModifiers));
      stream.printf("m");
   }              /* flush */

   public void setColorRed(){
      collectModifier(colorGenerator.getRed());
   }              /* setColorRed */

   public void setColorGreen(){
      collectModifier(colorGenerator.getGreen());
   }              /* setColorGreen */

   public void setColorBlue(){
      collectModifier(colorGenerator.getBlue());
   }              /* setColorBlue */

   public void setColorDefault(){
      collectModifier(colorGenerator.getDefault());
   }              /* setColorDefault */

   public void setBold(bool bold){
      if (bold == true) {
         collectModifier(";1");
      }else {
         collectModifier(";22");
      }
   }              /* setBold */

   private void collectModifier(string modifier){
      sessionModifiers += modifier;
   }              /* collectModifier */

   public void reset(FileStream stream){
      stream.printf("\x1B[0m");
   }              /* reset */
}
}
