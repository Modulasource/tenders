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
"Extrait de l'Arr�t� du 30 d�cembre 2005 fixant le montant des r�mun�rations d�es en contrepartie des prestations fournies par la Direction des Journaux officiels"
<br /><br />Article 2-3
<br /><br />La r�mun�ration des insertions au Bulletin officiel des annonces des march�s publics (BOAMP) est fix�e comme suit :
<br /><br />"La r�mun�ration des insertions principales est fix�e � 5,12 EUR la ligne ordinaire justifi�e sur une colonne.
<br /><br />La r�mun�ration des insertions de rappels d'annonces dans d'autres d�partements que celui de l'insertion principale est fix�e forfaitairement � 100 EUR par d�partement suppl�mentaire.
<br /><br />La r�mun�ration de la publication annuelle de la liste de l'ensemble des march�s conclus par une personne publique l'ann�e pr�c�dente avec le nom des attributaires est fix�e forfaitairement � 50 EUR pour moins de dix avis, � 150 EUR de dix � cent avis et � 300 EUR au-del� de cent avis.
<br /><br />La r�mun�ration des insertions �lectroniques concernant les march�s � proc�dures adapt�es dont le montant est inf�rieur � 90 000 EUR hors taxes est fix�e forfaitairement � 50 EUR."
</div>
<br /><br />
<form action="#">
<input type="button" value="Fermer" onclick="window.close();"/>
</form>
</body>
</html>
