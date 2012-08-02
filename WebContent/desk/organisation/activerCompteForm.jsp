<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="modula.graphic.Icone"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@ page import="org.coin.fr.bean.*,org.coin.bean.*" %>
<%
	String sTitle = "";
	String sMessTitle = "Attention !";
	String sMess = "";
	String sUrlIcone = Icone.ICONE_WARNING;
	String sBoutonName = "";
	
	int iIdUser =-1 ;
	PersonnePhysique personne = null;
	User user = null;
	Organisation organisation = null;
	try
	{
		iIdUser = Integer.parseInt(request.getParameter("iIdUser"));
		user = User.getUser(iIdUser);
		personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual());
		organisation = Organisation.getOrganisation(personne.getIdOrganisation());
	}
	catch(Exception e){}
	
	String sPageUseCaseId = "";
	PersonnePhysique personneLogue = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );

	if (user.getIdUserStatus() == UserStatus.INVALIDE)
	{
		
	    sPageUseCaseId 
          = AddressBookHabilitation.getUseCaseForUserActivation(
                personne,
                organisation,
                personneLogue);
	      
		
		sTitle = "Activation ";
		sMess = "Vous allez activer le compte utilisateur de "+personne.getCivilitePrenomNom()+".<br />"
		+ "Cette personne va recevoir un mail de validation de son compte puis son identifiant et mot de passe.";
		sBoutonName = "Activer";
	}
	else
	{
		
		sPageUseCaseId 
        = AddressBookHabilitation.getUseCaseForUserDesactivation(
              personne,
              organisation,
              personneLogue);
        
		sTitle = "Désactivation ";
		sMess = "Vous allez désactiver le compte utilisateur de "+personne.getCivilitePrenomNom()+".<br />"
	 + "Cette personne ne pourra plus se connecter à son compte.<br />"
	 + "Un nouveau mot de passe sera fourni lors de la réactivation du compte.";
		sBoutonName = "Désactiver";
	}
	sTitle += "du compte de "+personne.getCivilitePrenomNom();
%>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<form name="formulaire" method="post" action="<%=response.encodeURL("activerCompte.jsp")%>" >
<input type="hidden" name="iIdUser" value="<%= iIdUser %>" />
<%@ include file="/include/message.jspf" %>
<div align="center">
	<button type="submit" name="submit" ><%= sBoutonName %></button>
	&nbsp;<button type="reset" name="RAZ" 
	onclick="Redirect('<%=
		response.encodeRedirectURL(rootPath 
				+ "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="
				+ personne.getIdPersonnePhysique()) %>')" >Annuler</button>
</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>