using bob.builder.log;
using bob.builder.recipe.project;

using Vala;

namespace bob.builder.build.plugin {

    public errordomain CompilationError {
        PARSING_ERROR, CCOMPILATION_ERROR
    }

    public class ValaCodeCompiler {

        private const string DEFAULT_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";

        private Logger LOGGER = Logger.getLogger("ValaCodeCompiler");

        private CodeContext codeContext;
        private BuildConfiguration buildConfiguration;

        public ValaCodeCompiler(BuildConfiguration buildConfiguration) {
            this.buildConfiguration = buildConfiguration;

            initializeCodeContext();
            initializeContextDependencies();
            initializeContextSources();
            initializeContextCodeGenerator();
        }

        private void initializeCodeContext() {
            LOGGER.logInfo("Initializing CodeContext");
            codeContext = new CodeContext();
            CodeContext.push(codeContext);

            codeContext.codegen = new GDBusServerModule();
            codeContext.header_filename = buildConfiguration.outputHFile;
            codeContext.output = buildConfiguration.targetFile;
            codeContext.assert = false;
		    codeContext.checking = true;
            codeContext.debug = true;
		    codeContext.deprecated = true;
		    codeContext.hide_internal = false;
		    codeContext.experimental = false;
		    codeContext.experimental_non_null = false;
		    codeContext.gobject_tracing = true;
		    codeContext.report.enable_warnings = true;
		    codeContext.report.set_verbose_errors(true);
            codeContext.report.set_colors(DEFAULT_COLORS);
            codeContext.verbose_mode = buildConfiguration.verbose;
            codeContext.version_header = true;
            
            codeContext.basedir = CodeContext.realpath(".");
            codeContext.directory = codeContext.basedir;

            codeContext.profile = Profile.GOBJECT;
			codeContext.add_define("GOBJECT");
        }

        private void initializeContextDependencies() {
            foreach (BobBuildProjectDependency dependency in buildConfiguration.dependencies) {
                string dependencyString = dependency.to_string();
                LOGGER.logInfo(@"Using dependency: $(dependencyString)");
                codeContext.add_external_package(dependencyString);
            }
        }

        private void initializeContextSources() {
            foreach (BobBuildProjectSourceFile buildSource in buildConfiguration.sources) {
                if (codeContext.add_source_filename(buildSource.fileLocation, false, true)) {
                    if (buildConfiguration.verbose) {
                        LOGGER.logInfo(@"Using source file: $(buildSource.fileLocation)");
                    }
                }
            }
        }

        private void initializeContextCodeGenerator() {
            LOGGER.logInfo("Initializing CodeGenerator");
        }

        public void compile() throws CompilationError {
            LOGGER.logInfo("Starting code compilation ...");
            runCodeParsers();
            runCodeGenerator();
            runVapiGenerator();
            runCodeCompiler();

            if (hasErrors()) {
		        throw new CompilationError.CCOMPILATION_ERROR("An error occurred while compiling source code");
	        }

            CodeContext.pop();
        }

        private void runCodeParsers() throws CompilationError {
            LOGGER.logInfo("Running code parsers.");

            LOGGER.logInfo("Running general parser.");
            new Parser().parse(codeContext);

            LOGGER.logInfo("Running GENIE parser.");
	        new Genie.Parser().parse(codeContext);

            LOGGER.logInfo("Running GIR parser.");
	        new GirParser().parse(codeContext);

            codeContext.check();

	        if (hasErrors()) {
		        throw new CompilationError.PARSING_ERROR("An error occured while parsing source files");
	        }
        }

        private void runCodeGenerator() throws CompilationError {
            codeContext.codegen.emit(codeContext);
    	    if (hasErrors()) {
    			throw new CompilationError.PARSING_ERROR("An error occured while parsing source files");
    		}
        }

        private void runVapiGenerator() {
            if (!buildConfiguration.generateVapi) {
                return;
            }
            CodeWriter interfaceWriter = new CodeWriter();
            
            LOGGER.logInfo("Generating VAPI file.");
            interfaceWriter.write_file(codeContext, buildConfiguration.outputVapiFile);
        }

        private void runCodeCompiler() throws CompilationError {
            CCodeCompiler ccompiler = new CCodeCompiler();
            string ccCommand = Environment.get_variable("CC");
            string pkgConfigCommand = Environment.get_variable("PKG_CONFIG");
            ccompiler.compile(codeContext, ccCommand, buildConfiguration.ccOptions, pkgConfigCommand);

            if (hasErrors()) {
		        throw new CompilationError.PARSING_ERROR("An error occured while compiling C code");
	        }
        }

        private bool hasErrors() {
            return codeContext.report.get_errors() > 0;
        }

        private bool hasWarnings() {
            return codeContext.report.get_warnings() > 0;
        }
    }
}
