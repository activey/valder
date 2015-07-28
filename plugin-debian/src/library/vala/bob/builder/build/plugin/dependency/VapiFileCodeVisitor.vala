using bob.builder.log;
using Vala;

namespace bob.builder.build.plugin.dependency {

	public class VapiFileCodeVisitor : CodeVisitor {

		public delegate void PackageFileDelegate(string packageFile);
		public delegate void CHeaderFileDelegate(CHeader cHeaderFile);

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

		private void visitClass(Class clazz) {
			collectCHeaders(clazz);
			foreach (Constant constant in clazz.get_constants()) {
				collectCHeaders(constant);
			}
			foreach (Enum classEnum in clazz.get_enums()) {
				collectCHeaders(classEnum);
			}
			foreach (Field field in clazz.get_fields()) {
				collectCHeaders(field);
			}
			foreach (Class nestedClass in clazz.get_classes()) {
				visitClass(nestedClass);
			}
		}

		private void visitConstant(Constant constant) {
			collectCHeaders(constant);
		}

		public override void visit_namespace(Namespace namespace) {
			Attribute? attr = namespace.get_attribute(C_CODE_ATTRIBUTE);
			if (attr == null) {
				return;
			}
			_namespaceGirVersion = attr.get_string(C_GIR_VERSION_ATTRIBUTE_NAME, null);

			foreach (Constant constant in namespace.get_constants()) {
				collectCHeaders(constant);
			}
			foreach (Enum namespaceEnum in namespace.get_enums()) {
				collectCHeaders(namespaceEnum);
			}
			foreach (Class clazz in namespace.get_classes()) {
				visitClass(clazz);
			}
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
			foreach (string header in cHeaderPath.split(",", 0)) {
				if (header in _cHeadersPaths) {
					continue;
				}
				_cHeaders += new CHeader(header, _namespaceGirVersion);
				_cHeadersPaths += header;
			}
		}

		public void forEachCHeader(CHeaderFileDelegate cHeaderFileDelegate) {
			foreach (CHeader cHeaderFile in _cHeaders) {
				cHeaderFileDelegate(cHeaderFile);
			}
		}

		public void forEachVapiFile(PackageFileDelegate packageFileDelegate) {
			foreach (string vapiFile in _vapiFilesPaths) {
				packageFileDelegate(vapiFile);
			}
		}
	}
}
		