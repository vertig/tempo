<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline"
	xmlns:oxf="http://www.orbeon.com/oxf/processors"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:delegation="http://orbeon.org/oxf/xml/delegation"
        xmlns:tas="http://www.intalio.com/BPMS/Workflow/TaskAttachmentService/"
        xmlns:tms="http://www.intalio.com/BPMS/Workflow/TaskManagementServices-20051109/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <p:param name="instance" type="input"/>
    <p:param name="data" type="output"/>

    <!-- Call TAS WS for TAS.add operation to add new attachment -->

    <!-- Prepare the SOAP body message -->
    <p:processor name="oxf:xslt">
        <p:input name="data" href="#instance"/>
        <p:input name="config">
            <delegation:execute service="tasWS" operation="addRequest" xsl:version="2.0">
                <tas:authCredentials>
                    <tas:participantToken>
                        <xsl:value-of select="//@participantToken"/>
                    </tas:participantToken>
                    <tas:authorizedUsers>
                        <xsl:for-each select="/attachments/owners/userOwner">
                            <tas:user><xsl:value-of select="."/></tas:user>
                        </xsl:for-each>
                    </tas:authorizedUsers>
                    <tas:authorizedRoles>
                        <xsl:for-each select="/attachments/owners/roleOwner">
                            <tas:role><xsl:value-of select="."/></tas:role>
                        </xsl:for-each>
                    </tas:authorizedRoles>
                </tas:authCredentials>
                <tas:attachmentMetadata>
                    <tas:mimeType>text/plain</tas:mimeType>
                </tas:attachmentMetadata>
                <tas:plaintext>
                    <xsl:value-of select="/attachments/new/plaintext"/>
                </tas:plaintext>
            </delegation:execute>
        </p:input>
        <p:output name="data" id="addRequest"/>
    </p:processor>

    <!-- Call TAS.add -->
    <p:processor name="oxf:delegation">
        <p:input name="interface">
            <config>
                <service id="tasWS" type="webservice"
                    endpoint="http://localhost:8080/axis2/services/tas">
                    <operation nsuri="http://www.intalio.com/BPMS/Workflow/TaskAttachmentService/" name="addRequest" soap-action="add"/>
                </service>
            </config>
        </p:input>
        <p:input name="call" href="#addRequest"/>
        <p:output name="data" id="addResponse"/>
    </p:processor>

    <!-- Call TMS WS for TMS.add operation to add new attachment -->
    <!-- Prepare the SOAP message body -->
    <p:processor name="oxf:xslt">
        <p:input name="data" href="#instance"/>
        <p:input name="tasResponse" href="#addResponse"/>
        <p:input name="config">
            <delegation:execute service="TaskManagementServiceWS" operation="addAttachmentRequest" xsl:version="2.0">
                <tms:taskId>
                    <xsl:value-of select="/*/@taskId"/>
                </tms:taskId>
                <tms:attachment>
                    <tms:attachmentMetadata>
                        <tms:mimeType>text/plain</tms:mimeType>
                        <tms:fileName>plain::text</tms:fileName>
                        <tms:title><xsl:value-of select="/attachments/new/@title"/></tms:title>
                        <!--<tms:description>Deprecated</tms:description>-->
                        <!--<tms:creationDate>2001-12-17T09:30:47.0Z</tms:creationDate>-->
                    </tms:attachmentMetadata>
                    <tms:payloadUrl><xsl:value-of select="doc('input:tasResponse')/tas:url"/></tms:payloadUrl>
                </tms:attachment>
                <tms:participantToken>
                    <xsl:value-of select="/*/@participantToken"/>
                </tms:participantToken>
            </delegation:execute>
        </p:input>
        <p:output name="data" id="addAttachmentTMS"/>
    </p:processor>

    <!-- Call for TMS.addAttachment -->
    <p:processor name="oxf:delegation">
        <p:input name="interface">
            <config>
                <service id="TaskManagementServiceWS" type="webservice"
                    endpoint="http://localhost:8080/axis2/services/TaskManagementServices">
                    <operation nsuri="http://www.intalio.com/BPMS/Workflow/TaskManagementServices-20051109/"
                               name="addAttachmentRequest" soap-action="addAttachment"/>
                </service>
            </config>
        </p:input>
        <p:input name="call" href="#addAttachmentTMS"/>
        <!-- This output is never used, but should be here as otherwise Orbeon XPL engine consider that calling
        processor which output is not referenced further does not makes sense -->
        <p:output name="data" ref="data"/>
    </p:processor>

</p:config>
