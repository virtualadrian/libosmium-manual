<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/html/chunk.xsl"/>

    <xsl:param name="html.stylesheet" select="'manual.css'"/>
    <xsl:param name="chunker.output.indent" select="'yes'"/>
    <xsl:param name="header.rule" select="0"/>
    <xsl:param name="footer.rule" select="0"/>

    <xsl:template name="user.header.navigation">
        <div>MENU</div>
    </xsl:template>

</xsl:stylesheet>
