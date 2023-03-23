<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no" indent="yes"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:text>Weird Fiction Archive: </xsl:text>
                    <xsl:apply-templates select="//teiHeader//title"/>
                </title>
                <link rel="stylesheet" href="../CSS/weird.css"/> 
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width" initial-scale="1.0"/>
            </head>
            <body>
                <xsl:apply-templates select="//text"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="front/titlePage">
        <div class="title_page">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="front//titlePart[@type='main']">
        <h1 class="main_title">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    <xsl:template match="front//titlePart[@type='sub']">
        <h1 class="sub_title">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    <xsl:template match="front/titlePage/docAuthor">
        <h2 class="author">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="front/titlePage/epigraph">
        <blockquote class="epi_quote">
            <p>
            <xsl:apply-templates select="//epigraph/p"/>
            </p>
        </blockquote>
        <cite class="epi_cite">
            <xsl:apply-templates select="//epigraph/cit"/>
        </cite>
    </xsl:template>
    <xsl:template match="front/titlePage/note">
        <p class="note_canon">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="text/body/div[@type='chapter']/head">
        <h3 class="chapter_title">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="text/body/div/p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="floatingText/body/div[@type='article']/head">
        <h4 class="article_title">
            <xsl:apply-templates/>
        </h4>
    </xsl:template>
    <xsl:template match="floatingText/body/div[@type='article']/p">
        <p class="article_p">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="div/lg">
        <div class="lg">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="lg/l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    
    
</xsl:stylesheet>