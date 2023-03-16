<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>
        <sch:rule context="//tei:text/tei:body/tei:listPerson//tei:persName">
            <sch:report test="@type">
                Type for &lt;persName&gt; is determined in &lt;listPerson&gt;. The @type attribute should not be included here.
            </sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="//tei:text//tei:body//tei:p//tei:persName | //tei:text//tei:body//tei:l//tei:persName">
            <sch:let name="persNameVal" value="'char', 'hist'"/>
            <sch:assert test="@type = $persNameVal">
                Incorrect @type value for &lt;persName&gt;. Must be "char" (for fictional characters) or "hist" (for historical figures). 
            </sch:assert>
        </sch:rule>
    </sch:pattern>

</sch:schema>