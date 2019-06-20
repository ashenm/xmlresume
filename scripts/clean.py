#!/usr/bin/env python3
# Clean XMLResume Build Artifacts

from os import P_WAIT, listdir, remove, spawnlp

# build cache
artifacts = [
  'resume.pdf',
  'resume.html'
]

# purge build artifacts
# purge gh-pages artifacts
spawnlp('rm', 'rm', '--recursive', '--force', *(artifacts + listdir('gh-pages')))
