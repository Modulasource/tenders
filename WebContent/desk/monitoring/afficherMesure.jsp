<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.perf.*, java.util.*" %>
<%
	String sTitle = "afficher mesures";
	Mesure mesure = Mesure.getMesure(Integer.parseInt(request.getParameter("iIdMesure")));
	String sPersonneNomPrenom = "";
	try {
		org.coin.bean.User user = org.coin.bean.User.getUser(mesure.getIdUser() );
		org.coin.fr.bean.PersonnePhysique personne  
			= org.coin.fr.bean.PersonnePhysique.getPersonnePhysique(user.getIdIndividual());
		sPersonneNomPrenom 
			= "<a href='" 
			+ response.encodeURL(
				rootPath + "desk/organisation/afficherPersonnePhysique.jsp?" 
				+ "iIdPersonnePhysique="+ personne.getIdPersonnePhysique() )
			+ "' >" + personne.getCivilitePrenomNom() + "</a>"; 
	}catch(Exception e) {
		sPersonneNomPrenom = "non connecté";
	}

 %>
</head>
<body >
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Mesure</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Exception : </td>
		<td class="pave_cellule_droite"><%= org.coin.util.CalendarUtil.getDateFormattee(mesure.getDateCreation()) %> </td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">User : </td>
		<td class="pave_cellule_droite"><%= sPersonneNomPrenom %> </td>
	</tr>
	
	<tr>
		<td class="pave_cellule_gauche">Url : </td>
		<td class="pave_cellule_droite"><%= mesure.getUrlRequested() %> </td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">IP : </td>
		<td class="pave_cellule_droite"><%= mesure.getUserIp()  %> </td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Exception : </td>
		<td class="pave_cellule_droite"><%= mesure.getException().replaceAll("\n", "<br/>") %></td>
	</tr>
</table>
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>