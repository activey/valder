#!/bin/bash

rm -rf target/plugins/*.so
cp plugin-*/target/lib/libplugin-*.so target/plugins/