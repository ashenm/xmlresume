#!/usr/bin/env python3
# Generate Resume PDF

from os import P_WAIT, path, remove, spawnlp
from PyPDF2 import PdfFileReader, PdfFileWriter
from tempfile import NamedTemporaryFile

# denouement
output = PdfFileWriter()

# intermediate PDF
intermediate = NamedTemporaryFile(mode='wb')

# render intermediate PDF
spawnlp(P_WAIT, 'google-chrome', 'google-chrome', '--headless', '--no-sandbox',
  '--print-to-pdf={}'.format(intermediate.name), 'file:///{}'.format(path.abspath('resume.html')))

# construct denouement
with open(intermediate.name, 'rb') as file:

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
intermediate.close();
