<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@ page import="org.coin.fr.bean.*" %>
<%	
	String sTitle = "Suppression d'une personne";
	
	int iIdPersonne = -1;
	mt.modula.organisation.PersonnePhysiqueModula personne = null;
	Organisation organisation = null;
	iIdPersonne = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
	personne = mt.modula.organisation.PersonnePhysiqueModula.getPersonnePhysiqueModula(iIdPersonne);
	organisation = Organisation.getOrganisation(personne.getIdOrganisation());
	sTitle = "Suppression de "+personne.getCivilitePrenomNom();

	
	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForRemoveIndividual(organisation);
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );

	
	
%>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%
	long lIdCreator = HttpUtil.parseLong("lIdCreator",request,0);
	if(lIdCreator>0){
		organisation.setIdCreateur((int)lIdCreator);
		organisation.store();
	}

	personne.removeWithObjectAttached();

	String sMessTitle = "Succès !";
	String sMess = "La suppression de la personne a bien été effectuée.";
	String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;	
%>
<%@ include file="/include/message.jspf" %>
<div align="center">
	<button type="button" name="retour" 
	onclick="Redirect('<%=response.encodeRedirectURL(rootPath 
			+ "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
					+organisation.getIdOrganisation()) %>')" >Retour à l'organisation</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>