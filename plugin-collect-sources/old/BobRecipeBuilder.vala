using com.futureprocessing.bob.log;
using Vala;

namespace com.futureprocessing.bob.recipe {

    public errordomain CompilationError {
        PARSING_ERROR, CCOMPILATION_ERROR
    }

    public class BobRecipeBuilder {
        
        private Logger LOGGER = Logger.getLogger("BobRecipeBuilder");
        
        private BobRecipeBuildConfiguration buildConfiguration;
        private CodeContext codeContext;
        
        public BobRecipeBuilder(BobRecipeBuildConfiguration buildConfiguration) {
            this.buildConfiguration = buildConfiguration;      
            
            initializeCodeContext();
            initializeContextDependencies();
            initializeContextSources();   
            initializeContextCodeGenerator();
        }
        
        private void initializeCodeContext() {
            LOGGER.logInfo("Initializing CodeContext\n");
            codeContext = new CodeContext();
            CodeContext.push(codeContext);
                        
            codeContext.output = buildConfiguration.target;
            codeContext.assert = false;
		    codeContext.checking = true;
		    codeContext.deprecated = true;
		    codeContext.hide_internal = false;
		    codeContext.experimental = false;
		    codeContext.experimental_non_null = false;
		    codeContext.gobject_tracing = true;
		    codeContext.report.enable_warnings = true;
		    codeContext.report.set_verbose_errors(true);
		    codeContext.verbose_mode = true;
		    codeContext.version_header = true;
            
            codeContext.basedir = CodeContext.realpath (".");
            codeContext.profile = Profile.GOBJECT;
			codeContext.add_define("GOBJECT");
        }

        private void initializeContextDependencies() {
            foreach (BobRecipeBuildDependency dependency in buildConfiguration.dependencies) {
                string dependencyString = dependency.to_string();
                LOGGER.logInfo(@"Using dependency: $(dependencyString)\n");
                codeContext.add_external_package(dependencyString);
            }                    
        }
        
        private void initializeContextSources() {
            foreach (BobRecipeBuildSource buildSource in buildConfiguration.sources) {
                if (codeContext.add_source_filename(buildSource.filePath, true, true)) {
                    LOGGER.logInfo(@"Using source file: $(buildSource.fileName)\n");
                }
            }                    
        }

        private void initializeContextCodeGenerator() {
            LOGGER.logInfo("Initializing CodeGenerator\n");
            codeContext.codegen = new GDBusServerModule();
        }
         
        public void build() throws CompilationError {
            LOGGER.logInfo("Starting code compilation ...\n");
            runCodeParsers();
            runCodeGenerator();            
            runCodeCompiler();
            
            if (hasErrors()) {
		        throw new CompilationError.CCOMPILATION_ERROR("An error occurred while compiling source code");
	        }
        }
        
        private void runCodeParsers() throws CompilationError {
            new Parser().parse(codeContext);
	        new Genie.Parser().parse(codeContext);
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
        
        private void runCodeCompiler() throws CompilationError {
            CCodeCompiler ccompiler = new CCodeCompiler();
            string ccCommand = Environment.get_variable ("CC");
            string pkgConfigCommand = Environment.get_variable ("PKG_CONFIG");
            ccompiler.compile(codeContext, ccCommand, new string[] {}, pkgConfigCommand);
            
            if (hasErrors()) {
		        throw new CompilationError.PARSING_ERROR("An error occured while compiling C code");
	        }
        }
        
        private bool hasErrors() {
            return codeContext.report.get_errors () > 0 || (codeContext.report.get_warnings () > 0);
        }
        
    }
}