#!/usr/bin/env sh
# Build XMLResume

set -e

# build all templates
# into respective directories
for file in ./themes/*.xsl
do

  # handle empty dir
  test -e "$file" || \
    continue

  # log build theme
  echo "\033[36;1mBuilding theme $(basename $file)\033[0m"

  # build resume
  ./scripts/resume.py "$(basename $file)" && ./scripts/pdf.py

  # build artifacts
  mkdir --parent "gh-pages/$(basename $file .xsl)"

  # move artifacts
  mv --force "resume.html" "resume.pdf" "gh-pages/$(basename $file .xsl)/"

done
