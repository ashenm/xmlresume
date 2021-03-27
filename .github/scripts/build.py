#!/usr/bin/env python3

from yaml import load
from os import P_WAIT, makedirs, replace, spawnl, spawnv
from os.path import join

# parse theme formations
with open('themes.yml', 'rt') as stream:
  themes = load(stream=stream)

# build all theme formations
for theme in themes:

  # pdf arguments
  args = ['scripts/pdf.py']

  # page numbers
  if themes.get(theme).get('page_numbers'):
    args.extend(['--page-numbers'])

  # font size
  if themes.get(theme).get('font_size'):
    args.extend(['--font-size', str(themes.get(theme).get('font_size'))])

  # font face
  if themes.get(theme).get('font'):
    args.extend(['--font', join('fonts', themes.get(theme).get('font'))])

  # log build theme
  print('\033[36;1mBuilding theme {}.xsl\033[0m'.format(theme))

  # render html document
  spawnl(P_WAIT, 'scripts/resume.py', 'scripts/resume.py', '{}.xsl'.format(theme))

  # render pdf document
  spawnv(P_WAIT, 'scripts/pdf.py', args)

  # respective artifacts dir
  makedirs(name=join('gh-pages', theme), mode=0o700, exist_ok=True)

  # move artifacts
  replace(src='resume.html', dst=join('gh-pages', theme, 'resume.html'))
  replace(src='resume.pdf', dst=join('gh-pages', theme, 'resume.pdf'))

# vim: set expandtab shiftwidth=2:
