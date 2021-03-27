#!/usr/bin/env sh
# Build XMLResume

set -e

# build all templates
# into respective directories
python3 "$(dirname "$(readlink -f $0)")/build.py"

# webroot default theme artifacts
cp --force gh-pages/default/resume.html gh-pages/default/resume.pdf gh-pages/

# webroot fonts
cp --recursive --force fonts gh-pages/

# vim: set expandtab shiftwidth=2:
