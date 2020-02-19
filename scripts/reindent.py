#!/usr/bin/env python3
# Reindent BeautifulSoup prettified HTML

# built-in `compile` not being used
# hence following overwrite is harmless
from re import compile

def reindent(markup, offset=0, width=2, char=' '):

  # spacing
  fill = char
  level = offset
  indent = width

  # eol
  newline = '\n'

  # prettified output
  sanitized = []

  # non-HTML container elements
  # ignore defined punctuations within
  metadatas = [ 'script', 'style' ]

  # multi-line text elements
  # linefeed prior content
  textblocks = [ 'p' ]

  # special grammar chars
  # avoid preceding spaces
  punctuations = ( '.', ',', ':', ';' )

  # runtime RegExps
  reEmptyTag = compile(r'<([a-zA-Z]\S*).*?/>')
  reStartTag = compile(r'<([a-zA-Z]\S*).*?>')
  reEndTag = compile(r'</([a-zA-Z]\S*).*?>')

  # runtime stages for
  # element components
  header = ''
  payload = ''

  # runtime flags
  isMetadata = False
  isTextBlock = False

  # re-indent
  for crude in markup.splitlines():

    # discard current indent
    stage = crude.strip()

    # handle new lines
    if not stage:
      sanitized.append(newline)
      continue

    # handle starting and ending code blocks
    if stage.endswith(('{', '[')) and stage.startswith(('}', ']')):
      level -= 1
      sanitized.append(newline)
      sanitized.append(fill * level * indent + stage)
      level += 1
      continue

    # handle starting code blocks
    if stage.endswith(('{', '[')):
      sanitized.append(newline)
      sanitized.append(fill * level * indent + stage)
      level += 1
      continue

    # handle ending code blocks
    if stage.startswith(('}', ']')):
      level -= 1
      sanitized.append(newline)
      sanitized.append(fill * level * indent + stage)
      continue

    # handle empty tags
    tagMatch = reEmptyTag.match(stage)

    if tagMatch and header:

      sanitized.append(newline + fill * level * indent + header)
      header = ''
      level += 1

      sanitized.append(newline + fill * level * indent + stage)
      continue

    if tagMatch:
      sanitized.append(newline + fill * level * indent + stage)
      continue

    # handle opening tags
    tagMatch = reStartTag.match(stage)
    tagName = tagMatch and tagMatch.group(1)
    isTextBlock = tagName in textblocks

    if tagName and tagName in metadatas:
      sanitized.append(newline + fill * level * indent + stage)
      isMetadata = True
      level += 1
      continue

    if isTextBlock and header:

      sanitized.append(newline + fill * level * indent + header)
      header = ''
      level += 1

      sanitized.append(newline + fill * level * indent + stage)
      level += 1
      continue

    if isTextBlock:
      sanitized.append(newline + fill * level * indent + stage)
      level += 1
      continue

    if tagMatch and payload:
      sanitized.append(newline + fill * level * indent + payload)
      header = stage
      level += 1
      payload = ''
      continue

    if tagMatch and header:
      sanitized.append(newline + fill * level * indent + header)
      header = stage
      level += 1
      continue

    if tagMatch:
      header = stage
      continue

    # handle closing tags
    tagMatch = reEndTag.match(stage)
    tagName = tagMatch and tagMatch.group(1)

    if tagName and tagName in metadatas:
      level -= 1
      isMetadata = False
      sanitized.append(newline + fill * level * indent + stage)
      continue

    if tagMatch and payload:
      sanitized.append(newline + fill * level * indent + payload + stage)
      payload = ''
      continue

    if tagMatch and header:
      sanitized.append(newline + fill * level * indent + header)
      sanitized.append(newline + fill * level * indent + stage)
      header = ''
      continue

    if tagMatch:
      level -= 1
      sanitized.append(newline + fill * level * indent + stage)
      continue

    # handle text
    if isMetadata:
      sanitized.append(newline + fill * level * indent + stage)
      continue

    if header:
      payload = header + stage
      header = ''
      continue

    if stage.startswith(punctuations):
      sanitized.append(stage)
      continue

    sanitized.append(newline + fill * level * indent + stage)

  # strip any leading eols or spacings
  sanitized[0] = sanitized[0].lstrip()

  # stringify output
  return ''.join(sanitized)
