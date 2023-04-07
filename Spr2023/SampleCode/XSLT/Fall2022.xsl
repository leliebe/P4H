<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="xs tei" version="2.0">
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>

	<!--  =======================================================
		revision history
	00-began with fork from /xslt/masters/HTMLtransform.xsl
	01-filled master with needed code
	02-revised plays, simplified by eliminating TOC
	03-created for CritArchive 
	04-changes 09/20/2021
	05-new, combining LL, LM, and SN, as of 8/24/22
	06-revised for P4H Fall 2022, as of 11/18/22-->
	
	
	<!-- =======================================================
		sections in this xslt:
		
		1.  running documents
		2.  document structure
		3.  front templates
		4.  structural elements all documents
		5.  style
		6.  figures, images, illustrations
		7.  bibliographic and quotations
		8.  page numbers and forme work
		9.  drama
		10. letters
		11. notes and back matter
	
	-->
	

	<!-- =======================================================
		running documents -->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="nbrPoetryLines">no</xsl:param>
	<xsl:param name="manualPageNumber">no</xsl:param>
	<xsl:param name="centerPageHeader">no</xsl:param>
	<xsl:param name="baseURL"></xsl:param>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="list">
		<xsl:for-each select="item">
			<xsl:apply-templates select="document(@code)/tei:TEI"/>
		</xsl:for-each>
	</xsl:template>


	<!-- =======================================================
		document structure -->

	<xsl:template match="tei:TEI">
		<xsl:variable name="docID" select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local']"/> <!-- add this to the rules -->
		<xsl:result-document href="../HTML/{$docID}.html">
			<html lang="en">
				<xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
				<xsl:apply-templates/>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="tei:teiHeader">
		<head>
			<title>
				<xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title[1]"/>
			</title>
			<link rel="stylesheet" type="text/css" href="../css/forWeb.css"/>
		</head>
	</xsl:template>

	<xsl:template match="tei:text">
		<body>
			<xsl:if test="tei:front">
				<xsl:apply-templates select="tei:front"/>
			</xsl:if>
			<main>
				<xsl:apply-templates select="tei:body"/>
			</main>
			<xsl:if test="tei:back">
				<xsl:apply-templates select="tei:back"/>
			</xsl:if>
			<xsl:if test="//tei:note">
				<section class="notes">
					<h2>Notes</h2>
					<xsl:apply-templates select="//tei:note" mode="end"/>
				</section>
				<section class="noteSpace">
					<h2>HTML constraints</h2>
					<p>Makes enough space, 60em in the css, at the end of webpage for the note link
						to bring the specified note to the top of the screen.</p>
				</section>
			</xsl:if>
		</body>
	</xsl:template>

	<!-- =======================================================
	   front templates -->

	<xsl:template match="tei:front">
		<div class="front">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:titlePage">
		<xsl:if test="@facs">
			<a target="_blank">
				<xsl:attribute name="href">
					<xsl:value-of select="concat('../images/', @facs)"/>
				</xsl:attribute>
			<img class="imageTP" alt="an image of the title page">
				<xsl:attribute name="src">
					<xsl:value-of select="concat('../images/', @facs)"/>
				</xsl:attribute>
			</img>
			</a>
		</xsl:if>
		<div class="tp">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:titlePart">
		<h2 class="tp">
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="tei:byline">
		<span class="byline">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:docAuthor">
		<h3 class="tp">
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

	<xsl:template match="tei:docDate">
		<span class="tpDate">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:pubPlace">
		<span class="tpPlace">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:publisher">
		<span class="tpPub">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:imprimatur">
		<span class="tpImprimatur">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:docImprint">
		<p class="noindent tpPubInfo">
			<xsl:if test="tei:pubPlace">
				<xsl:apply-templates select="tei:pubPlace"/>
			</xsl:if>
			<xsl:if test="tei:publisher">
				<xsl:apply-templates select="tei:publisher"/>
			</xsl:if>
			<xsl:if test="tei:docDate">
				<xsl:apply-templates select="tei:docDate"/>
			</xsl:if>
			<xsl:if test="tei:date">
				<xsl:apply-templates select="tei:date"/>
			</xsl:if>
		</p>
	</xsl:template>

	<xsl:template match="tei:docEdition">
		<xsl:choose>
			<xsl:when test="tei:bibl/tei:biblScope/@unit">
				<p>
					<xsl:text>Vol. </xsl:text>
					<xsl:value-of select="tei:bibl/tei:biblScope[@unit = 'volume']"/>
					<xsl:text>, </xsl:text>
					<xsl:text>pp. </xsl:text>
					<xsl:value-of select="tei:bibl/tei:biblScope[@unit = 'page']"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="tp">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
		 =======================================================
			structural elements all documents-->
	
	<xsl:template match="tei:div | tei:div1 | tei:div2">
		<div>
			<xsl:attribute name="class" select="@type"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:head">
		<header>
			<xsl:apply-templates/>
		</header>
	</xsl:template>
	
	<xsl:template match="tei:p">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type">
					<xsl:attribute name="class" select="@type"/>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match="tei:lg">
		<span class="stanza">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:l">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:value-of select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'l'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span>
			<xsl:attribute name="class" select="$class"/>
			<xsl:choose>
				<xsl:when
					test="$nbrPoetryLines = 'yes' and not(parent::tei:quote/parent::tei:cit/parent::tei:epigraph)">
					<span class="ltext">
						<xsl:apply-templates/>
					</span>
					<span class="lno">
						<xsl:number from="tei:div" level="any"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:table">
		<table>
			<xsl:if test="@rend">
				<xsl:attribute name="class">
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	
	<xsl:template match="tei:row">
		<tr>
			<xsl:if test="parent::tei:table[@rend]">
				<xsl:attribute name="class" select="parent::tei:table/@rend"/>
			</xsl:if>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
	
	<xsl:template match="tei:cell">
		<td>
			<xsl:if test="parent::tei:row/parent::tei:table[@rend]">
				<xsl:attribute name="class" select="parent::tei:row/parent::tei:table/@rend"/>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	
	<xsl:template match="tei:lb">
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
	
	<xsl:template match="tei:list">
		<xsl:choose>
			<xsl:when test="@type = 'gloss'">
				<dl>
					<xsl:apply-templates/>
				</dl>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:item">
		<xsl:choose>
			<xsl:when test="parent::tei:list[@type = 'gloss']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:apply-templates/>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:term">
		<dt>
			<xsl:attribute name="id" select="@xml:id"/>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>
	
	<xsl:template match="tei:gloss">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>
	
	
	<!-- =======================================================
		   style -->
	
	<xsl:template match="tei:hi">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="@rend"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:emph">
		<em>
			<xsl:value-of select="."/>
		</em>
	</xsl:template>


	<!-- =======================================================
		figures, images, and illustrations -->
	
	<xsl:template match="tei:figure">
		<figure>
			<xsl:attribute name="class" select="@type"/>
			<span class="figureHead"><xsl:apply-templates select="tei:head"/></span>
			<xsl:apply-templates select="tei:graphic"/>
			<figcaption><xsl:apply-templates select="tei:figDesc"/></figcaption>
		</figure>
	</xsl:template>
	
	<xsl:template match="tei:graphic">
		<a target="_blank">
			<xsl:attribute name="href">
				<xsl:value-of select="concat('../images/', @url)"/>
			</xsl:attribute>
			<img>
				<xsl:attribute name="src">
					<xsl:value-of select="concat('../images/', @url)"/>
				</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:value-of select="concat('image of ', parent::tei:figure/tei:head)"/>
				</xsl:attribute>
				<xsl:attribute name="class">
					<xsl:value-of select="parent::tei:figure/@type"/>
				</xsl:attribute>
			</img>
		</a>
	</xsl:template>
	
	
	<!-- =======================================================
	      bibliographic and quotations -->


	<xsl:template match="tei:bibl">
		<xsl:choose>
			<xsl:when test="parent::tei:head/parent::tei:div[@type = 'essay']">
				<!-- why not for poem? because the poem div starts after header info.-->
				<header class="headBibl">
					<xsl:apply-templates/>
				</header>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:div/tei:head/tei:bibl/tei:author">
		<span class="author">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:head/tei:bibl/tei:title">
		<span class="titleHeader">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:title">
		<!-- this hasn't been tested -->
		<xsl:variable name="class1">
			<xsl:choose>
				<xsl:when test="@level = 'a' or @level = 's' or @level = 'u'">
					<xsl:value-of select="'titlePart'"/>
				</xsl:when>
				<xsl:when test="@level = 'm' or @level = 'j'">
					<xsl:value-of select="'titleWhole'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="class2">
			<xsl:choose>
				<xsl:when test="@type = 'main'">
					<xsl:value-of select="'titleMain'"/>
				</xsl:when>
				<xsl:when test="@type = 'sub'">
					<xsl:value-of select="'titleSub'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<span>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="@level or @type">
						<xsl:choose>
							<xsl:when test="$class1 != '' and $class2 != ''">
								<xsl:value-of select="$class1"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$class2"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$class1">
										<xsl:value-of select="$class1"/>
									</xsl:when>
									<xsl:when test="$class2">
										<xsl:value-of select="$class2"/>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'title'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:epigraph">
		<div class="blockquote">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:cit">
		<p class="epigraph">
		<xsl:choose>
			<xsl:when test="tei:quote/tei:l">
				<span class="stanza">
					<xsl:apply-templates select="tei:quote"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates select="tei:quote"/>
			</xsl:otherwise>
		</xsl:choose>
		</p>
		<p class="cit">
			<xsl:apply-templates select="tei:bibl"/>
		</p>
	</xsl:template>
	
	<xsl:template match="tei:q">
		<xsl:text>&quot;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&quot;</xsl:text>
	</xsl:template>
	
	<xsl:template match="tei:quote">
		<xsl:choose>
			<xsl:when test="parent::tei:div">
				<div class="blockquote">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:when test="parent::tei:p">
				<span class="blockquote">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="parent::tei:cit">
				<xsl:apply-templates/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:name">
		<span class="name">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<a name="{@xml:id}"/>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="@ref">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="concat($baseURL, @ref)"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>

	<xsl:template match="tei:persName">
		<span class="persName">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<a name="{@xml:id}"/>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="@ref">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="concat('./Standoff.html/#', @ref)"/>
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
	
	<xsl:template match="tei:placeName">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="concat('places.html', @xml:id)"/>
					</xsl:attribute>
					<xsl:if test="@type">
						<xsl:attribute name="class" select="@type"/>
					</xsl:if>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<span class="{local-name()}">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:date">
		<span class="date">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	
	<!-- =======================================================
		page numbers and forme work -->

	<xsl:template match="tei:pb">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="parent::tei:div">
					<xsl:text>pageNumber</xsl:text>
				</xsl:when>
				<xsl:when test="parent::tei:quote/parent::tei:div">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::tei:quote/parent::tei:p">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::tei:p/parent::tei:quote/parent::tei:div">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::tei:p/parent::tei:quote">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::tei:note/parent::tei:quote">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::tei:lg/parent::tei:quote">
					<xsl:text>pageInsideStanza</xsl:text>
				</xsl:when>
				<xsl:when test="parent::tei:l/parent::tei:lg/parent::tei:quote">
					<xsl:text>pageInsideLine</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>pageNumber</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$manualPageNumber = 'yes'">
				<span class="pageTop"/>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:attribute name="class" select="$class"/>
					<xsl:text>[Page </xsl:text>
					<xsl:value-of select="@n"/>
					<xsl:text>]</xsl:text>
				</span>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@facs">
			<a target="_blank">
				<xsl:attribute name="href">
					<xsl:value-of select="concat('../images/', @facs)"/>
				</xsl:attribute>
			<img class="pgImg">
				<xsl:attribute name="alt">
					<xsl:value-of select="concat('image of page number ', @n)"/>
				</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:value-of select="concat('../images/', @facs)"/>
				</xsl:attribute>
			</img>
			</a>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:fw">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="@type = 'pageHeader'">
					<xsl:call-template name="fwPageTopHdr"/>
				</xsl:when>
				<xsl:when test="@type = 'pageNumber'">
					<xsl:call-template name="fwPageTopNbr"/>
				</xsl:when>
				<xsl:when test="@type = 'catch'">
					<xsl:value-of select="@type"/>
				</xsl:when>
				<xsl:when test="@type = 'vol'">
					<xsl:choose>
						<xsl:when test="following-sibling::tei:fw[1][@type = 'sig']">
							<xsl:choose>
								<xsl:when test="parent::tei:quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:p/parent::tei:quote/parent::tei:div">
									<!-- I think this is unnecessary, given the next one -->
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:p/parent::tei:quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:lg/parent::tei:quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:l/parent::tei:lg/parent::tei:quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>volWithSig</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="parent::tei:quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:p/parent::tei:quote/parent::tei:div">
							<!-- I think this is unnecessary, given the next one -->
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:p/parent::tei:quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:lg/parent::tei:quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:l/parent::tei:lg/parent::tei:quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>vol</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@type = 'sig'">
					<xsl:choose>
						<xsl:when test="preceding-sibling::tei:fw[1][@type = 'vol']">
							<xsl:choose>
								<xsl:when test="parent::tei:quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:p/parent::tei:quote/parent::tei:div">
									<!-- I think this is unnecessary, given the next one -->
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:p/parent::tei:quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:lg/parent::tei:quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::tei:l/parent::tei:lg/parent::tei:quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>sigWithVol</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="parent::tei:quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:p/parent::tei:quote/parent::tei:div">
							<!-- I think this is unnecessary, given the next one -->
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:p/parent::tei:quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:lg/parent::tei:quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::tei:l/parent::tei:lg/parent::tei:quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>sig</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="following-sibling::*[1][self::tei:fw]">
			<br/>
			<!-- needed for floating to work properly -->
		</xsl:if>
		<span>
			<xsl:attribute name="class" select="$class"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template name="fwPageTopHdr">
		<xsl:choose>
			<xsl:when test="$centerPageHeader">
				<xsl:text>pageTopCenter</xsl:text>
			</xsl:when>
			<xsl:when test="following-sibling::*[1] = parent::*/tei:fw[@type = 'pageNumber']">
				<xsl:text>pageTopLeft</xsl:text>
			</xsl:when>
			<xsl:when test="preceding-sibling::*[1] = parent::*/tei:fw[@type = 'pageNumber']">
				<xsl:text>pageTopRight</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>pageHeader</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="fwPageTopNbr">
		<xsl:choose>
			<xsl:when test="following-sibling::*[1] = parent::*/tei:fw[@type = 'pageHeader']">
				<xsl:text>pageTopLeft</xsl:text>
			</xsl:when>
			<xsl:when test="preceding-sibling::*[1] = parent::*/tei:fw[@type = 'pageHeader']">
				<xsl:text>pageTopRight</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	
	<!-- ======================================================+
            templates used for drama -->
	
	
	<xsl:template match="tei:set">
		<div class="set">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:prologue | tei:epilogue">
		<div class="{local-name()}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:castList">
		<div class="castList">
			<xsl:if test="tei:head">
				<h5 class="castListHead">
					<xsl:value-of select="tei:head"/>
				</h5>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="//tei:castGroup/tei:castGroup">
					<xsl:apply-templates select="tei:castGroup | tei:castItem"/>
				</xsl:when>
				<xsl:otherwise>
					<table class="simpleCastList">
						<xsl:apply-templates select="tei:castItem" mode="simple"/>
					</table>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:castGroup">
		<xsl:choose>
			<xsl:when test="parent::tei:castList">
				<ul>
					<li>
						<xsl:apply-templates/>
					</li>
				</ul>
			</xsl:when>
			<xsl:when test="child::tei:roleDesc">
				<table class="castGroupings">
					<tr>
						<td class="castItem">
							<xsl:apply-templates select="tei:castItem"/>
						</td>
						<xsl:choose>
							<xsl:when test="@rend='braced'">
								<td class="curlyBracket">}</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="space">&#160;</td>
							</xsl:otherwise>
						</xsl:choose>
						<td class="roleDesc">
							<xsl:apply-templates select="tei:roleDesc"/>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:castItem">
		<xsl:choose>
			<xsl:when test="parent::tei:castGroup and following-sibling::tei:roleDesc and child::tei:roleDesc">
				<table class="castItems">
					<tr>
						<td class="role">
							<xsl:apply-templates select="tei:role"/>
							<xsl:text>&#160;</xsl:text>
							<xsl:apply-templates select="tei:roleDesc"/>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="tei:role">
				<table class="castItems">
					<tr>
						<td class="role">
							<xsl:apply-templates select="tei:role"/>
						</td>
						<td class="space">&#160;</td>
						<xsl:choose>
							<xsl:when test="tei:roleDesc">
								<td class="itemRoleDesc">
									<xsl:apply-templates select="tei:roleDesc"/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="space">&#160;</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<p class="castItem">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:castItem" mode="simple">
		<tr>
			<td class="role">
				<xsl:apply-templates select="tei:role"/>
			</td>
			<td class="roleDesc">
				<xsl:apply-templates select="tei:roleDesc"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="tei:castGroup/tei:head">
		<span class="groupHead">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:stage">
		<span>
			<xsl:attribute name="class">
				<xsl:text>stage </xsl:text>
				<xsl:value-of select="@type"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:sp">
		<p class="sp">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match="tei:speaker">
		<span class="speaker">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:sp/tei:p | tei:sp/tei:lg | tei:sp/tei:l">
		<span class="speech">
			<xsl:choose>
				<xsl:when test="@rend">
					<span>
						<xsl:attribute name="class" select="@rend"/>
						<xsl:apply-templates/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	

	<!-- =======================================================
	   letters -->

	<xsl:template match="tei:opener">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="'opener'"/>
						<xsl:text>&#160;</xsl:text>
						<xsl:attribute name="class" select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'opener'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:closer">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="'closer'"/>
						<xsl:text>&#160;</xsl:text>
						<xsl:attribute name="class" select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'closer'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:salute | tei:signed">
		<span>
				<xsl:attribute name="class">
					<xsl:value-of select="local-name()"/>
					<xsl:if test="@rend">
					<xsl:text>&#160;</xsl:text>
					<xsl:value-of select="@rend"/>
					</xsl:if>
				</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dateline">
		<p class="dateline">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="address">
		<span class="address">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="addrLine">
		<span>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class" select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'addrLine'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="addName">
		<span>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class" select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'addName'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	
	<!-- =======================================================
	   notes and backmatter -->

	<xsl:template match="tei:note">
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

	<xsl:template match="tei:note" mode="end">
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

	<xsl:template match="tei:back">
		<div class="back">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

</xsl:stylesheet>
