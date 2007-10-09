<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:b4p="http://www.intalio.com/bpms/workflow/ib4p_20051115"
                xmlns:tms="http://www.intalio.com/BPMS/Workflow/TaskManagementServices-20051109/"
                version="1.0">

    <xsl:output method="xml"/>
    <xsl:param name="metadata"/>

   <!-- Change namespace for matching elements -->

    <xsl:template match="tms:claimAction">
        <xsl:call-template name="change">
            <xsl:with-param name="elements" select="$metadata/b4p:claimAction"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tms:revokeAction">
        <xsl:call-template name="change">
            <xsl:with-param name="elements" select="$metadata/b4p:revokeAction"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tms:saveAction">
        <xsl:call-template name="change">
            <xsl:with-param name="elements" select="$metadata/b4p:saveAction"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tms:completeAction">
        <xsl:call-template name="change">
            <xsl:with-param name="elements" select="$metadata/b4p:completeAction"/>
        </xsl:call-template>
    </xsl:template>

   <xsl:template name="change">
      <xsl:param name="elements"/>
      <xsl:for-each select="$elements">
          <xsl:element name="{local-name()}"
                       namespace="http://www.intalio.com/BPMS/Workflow/TaskManagementServices-20051109/">
              <xsl:if test="count(*) > 0">
                  <xsl:call-template name="change">
                      <xsl:with-param name="elements" select="*"/>
                  </xsl:call-template>
              </xsl:if>
              <xsl:apply-templates select="text()"/>
          </xsl:element>
      </xsl:for-each>
   </xsl:template>

    <!-- Identity transform for the rest -->
    <xsl:template match="*|@*|text()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>