#!/usr/bin/env python3
# Generate Resume PDF

from os import P_WAIT, path, remove, spawnlp
from PyPDF2 import PdfFileReader, PdfFileWriter

# denouement
output = PdfFileWriter()

# render intermediate PDF
spawnlp(P_WAIT, 'google-chrome', 'google-chrome', '--headless', '--disable-gpu', '--print-to-pdf=/tmp/resume.pdf', 'file:///{}'.format(path.abspath('standalone.html')))

# construct denouement
with open('/tmp/resume.pdf', 'rb') as file:

  # append pages
  output.appendPagesFromReader(PdfFileReader(file))

  # add metadata
  output.addMetadata({
    '/Subject': 'Curriculum Vitae',
    '/Creator': 'XMLResume (https://github.com/ashenm/xmlresume)',
    '/Title': 'Curriculum Vitae - Ashen Gunaratne',
    '/Author': 'Ashen Gunaratne'
  })

  # write output
  with open('resume.pdf', 'wb') as file:
    output.write(file)

# delete intermediate PDF
remove('/tmp/resume.pdf')
