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

String sMetaDataKeywords = "modula, d�mat�rialisation, logiciel, progiciel, march�s publics, appels d'offre, avis d'appel public � concurrence, AAPC, avis d'attribution, AATR, annonces l�gales, journal annonces l�gales, d�mat, acheteur public, infrastructure � cl� publique, interfa�age marco agysoft, logiciels de gestion des march�s publics, portail de d�mat�rialisation, plate-forme de d�mat�rialisation, proc�dures formalis�es, mapa, proc�dures adapt�es, e-administration, publication march�";
sMetaDataKeywords = Configuration.getConfigurationDescriptionMemory("design.desk.html.metadata.keywords",sMetaDataKeywords, false);

String sMetaDataDescription = "solution globale, logiciel de d�mat�rialisation de march�s et des achats publics. Service de d�mat�rialisation des march�s publics fourni aux acheteurs publics, collectivit�s teriitoriales et entreprises publiques, conform�ment � l'article 56 du code des march�s publics. Progiciel interfa�able avec les logiciels de gestion de march�s publics et fourni � la presse quotidienne r�gionale.";
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