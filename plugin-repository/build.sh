#!/bin/bash

LIBRARY_NAME='repository'
HEADER_LOCATION=('../src/library/c')
SOURCES=(`find src/library/vala -type f -name "**.vala"`)
PACKAGES=('glib-2.0' 'gobject-2.0' 'gio-2.0' 'json-glib-1.0' 'gmodule-2.0' 'bob')
VAPI_DIRS=('../src/library/vapi')

SOURCES_PREFIXED=$(printf "%s " "${SOURCES[@]}")
PACKAGES_PREFIXED=$(printf " --pkg %s" "${PACKAGES[@]}")
VAPI_DIRS_PREFIXED=$(printf " --vapidir %s" "${VAPI_DIRS[@]}")

mkdir -p target/lib
valac -v --library=$LIBRARY_NAME $SOURCES_PREFIXED -X -fPIC -X --shared -X -I$HEADER_LOCATION $VAPI_DIRS_PREFIXED $PACKAGES_PREFIXED -o target/lib/lib$LIBRARY_NAME.so