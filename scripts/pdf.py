#!/usr/bin/env python3
#
# XMLResume
# https://github.com/ashenm/xmlresume
# Generate resume PDF
#
# Ashen Gunaratne
# mail@ashenm.dev
#

from os import P_WAIT, path, remove, spawnlp
from os.path import basename
from pypdf import PdfReader, PdfWriter
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
output = PdfWriter()

# intermediate docs
intermediate = NamedTemporaryFile(mode='wb')
forefront = NamedTemporaryFile(mode='wb')

# render intermediate PDF
spawnlp(P_WAIT, 'node', 'node', 'scripts/pdf.js', '--output={}'.format(intermediate.name), '--source=file:///{}'.format(path.abspath('resume.html')))

# construct denouement
with open(intermediate.name, 'rb') as resume, open(forefront.name, 'rb') as forepart:

  intermediate.pdf = PdfReader(resume)
  forefront.pages = len(intermediate.pdf.pages)

  forefront.canvas = Canvas(filename=forefront.name, pagesize=A4, initialFontName='Helvetica')

  # no header or footer on first page
  forefront.canvas.showPage()

  # register custom fonts
  if args.font:
    pdfmetrics.registerFont(TTFont('{}'.format(basename(args.font)), '{}.ttf'.format(args.font)))
    forefront.canvas.setFont('{}'.format(basename(args.font)), forefront.canvas._fontsize)

  # construct page headers and footers
  for i in range(2, forefront.pages + 1):
    forefront.canvas.setFont(basename(args.font) if args.font else forefront.canvas._fontname, args.font_size * mm)
    forefront.canvas.drawRightString(200 * mm, 287 * mm, '{}'.format(f'Ashen Gunaratne {i}/{forefront.pages}' if args.page_numbers else ''))
    forefront.canvas.showPage()

  # flush changes
  forefront.canvas.save()

  # read constructed custom headers
  forefront.pdf = PdfReader(forepart)

  # merge resume and headers
  for i in range(0, forefront.pages):
    intermediate.pdf.pages[i].merge_page(forefront.pdf.pages[i])
    output.add_page(intermediate.pdf.pages[i])

  # add metadata
  # https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/pdfmark_reference.pdf
  output.add_metadata({
    '/Subject': 'Curriculum Vitae',
    '/Creator': 'XMLResume (https://github.com/ashenm/xmlresume)',
    '/Title': 'Curriculum Vitae - Ashen Gunaratne',
    '/Author': 'Ashen Gunaratne'
  })

  # configure initial view
  output.page_layout = '/SinglePage'

  # write output
  with open('resume.pdf', 'wb') as file:
    output.write(file)

# delete intermediate docs
intermediate.close();
forefront.close();

# vim: set expandtab shiftwidth=2:
