using bob.builder.log;
using bob.builder.recipe.project;

using Vala;

namespace bob.builder.build.plugin {

	public class ValaCodeCompilerOutcome {

		public bool binaryGenerated {
			get;
			set;
		}

		public ValaCodeCompilerOutcome.default() {
			binaryGenerated = true;
		}

		public ValaCodeCompilerOutcome.noBinaryGenerated() {
			binaryGenerated = false;
		}
	}

}