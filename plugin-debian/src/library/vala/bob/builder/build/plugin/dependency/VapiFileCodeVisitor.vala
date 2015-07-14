using bob.builder.log;
using Vala;

namespace bob.builder.build.plugin.dependency {

	public class VapiFileCodeVisitor : CodeVisitor {

		public delegate void PackageFileDelegate(string packageFile);

		private const string FILE_VAPI_EXTENSION = ".vapi";
		private const string C_CODE_ATTRIBUTE = "CCode";
		private const string C_HEADER_ATTRIBUTE_NAME = "cheader_filename";
		private const string C_GIR_VERSION_ATTRIBUTE_NAME = "gir_version";

		private string[] _cHeadersPaths = new string[0];
		private string[] _vapiFilesPaths = new string[0];
		private CHeader[] _cHeaders = new CHeader[0];
		private string _namespaceGirVersion;

		public override void visit_source_file(SourceFile sourceFile) {
			if (!sourceFile.filename.has_suffix(FILE_VAPI_EXTENSION)) {
				return;
			}
			addValaFile(sourceFile.filename);
			sourceFile.accept_children(this);
		}

		private void addValaFile(string valaFilePath) {
			if (valaFilePath in _vapiFilesPaths) {
				return;
			}
			_vapiFilesPaths += valaFilePath;
		}

		public override void visit_class(Class clazz) {
			collectCHeaders(clazz);
		}

		public override void visit_namespace(Namespace namespace) {
			Attribute? attr = namespace.get_attribute(C_CODE_ATTRIBUTE);
			if (attr == null) {
				return;
			}
			_namespaceGirVersion = attr.get_string(C_GIR_VERSION_ATTRIBUTE_NAME, null);
		}

		public override void visit_constant(Constant constant) {
			collectCHeaders(constant);
		}

		public override void visit_enum(Enum enumeration) {
			collectCHeaders(enumeration);
		}

		public override void visit_field(Field field) {
			collectCHeaders(field);
		}

		private void collectCHeaders(CodeNode codeNode) {
			Attribute? attr = codeNode.get_attribute(C_CODE_ATTRIBUTE);
			if (attr == null) {
				return;
			}
			addCHeader(attr.get_string(C_HEADER_ATTRIBUTE_NAME, null));
		}

		private void addCHeader(string? cHeaderPath) {
			if (cHeaderPath == null) {
				return;
			}
			if (cHeaderPath in _cHeadersPaths) {
				return;
			}
			_cHeadersPaths += cHeaderPath;
			_cHeaders += new CHeader(cHeaderPath, _namespaceGirVersion);
		}

		public void forEachCHeader(PackageFileDelegate packageFileDelegate) {
			foreach (CHeader cHeaderFile in _cHeaders) {
				packageFileDelegate(cHeaderFile.getVersionedFileName());
			}
		}

		public void forEachVapiFile(PackageFileDelegate packageFileDelegate) {
			foreach (string vapiFile in _vapiFilesPaths) {
				packageFileDelegate(vapiFile);
			}
		}
	}
}
		