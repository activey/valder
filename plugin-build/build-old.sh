valac --library=bob-plugin-build \
../src/main/vala/com/futureprocessing/bob/plugin/BuildPlugin.vala \
src/main/vala/com/futureprocessing/bob/plugin/BuildApplicationPlugin.vala \
-X -fPIC -X -shared \
--pkg glib-2.0 --pkg gmodule-2.0 --pkg json-glib-1.0 \
-o libbob-plugin-build.so
