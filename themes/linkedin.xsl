<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" media-type="text/html" />

  <xsl:template match="/resume">

    ---
    title: Résumé | Ashen Gunaratne
    desc: Curriculum Vitae of Ashen Gunaratne
    ---

    {%- capture metadata -%}

      <style>

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
          font-family: sans-serif;
          display: flex;
        }

        #resume a {
          color: #007BFF;
          text-decoration: none;
        }

        #resume a:hover {
          text-decoration: underline;
        }

        #resume .title, #resume .subtitle,
        #resume .duration, #resume .location {
          font-weight: normal;
          margin: 0 0 0.5mm 0;
        }

        #resume .font-italic {
          font-style: italic;
        }

        #sidebar, #premier {
          padding: 15mm 7mm 5mm 7mm;
        }

        #sidebar {
          color: #E1E1E1E1;
          background-color: #293E49;
          flex: 0 0 22.5%;
        }

        #sidebar > .section > .title {
          margin: 0 0 4mm 0;
          font-size: 5mm;
        }

        #sidebar > .section > .record {
          margin: 1mm 0;
          font-size: 3.5mm;
        }

        #sidebar > .section + .section {
          padding-top: 8mm;
        }

        #sidebar > .section + .section > .record {
          text-transform: capitalize;
        }

        #sidebar > .section:first-child > a.site,
        #sidebar > .section:first-child > a.contact {
          display: block;
          font-style: normal;
          text-decoration: none;
          color: inherit;
        }

        #sidebar > .section:first-child > a.site > span {
          color: #949494;
          font-size: 4mm;
          display: block;
        }

        #sidebar > .section:first-child > a.site > span::before {
          content: " ";
        }

        /* mobile number */
        #sidebar > .section:first-child > .contact:nth-child(2) {
          cursor: initial;
          margin: 5mm 0 1mm 0;
        }

        /* email address */
        #sidebar > .section:first-child > .contact:nth-child(3) {
          margin: 0 0 5mm 0;
        }

        /* name */
        #premier > div:first-child > h1 {
          font-size: 7.5mm;
        }

        /* heading */
        #premier > div:first-child > p {
          font-size: 5mm;
          margin: 0;
        }

        #premier > .section > .title {
          font-size: 4.5mm;
          break-inside: avoid;
          text-transform: capitalize;
          padding: 7.5mm 0 1.5mm 0;
        }

        #premier > .section > .title::before {
          width: 15mm;
          height: 0.75mm;
          display: block;
          background: #9E9E9E;
          margin-bottom: 2.75mm;
          content: "";
        }

        #premier > .section > .record {
          padding-top: 3.5mm;
          break-inside: avoid;
        }

        #premier > .section > ul.record {
          margin: 0;
          padding-inline-start: 0;
        }

        #premier > .section > ul.record > li {
          display: inline;
        }

        #premier > .section > ul.record > li:not(:last-of-type):after {
          content: ","
        }

        #premier > .section > .record > .title {
          font-weight: bold;
          font-size: 4mm;
        }

        #premier > .section > .record > .subtitle {
          font-size: 3.75mm;
        }

        #premier > .section > .record > .duration,
        #premier > .section > .record > .location {
          font-size: 3.55mm;
          margin-bottom: 0.25mm;
        }

        #premier > .section > .record > .location {
          color: #B1B1B1;
        }

        #premier > .section > .record > .summary,
        #premier > .section > .record > .article {
          font-size: 3.75mm;
          margin: 1mm 0 0 0;
        }

        #premier > .section > .record > .article {
          flex-wrap: wrap;
          list-style-type: disc;
          padding-inline-start: 2.5ch;
          display: flex;
        }

        #premier > .section > .record > .article > dt {
          flex: 0 0 50%;
          display: list-item;
          margin: 0 0 1mm 0;
        }

        @media print {

          /* fill resume edge-to-edge  */
          main { margin: 0; }

          /* reset transformations */
          #resume { transform: initial!important; }

          /* remove hyperlink styles */
          #resume a { color: inherit; }

        }

        @media screen {
          #resume { box-shadow: 0 0 2.5mm; }
        }

        @page {
          margin: 0;
          size: A4 portrait;
        }

      </style>

    {%- endcapture -%}

    {%- capture scripts -%}

      <script>

        var scale = function scaleElementResume () {

          var resume = document.getElementById('resume');

          // dimensions in pixels
          var styles = window.getComputedStyle(resume);
          var height = styles.height.replace('px', '');
          var width = styles.width.replace('px', '');

          // mm to pixel ratio
          var ratio = styles.minHeight.replace('px', '') / 297;

          // height sidebar to tally number of pages
          resume.style.height = Math.ceil(height / ratio / 297) * 297 + 'mm';

          // shadow reference container element
          resume.container = resume.parentElement;

          // scale only on smaller devices
          // remove any exsisting transformations
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

      </script>

    {%- endcapture -%}

    {%- capture body -%}
      <header>
      </header>
      <main>
        <div id="resume">
          <aside id="sidebar">
            <xsl:apply-templates select="metadata" />
          </aside>
          <div id="premier">
            <div>
              <h1 class="title"><xsl:value-of select="metadata/name" /></h1>
              <p><xsl:value-of select="metadata/summary" /></p>
            </div>
            <xsl:for-each select="section[title != 'research interests']" >
              <div class="section"><xsl:apply-templates select="." /></div>
            </xsl:for-each>
          </div>
        </div>
      </main>
      <footer>
      </footer>
    {%- endcapture -%}

    {%- include base.html -%}

  </xsl:template>

  <xsl:template match="/resume/metadata">
    <div class="section">
      <h1 class="title">Contact</h1>
      <a class="record contact">
        <xsl:attribute name="href">javascript:void(0)</xsl:attribute>
        <xsl:value-of select="contact/mobile" />
      </a>
      <a class="record contact">
        <xsl:attribute name="href">mailto:<xsl:value-of select="contact/email" /></xsl:attribute>
        <xsl:value-of select="contact/email" />
      </a>
      <xsl:for-each select="sites/site">
        <a class="record site">
          <xsl:attribute name="href">https://<xsl:value-of select="." /></xsl:attribute>
          <xsl:value-of select="." /><span>(<xsl:value-of select="@name" />)</span>
        </a>
      </xsl:for-each>
    </div>
    <xsl:if test="boolean(../section/title = 'research interests')">
      <div class="section">
        <h1 class="title">Research Interests</h1>
        <xsl:for-each select="../section[title='research interests']/list/item">
          <p class="record"><xsl:value-of select="." /></p>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/resume/section">
    <xsl:if test="not(list)">
      <h2 class="title"><xsl:value-of select="title" /></h2>
      <xsl:for-each select="record">
        <xsl:apply-templates select="." />
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="boolean(list)">
      <h1 class="title"><xsl:value-of select="title" /></h1>
      <ul class="record">
        <xsl:for-each select="list/item">
          <li><xsl:value-of select="." /></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/resume/section/record">
    <div class="record">
      <h4 class="title"><xsl:value-of select="title" /></h4>
      <h5 class="subtitle"><xsl:apply-templates select="subtitle" /></h5>
      <p class="duration"><xsl:apply-templates select="duration" /></p>
      <xsl:if test="boolean(location)">
        <p class="location"><xsl:apply-templates select="location" /></p>
      </xsl:if>
      <p class="summary"><xsl:value-of select="summary" disable-output-escaping="yes" /></p>
      <xsl:if test="boolean(articles)">
        <dl class="article"><xsl:apply-templates select="articles" /></dl>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="/resume/section/record/subtitle">
    <xsl:if test="not(../transcript)">
      <xsl:value-of select="." />
    </xsl:if>
    <xsl:if test="boolean(../transcript)">
      <a class="transcript">
        <xsl:attribute name="href"><xsl:value-of select="../transcript" /></xsl:attribute>
        <xsl:value-of select="." />
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/resume/section/record/articles">
    <xsl:for-each select="article">
      <dt><xsl:value-of select="property" /></dt>
      <dd><xsl:value-of select="value" /></dd>
    </xsl:for-each>
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

  <xsl:template match="/resume/section/record/location">
    <span class="city">
      <xsl:value-of select="city" />
    </span>,
    <span class="country">
      <xsl:attribute name="data-isocode"><xsl:value-of select="@isocode" /></xsl:attribute>
      <xsl:value-of select="country" />
    </span>
  </xsl:template>

</xsl:stylesheet>
