#!/usr/bin/env python3
# Clean XMLResume Build Artifacts

from os import P_WAIT, spawnlp

# build cache
artifacts = [
  'resume.pdf',
  'resume.html',
  'gh-pages/resume.html',
  'gh-pages/resume.pdf'
]

# purge build artifacts
# purge gh-pages artifacts
spawnlp(P_WAIT, 'git', 'git', 'clean', '-fdq', 'gh-pages')
spawnlp(P_WAIT, 'rm', 'rm', '-rf', *artifacts)
