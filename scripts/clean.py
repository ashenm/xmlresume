#!/usr/bin/env python3
#
# XMLResume
# https://github.com/ashenm/xmlresume
# Clean build artifacts
#
# Ashen Gunaratne
# mail@ashenm.ml
#

from os import P_WAIT, spawnlp

# build cache
artifacts = [
  'resume.pdf',
  'resume.html'
]

# purge build artifacts
# purge gh-pages artifacts
spawnlp(P_WAIT, 'git', 'git', 'clean', '-fdq', 'gh-pages')
spawnlp(P_WAIT, 'rm', 'rm', '-rf', *artifacts)

# vim: set expandtab shiftwidth=2:
