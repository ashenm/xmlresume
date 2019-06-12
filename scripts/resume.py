#!/usr/bin/env python3
# Generate and Prettify resume.html

from re import sub
from lxml import etree
from bs4 import BeautifulSoup
from reindent import reindent
from os.path import join
from sys import argv

# eol
newline = '\n'

# prettified output
sanitized = []

# extra linefeeded elements
extras = [ 'script', 'style' ]

# resume theme
theme = dict(enumerate(argv)).get(1, 'default.xsl')

# translate resume
xsl = etree.XSLT(etree.parse(source=join('themes', theme)))
crude = str(xsl(etree.parse(source='resume.xml')))

# prettify html
soup = BeautifulSoup(markup=crude, features='lxml')
crude = soup.p.prettify(encoding=None, formatter='html')
crude = crude.splitlines(keepends=False)

# lead front matter
for stage in crude[:]:
  if crude.pop(0).strip() == '---':
    sanitized.append('---')
    break

# construct front matter
for stage in crude[:]:
  if crude.pop(0).strip() == '---':
    sanitized.append('---')
    break
  sanitized.append(stage.strip())

# re-nindent
crude = reindent(markup=newline.join(crude[:]), offset=1)
sanitized += crude.splitlines(keepends=False)

# purge trailing element
# and stringify content
sanitized = newline.join(sanitized[:-1])

# extra space template tags
sanitized = sub(r'{%- capture (.+) -%}', '{}{}'.format(r'{%- capture \1 -%}', newline), sanitized)
sanitized = sanitized.replace(r'{%- endcapture -%}', '{}{}'.format(newline, r'{%- endcapture -%}'))

# extra space custom tags
sanitized = sub(r'(\s*)<({})>'.format('|'.join(extras)), '{}{}'.format(r'\1<\2>', newline), sanitized)
sanitized = sub(r'(\s*)</({})>'.format('|'.join(extras)), '{}{}'.format(newline, r'\1</\2>'), sanitized)

# write output
with open(file='resume.html', mode='w', encoding='utf_8', newline=newline) as file:
  file.write(sanitized)
  file.write(newline)
