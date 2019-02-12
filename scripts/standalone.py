#!/usr/bin/env python3
# Generate Standalone resume.html

import re
from frontmatter import parse
from bs4 import BeautifulSoup
from reindent import reindent

# eol
newline = '\n'

# html doc
output = ''

# extra linefeeded elements
extras = [ 'script', 'style']

# html template
soup = """
  <!DOCTYPE html>
  <html lang="en">

    <head>

      <meta charset="utf-8" />
      <meta name="author" content="Ashen Gunaratne" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

"""

# extract jekyll front-matter and template
with open(file='resume.html', encoding='utf_8') as file:
  frontmatter, jekyll = parse(file.read(-1))

# set metadata
soup += '<meta name="description" content="{}" />'.format(frontmatter.get('desc', 'Curriculum Vitae'))
soup += '<title>{}</title>'.format(frontmatter.get('title', 'Curriculum Vitae'))

# runtime RegExps
reStartBlock = re.compile(r'{%- capture (.*) -%}')
reEndBlock = re.compile(r'{%- endcapture -%}')
reEmptyTag = re.compile(r'<[a-zA-Z].*?/>')
reStartTag = re.compile(r'<[a-zA-Z].*?>')
reEndTag = re.compile(r'</[a-zA-Z].*?>')

# runtime flags
capture = False

# jekyll variables
includes = {}

# capture includes
for line in jekyll.splitlines(keepends=True):

  startBlock = reStartBlock.match(line)
  endBlock = reEndBlock.match(line)

  if endBlock:
    capture = False
    continue

  if startBlock:
    capture = startBlock.group(1)
    includes[startBlock.group(1)] = ''
    continue

  if capture:
    includes[capture] += line
    continue

  continue

# inject metadata
# inject scripts
soup += includes.get('metadata', '')
soup += includes.get('scripts', '')

# construct body
soup += '</head><body>'
soup += includes.get('body', '')
soup += '</body></html>'

# prettify content
soup = BeautifulSoup(markup=soup, features="lxml")
output = reindent(markup=soup.prettify())

# extra space custom tags
output = re.sub(r'(\s*)<({})>'.format('|'.join(extras)), '{}{}'.format(r'\1<\2>', newline), output)
output = re.sub(r'(\s*)</({})>'.format('|'.join(extras)), '{}{}'.format(newline, r'\1</\2>'), output)

# write output
with open(file='standalone.html', mode='w', encoding='utf_8', newline=newline) as file:
  file.write(output)
