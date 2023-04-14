<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no" indent="yes"/>
    <xsl:template match="/">
        <html lang="en">
            <xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
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
                <xsl:if test="//front">
                    <xsl:apply-templates select="//front"/>
                </xsl:if>
                <main>
                    <xsl:apply-templates select="//text/body"/>
                </main>
                <xsl:if test="//back">
                    <xsl:apply-templates select="//back"/>
                </xsl:if>
                <xsl:if test="//note">
                    <section class="notes">
                        <h2>Notes</h2>
                        <xsl:apply-templates select="//note[type='editorial']" mode="end"/>
                    </section>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
    
<!--Front Matter-->
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
    <xsl:template match="//epigraph">
        <blockquote class="epi_quote">
            <p>
            <xsl:apply-templates select="//epigraph/p"/>
            </p>
        </blockquote>
        <cite class="epi_cite">
            <xsl:apply-templates select="//epigraph/cit"/>
        </cite>
    </xsl:template>
    <xsl:template match="front/titlePage/note[@type='canon']">
        <p class="note_canon">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
<!--General Text Structure-->
    <xsl:template match="div">
        <div>
            <xsl:attribute name="class" select="@type"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="lb">
        <xsl:choose>
            <xsl:when test="@rend='hr'">
                <hr>
                    <xsl:attribute name="class">
                        <xsl:value-of select="parent::*/local-name()"/>
                    </xsl:attribute>
                </hr>
            </xsl:when>
            <xsl:otherwise>
                <br/>
            </xsl:otherwise>
        </xsl:choose>
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

<!--Style-->
    <xsl:template match="hi">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="emph">
        <em>
            <xsl:value-of select="."/>
        </em>
    </xsl:template>

<!--Handling Standoff-->
    <xsl:template match="persName">
        <span class="persName">
            <xsl:choose>
                <xsl:when test="@xml:id">
                    <a href="@xml:id"/>
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="@ref">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('./persons.html/#', @ref)"/>
                        </xsl:attribute>
                        <xsl:if test="@type">
                            <xsl:attribute name="class" select="@type"/>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="placeName">
        <span class="placeName">
            <xsl:choose>
                <xsl:when test="@xml:id">
                    <a name="{@xml:id}"/>
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="@ref">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('./places.html/#', @ref)"/>
                        </xsl:attribute>
                        <xsl:if test="@type">
                            <xsl:attribute name="class" select="@type"/>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
<!--Notes-->
    <xsl:template match="//note[@type='editorial']">
        <xsl:variable name="noteNumber">
            <xsl:number select="." level="any"/>
        </xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$noteNumber"/>
            </xsl:attribute>
            <xsl:attribute name="id" select="concat('back', $noteNumber)"/>
            <sup>
                <xsl:value-of select="$noteNumber"/>
            </sup>
        </a>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="//note[@type='editorial']" mode="end">
        <xsl:variable name="noteNumber">
            <xsl:number select="." level="any"/>
        </xsl:variable>
        <p class="note" id="{$noteNumber}">
            <xsl:value-of select="$noteNumber"/>
            <xsl:text>.&#160;&#160;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>#back</xsl:text>
                    <xsl:value-of select="$noteNumber"/>
                </xsl:attribute>
                <xsl:text>Back</xsl:text>
            </a>
        </p>
    </xsl:template>
    
    <xsl:template match="back">
        <div class="back">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
<!--Standoff-->
    <xsl:template match="//text/body/listPerson/person/persName">
        <div class="person">
            <h2 class="persName">
                <xsl:value-of select="forename"/> 
                <xsl:text> </xsl:text>
                <xsl:value-of select="surname"/>
            </h2>
        </div>
    </xsl:template>
    
</xsl:stylesheet>