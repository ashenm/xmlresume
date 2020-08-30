#!/usr/bin/env python3
# Generate Resume PDF

from os import P_WAIT, path, remove, spawnlp
from os.path import basename
from PyPDF2 import PdfFileReader, PdfFileWriter
from tempfile import NamedTemporaryFile
from argparse import ArgumentParser
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm

# parse arguments
parser = ArgumentParser()
parser.add_argument('--page-numbers', action='store_true', help='Display page numbers on top-right corner')
parser.add_argument('--font', metavar='FONT', help='Specify display font for header and footer (default: \'Helvetica\')')
parser.add_argument('--font-size', default=1, type=float, metavar='SIZE', help='Specify display font size for header and footer (default: \'1mm\')')
args = parser.parse_args()

# denouement
output = PdfFileWriter()

# intermediate docs
intermediate = NamedTemporaryFile(mode='wb')
forefront = NamedTemporaryFile(mode='wb')

# render intermediate PDF
spawnlp(P_WAIT, 'node', 'node', 'scripts/pdf.js', '--output={}'.format(intermediate.name), '--source=file:///{}'.format(path.abspath('resume.html')))

# construct denouement
with open(intermediate.name, 'rb') as resume, open(forefront.name, 'rb') as forepart:

  intermediate.pdf = PdfFileReader(resume)
  forefront.pages = intermediate.pdf.getNumPages()

  forefront.canvas = Canvas(filename=forefront.name, pagesize=A4, initialFontName='Helvetica')

  # no header or footer on first page
  forefront.canvas.showPage()

  # register custom fonts
  if args.font:
    pdfmetrics.registerFont(TTFont('{}'.format(basename(args.font)), '{}.ttf'.format(args.font)))
    forefront.canvas.setFont('{}'.format(basename(args.font)), forefront.canvas._fontsize)

  # header and footer styles
  forefront.canvas.setFontSize(args.font_size * mm)

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

  # configure initial view
  output.setPageLayout('/SinglePage')

  # write output
  with open('resume.pdf', 'wb') as file:
    output.write(file)

# delete intermediate docs
intermediate.close();
forefront.close();
