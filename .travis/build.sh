#!/usr/bin/env sh
# Build XMLResume

set -e

# build all defaults
# pdf, standalone, and jekyll template
make default

# gh-pages artifacts
cp -rfv gh-pages/* .
