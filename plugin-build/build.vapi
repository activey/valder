/* build.vapi generated by valac 0.28.0, do not modify. */

namespace bob {
	namespace builder {
		namespace build {
			namespace plugin {
				[CCode (cheader_filename = "src/library/vala/bob/builder/build/plugin/BuildConfiguration.h")]
				public class BuildApplicationPlugin : bob.builder.build.plugin.AbstractBobBuildPlugin {
					public BuildApplicationPlugin ();
					public override void initialize (bob.builder.recipe.plugin.BobBuildPluginRecipe pluginRecipe) throws bob.builder.build.plugin.BobBuildPluginError;
					public override void run (bob.builder.recipe.project.BobBuildProjectRecipe projectRecipe) throws bob.builder.build.plugin.BobBuildPluginError;
				}
				[CCode (cheader_filename = "src/library/vala/bob/builder/build/plugin/BuildConfiguration.h")]
				public class BuildConfiguration {
					public BuildConfiguration ();
					public void addDependency (bob.builder.recipe.project.BobBuildProjectDependency dependency);
					public void addSource (bob.builder.recipe.project.BobBuildProjectSourceFile source);
					public string[] ccOptions { get; set; }
					public GLib.List<bob.builder.recipe.project.BobBuildProjectDependency> dependencies { get; }
					public GLib.List<bob.builder.recipe.project.BobBuildProjectSourceFile> sources { get; }
					public string targetFile { get; set; }
					public bool verbose { get; set; }
				}
				[CCode (cheader_filename = "src/library/vala/bob/builder/build/plugin/BuildConfiguration.h")]
				public class BuildConfigurationBuilder {
					public BuildConfigurationBuilder ();
					public bob.builder.build.plugin.BuildConfigurationBuilder addDependency (bob.builder.recipe.project.BobBuildProjectDependency dependency);
					public bob.builder.build.plugin.BuildConfigurationBuilder addSource (bob.builder.recipe.project.BobBuildProjectSourceFile source);
					public bob.builder.build.plugin.BuildConfiguration build ();
					public bob.builder.build.plugin.BuildConfigurationBuilder ccOptions (string[] ccOptions);
					public BuildConfigurationBuilder.fromJSONObject (bob.builder.json.JsonObject jsonObject);
					public bob.builder.build.plugin.BuildConfigurationBuilder targetDirectory (string targetDirectory);
					public bob.builder.build.plugin.BuildConfigurationBuilder targetFileName (string targetFileName);
				}
				[CCode (cheader_filename = "src/library/vala/bob/builder/build/plugin/BuildConfiguration.h")]
				public class ValaCodeCompiler {
					public ValaCodeCompiler (bob.builder.build.plugin.BuildConfiguration buildConfiguration);
					public void compile () throws bob.builder.build.plugin.CompilationError;
				}
				[CCode (cheader_filename = "src/library/vala/bob/builder/build/plugin/BuildConfiguration.h")]
				public errordomain CompilationError {
					PARSING_ERROR,
					CCOMPILATION_ERROR
				}
			}
		}
	}
}
[CCode (cheader_filename = "src/library/vala/bob/builder/build/plugin/plugin.h")]
public static void initializePlugin (bob.builder.build.plugin.BobBuildPluginLoader pluginLoader);
[CCode (cheader_filename = "src/library/vala/bob/builder/build/plugin/plugin.h")]
public static string[] getDependencies ();
