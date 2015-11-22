#!/bin/bash

SOURCES=(`find src/library -type f -name "**.vala"`)
PACKAGES=('glib-2.0' 'gobject-2.0' 'gio-2.0' 'json-glib-1.0' 'libvala-0.30' 'gmodule-2.0' 'gee-0.8')

SOURCES_PREFIXED=$(printf "%s " "${SOURCES[@]}")
PACKAGES_PREFIXED=$(printf " --pkg %s" "${PACKAGES[@]}")

mkdir -p target/lib
valac -g -v --library=bob-builder -H src/library/c/bob-0.0.1.h --vapi=src/library/vapi/bob-0.0.1.vapi $SOURCES_PREFIXED -X -fPIC -X -shared $PACKAGES_PREFIXED -o target/lib/libbob.so