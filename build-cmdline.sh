#!/bin/bash

set -x

SOURCES=(`find src/main -type f -name "**.vala"`)
PACKAGES=('glib-2.0' 'gobject-2.0' 'gio-2.0' 'json-glib-1.0' 'libvala-0.28' 'gmodule-2.0' 'gee-0.8' 'bob')

SOURCES_PREFIXED=$(printf "%s " "${SOURCES[@]}")
PACKAGES_PREFIXED=$(printf " --pkg %s" "${PACKAGES[@]}")
VAPI_PREFIXED=$(printf "%s " "${VAPI[@]}")

mkdir -p target/plugins
valac -g -v $SOURCES_PREFIXED -X -Wl,-rpath=\$ORIGIN/lib -X -Ltarget/lib -X -lbob -X -Isrc/library/c --vapidir src/library/vapi $PACKAGES_PREFIXED -o target/bob