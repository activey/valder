#!/bin/bash

SOURCES=(`find src/main -type f -name "**.vala"`)
VAPI=(`find src/library -type f -name "**.vapi"`)
PACKAGES=('glib-2.0' 'gobject-2.0' 'gio-2.0' 'json-glib-1.0' 'libvala-0.26' 'gmodule-2.0')

SOURCES_PREFIXED=$(printf "%s " "${SOURCES[@]}")
PACKAGES_PREFIXED=$(printf " --pkg %s" "${PACKAGES[@]}")
VAPI_PREFIXED=$(printf "%s " "${VAPI[@]}")

mkdir -p target/plugins
valac-0.26 -g -v $VAPI_PREFIXED $SOURCES_PREFIXED -X -Wl,-rpath=\$ORIGIN/lib -X -Ltarget/lib -X -lbobbuilder -X -Isrc/library/vapi $PACKAGES_PREFIXED -o target/bob