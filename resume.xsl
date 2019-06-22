<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
  <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" media-type="text/html" />

  <xsl:template match="/">

    <html lang="en">
    <head>

      <meta name="author" content="Ashen Gunaratne" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="Curriculum Vitae of Ashen Gunaratne" />
      <meta name="keywords" content="ashen, gunaratne, homepage, bio, curriculum vitae, cv, resume" />

      <meta property="og:type" content="profile" />
      <meta property="og:profile:first_name" content="Ashen" />
      <meta property="og:profile:last_name" content="Gunaratne" />
      <meta property="og:profile:gender" content="male" />
      <meta property="og:image" content="https://avatars1.githubusercontent.com/u/16164426?s=400&amp;v=4" />
      <meta property="og:site_name" content="Ashen Gunaratne" />
      <meta property="og:title" content="R&#180;sum&#180; | Ashen Gunaratne" />
      <meta property="og:description" content="Curriculum Vitae of Ashen Gunaratne" />
      <meta property="og:url" content="https://www.ashenm.ml/resume" />
      <meta property="og:locale" content="en" />

      <title>Résumé | Ashen Gunaratne</title>
      
      <style>
        <xsl:call-template name="styles" />
      </style>

      <script>
        <xsl:call-template name="scripts" />
      </script>

    </head>
    <body>
      <xsl:call-template name="body" />
    </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
