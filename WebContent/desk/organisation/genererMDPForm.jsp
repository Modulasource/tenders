<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*" %>
<%
	String sTitle = "";
	String sMessTitle = "Attention !";
	String sMess = "";
	String sUrlIcone = Icone.ICONE_WARNING;
	String sBoutonName = "";
	Connection conn = ConnectionManager.getConnection();

	int iIdUser = Integer.parseInt(request.getParameter("iIdUser")); ;
	User user = User.getUser(iIdUser,conn);
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual(), false, conn);;
	Organisation organisation = Organisation.getOrganisation(personne.getIdOrganisation(), false, conn);

	
    String sPageUseCaseId = AddressBookHabilitation.getUseCaseForGeneratePassword(organisation);
    sessionUserHabilitation.isHabilitateException(sPageUseCaseId , conn);


	sTitle = "Génération d'un mot de passe";
	
	sMess = "Vous allez générer un nouveau mot de passe pour le compte utilisateur de "
		+ personne.getCivilitePrenomNom(conn) + ".<br />"
		+ "Cette personne recevra un mail avec son nouveau mot de passe.";
	sBoutonName = "Générer";
	
	ConnectionManager.closeConnection(conn);

%>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<form name="formulaire" method="post" action="<%=response.encodeURL("genererMDP.jsp")%>" >
<input type="hidden" name="iIdUser" value="<%= iIdUser %>" />
<%@ include file="../../include/message.jspf" %>
	<div align="center">
		<button type="submit" name="submit" ><%= sBoutonName %></button>
		&nbsp;
		<button type="reset" name="RAZ" 
			onclick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="+personne.getIdPersonnePhysique()) %>')" 
			>Annuler</button>
	</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
<%@page import="modula.graphic.Icone"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>

<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%></html>