<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.perf.*, java.util.*" %>
<%
	String sTitle = "Monitoring";

	List<HttpSession> listActiveSession = SessionManager.getAllActiveSession();

 %>
</head>
<body >
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
Contrôle des sessions<br/><br/>

Nombre de mesures en base : <%= Mesure.getTableCount() %><br />
Nombre de sessions actives : <%= listActiveSession.size() %><br />
<br />

<a href="<%= response.encodeURL("afficherMesureParUrl.jsp") %>" >Afficher toutes les statistiques par URL</a><br />
<a href="<%= response.encodeURL("afficherMesureParUser.jsp?iDayCount=1") %>" >Afficher les statistiques de la journée par utilisateur</a><br />
<a href="<%= response.encodeURL("afficherMesureParUser.jsp?iDayCount=7") %>" >Afficher toutes les statistiques par utilisateur depuis 7 jours</a><br />
<a href="<%= response.encodeURL("afficherMesureParUser.jsp?iDayCount=7&amp;bShowAdmin=false") %>" >Afficher toutes les statistiques par utilisateur depuis 7 jours sans admin</a><br />
<a href="<%= response.encodeURL("afficherToutesMesureAvecException.jsp") %>" >Afficher toutes les pages en erreur</a><br />
<a href="<%= response.encodeURL("displayAllActiveSession.jsp") %>" >Afficher toutes les connexions actives</a><br />
<br />
Pour les commerciaux :<br/>
<!-- 
<a href="<%= response.encodeURL("displayAllPersonnePhysiqueMail.jsp") %>" >La liste des emails de tous les carnets d'adresses</a><br />
<a href="<%= response.encodeURL("afficherToutesAffairesParAcheteurPublic.jsp") %>" >Afficher toutes les affaires par acheteur public</a><br />
 -->
 <a href="<%= response.encodeURL("displayAllMarcheConso.jsp") %>" >Afficher la consommation de procédures</a><br />
<br />
<br />
<a href="<%= response.encodeURL("removeAllMesure.jsp") %>" >Vider toutes les mesures </a><br />
<a href="<%= response.encodeURL("removeAllMesureAvecException.jsp") %>" >Vider toutes les mesures avec exception</a><br />
<a href="<%= response.encodeURL("removeAllMesure.jsp?sWhereClause=WHERE+id_coin_user+=+0") %>" >Vider toutes les statistiques pour utilisateur non connecté</a><br />
<br />
<br />
Obsoletes :<br />
<a href="<%= response.encodeURL("afficherMesureParUser.jsp?iDayCount=1&amp;bDisplayNotConnectedUser=true") %>" >Afficher les statistiques de la journée : tout</a><br />
<a href="<%= response.encodeURL("afficherMesureParUser.jsp?iDayCount=1&amp;bDisplayNotConnectedUser=true&amp;bShowAdmin=false") %>" >Afficher les statistiques de la journée : tout et sans admin</a><br />
<a href="<%= response.encodeURL("afficherToutesMesure.jsp") %>" >Afficher toutes les mesures </a><br />
<a href="<%= response.encodeURL("afficherMesureParSessionId.jsp") %>" >Afficher les statistiques par Session Id</a><br />
<a href="<%= response.encodeURL("afficherMesureParSessionId.jsp?sWhereClause=WHERE+id_coin_user+&lt;&gt;0") %>" >Afficher les statistiques par utilisateur connecté</a><br />
<br />
<br />
Module comptable :<br />
<a href="<%= response.encodeURL("afficherTousEvenementsComptable.jsp") %>" >Afficher tous les evenements comptables </a><br />
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.apache.tomcat.SessionManager"%>
</html>