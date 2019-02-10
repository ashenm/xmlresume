#!/usr/bin/env sh
# Build XMLResume

set -e

# build all defaults
# pdf, standalone, and jekyll template
make default

# gp-pages index
cp -f standalone.html index.html
