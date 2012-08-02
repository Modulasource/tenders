<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,org.coin.fr.bean.*,modula.*" %>
<%@ include file="pave/localizationObject.jspf" %>
<%
	String sTitle = locTitle.getValue(5,"Suppression de l'organisation")+" ";
	
	int iIdOrganisation = -1;
	Organisation organisation = null;
	try 
	{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = Organisation.getOrganisation(iIdOrganisation);	
		organisation.setAbstractBeanLocalization(sessionLanguage);
		sTitle += organisation.getRaisonSociale();
	}
	catch (Exception e) 
	{
		response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=17"));
		return;
	}	

	
	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForRemoveOrganization(organisation);
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
	
	String sMessTitle = localizeButton.getValue(45,"Attention")+ " !";
	String sMess = locMessage.getValue(23,"Vous allez supprimer une organisation");
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;	
	
	boolean bAuthorize = false;
	try{
		bAuthorize = AddressBook.authorizeOrganizationRemove(organisation);
	}catch(CoinDatabaseRemoveException e){sMess = e.getMessage();}
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<form name="formulaire" method="post" action="<%=response.encodeURL("supprimerOrganisation.jsp")%>" >
	<input type="hidden" name="iIdOrganisation" value="<%= iIdOrganisation %>" />
    <%@ include file="/include/message.jspf" %>
	<div class="center">
	<% if(bAuthorize){ %><button type="submit" name="submit" ><%= localizeButton.getValueDelete() %></button><%} %>
	<button type="button"  
		onclick="Redirect('<%=response.encodeRedirectURL(
				rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
						+iIdOrganisation) %>')" ><%= localizeButton.getValueCancel() %></button>
    </div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="mt.common.addressbook.AddressBook"%>
<%@page import="org.coin.db.CoinDatabaseRemoveException"%>

<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%></html>