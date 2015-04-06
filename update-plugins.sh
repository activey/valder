#!/bin/bash

rm -rf target/plugins/*.so
cp plugin-build/target/lib/*.so target/plugins/
cp plugin-collect-sources/target/lib/*.so target/plugins/