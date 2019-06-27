#!/usr/bin/env python3
# Generate Resume PDF

from os import P_WAIT, path, remove, spawnlp
from PyPDF2 import PdfFileReader, PdfFileWriter
from tempfile import NamedTemporaryFile
from argparse import ArgumentParser
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm

# parse arguments
parser = ArgumentParser()
parser.add_argument('--page-numbers', action='store_true', help='Display page numbers on top-right corner')
args = parser.parse_args()

# denouement
output = PdfFileWriter()

# intermediate docs
intermediate = NamedTemporaryFile(mode='wb')
forefront = NamedTemporaryFile(mode='wb')

# render intermediate PDF
spawnlp(P_WAIT, 'google-chrome', 'google-chrome', '--headless', '--no-sandbox',
  '--print-to-pdf={}'.format(intermediate.name), 'file:///{}'.format(path.abspath('resume.html')))

# construct denouement
with open(intermediate.name, 'rb') as resume, open(forefront.name, 'rb') as forepart:

  intermediate.pdf = PdfFileReader(resume)
  forefront.pages = intermediate.pdf.getNumPages()

  forefront.canvas = Canvas(filename=forefront.name, pagesize=A4)

  # no header or footer on first page
  forefront.canvas.showPage()

  # header and footer styles
  forefront.canvas.setFont('Times-Roman', 4 * mm)

  # construct page headers and footers
  for i in range(2, forefront.pages + 1):
    forefront.canvas.drawRightString(200 * mm, 287 * mm, '{}'.format(f'Ashen Gunaratne {i}/{forefront.pages}' if args.page_numbers else ''))
    forefront.canvas.showPage()

  # flush changes
  forefront.canvas.save()

  # read constructed custom headers
  forefront.pdf = PdfFileReader(forepart)

  # merge resume and headers
  for i in range(0, forefront.pages):
    intermediate.pdf.getPage(i).mergePage(forefront.pdf.getPage(i))
    output.addPage(intermediate.pdf.getPage(i))

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

# delete intermediate docs
intermediate.close();
forefront.close();
