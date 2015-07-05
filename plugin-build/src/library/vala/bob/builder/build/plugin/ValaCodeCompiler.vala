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

        private string[] vapiDirectories = new string[0];
        private CCOptions ccOptions;

        public ValaCodeCompiler(BuildConfiguration buildConfiguration) {
            this.buildConfiguration = buildConfiguration;
            this.ccOptions = new CCOptions(buildConfiguration.ccOptions);
            
            initializeCodeContext();
            initializeContextDebug();
            initializeContextVapiLibraries();
            useContextVapiDirectories();
            
            initializeContextDependencies();
            initializeContextSources();
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

        private void initializeContextDebug() {
            if (buildConfiguration.debug) {
                LOGGER.logInfo("Setting DEBUG mode.");

                codeContext.debug = buildConfiguration.debug;
                ccOptions.addDebugFlag();
            }
        }

        private void initializeContextVapiLibraries() {
            foreach (BobBuildProjectDependency dependency in buildConfiguration.dependencies) {
                if (dependency.vapiDirectory != null) {
                    LOGGER.logInfo(@"Using VAPI directory: $(dependency.vapiDirectory) for dependency: %s.", dependency.toString());
                    vapiDirectories += dependency.vapiDirectory;
                }

                if (dependency.cHeadersDirectory != null) {
                    LOGGER.logInfo(@"Using C headers directory: $(dependency.cHeadersDirectory) for dependency: %s.", dependency.toString());
                    ccOptions.addCHeadersDirectoryLocation(dependency.cHeadersDirectory);
                    ccOptions.useLibrary(dependency.dependency);
                }
            }
        }

        private void useContextVapiDirectories() {
            codeContext.vapi_directories = vapiDirectories;    
        }

        private void initializeContextDependencies() {
            LOGGER.logInfo("Initializing dependencies for scope: %s.", buildConfiguration.scope.name());
            foreach (BobBuildProjectDependency dependency in buildConfiguration.dependencies) {
                if (!dependency.scope.matches(buildConfiguration.scope)) {
                    continue;
                }
                string dependencyString = dependency.toString();
                if (codeContext.add_external_package(dependencyString)) {
                    LOGGER.logInfo(@"Using PKG dependency: $(dependencyString).");
                } else {
                    LOGGER.logError(@"Unable to find PKG dependency: $(dependencyString).");
                }
            }
        }

        private void initializeContextSources() {
            foreach (BobBuildProjectSourceFile buildSource in buildConfiguration.sources) {
                if (codeContext.add_source_filename(buildSource.fileLocation, false, true)) {
                    
                    if (buildConfiguration.verbose) {
                        LOGGER.logInfo(@"Using source file: $(buildSource.fileLocation).");
                    }
                }
            }
        }

        public ValaCodeCompilerOutcome compile() throws CompilationError {
            if (!hasAnyValaSourceFiles()) {
                LOGGER.logInfo("No VALA source files available, skipping code compilation.");
                return new ValaCodeCompilerOutcome.noBinaryGenerated();
            }

            LOGGER.logInfo("Starting code compilation ...");
            runCodeParsers();
            runCodeGenerator();
            runVapiGenerator();
            runCodeCompiler();
            
            CodeContext.pop();

            if (hasErrors()) {
                throw new CompilationError.CCOMPILATION_ERROR("An error occurred while compiling source code");
            }

            return new ValaCodeCompilerOutcome.default();
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
		        throw new CompilationError.PARSING_ERROR("An error occured while parsing source files.");
	        }
        }

        private void runCodeGenerator() throws CompilationError {
            codeContext.codegen.emit(codeContext);
    	    if (hasErrors()) {
    			throw new CompilationError.PARSING_ERROR("An error occured while parsing source files.");
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

            stdout.printf(">>>> %s \n", string.joinv(",", ccOptions.getCcOptions()));

            ccompiler.compile(codeContext, ccCommand, ccOptions.getCcOptions(), pkgConfigCommand);

            if (hasErrors()) {
		        throw new CompilationError.CCOMPILATION_ERROR("An error occured while compiling C code.");
	        }
        }

        private bool hasErrors() {
            return codeContext.report.get_errors() > 0;
        }

        private bool hasAnyValaSourceFiles() {
            return buildConfiguration.hasAnySources(".vala");
        }
    }
}
