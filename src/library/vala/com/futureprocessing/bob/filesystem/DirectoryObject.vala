namespace com.futureprocessing.bob.filesystem
{
public class DirectoryObject : FileSystemObject {
   private File directory;
   public DirectoryObject(File directory){
      this.directory = directory;
   }

   public DirectoryObject.fromGivenLocation(string directoryLocation){
      this.directory = File.new_for_path(directoryLocation);
   }
   public void accept(FileSystemVisitor visitor){
      try {
         FileEnumerator enumerator = directory.enumerate_children(
            FileAttribute.STANDARD_NAME,
            0);
         FileInfo fileInfo;
         while ((fileInfo = enumerator.next_file()) != null)
         {
            File file = enumerator.get_child(fileInfo);
            if (isDirectory(fileInfo)) {
               new DirectoryObject(file).accept(visitor);
               continue;
            }
            new FileObject(file).accept(visitor);
         }
      }
      catch(Error e){
         stderr.printf(@"An error occurred $(e.message)");
      }
   }              /* accept */

   private bool isDirectory(FileInfo fileInfo){
      return fileInfo.get_file_type() == FileType.DIRECTORY;
   }              /* isDirectory */
}
}
