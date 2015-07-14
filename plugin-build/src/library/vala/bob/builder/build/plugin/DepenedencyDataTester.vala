using Vala;

namespace bob.builder.build.plugin {

	public class DepenedencyDataTester : CodeVisitor {

		private string _package;
		private string _vapiFilePath;

		private string[] _cHeaders = new string[0];

		public DepenedencyDataTester(string package, string vapiFilePath) {
			_package = package;
			_vapiFilePath = vapiFilePath;
		}

		public void test() {
			CodeContext codeContext = new CodeContext();
            CodeContext.push(codeContext);
			codeContext.add_external_package(_package);             
			new Parser().parse(codeContext);
			codeContext.accept(this);

            CodeContext.pop();
		}

		public override void visit_source_file(SourceFile sourceFile) {
			if (!sourceFile.filename.has_suffix(".vapi")) {
				return;
			}
			stdout.printf("------ VAPI File> %s \n", sourceFile.filename);
			sourceFile.accept_children(this);
		}

		public override void visit_class(Class clazz) {
			Attribute? attr = clazz.get_attribute("CCode");
			if (attr != null) {
				addCHeader(attr.get_string("cheader_filename", "-"));
			}
		}

		private void addCHeader(string cHeaderPath) {
			if (cHeaderPath in _cHeaders) {
				return;
			}
			stdout.printf("------ C Header> %s \n", cHeaderPath);
			_cHeaders += cHeaderPath;
		}
	}

}