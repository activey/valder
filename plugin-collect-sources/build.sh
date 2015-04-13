#!/bin/bash

LIBRARY_NAME='collect-sources'
VAPI_SOURCES=(`find ../src/library/vapi -type f -name "**.vapi"`)
HEADER_LOCATION=('../src/library/vapi')
SOURCES=(`find src/library/vala -type f -name "**.vala"`)
PACKAGES=('glib-2.0' 'gobject-2.0' 'gio-2.0' 'json-glib-1.0' 'gmodule-2.0')

VAPI_SOURCES_PREFIXED=$(printf "%s " "${VAPI_SOURCES[@]}")
SOURCES_PREFIXED=$(printf "%s " "${SOURCES[@]}")
PACKAGES_PREFIXED=$(printf " --pkg %s" "${PACKAGES[@]}")

mkdir -p target/lib
valac -v --library=$LIBRARY_NAME $VAPI_SOURCES_PREFIXED $SOURCES_PREFIXED -X -fPIC -X --shared -X -I$HEADER_LOCATION $PACKAGES_PREFIXED -o target/lib/lib$LIBRARY_NAME.so