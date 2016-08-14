using bob.builder.log;

namespace bob.builder.build.plugin {

    public class EnvironmentPackagesDependenciesParser {

        public delegate void ParsedDependencyDelegate(string name, string version);

        private Logger LOGGER = Logger.getLogger("EnvironmentPackagesDependenciesParser");

        const string VAR_DEPS_PKGS = "DEPS_PKGS";

        public void parseDependencies(ParsedDependencyDelegate parsedDependencyDelegate) {
            string dependencyPackages = Environment.get_variable(VAR_DEPS_PKGS);
            if (dependencyPackages == null) {
                LOGGER.logInfo("No environment dependencies packages passed.");
                return;
            }

            string[] dependencies = dependencyPackages.split(",", 0);
            foreach (string dependency in dependencies) {
                string[] dependencyParts = dependency.split(":", 0);
                if (dependencyParts.length < 1) {
                        continue;
                }
                string dependencyName = dependencyParts[0];
                string version = (dependencyParts.length < 2) ? "-" : dependencyParts[1];
                parsedDependencyDelegate(dependencyName, version);
            }
        }
    }   
}