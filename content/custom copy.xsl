<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" 
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:exsl="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    extension-element-prefixes="exsl msxsl"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    exclude-result-prefixes="xsl tei xd eg fn #default">
    
    <!-- import teibp.xsl, which allows templates, 
         variables, and parameters from teibp.xsl 
         to be overridden here. -->
    <xsl:import href="teibp.xsl"/>
    
    <xsl:param name="pbNote"><text>p. </text></xsl:param>
    
    <xsl:param name="transcription" select="concat($filePrefix,'/css/transcription.css')"/>
    <xsl:param name="edition" select="concat($filePrefix,'/css/edition.css')"/>
    <xsl:param name="edition_markup" select="concat($filePrefix,'/css/edition_markup.css')"/>
    <!-- The following tells ClaytonPlate which to use. I should be able to work that into the JS as well, but it didn't work as well as I wanted.  -->
    <xsl:param name="switchCSS" select="concat($filePrefix,'/css/edition.css')"/>


    <!-- The following creates the CSS switching toolbox. It overrides the same in teibp.xsl-->
     <xsl:template name="teibpToolbox">
        <div id="teibpToolbox">
            <div>
                <h1>Display Options</h1>
                <label for="pbToggle">Hide page breaks</label>
                <input type="checkbox" id="pbToggle" /> 
                <!-- this is what I'm adding -->
                <label for="noteToggle">Hide notes</label>
                <input type="checkbox" id="noteToggle" /> 
                <!-- end addition -->
                <div>
                    <h3>Select Text View:</h3>
                    <select style="display:inline;" id="themeBox" onchange="switchTextView(this);">
                        <option value="{$edition}">Reading Text</option>
                        <option value="{$edition_markup}">Intermediate</option>
                        <option value="{$transcription}"> Transcription</option>
                </select>           
            </div>
            </div>
        </div>
    </xsl:template>

    <!-- This constructs the pretend-HTML head of the document.  The main change from teibp.xsl is that I've added a javascript function switchTextView(theme) and a CSS line calling $switchCSS from above. -->
    <xsl:template name="htmlHead">
        <head>
            <meta charset="UTF-8"/>
            <link id="maincss" rel="stylesheet" type="text/css" href="{$teibpCSS}"/>
            <link id="customcss" rel="stylesheet" type="text/css" href="{$customCSS}"/>
            <link id="switchcss" rel="stylesheet" type="text/css" href="{$switchCSS}" />
            <!-- I am adding this line to try to get refs to open in same window. not working -->
            <base target="_self"/>
            <script type="text/javascript" src="{$jqueryJS}"></script>
            <script type="text/javascript" src="{$jqueryBlockUIJS}"></script>
            <script type="text/javascript" src="{$teibpJS}"></script>
            <script type="text/javascript">
                $(document).ready(function() {
                    $("html > head > title").text($("TEI > teiHeader > fileDesc > titleStmt > title:first").text());
                    $.unblockUI();  
                });
                function switchTextView(theme) {
                    document.getElementById('switchcss').href=theme.options[theme.selectedIndex].value;
                }
            </script>
            <xsl:call-template name="tagUsage2style"/>
            <xsl:call-template name="rendition2style"/>
            <title><!-- don't leave empty. --></title>
        </head>
    </xsl:template>
    
    <!-- I have copied this from teipb.xsl and added target="_self", to try to open links in same window, but not working) -->
    <xd:doc>
        <xd:desc>
            <xd:p>Transforms TEI ref element to html a (link) element. </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:ref[@target]" priority="99">
        <a href="{@target}" target="_self">
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="rendition"/>
            <xsl:apply-templates select="node()"/>
        </a>
    </xsl:template>
    

    <!-- I've copied this over and commented out function calls, to make title disappear from top of page. This works.
    <xsl:template match="tei:teiHeader//tei:title">
        <tei-title>
            <xsl:call-template name="addID"/>
            <xsl:apply-templates select="@*|node()"/> 
        </tei-title>
    </xsl:template>
-->
</xsl:stylesheet>