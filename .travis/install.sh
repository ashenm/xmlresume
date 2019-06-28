#!/usr/bin/env sh
# Install XMLResume Build Dependencies

set -e

# python3 libraries
pip3 install --requirement requirements.txt

# node libraries
npm install puppeteer yargs
