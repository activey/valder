#!/bin/bash

PLUGIN_SOURCES=(`find ../src/library/vala -type f -name "**.vala"`)
SOURCES=(`find src/library/vala -type f -name "**.vala"`)
PACKAGES=('glib-2.0' 'gobject-2.0' 'gio-2.0' 'json-glib-1.0' 'gmodule-2.0')

PLUGIN_SOURCES_PREFIXED=$(printf "%s " "${PLUGIN_SOURCES[@]}")
SOURCES_PREFIXED=$(printf "%s " "${SOURCES[@]}")
PACKAGES_PREFIXED=$(printf " --pkg %s" "${PACKAGES[@]}")

mkdir -p target/lib
valac-0.26 -v --library=build $PLUGIN_SOURCES_PREFIXED $SOURCES_PREFIXED -X -fPIC -X --shared $PACKAGES_PREFIXED -o target/lib/libbuild.so