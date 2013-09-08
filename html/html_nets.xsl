<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all" version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p> TEI stylesheet dealing with elements from the nets module,
      making HTML output. </p>
      <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
      <p>Author: See AUTHORS</p>
      <p>Id: $Id$</p>
      <p>Copyright: 2013, TEI Consortium</p>
    </desc>
  </doc>
  <xsl:param name="treestyle">google</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element eTree</desc>
  </doc>
  <xsl:template match="tei:eTree|tei:eLeaf">
    <xsl:choose>
      <xsl:when test="$treestyle='google'">
        <xsl:if test="not(preceding::tei:eTree)">
          <script type="text/javascript" src="https://www.google.com/jsapi"/>
          <script type="text/javascript">
	google.setOnLoadCallback(drawCharts);
	function drawCharts() {
	<xsl:for-each select="key('TREES',1)"><xsl:variable name="TREEID" select="generate-id()"/><xsl:text>var data</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>= new google.visualization.DataTable();
	  data</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>.addColumn('string', 'Person');
	  data</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>.addColumn('string', 'Parent');
	  data</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>.addColumn('string', 'Note');
	  data</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>.addRows([
	  [{v:'</xsl:text><xsl:value-of select="generate-id()"/><xsl:text>',  f:'</xsl:text><xsl:for-each select="tei:label"><xsl:apply-templates/></xsl:for-each><xsl:text>'}, '', ''],
</xsl:text><xsl:for-each select=".//tei:eTree|.//tei:eLeaf"><xsl:text>[{v:'</xsl:text><xsl:value-of select="generate-id()"/><xsl:text>',  f:'</xsl:text><xsl:for-each select="tei:label"><xsl:apply-templates/></xsl:for-each><xsl:text>'}, '</xsl:text><xsl:for-each select="parent::tei:*"><xsl:value-of select="generate-id()"/></xsl:for-each><xsl:text>', ''],
</xsl:text></xsl:for-each><xsl:text>]);
	  var chart</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>= new	google.visualization.OrgChart(document.getElementById('chart</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>'));
	  chart</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>.draw(data</xsl:text><xsl:value-of select="$TREEID"/><xsl:text>, {allowCollapse:true,nodeClass:'teinode',allowHtml:true});
	  </xsl:text></xsl:for-each>
	};
      </script>
        </xsl:if>
        <xsl:if test="not(ancestor::tei:eTree)">
          <xsl:variable name="TREEID" select="generate-id()"/>
          <span id="chart{$TREEID}"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$treestyle='d3'">
       <xsl:choose>
          <xsl:when test="not(ancestor::tei:eTree)">
            <xsl:variable name="TREEID" select="generate-id()"/>
            <div class="treediagram" id="viz{$TREEID}"/>
<xsl:variable name="treedepth"
	      select="max(
		      descendant::*[(self::tei:eTree or self::tei:eLeaf) and not(tei:eTree or tei:eLeaf)]/count(ancestor-or-self::*[self::tei:eTree or self::tei:eLeaf])) "/>
<xsl:variable name="treewidth"
	      select="max(
		      descendant-or-self::*[self::tei:eTree or self::tei:eLeaf]/(count(tei:eLeaf)+count(tei:eTree))) "/>

<xsl:message>Size of tree is <xsl:value-of select="($treedepth,$treewidth)"
separator=":"/></xsl:message>
           <script type="text/javascript">
       //JSON object with the data
      var treeData = {
         "name" : '<xsl:apply-templates select="tei:label"/>
	 <xsl:text>', </xsl:text>
	 <xsl:if test="tei:eTree|tei:eLeaf">"children" : [<xsl:apply-templates select="*[not(self::tei:label)]"/>]</xsl:if>};
      // Create a svg canvas
      var vis = d3.select("#viz<xsl:value-of select="$TREEID"/>").append("svg:svg")
      .attr("width", 600)
      .attr("height", 600)
      .append("svg:g")
      .attr("transform", "translate(40, 40)"); 
      // Create a tree "canvas"
      var tree = d3.layout.tree()
    .size([600,500]);
    // Preparing the data for the tree layout, convert data into an array of nodes
    var nodes = tree.nodes(treeData);
    // Create an array with all the links
    var links = tree.links(nodes);
    var link = vis.selectAll("pathlink")
    .data(links)
    .enter().append("svg:path")
    .attr("class", "link")
    .attr("d", elbow)    
    var node = vis.selectAll("g.node")
    .data(nodes)
    .enter().append("svg:g")
    .attr("class","node")
    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
    node.append("svg:foreignObject")
    .attr("x", -75)
    .attr("y", -15)
      .attr("width", 150)
      .attr("height", 150)
      .append("xhtml:div")
      .attr("class", "nodetext")
      .html(function(d) { return d.name; });
    </script>

          </xsl:when>
          <xsl:otherwise>{"name" : '<xsl:apply-templates select="tei:label"/>
	  <xsl:text>', </xsl:text>
	    <xsl:if test="tei:eTree|tei:eLeaf">"children" : [<xsl:apply-templates select="*[not(self::tei:label)]"/>]</xsl:if>
	    <xsl:text>}, 
	    </xsl:text>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:eTree/tei:label/tei:lb">
    <br/>
  </xsl:template>
  <xsl:template match="tei:eLeaf/tei:label/tei:lb">
    <br/>
  </xsl:template>
  <xsl:template match="tei:forest">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:function name="tei:escape">
    <xsl:param name="what"/>
    <xsl:variable name="result">
      <xsl:apply-templates select="$what"/>
    </xsl:variable>
    <xsl:apply-templates select="$result" mode="escape"/>
  </xsl:function>
  <xsl:template match="*" mode="escape">
    <xsl:value-of select="concat('&lt;',name(),'&gt;')"/>
    <xsl:apply-templates mode="escape"/>
    <xsl:value-of select="concat('&lt;/',name(),'&gt;')"/>
  </xsl:template>
</xsl:stylesheet>
