#!/usr/bin/env python3
#
# XMLResume
# https://github.com/ashenm/xmlresume
# Generate and prettify resume.html
#
# Ashen Gunaratne
# mail@ashenm.ml
#

from lxml import etree
from bs4 import BeautifulSoup
from reindent import reindent
from os.path import join
from sys import argv

# resume theme
theme = dict(enumerate(argv)).get(1, 'default.xsl')

# translate resume
xsl = etree.XSLT(etree.parse(source=join('themes', theme)))
document = str(xsl(etree.parse(source='resume.xml')))

# prettify html
soup = BeautifulSoup(markup=document, features='lxml')

# write prettified output
with open(file='resume.html', mode='w', encoding='utf_8') as file:
  file.write(reindent(markup=soup.prettify(encoding=None, formatter='html')))

# vim: set expandtab shiftwidth=2:
