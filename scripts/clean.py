#!/usr/bin/env python3
# Clean XMLResume Build Artifacts

import os

# build cache
artifacts = [
  'index.html',
  'resume.pdf',
  'resume.html',
  'standalone.html'
]

# purge build artifacts
for artifact in artifacts:
  try:
    os.remove(artifact)
  except:
    pass
