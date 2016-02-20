using bob.builder.log;
using bob.builder.recipe.project;
using bob.builder.filesystem;

using Vala;

namespace bob.builder.build.plugin {

	public class GIRGenerator {

		public void generateGIRRepositoryFile(CodeContext codeContext, GirConfiguration girConfiguration) {
			string girFileName = "%s-%s.gir".printf(girConfiguration.libraryName, girConfiguration.libraryVersion);
			string girNamespace = girConfiguration.libraryName;

			GIRWriter gir_writer = new GIRWriter();
			gir_writer.write_file(
				codeContext, 
				girConfiguration.outputDirectory, 
				girFileName, 
				girNamespace, 
				girConfiguration.libraryVersion, 
				girConfiguration.libraryName, 
				girConfiguration.libraryName);
		}	
	}
}