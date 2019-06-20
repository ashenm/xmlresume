#!/usr/bin/env python3
# Clean XMLResume Build Artifacts

from os import P_WAIT, listdir, spawnlp

# build cache
artifacts = [
  'resume.pdf',
  'resume.html'
]

# purge build artifacts
# purge gh-pages artifacts
spawnlp(P_WAIT, 'rm', 'rm', '--recursive', '--force', *artifacts, *('{}/{}'.format('gh-pages', theme.replace('.xsl', '')) for theme in listdir('themes')))
