<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.util.*,modula.marche.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Tarifs du BOAMP";
%>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page">
	<%= sTitle %>
</div>
<br />
<div style="font-weight:bold;text-align:left">
"Extrait de l'Arrêté du 30 décembre 2005 fixant le montant des rémunérations dûes en contrepartie des prestations fournies par la Direction des Journaux officiels"
<br /><br />Article 2-3
<br /><br />La rémunération des insertions au Bulletin officiel des annonces des marchés publics (BOAMP) est fixée comme suit :
<br /><br />"La rémunération des insertions principales est fixée à 5,12 EUR la ligne ordinaire justifiée sur une colonne.
<br /><br />La rémunération des insertions de rappels d'annonces dans d'autres départements que celui de l'insertion principale est fixée forfaitairement à 100 EUR par département supplémentaire.
<br /><br />La rémunération de la publication annuelle de la liste de l'ensemble des marchés conclus par une personne publique l'année précédente avec le nom des attributaires est fixée forfaitairement à 50 EUR pour moins de dix avis, à 150 EUR de dix à cent avis et à 300 EUR au-delà de cent avis.
<br /><br />La rémunération des insertions électroniques concernant les marchés à procédures adaptées dont le montant est inférieur à 90 000 EUR hors taxes est fixée forfaitairement à 50 EUR."
</div>
<br /><br />
<form action="#">
<input type="button" value="Fermer" onclick="window.close();"/>
</form>
</body>
</html>
