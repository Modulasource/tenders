<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="pave/localizationObject.jspf" %>
<%
	String sTitle = "Suppression d'une personne";

	int iIdPersonne = -1;
	PersonnePhysique personne = null;
	Organisation organisation = null;
	iIdPersonne = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
	personne = PersonnePhysique.getPersonnePhysique(iIdPersonne);
	personne.setAbstractBeanLocalization(sessionLanguage);
	organisation = Organisation.getOrganisation(personne.getIdOrganisation());
	organisation.setAbstractBeanLocalization(sessionLanguage);
	sTitle = locTitle.getValue(6,"Suppression de")+" "+personne.getCivilitePrenomNom();

	
	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForRemoveIndividual(organisation);
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );

	
%>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<form name="formulaire" method="post" action="<%=response.encodeURL("supprimerPersonne.jsp")%>" >
<input type="hidden" name="iIdPersonnePhysique" value="<%= iIdPersonne %>" />
<%
	String sMessTitle = localizeButton.getValue(45,"Attention")+ " !";
	String sMess = "Vous allez supprimer une personne, en conséquence cette personne perdra ses droits d'accès à la plate-forme Modula."
	+ "<br />Si cette personne a candidaté pour certains marchés, ses candidatures seront également detruites.";
	sMess = locMessage.getValue(66,sMess);
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;	
%>
<%@ include file="/include/message.jspf" %>
	<div align="center" >
		<%
		if(organisation.getIdCreateur() == personne.getId()){
			Vector<PersonnePhysique> vPP = PersonnePhysique.getAllFromIdOrganisation((int)organisation.getId());
			CoinDatabaseUtil.remove(personne,vPP);
			if(vPP != null && !vPP.isEmpty()){
				%>Transférer la gérance : <%= CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect("lIdCreator",1,(Vector)vPP,0,"",false,false) %><br/><%
			}
		}
		%>
		<br/>
		<button type="submit" name="submit" >Supprimer</button>
		&nbsp;<button 
			type="reset" name="RAZ" 
		onclick="Redirect('<%=response.encodeRedirectURL(rootPath 
				+"desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="
				+iIdPersonne) %>')" >Annuler</button>
	</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.db.CoinDatabaseUtil"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%></html>