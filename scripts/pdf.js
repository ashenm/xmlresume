#!/usr/bin/env node
/**
 * XMLResume
 * https://github.com/ashenm/xmlresume
 * Generate intermediate resume PDF
 *
 * Ashen Gunaratne
 * mail@ashenm.dev
 *
 */

const path = require('path');
const puppeteer = require('puppeteer');
const argv = require('yargs').argv;

// ensure requisite arguments
if (!argv.source || !argv.output) {
  console.error(`${path.basename(argv.$0)}: Missing requisite argument(s)`);
  process.exit(2);
}

// generate pdf
puppeteer.launch({ args: [ '--no-sandbox' ], headless: "new" }).then(async browser => {

  const page = await browser.newPage();
  const response = await page.goto(argv.source);

  await page.pdf({
    path: argv.output,
    displayHeaderFooter: argv.hasOwnProperty('headers'),
    preferCSSPageSize: true,
    printBackground: true
  });

  await browser.close();

});

/* vim: set expandtab shiftwidth=2: */
