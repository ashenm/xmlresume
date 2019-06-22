<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../resume.xsl" />

  <xsl:output method="html" version="5.0" encoding="UTF-8" media-type="text/html" />

  <xsl:template match="/">
    <xsl:apply-imports />
  </xsl:template>

  <xsl:template name="styles">

    html, body {
      margin: 0;
      background-color: #525659;
    }

    main {
      width: 210mm;
      margin: 2.5mm auto;
    }

    #resume {
      width: 210mm;
      min-height: 297mm;
      background-color: #FFF;
      transform-origin: top left;
      font-family: Garamond;
      font-size: 4mm;
    }

    #resume a {
      color: #007BFF;
      text-decoration: none;
    }

    #resume a:hover {
      text-decoration: underline;
    }

    #resume .title, #resume .subtitle,
    #resume .location, #resume .duration, #resume .record {
      font-size: inherit;
      font-weight: normal;
      margin: 0;
    }

    #resume .title {
      font-weight: bold;
    }

    #resume .subtitle {
      font-style: italic;
    }

    #resume .summary {
      margin: 1mm 0 0 0;
    }

    #resume > .metadata {
      text-align: center;
      padding: 15mm 0 15mm 0;
    }

    #resume > .metadata > .title {
      margin-bottom: 2mm;
      font-size: 8mm;
    }

    #resume > .metadata > .section {
      margin-bottom: 1mm;
    }

    #resume > .metadata > .section > .title {
      display: none;
    }

    #resume > .metadata > .section > .address {
      margin: 0.5mm 0 0.5mm 0;
      font-style: normal;
      font-size: 4.5mm;
    }

    #resume > .metadata > .section.sites > .record,
    #resume > .metadata > .section.contact > .record {
      font-family: monospace;
    }

    #resume > .section {
      display: flex;
      padding: 5mm 10mm 0 10mm;
    }

    #resume > .section > .titles {
      flex: 0 0 30mm;
    }

    #resume > .section > .titles > .title {
      font-weight: normal;
      font-style: italic;
    }

    #resume > .section > .records {
      flex: 1 1 100%;
    }

    #resume > .section > .records > .record {
      flex-wrap: wrap;
      break-inside: avoid;
      display: flex;
    }

    #resume > .section > .records > .record > .title,
    #resume > .section > .records > .record > .subtitle,
    #resume > .section > .records > .record > .location,
    #resume > .section > .records > .record > .duration {
      flex: 0 0 50%;
    }

    #resume > .section > .records > .record > .location,
    #resume > .section > .records > .record > .duration {
      text-align: right;
    }

    #resume > .section > .records > .record > .article {
      margin: 1mm 0 0 0;
      padding: 0 0 0 2.5ch;
      list-style-type: disc;
      flex-wrap: wrap;
      display: flex;
    }

    #resume > .section > .records > .record > .article > .property {
      flex: 0 0 50%;
      display: list-item;
      margin: 0 0 0.5mm 0;
    }

    #resume > .section > .records > .record:not(:first-of-type) {
      padding: 5mm 0 0 0;
    }

    #resume > .section > .records > .list {
      list-style-type: none;
      padding: 0;
      margin: 0;
    }

    #resume > .section > .records > .list > .item,
    #resume > .section > .records > .list > .item > .record {
      display: inline;
      /* font-weight: inherit; */
      /* font-size: inherit; */
      margin: 0;
    }

    #resume > .section > .records > .list > .item:not(:last-of-type) > .record::after {
      content: ", ";
    }

    #resume > .section > .records > .list > .item:first-of-type > .record {
      text-transform: capitalize;
    }

    @media print {

      /* fill resume edge-to-edge  */
      main { margin: 0; }

      /* reset transformations */
      /* reduce margins to event height */
      #resume { height: calc(100% - 20mm)!important; transform: initial!important; }

      /* remove hyperlink styles */
      #resume a { color: inherit; }
    
    }

    @page {
      size: A4 portrait;
      margin: 10mm 0 10mm 0;
    }

  </xsl:template>

  <xsl:template name="scripts">

    var scale = function scaleElementResume () {

      var resume = document.getElementById('resume');

      // dimensions in pixels
      var styles = window.getComputedStyle(resume);
      var height = styles.height.replace('px', '');
      var width = styles.width.replace('px', '');

      // mm to pixel ratio
      var ratio = styles.minHeight.replace('px', '') / 297;

      // height document to tally number of pages
      resume.style.height = Math.ceil(height / ratio / 297) * 297 + 'mm';

      // shadow reference container element
      resume.container = resume.parentElement;

      // scale only on smaller devices
      // remove any exsisting transformations on larger devices
      if (window.matchMedia('(min-width: 210mm)').matches) {
        resume.container.style.height = '';
        resume.container.style.width = '';
        resume.style.transform = '';
        return;
      }

      // dimensions after transform
      resume.container.width = document.documentElement.clientWidth - ratio * 5;
      resume.scale = resume.container.width / width;
      resume.container.height = resume.scale * window.getComputedStyle(resume.container).height.replace('px', '');

      // transform elements
      resume.container.style.height = resume.container.height + 'px';
      resume.container.style.width = resume.container.width + 'px';
      resume.style.transform = 'scale(' + resume.scale + ')';

    };

    // TEMP avoid page breaks after section titles
    // https://bugs.webkit.org/show_bug.cgi?id=5097
    // https://bugzilla.mozilla.org/show_bug.cgi?id=132035
    document.addEventListener('DOMContentLoaded', function () { document.querySelectorAll('#premier > .section > .title').forEach(function (e) { e.style.height = + window.getComputedStyle(e).height.replace('px', '') + + (e.style.marginBottom = -1 * e.parentElement.querySelector('.record').clientHeight + 'px').replace(/-|px/g, '') + 'px'; }); }, false);

    // transform dates on initial load
    document.addEventListener('DOMContentLoaded', function () { document.querySelectorAll('.date').forEach(function (e) { e.innerText = e.dataset.utc &amp;&amp; (new Date(e.dataset.utc)).toLocaleString('en', { month: 'long', year: 'numeric' }) || 'Present'; }); }, false);

    // scale on initial load and and on viewport resizing
    document.addEventListener('DOMContentLoaded', scale, false);
    window.addEventListener('resize', scale, false);

  </xsl:template>

  <xsl:template name="body">
    <header>
    </header>
    <main>
      <xsl:apply-templates select="/resume" />
    </main>
    <footer>
    </footer>
  </xsl:template>

  <xsl:template match="/resume">
    <div id="resume">
      <div class="metadata">
        <xsl:apply-templates select="metadata" />
      </div>
      <xsl:for-each select="/resume/section">
        <div class="section"><xsl:apply-templates select="." /></div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="/resume/metadata">
    <h1 class="title"><xsl:value-of select="name" /></h1>
    <address class="section">
      <p class="address">
        <xsl:value-of select="address/street" />,
        <span class="city"><xsl:value-of select="address/city" /></span>,
        <xsl:value-of select="address/zip" />
        <span>
          <xsl:attribute name="data-isocode">
            <xsl:value-of select="address/country/@isocode" />
          </xsl:attribute>
          <xsl:value-of select="address/country" />
        </span>
      </p>
    </address>
    <div class="section sites">
      <h2 class="title">sites</h2>
      <xsl:for-each select="sites/site">
        <h3 class="record"><xsl:value-of select="." /></h3>
      </xsl:for-each>
    </div>
    <div class="section contact">
      <h2 class="title">contact</h2>
      <h3 class="record">
        <a>
          <xsl:attribute name="href"><xsl:value-of select="contact/mobile/@href" /></xsl:attribute>
          <xsl:value-of select="contact/mobile" />
        </a>
      </h3>
      <h3 class="record">
        <a>
          <xsl:attribute name="href"><xsl:value-of select="contact/email/@href" /></xsl:attribute>
          <xsl:value-of select="contact/email" />
        </a>
      </h3>
    </div>
  </xsl:template>

  <xsl:template match="/resume/section">
	<div class="titles">
	  <h2 class="title"><xsl:value-of select="title" /></h2>
	</div>
	<div class="records">
      <xsl:if test="not(list)">
	    <xsl:for-each select="record">
		  <div class="record"><xsl:apply-templates select="." /></div>
	    </xsl:for-each>
      </xsl:if>
	  <xsl:if test="boolean(list)">
		<ul class="list">
          <xsl:for-each select="list/item">
            <li class="item"><h3 class="record"><xsl:value-of select="." /></h3></li>
          </xsl:for-each>
        </ul>
	  </xsl:if>
	</div>
  </xsl:template>

  <xsl:template match="/resume/section/record">
    <h3 class="title"><xsl:value-of select="title" /></h3>
	<p class="location"><xsl:apply-templates select="location" /></p>
    <h4 class="subtitle">
      <xsl:if test="not(transcript)">
        <xsl:value-of select="subtitle" />
      </xsl:if>
      <xsl:if test="boolean(transcript)">
        <a>
          <xsl:attribute name="href"><xsl:value-of select="transcript" /></xsl:attribute>
          <xsl:value-of select="subtitle" />
        </a>
      </xsl:if>
    </h4>
	<p class="duration"><xsl:apply-templates select="duration" /></p>
	<p class="summary"><xsl:value-of select="summary" disable-output-escaping="yes" /></p>
    <xsl:if test="boolean(articles)">
      <dl class="article"><xsl:apply-templates select="articles" /></dl>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/resume/section/record/location">
    <span class="city">
      <xsl:value-of select="city" />
    </span>,
    <span class="country">
      <xsl:attribute name="data-isocode"><xsl:value-of select="@isocode" /></xsl:attribute>
      <xsl:value-of select="country" />
    </span>
  </xsl:template>

  <xsl:template match="/resume/section/record/duration">
    <span class="date">
      <xsl:attribute name="data-utc"><xsl:value-of select="@start" /></xsl:attribute>  
    </span>
    -
    <span class="date">
      <xsl:attribute name="data-utc"><xsl:value-of select="@end" /></xsl:attribute>
    </span>
  </xsl:template>

  <xsl:template match="/resume/section/record/articles">
    <xsl:for-each select="article">
      <dt class="property"><xsl:value-of select="property" /></dt>
      <dd class="value"><xsl:value-of select="value" /></dd>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
