<jsp:useBean id="rootPath" scope="request" class="java.lang.String" />
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="modula.graphic.Theme"%>
<%
LocalizeButton localizeButton = null;
try {
	localizeButton = new LocalizeButton(request);
}catch (Exception e) {
	e.printStackTrace();
}

String sMetaDataTitle = "D&eacute;mat&eacute;rialisation de march&eacute;s publics";
sMetaDataTitle = Configuration.getConfigurationDescriptionMemory("design.desk.html.metadata.title",sMetaDataTitle, false);

String sMetaDataKeywords = "modula, dématérialisation, logiciel, progiciel, marchés publics, appels d'offre, avis d'appel public à concurrence, AAPC, avis d'attribution, AATR, annonces légales, journal annonces légales, démat, acheteur public, infrastructure à clé publique, interfaçage marco agysoft, logiciels de gestion des marchés publics, portail de dématérialisation, plate-forme de dématérialisation, procédures formalisées, mapa, procédures adaptées, e-administration, publication marché";
sMetaDataKeywords = Configuration.getConfigurationDescriptionMemory("design.desk.html.metadata.keywords",sMetaDataKeywords, false);

String sMetaDataDescription = "solution globale, logiciel de dématérialisation de marchés et des achats publics. Service de dématérialisation des marchés publics fourni aux acheteurs publics, collectivités teriitoriales et entreprises publiques, conformément à l'article 56 du code des marchés publics. Progiciel interfaçable avec les logiciels de gestion de marchés publics et fourni à la presse quotidienne régionale.";
sMetaDataDescription = Configuration.getConfigurationDescriptionMemory("design.desk.html.metadata.description",sMetaDataDescription, false);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
<head>
<title>MPI Mobile</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="content-language" content="fr" />
<meta name="keywords" content="<%= sMetaDataKeywords %>" />
<meta name="description" content="<%= sMetaDataDescription %>"/>

<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />

<meta name="viewport" content="width=device-width, user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<link rel="apple-touch-icon" href="<%=rootPath%>mobile/include/images/apple-touch-icon.png"/>

</head>
<script type="text/javascript" src="<%=rootPath%>dwr/engine.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/prototype.js" ></script>
<script type="text/javascript" src="<%=rootPath%>mobile/include/js/utils.js" ></script>
<script>
var rootPath = "<%=rootPath%>";
</script>
<body>