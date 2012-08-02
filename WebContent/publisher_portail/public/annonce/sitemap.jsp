<?xml version="1.0" encoding="UTF-8" ?>
<%@ page contentType="text/xml;charset=UTF-8" %>
<%
String sURLWebsite = Configuration.getConfigurationValueMemory("publisher.sitemap.url", "/");
%>

<%@page import="java.util.Vector"%>
<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.util.HTMLEntities"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.bean.conf.Configuration"%><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	<url>
		<loc><%= sURLWebsite+"toutes-les-annonces.html" %></loc>
		<changefreq>always</changefreq>
		<priority>0.5</priority>
	</url>
<%
Vector<Marche> vMarche = Marche.getAllMarcheFromDepartmentAndCompetence("", 0,
		"AND ( (statut.aatr=1 AND statut.aatr_en_ligne=1) "
		+"OR ((statut.aapc=1 AND statut.aapc_en_ligne=1)) ) "
		+"AND (TO_DAYS(NOW())-TO_DAYS(marche.date_creation))>70");
String sKeywordMarche = "";
for(int i=0;i<vMarche.size();i++){
	sKeywordMarche = Outils.getKeywordsForURL(Outils.stripHTMLTags(HTMLEntities.unhtmlentities(vMarche.get(i).getObjet())), 100, 2)+"_a"+vMarche.get(i).getId()+".html";
%>
	<url>
		<loc><%= sURLWebsite+sKeywordMarche %></loc>
		<lastmod><%= CalendarUtil.getXmlDateFormat(vMarche.get(i).getDateModification()) %></lastmod>
		<priority>0.5</priority>
	</url>
<%
}
%>
</urlset>