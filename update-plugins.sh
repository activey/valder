#!/bin/bash

rm -rf target/bin/plugins/*.so
cp plugin-*/target/lib/libplugin-*.so target/bin/plugins/