<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:geo="http://www.geosoft.com/schema/geo" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:geox="http://www.geosoft.com/schema/iso_geophysics_extension" xmlns:xlink="http://www.w3.org/1999/xlink">
  <!--created September-24-14 2:32:23 PM-->
  <xsl:output method="html" />
  <xsl:template match="/">
    <html>
      <head>
        <style type="text/css">
		hr.thick_seperator {color:#0000CC;}
		hr.thin_seperator {color:#0000FF;height:1px;}
		div.summary {font:13px Arial;margin-bottom:5px;cursor:pointer;background-color:rgb(226,238,255);border:1px #0000FF solid;padding:4px;}
		div.summary h4 {text-align:center;margin:2px;}
		div.summary table tr th {font-weight:normal;text-align:left;vertical-align:top;padding:2px;color:#0000CC;}
		div.summary table tr td {text-align:left;vertical-align:top;padding:2px 2px 2px 2em;}
		table.lineage {margin-left:15px;border-collapse:collapse;background-color:rgb(226,238,255);}
		tr.lineageHeading {color:#0000FF;font-weight:bold;background-color:#0000CC;}
		th.lineageHeader {border:1px #0000FF solid;}
		tr.lineageRow {color:#0000CC;}
		td.lineage {border:1px #0000FF solid;}
		span.label {font:11px Arial;color:#000;margin-right:1em;}
		span.text {font:11px Arial;color:#0000CC;}
		a.text {font:11px Arial;color:#0000CC;text-decoration:underline}
		span.category {font:11px Arial;color:#0000CC;font-weight:bold;font-style:italic;}
		div.section_title {cursor:pointer;}
		a.section {font:11px Arial;color:#0000CC;font-style:italic;text-decoration:underline}
		span.section {font-family:Monospace;}
		a.backtotop {font-size:8pt;color:#0000CC;text-decoration:underline;display:block;margin-top:8px;}
		div.level1 {font:11px Arial;margin-left:15px;}
		div.level1Title {font:11px Arial;margin-left:15px;margin-bottom:5px;}
		div.level1TitleWithSpacingAbove {margin-left:15px;margin-bottom:5px;margin-top:5px;}
		div.level2 {font:11px Arial;margin-left:25px;}
		div.spacer {margin-bottom:10px;}
		div.section {display:block;cursor:default;}
		div.inlinelabel {color:#000;margin-right:1em;float:left;}
		div.inlinetext {display:block;vertical-align:top;color:#0000CC;float:left;}
		div.extents {font:11px Arial;margin-left:15px;}
		div.extents table tr th {font:11px Arial;text-align:left;padding-right:1em;}
		div.extents table tr td {font:11px Arial;text-align:left;color:#0000CC;}
				</style>
        <script type="text/javascript">
		function ToggleSection(strSectionId) {
			oSection = document.getElementById(strSectionId);
			oSectionStatus = document.getElementById(strSectionId + "Status");
			if (oSection.style.display == "block" || oSection.style.display == "") {
				oSection.style.display = "none";
				oSectionStatus.innerHTML = "+";
			} else {
				oSection.style.display = "block";
				oSectionStatus.innerHTML = "-";
			}
		}
				</script>
      </head>
      <body>
        <a id="top" />
        <!--summary section-->
        <div class="summary">
          <h4>Geological Survey of Canada - Geophysical Data</h4>
          <table>
            <tr>
              <th>Dataset title</th>
              <td>
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" />
              </td>
            </tr>
            <tr>
              <th>Description</th>
              <td>
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString" />
                </xsl:call-template>
              </td>
            </tr>
          </table>
        </div>
        <!--link section-->
        <div>
          <span class="category">Metadata:</span>
        </div>
        <div class="level1">
          <a class="section" href="#pSingleDatasetGeneral">General</a>
        </div>
        <div class="level1">
          <a class="section" href="#pSingleDatasetData">Data</a>
        </div>
        <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:tieLineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:averagesensorheight/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftType/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument6/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftPositionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyComments/gco:CharacterString) ">
          <div class="level1">
            <a class="section" href="#pAirborne">Airborne Geophysics</a>
          </div>
        </xsl:if>
        <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:tieLineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:averagesensorheight/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:platform/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument6/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument7/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument8/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument9/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument10/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument11/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument12/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:positionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:completionDate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyAcquisitionYearRange/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyComments/gco:CharacterString) ">
          <div class="level1">
            <a class="section" href="#pCompilation">Compilation</a>
          </div>
        </xsl:if>
        <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMode/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingInterval/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:positionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyComments/gco:CharacterString) ">
          <div class="level1">
            <a class="section" href="#pGround">Ground Geophysics</a>
          </div>
        </xsl:if>
        <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:drillholeID/gco:Integer) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:startDepth/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:endofHole/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingInterval/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:positionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyComments/gco:CharacterString) ">
          <div class="level1">
            <a class="section" href="#pBorehole">Borehole</a>
          </div>
        </xsl:if>
        <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:vesselType/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:Instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument6/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:positioningMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyComments/gco:CharacterString) ">
          <div class="level1">
            <a class="section" href="#pMarine">Marine Geophysics</a>
          </div>
        </xsl:if>
        <div class="level1">
          <a class="section" href="#pProjection">Coordinate System</a>
        </div>
        <hr class="thick_seperator" />
        <!--content section-->
        <xsl:call-template name="pSingleDatasetGeneral" />
        <xsl:call-template name="pSingleDatasetData" />
        <xsl:call-template name="pSingleDatasetLocation" />
        <xsl:call-template name="pAirborne" />
        <xsl:call-template name="pCompilation" />
        <xsl:call-template name="pGround" />
        <xsl:call-template name="pBorehole" />
        <xsl:call-template name="pMarine" />
        <xsl:call-template name="pProjection" />
      </body>
    </html>
  </xsl:template>
  <!--General-->
  <xsl:template name="pSingleDatasetGeneral">
    <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:opendate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/geox:dataWebURL/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation/gco:CharacterString) ">
      <a id="pSingleDatasetGeneral" />
      <div class="section_title">
        <a onclick="javascript:ToggleSection('pSingleDatasetGeneralSection')">
          <span class="section" id="pSingleDatasetGeneralSectionStatus">-</span>
          <span class="category">General</span>
        </a>
        <div class="section" id="pSingleDatasetGeneralSection">
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString)">
            <div class="level1">
              <span class="label">Dataset title:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString)">
            <div class="level1">
              <span class="label">Project number:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:opendate/gco:Date)">
            <div class="level1">
              <span class="label">Open date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:opendate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Description:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/geox:dataWebURL/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Web URL:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-url">
                  <xsl:with-param name="url" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/geox:dataWebURL/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Supporting documents:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-urls">
                  <xsl:with-param name="urls" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword)&gt;0">
            <div class="level1">
              <div class="inlinelabel">Keywords:</div>
              <div class="inlinetext">
                <xsl:for-each select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword">
                  <xsl:value-of select="gco:CharacterString" />
                  <xsl:if test="position()!=count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword)">
                    <br />
                  </xsl:if>
                </xsl:for-each>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
        </div>
      </div>
      <a class="backtotop" href="#top">Back To Top</a>
      <hr class="thin_seperator" />
    </xsl:if>
  </xsl:template>
  <!--Data-->
  <xsl:template name="pSingleDatasetData">
    <xsl:if test="boolean(//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/geox:dataSourceType/gco:CharacterString) or boolean(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceSpecificUsage/gmd:MD_Usage/geox:classification/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceSpecificUsage/gmd:MD_Usage/geox:restriction/gco:CharacterString) or boolean(//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:DescriptionDetails/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:AdminstrationContractor/gmd:MD_ProgressCode) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:ProcessingContractor/gmd:MD_ProgressCode) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:InterpretationContractor/gmd:MD_ProgressCode) or boolean(//gmd:metadataEntity/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString) or boolean(//gmd:metadataEntity/gmd:MD_Metadata/gmd:dateStamp/gco:Date) ">
      <a id="pSingleDatasetData" />
      <div class="section_title">
        <a onclick="javascript:ToggleSection('pSingleDatasetDataSection')">
          <span class="section" id="pSingleDatasetDataSectionStatus">-</span>
          <span class="category">Data</span>
        </a>
        <div class="section" id="pSingleDatasetDataSection">
          <xsl:if test="boolean(//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/geox:dataSourceType/gco:CharacterString)">
            <div class="level1">
              <span class="label">Data source:</span>
              <span class="text">
                <xsl:value-of select="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/geox:dataSourceType/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString)">
            <div class="level1">
              <span class="label">Data format:</span>
              <span class="text">
                <xsl:value-of select="//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceSpecificUsage/gmd:MD_Usage/geox:classification/gco:CharacterString)">
            <div class="level1">
              <span class="label">Classification:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceSpecificUsage/gmd:MD_Usage/geox:classification/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceSpecificUsage/gmd:MD_Usage/geox:restriction/gco:CharacterString)">
            <div class="level1">
              <span class="label">Restriction:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceSpecificUsage/gmd:MD_Usage/geox:restriction/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:DescriptionDetails/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Restriction details:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:DescriptionDetails/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:AdminstrationContractor/gmd:MD_ProgressCode)">
            <div class="level1">
              <span class="label">Administration contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:AdminstrationContractor/gmd:MD_ProgressCode" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:ProcessingContractor/gmd:MD_ProgressCode)">
            <div class="level1">
              <span class="label">Processing contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:ProcessingContractor/gmd:MD_ProgressCode" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:InterpretationContractor/gmd:MD_ProgressCode)">
            <div class="level1">
              <span class="label">Interpretation contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:InterpretationContractor/gmd:MD_ProgressCode" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:metadataEntity/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString)">
            <div class="level1">
              <span class="label">Metadata created by:</span>
              <span class="text">
                <xsl:value-of select="//gmd:metadataEntity/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:metadataEntity/gmd:MD_Metadata/gmd:dateStamp/gco:Date)">
            <div class="level1">
              <span class="label">Metadata creation date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:metadataEntity/gmd:MD_Metadata/gmd:dateStamp/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
        </div>
      </div>
      <a class="backtotop" href="#top">Back To Top</a>
      <hr class="thin_seperator" />
    </xsl:if>
  </xsl:template>
  <!--Location-->
  <xsl:template name="pSingleDatasetLocation" />
  <!--Airborne Geophysics-->
  <xsl:template name="pAirborne">
    <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:tieLineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:averagesensorheight/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftType/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument6/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftPositionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyComments/gco:CharacterString) ">
      <a id="pAirborne" />
      <div class="section_title">
        <a onclick="javascript:ToggleSection('pAirborneSection')">
          <span class="section" id="pAirborneSectionStatus">-</span>
          <span class="category">Airborne Geophysics</span>
        </a>
        <div class="section" id="pAirborneSection">
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyName/gco:CharacterString)">
            <div class="level1">
              <span class="label">Survey name:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyName/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:contractJobNo/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contract #:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:contractJobNo/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyOperator/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyOperator/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:originalClient/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Original client(s):</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:originalClient/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineSpacing/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line spacing (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineSpacing/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineDirection/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line direction (deg cw):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:lineDirection/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:tieLineSpacing/gco:CharacterString)">
            <div class="level1">
              <span class="label">Tie line spacing (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:tieLineSpacing/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:averagesensorheight/gco:CharacterString)">
            <div class="level1">
              <span class="label">Average sensor height (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:averagesensorheight/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:totalLineKm/gco:CharacterString)">
            <div class="level1">
              <span class="label">Total line kilometers (km):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:totalLineKm/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftType/gco:CharacterString)">
            <div class="level1">
              <span class="label">Aircraft type:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftType/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument1/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 1:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument1/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument2/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 2:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument2/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument3/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 3:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument3/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument4/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 4:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument4/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument5/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 5:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument5/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument6/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 6:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:instrument6/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:additionalInstruments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Additional instruments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:additionalInstruments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftPositionMethod/gco:CharacterString)">
            <div class="level1">
              <span class="label">Positioning method:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:aircraftPositionMethod/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveystartdate/gco:Date)">
            <div class="level1">
              <span class="label">Survey start date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveystartdate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyenddate/gco:Date)">
            <div class="level1">
              <span class="label">Survey end date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyenddate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyComments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Survey comments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:airborne/geox:MD_Airborne/geox:surveyComments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
        </div>
      </div>
      <a class="backtotop" href="#top">Back To Top</a>
      <hr class="thin_seperator" />
    </xsl:if>
  </xsl:template>
  <!--Compilation-->
  <xsl:template name="pCompilation">
    <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:tieLineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:averagesensorheight/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:platform/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument6/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument7/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument8/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument9/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument10/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument11/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument12/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:positionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:completionDate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyAcquisitionYearRange/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyComments/gco:CharacterString) ">
      <a id="pCompilation" />
      <div class="section_title">
        <a onclick="javascript:ToggleSection('pCompilationSection')">
          <span class="section" id="pCompilationSectionStatus">-</span>
          <span class="category">Compilation</span>
        </a>
        <div class="section" id="pCompilationSection">
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyName/gco:CharacterString)">
            <div class="level1">
              <span class="label">Survey name:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyName/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:contractJobNo/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contract #:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:contractJobNo/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyOperator/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyOperator/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:originalClient/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Original client(s):</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:originalClient/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineSpacing/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line spacing (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineSpacing/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineDirection/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line direction (deg cw):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:lineDirection/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:tieLineSpacing/gco:CharacterString)">
            <div class="level1">
              <span class="label">Tie line spacing (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:tieLineSpacing/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:averagesensorheight/gco:CharacterString)">
            <div class="level1">
              <span class="label">Average sensor height (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:averagesensorheight/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:totalLineKm/gco:CharacterString)">
            <div class="level1">
              <span class="label">Total line kilometers (km):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:totalLineKm/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:platform/gco:CharacterString)">
            <div class="level1">
              <span class="label">Platform:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:platform/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument1/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 1:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument1/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument2/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 2:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument2/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument3/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 3:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument3/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument4/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 4:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument4/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument5/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 5:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument5/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument6/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 6:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument6/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument7/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 7:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument7/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument8/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 8:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument8/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument9/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 9:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument9/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument10/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 10:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument10/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument11/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 11:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument11/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument12/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 12:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:instrument12/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:additionalInstruments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Additional instruments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:additionalInstruments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:positionMethod/gco:CharacterString)">
            <div class="level1">
              <span class="label">Positioning method:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:positionMethod/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:completionDate/gco:Date)">
            <div class="level1">
              <span class="label">Completion date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:completionDate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyAcquisitionYearRange/gco:CharacterString)">
            <div class="level1">
              <span class="label">Survey acquisition year range:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyAcquisitionYearRange/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyComments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Compilation comments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:compilation/geox:MD_Compilation/geox:surveyComments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
        </div>
      </div>
      <a class="backtotop" href="#top">Back To Top</a>
      <hr class="thin_seperator" />
    </xsl:if>
  </xsl:template>
  <!--Ground Geophysics-->
  <xsl:template name="pGround">
    <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMode/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingInterval/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:positionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyComments/gco:CharacterString) ">
      <a id="pGround" />
      <div class="section_title">
        <a onclick="javascript:ToggleSection('pGroundSection')">
          <span class="section" id="pGroundSectionStatus">-</span>
          <span class="category">Ground Geophysics</span>
        </a>
        <div class="section" id="pGroundSection">
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyName/gco:CharacterString)">
            <div class="level1">
              <span class="label">Survey name:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyName/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:contractJobNo/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contract #:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:contractJobNo/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyOperator/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyOperator/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:originalClient/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Original client(s):</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:originalClient/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineSpacing/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line spacing (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineSpacing/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineDirection/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line direction (deg cw):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:lineDirection/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:totalLineKm/gco:CharacterString)">
            <div class="level1">
              <span class="label">Total line kilometers (km):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:totalLineKm/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument1/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 1:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument1/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument2/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 2:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:instrument2/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:additionalInstruments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Additional instruments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:additionalInstruments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMode/gco:CharacterString)">
            <div class="level1">
              <span class="label">Sampling mode:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMode/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMethod/gco:CharacterString)">
            <div class="level1">
              <span class="label">Sampling method:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingMethod/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingInterval/gco:Decimal)">
            <div class="level1">
              <span class="label">Sampling interval (cm):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:samplingInterval/gco:Decimal" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:positionMethod/gco:CharacterString)">
            <div class="level1">
              <span class="label">Positioning method:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:positionMethod/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveystartdate/gco:Date)">
            <div class="level1">
              <span class="label">Survey start date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveystartdate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyenddate/gco:Date)">
            <div class="level1">
              <span class="label">Survey end date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyenddate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyComments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Survey comments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:ground/geox:MD_Ground/geox:surveyComments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
        </div>
      </div>
      <a class="backtotop" href="#top">Back To Top</a>
      <hr class="thin_seperator" />
    </xsl:if>
  </xsl:template>
  <!--Borehole-->
  <xsl:template name="pBorehole">
    <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:drillholeID/gco:Integer) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:startDepth/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:endofHole/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingInterval/gco:Decimal) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:positionMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyComments/gco:CharacterString) ">
      <a id="pBorehole" />
      <div class="section_title">
        <a onclick="javascript:ToggleSection('pBoreholeSection')">
          <span class="section" id="pBoreholeSectionStatus">-</span>
          <span class="category">Borehole</span>
        </a>
        <div class="section" id="pBoreholeSection">
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyName/gco:CharacterString)">
            <div class="level1">
              <span class="label">Survey name:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyName/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:contractJobNo/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contract #:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:contractJobNo/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyOperator/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyOperator/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:originalClient/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Original client(s):</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:originalClient/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:drillholeID/gco:Integer)">
            <div class="level1">
              <span class="label">Drillhole ID:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:drillholeID/gco:Integer" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:startDepth/gco:Decimal)">
            <div class="level1">
              <span class="label">Start depth:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:startDepth/gco:Decimal" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:endofHole/gco:Decimal)">
            <div class="level1">
              <span class="label">End of hole:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:endofHole/gco:Decimal" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument1/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 1:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument1/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument2/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 2:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument2/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument3/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 3:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument3/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument4/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 4:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument4/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument5/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 5:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:instrument5/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:additionalInstruments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Additional instruments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:additionalInstruments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingMethod/gco:CharacterString)">
            <div class="level1">
              <span class="label">Sampling method:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingMethod/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingInterval/gco:Decimal)">
            <div class="level1">
              <span class="label">Sampling interval:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:samplingInterval/gco:Decimal" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:positionMethod/gco:CharacterString)">
            <div class="level1">
              <span class="label">Positioning method:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:positionMethod/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveystartdate/gco:Date)">
            <div class="level1">
              <span class="label">Survey start date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveystartdate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyenddate/gco:Date)">
            <div class="level1">
              <span class="label">Survey end date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyenddate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyComments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Survey comments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:borehole/geox:MD_Borehole/geox:surveyComments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
        </div>
      </div>
      <a class="backtotop" href="#top">Back To Top</a>
      <hr class="thin_seperator" />
    </xsl:if>
  </xsl:template>
  <!--Marine Geophysics-->
  <xsl:template name="pMarine">
    <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyName/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:contractJobNo/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyOperator/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:originalClient/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineSpacing/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineDirection/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:totalLineKm/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:vesselType/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument1/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument2/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:Instrument3/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument4/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument5/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument6/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:additionalInstruments/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:positioningMethod/gco:CharacterString) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveystartdate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyenddate/gco:Date) or boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyComments/gco:CharacterString) ">
      <a id="pMarine" />
      <div class="section_title">
        <a onclick="javascript:ToggleSection('pMarineSection')">
          <span class="section" id="pMarineSectionStatus">-</span>
          <span class="category">Marine Geophysics</span>
        </a>
        <div class="section" id="pMarineSection">
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyName/gco:CharacterString)">
            <div class="level1">
              <span class="label">Survey name:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyName/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:contractJobNo/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contract #:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:contractJobNo/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyOperator/gco:CharacterString)">
            <div class="level1">
              <span class="label">Acquisition contractor:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyOperator/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:originalClient/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Original client(s):</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:originalClient/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineSpacing/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line spacing (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineSpacing/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineDirection/gco:CharacterString)">
            <div class="level1">
              <span class="label">Line direction (deg cw):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:lineDirection/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineSpacing/gco:CharacterString)">
            <div class="level1">
              <span class="label">Tie line spacing (m):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineSpacing/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineDirection/gco:CharacterString)">
            <div class="level1">
              <span class="label">Tie line direction (deg cw):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:tieLineDirection/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:totalLineKm/gco:CharacterString)">
            <div class="level1">
              <span class="label">Total line kilometers (km):</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:totalLineKm/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:vesselType/gco:CharacterString)">
            <div class="level1">
              <span class="label">Vessel type:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:vesselType/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument1/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 1:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument1/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument2/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 2:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument2/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:Instrument3/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 3:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:Instrument3/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument4/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 4:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument4/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument5/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 5:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument5/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument6/gco:CharacterString)">
            <div class="level1">
              <span class="label">Instrument 6:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:instrument6/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:additionalInstruments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Additional instruments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:additionalInstruments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:positioningMethod/gco:CharacterString)">
            <div class="level1">
              <span class="label">Positioning method:</span>
              <span class="text">
                <xsl:value-of select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:positioningMethod/gco:CharacterString" />
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveystartdate/gco:Date)">
            <div class="level1">
              <span class="label">Survey start date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveystartdate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyenddate/gco:Date)">
            <div class="level1">
              <span class="label">Survey end date:</span>
              <span class="text">
                <xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyenddate/gco:Date" />
                </xsl:call-template>
              </span>
            </div>
          </xsl:if>
          <xsl:if test="boolean(//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyComments/gco:CharacterString)">
            <div class="level1">
              <div class="inlinelabel">Survey comments:</div>
              <div class="inlinetext">
                <xsl:call-template name="format-multilinetext">
                  <xsl:with-param name="text" select="//gmd:identificationInfo/gmd:MD_DataIdentification/geox:geophysics/geox:MD_Geophysics/geox:marine/geox:MD_Marine/geox:surveyComments/gco:CharacterString" />
                </xsl:call-template>
              </div>
              <br style="clear:both;" />
            </div>
          </xsl:if>
        </div>
      </div>
      <a class="backtotop" href="#top">Back To Top</a>
      <hr class="thin_seperator" />
    </xsl:if>
  </xsl:template>
  <!--coordinate system-->
  <xsl:template name="pProjection">
    <a id="pProjection" />
    <div class="section_title">
      <a onclick="javascript:ToggleSection('pProjectionSection')">
        <span class="section">-</span>
        <span class="category">Coordinate System</span>
      </a>
    </div>
    <div class="section" id="pProjectionSection">
      <xsl:if test="boolean(//gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString)" />
      <div class="level1">
        <span class="label">Name:</span>
        <span class="text">
          <xsl:value-of select="//gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString" />
        </span>
      </div>
      <div class="level1TitleWithSpacingAbove">
        <span class="label">Extents:</span>
        <div class="extents">
          <table>
            <xsl:variable name="east" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal" />
            <xsl:if test="$east!=''">
              <tr>
                <th>East:</th>
                <td>
                  <xsl:value-of select="$east" />
                </td>
              </tr>
            </xsl:if>
            <xsl:variable name="west" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal" />
            <xsl:if test="$west!=''">
              <tr>
                <th>West:</th>
                <td>
                  <xsl:value-of select="$west" />
                </td>
              </tr>
            </xsl:if>
            <xsl:variable name="south" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal" />
            <xsl:if test="$south!=''">
              <tr>
                <th>South:</th>
                <td>
                  <xsl:value-of select="$south" />
                </td>
              </tr>
            </xsl:if>
            <xsl:variable name="north" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal" />
            <xsl:if test="$north!=''">
              <tr>
                <th>North:</th>
                <td>
                  <xsl:value-of select="$north" />
                </td>
              </tr>
            </xsl:if>
            <xsl:variable name="distance" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance | gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:distance" />
            <xsl:if test="$distance!=''">
              <tr>
                <th>Spatial resolution:</th>
                <td>
                  <xsl:value-of select="$distance" />
                </td>
              </tr>
            </xsl:if>
            <xsl:variable name="positioning_method_horizontal" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:positionMethod/gmd:MD_PositionMethod/gmd:horizontal/gco:CharacterString" />
            <xsl:if test="$positioning_method_horizontal!=''">
              <tr>
                <th>Positioning method-horizontal:</th>
                <td>
                  <xsl:value-of select="$positioning_method_horizontal" />
                </td>
              </tr>
            </xsl:if>
            <xsl:variable name="positioning_method_vertical" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:positionMethod/gmd:MD_PositionMethod/gmd:vertical/gco:CharacterString" />
            <xsl:if test="$positioning_method_vertical!=''">
              <tr>
                <th>Positioning method-vertical:</th>
                <td>
                  <xsl:value-of select="$positioning_method_vertical" />
                </td>
              </tr>
            </xsl:if>
            <xsl:variable name="additional_quality_info" select="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:processStep/gmd:LI_ProcessStep/gmd:additionalDescription/gco:CharacterString" />
            <xsl:if test="$additional_quality_info!=''">
              <tr>
                <th>Additional quality info:</th>
                <td>
                  <xsl:value-of select="$additional_quality_info" />
                </td>
              </tr>
            </xsl:if>
          </table>
        </div>
      </div>
    </div>
    <a class="backtotop" href="#top">Back To Top</a>
    <hr class="thin_seperator" />
  </xsl:template>
  <!--utility templates-->
  <xsl:template name="get-month-name">
    <xsl:param name="month" />
    <xsl:choose>
      <xsl:when test="$month = 1">January</xsl:when>
      <xsl:when test="$month = 2">February</xsl:when>
      <xsl:when test="$month = 3">March</xsl:when>
      <xsl:when test="$month = 4">April</xsl:when>
      <xsl:when test="$month = 5">May</xsl:when>
      <xsl:when test="$month = 6">June</xsl:when>
      <xsl:when test="$month = 7">July</xsl:when>
      <xsl:when test="$month = 8">August</xsl:when>
      <xsl:when test="$month = 9">September</xsl:when>
      <xsl:when test="$month = 10">October</xsl:when>
      <xsl:when test="$month = 11">November</xsl:when>
      <xsl:when test="$month = 12">December</xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="format-date">
    <xsl:param name="date" />
    <xsl:if test="not($date='')">
      <xsl:variable name="year">
        <xsl:choose>
          <xsl:when test="contains($date, '-')">
            <xsl:value-of select="substring-before($date, '-')" />
          </xsl:when>
          <xsl:when test="contains($date, '.')">
            <xsl:value-of select="substring-before($date, '.')" />
          </xsl:when>
          <xsl:when test="contains($date, '/')">
            <xsl:value-of select="substring-before($date, '/')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($date, 1, 4)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="date-year">
        <xsl:choose>
          <xsl:when test="contains($date, '-')">
            <xsl:value-of select="substring-after($date, '-')" />
          </xsl:when>
          <xsl:when test="contains($date, '.')">
            <xsl:value-of select="substring-after($date, '.')" />
          </xsl:when>
          <xsl:when test="contains($date, '/')">
            <xsl:value-of select="substring-after($date, '/')" />
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="month">
        <xsl:choose>
          <xsl:when test="contains($date-year, '-')">
            <xsl:value-of select="substring-before($date-year, '-')" />
          </xsl:when>
          <xsl:when test="contains($date-year, '.')">
            <xsl:value-of select="substring-before($date-year, '.')" />
          </xsl:when>
          <xsl:when test="contains($date-year, '/')">
            <xsl:value-of select="substring-before($date-year, '/')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($date, 5, 2)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="day">
        <xsl:choose>
          <xsl:when test="contains($date-year, '-')">
            <xsl:value-of select="substring-after($date-year, '-')" />
          </xsl:when>
          <xsl:when test="contains($date-year, '.')">
            <xsl:value-of select="substring-after($date-year, '.')" />
          </xsl:when>
          <xsl:when test="contains($date-year, '/')">
            <xsl:value-of select="substring-after($date-year, '/')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($date, 7, 2)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="get-month-name">
        <xsl:with-param name="month" select="$month" />
      </xsl:call-template>
      <xsl:value-of select="concat(' ', $day)" />
      <xsl:value-of select="concat(', ', $year)" />
    </xsl:if>
  </xsl:template>
  <xsl:template name="format-url">
    <xsl:param name="url" />
    <a>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$url" />
      </xsl:attribute>
      <xsl:value-of select="$url" />
    </a>
  </xsl:template>
  <xsl:template name="format-urls">
    <xsl:param name="urls" />
    <xsl:variable name="replaced_newlines" select="translate($urls, '&#xA;', ';')" />
    <xsl:variable name="replaced_commas" select="translate($replaced_newlines, ',', ';')" />
    <xsl:call-template name="get-urls">
      <xsl:with-param name="urls" select="$replaced_commas" />
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="format-url-line">
    <xsl:param name="text" />
    <xsl:variable name="title" select="substring-before($text, '&lt;')" />
    <xsl:variable name="var1" select="substring-after($text, '&lt;')" />
    <xsl:variable name="var2" select="substring-before($var1, '&gt;')" />
    <xsl:choose>
      <xsl:when test="starts-with($var2, 'http://')">
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="$var2" />
          </xsl:attribute>
          <xsl:value-of select="$title" />
        </a>
      </xsl:when>
      <xsl:when test="starts-with($var2, '\\')">
        <a target="_blank">
          <xsl:attribute name="href">file:///<xsl:value-of select="$var2" /></xsl:attribute>
          <xsl:value-of select="$title" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
			
	template "format-multilinetext" supports multi-line text with url linkages - each linkage in a whole line of text. for example: 
		Available: 
				Project information<http://info.example.com> 
				Design document<\\server\project1\design\design stage 1.doc> 
		-->
  <xsl:template name="format-multilinetext">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '&#xA;')">
        <xsl:variable name="before" select="substring-before($text, '&#xA;')" />
        <xsl:variable name="after" select="substring-after($text, '&#xA;')" />
        <xsl:if test="boolean($before)">
          <xsl:choose>
            <xsl:when test="contains($before, '&lt;') and contains($before, '&gt;')">
              <xsl:call-template name="format-url-line">
                <xsl:with-param name="text" select="$before" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$before" />
            </xsl:otherwise>
          </xsl:choose>
          <br />
        </xsl:if>
        <xsl:if test="boolean($after)">
          <xsl:call-template name="format-multilinetext">
            <xsl:with-param name="text" select="$after" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($text, '&lt;') and contains($text, '&gt;')">
            <xsl:call-template name="format-url-line">
              <xsl:with-param name="text" select="$text" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$text" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-urls">
    <xsl:param name="urls" />
    <xsl:choose>
      <xsl:when test="contains($urls, ';')">
        <xsl:variable name="before" select="substring-before($urls, ';')" />
        <xsl:variable name="after" select="substring-after($urls, ';')" />
        <xsl:if test="normalize-space($before)">
          <br />
          <xsl:call-template name="format-url">
            <xsl:with-param name="url" select="$before" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$after">
          <xsl:call-template name="get-urls">
            <xsl:with-param name="urls" select="$after" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="normalize-space($urls)">
          <br />
          <a>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="$urls" />
            </xsl:attribute>
            <xsl:value-of select="$urls" />
          </a>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="format-table">
    <xsl:param name="text" />
    <xsl:param name="td-separator" select="'|'" />
    <xsl:param name="tr-separator" select="'&#xA;'" />
    <xsl:param name="head-line" select="'no'" />
    <xsl:param name="style" />
    <xsl:variable name="headtext">
      <xsl:if test="$head-line='yes'">
        <xsl:choose>
          <xsl:when test="contains($text, $tr-separator)">
            <xsl:value-of select="substring-before($text, $tr-separator)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$text" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="bodytext">
      <xsl:choose>
        <xsl:when test="$head-line='yes' and not($tr-separator='')">
          <xsl:if test="contains($text, $tr-separator)">
            <xsl:value-of select="substring-after($text, $tr-separator)" />
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$text" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <table border="1" cellpadding="2" cellspacing="0">
      <xsl:if test="not($headtext='')">
        <tr>
          <xsl:call-template name="format-th">
            <xsl:with-param name="text" select="$headtext" />
            <xsl:with-param name="td-separator" select="$td-separator" />
            <xsl:with-param name="style" select="$style" />
          </xsl:call-template>
        </tr>
      </xsl:if>
      <xsl:call-template name="format-tr">
        <xsl:with-param name="text" select="$bodytext" />
        <xsl:with-param name="tr-separator" select="$tr-separator" />
        <xsl:with-param name="td-separator" select="$td-separator" />
        <xsl:with-param name="style" select="$style" />
      </xsl:call-template>
    </table>
  </xsl:template>
  <xsl:template name="format-tr">
    <xsl:param name="text" />
    <xsl:param name="tr-separator" />
    <xsl:param name="td-separator" />
    <xsl:param name="style" />
    <xsl:variable name="text-0">
      <xsl:choose>
        <xsl:when test="contains($text, $tr-separator)">
          <xsl:value-of select="substring-before($text, $tr-separator)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$text" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="text-1">
      <xsl:value-of select="concat($text-0, $td-separator)" />
    </xsl:variable>
    <xsl:variable name="text-2">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="text" select="$text-1" />
        <xsl:with-param name="replace" select="concat($td-separator, $td-separator)" />
        <xsl:with-param name="by" select="concat($td-separator, ' ', $td-separator)" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="text1" select="substring($text-2, 1, string-length($text-2) - string-length($td-separator))" />
    <xsl:variable name="texts">
      <xsl:if test="contains($text, $tr-separator)">
        <xsl:value-of select="substring-after($text, $tr-separator)" />
      </xsl:if>
    </xsl:variable>
    <tr>
      <xsl:call-template name="format-td">
        <xsl:with-param name="text" select="$text1" />
        <xsl:with-param name="td-separator" select="$td-separator" />
        <xsl:with-param name="style" select="$style" />
      </xsl:call-template>
    </tr>
    <xsl:if test="not($texts='')">
      <xsl:call-template name="format-tr">
        <xsl:with-param name="text" select="$texts" />
        <xsl:with-param name="tr-separator" select="$tr-separator" />
        <xsl:with-param name="td-separator" select="$td-separator" />
        <xsl:with-param name="style" select="$style" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="format-th">
    <xsl:param name="text" />
    <xsl:param name="td-separator" />
    <xsl:param name="style" />
    <xsl:variable name="text1">
      <xsl:choose>
        <xsl:when test="contains($text, $td-separator)">
          <xsl:value-of select="substring-before($text, $td-separator)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$text" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="texts">
      <xsl:if test="contains($text, $td-separator)">
        <xsl:value-of select="substring-after($text, $td-separator)" />
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="style1">
      <xsl:choose>
        <xsl:when test="contains($style, $td-separator)">
          <xsl:value-of select="substring-before($style, $td-separator)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$style" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="styles">
      <xsl:if test="contains($style, $td-separator)">
        <xsl:value-of select="substring-after($style, $td-separator)" />
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not($style1='')">
        <th>
          <xsl:attribute name="style">
            <xsl:value-of select="$style1" />
          </xsl:attribute>
          <xsl:value-of select="$text1" />
        </th>
      </xsl:when>
      <xsl:otherwise>
        <th>
          <xsl:value-of select="$text1" />
        </th>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not($texts='')">
      <xsl:call-template name="format-th">
        <xsl:with-param name="text" select="$texts" />
        <xsl:with-param name="td-separator" select="$td-separator" />
        <xsl:with-param name="style" select="$styles" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="format-td">
    <xsl:param name="text" />
    <xsl:param name="td-separator" />
    <xsl:param name="style" />
    <xsl:variable name="text1">
      <xsl:choose>
        <xsl:when test="contains($text, $td-separator)">
          <xsl:value-of select="substring-before($text, $td-separator)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$text" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="texts">
      <xsl:if test="contains($text, $td-separator)">
        <xsl:value-of select="substring-after($text, $td-separator)" />
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="style1">
      <xsl:choose>
        <xsl:when test="contains($style, $td-separator)">
          <xsl:value-of select="substring-before($style, $td-separator)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$style" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="styles">
      <xsl:if test="contains($style, $td-separator)">
        <xsl:value-of select="substring-after($style, $td-separator)" />
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not($style1='')">
        <td>
          <xsl:attribute name="style">
            <xsl:value-of select="$style1" />
          </xsl:attribute>
          <xsl:value-of select="$text1" />
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td>
          <xsl:value-of select="$text1" />
        </td>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not($texts='')">
      <xsl:call-template name="format-td">
        <xsl:with-param name="text" select="$texts" />
        <xsl:with-param name="td-separator" select="$td-separator" />
        <xsl:with-param name="style" select="$styles" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="string-replace">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:variable name="t0" select="substring-before(string($text), string($replace))" />
        <xsl:variable name="t1" select="substring-after(string($text), string($replace))" />
        <xsl:variable name="t2" select="concat($t0, $by, $t1)" />
        <xsl:choose>
          <xsl:when test="contains($t2, $replace)">
            <xsl:call-template name="string-replace">
              <xsl:with-param name="text" select="$t2" />
              <xsl:with-param name="replace" select="$replace" />
              <xsl:with-param name="by" select="$by" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$t2" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>