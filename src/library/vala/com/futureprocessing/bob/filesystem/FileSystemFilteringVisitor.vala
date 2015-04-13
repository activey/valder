namespace com.futureprocessing.bob.filesystem
{
public abstract class FileSystemFilteringVisitor : FileSystemVisitor {
   private FileFilter filter;
   public FileSystemFilteringVisitor(FileFilter filter){
      this.filter = filter;
   }

   protected abstract void visitFileFiltered(File file);


   public void visitFile(File file){
      if (filter.fileMatchesCriteria(file)) {
         visitFileFiltered(file);
      }
   }              /* visitFile */
}
}
