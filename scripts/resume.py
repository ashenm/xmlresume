#!/usr/bin/env python3
# Generate and Prettify resume.html

import re
from lxml import etree
from bs4 import BeautifulSoup

# spacing
level = 1
indent = 2
newline = '\n'

# prettified output
sanitized = []

# extra linefeeded elements
extras = [ 'script', 'style' ]

# translate resume
xsl = etree.XSLT(etree.parse(source='resume.xsl'))
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

# runtime RegExps
reEmptyTag = re.compile(r'<[a-zA-Z].*?/>')
reStartTag = re.compile(r'<[a-zA-Z].*?>')
reEndTag = re.compile(r'</[a-zA-Z].*?>')

# re-indent
for line in crude[:]:

  # trim whitespace
  stage = line.strip()

  # new lines
  if not stage:
    sanitized.append('')
    continue

  # starting code blocks
  if stage.endswith('{'):
    sanitized.append(' ' * level * indent + stage)
    level += 1
    continue

  # ending code blocks
  if stage.startswith('}'):
    level -= 1
    sanitized.append(' ' * level * indent + stage)
    continue

  # template tags
  if stage.startswith('{'):
    sanitized.append(stage)
    continue

  # empty tags
  if reEmptyTag.match(stage):
    sanitized.append(' ' * level * indent + stage)
    continue

  # find tags
  startTag = reStartTag.match(stage)
  endTag = reEndTag.match(stage)

  # opening tags
  if startTag:
    sanitized.append(' ' * level * indent + stage)
    level += 1
    continue

  # closing tags
  if endTag:
    level -= 1
    sanitized.append(' ' * level * indent + stage)
    continue

  # text content
  sanitized.append(' ' * level * indent + stage)

# purge trailing element
sanitized = sanitized[:-1]

# stringify content
sanitized = newline.join(sanitized)

# extra space template tags
sanitized = re.sub(r'{%- capture (.+) -%}', '{}{}'.format(r'{%- capture \1 -%}', newline), sanitized)
sanitized = sanitized.replace(r'{%- endcapture -%}', '{}{}'.format(newline, r'{%- endcapture -%}'))

# extra space custom tags
sanitized = re.sub(r'(\s*)<({})>'.format('|'.join(extras)), '{}{}'.format(r'\1<\2>', newline), sanitized)
sanitized = re.sub(r'(\s*)</({})>'.format('|'.join(extras)), '{}{}'.format(newline, r'\1</\2>'), sanitized)

# write output
with open(file='resume.html', mode='w', encoding='utf_8', newline=newline) as file:
  file.write(sanitized)
  file.write(newline)
