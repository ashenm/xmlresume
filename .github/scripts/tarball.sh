#!/usr/bin/env sh

set -e

tar --create --bzip2 --verbose --file=artifacts.tar.bz2 gh-pages

# vim: set expandtab shiftwidth=2:
