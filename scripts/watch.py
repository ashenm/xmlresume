#!/usr/bin/env python3
#
# XMLResume
# https://github.com/ashenm/xmlresume
# Watch changes and rebuild artifacts
#
# Ashen Gunaratne
# mail@ashenm.ml
#

from time import sleep
from os import P_WAIT, stat, spawnlp

def monitor(file, settle, cmd):

  # last most modification
  last = stat(file).st_mtime

  while True:

    # latest modification
    current = stat(file).st_mtime

    # handle non-changes
    if last == current:
      sleep(settle)
      continue

    last = current

    spawnlp(P_WAIT, *cmd)
    sleep(settle)

if __name__ == '__main__':

  from os import P_WAIT, spawnl
  from os.path import basename, join, isfile
  from sys import argv, exit, stderr

  # resume theme
  theme = dict(enumerate(argv)).get(1, 'default.xsl')
  theme_abspath = join('themes', theme)

  # ensure file exsist
  if not isfile(theme_abspath):
    print('{}: cannot access \'{}\': No such file or directory'.format(basename(argv[0]), theme_abspath), file=stderr)
    exit(2)

  # command to execute
  cmd = ['./scripts/resume.py', './scripts/resume.py', theme]

  # trigger initial build
  spawnl(P_WAIT, *cmd)

  # monitor file
  monitor(join('themes', theme), 1, cmd)

# vim: set expandtab shiftwidth=2:
