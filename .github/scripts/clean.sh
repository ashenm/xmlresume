#!/usr/bin/env sh

set -e

for file in gh-pages/*; do

  case $file in
    */index.html)
      continue
      ;;
  esac

  rm --recursive --force $file
  rm --force artifacts.tar.bz2

done

# vim: set expandtab shiftwidth=2:
