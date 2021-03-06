#!/bin/bash
PWD=`pwd`
LIBRARY_NAME=`basename $PWD`
LIBRARY_VERSION='0.0.1'
VAPI_SOURCES=(`find ../src/library/vapi -type f -name "**.vapi"`)
HEADER_LOCATION=('../src/library/c')
SOURCES=(`find src/library/vala -type f -name "**.vala"`)
PACKAGES=('glib-2.0' 'gobject-2.0' 'gio-2.0' 'gee-0.8' 'json-glib-1.0' 'gmodule-2.0' 'libvala-0.30')

VAPI_SOURCES_PREFIXED=$(printf "%s " "${VAPI_SOURCES[@]}")
SOURCES_PREFIXED=$(printf "%s " "${SOURCES[@]}")
PACKAGES_PREFIXED=$(printf " --pkg %s" "${PACKAGES[@]}")

mkdir -p target/lib
valac -v --library=$LIBRARY_NAME $VAPI_SOURCES_PREFIXED $SOURCES_PREFIXED -X -fPIC -X --shared -X -I$HEADER_LOCATION $PACKAGES_PREFIXED -o target/lib/lib$LIBRARY_NAME.so --vapi=src/library/vapi/$LIBRARY_NAME-$LIBRARY_VERSION.vapi