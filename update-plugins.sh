#!/bin/bash

rm -rf target/plugins/*.so
cp plugin-*/target/lib/*.so target/plugins/