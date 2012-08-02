<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,org.coin.bean.editorial.*,org.coin.fr.bean.*" %>
<%
	String sTitle = "Suppression du contenu rédactionnel ";
	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	
	int iIdEditorialAssistance = -1;
	try{iIdEditorialAssistance = Integer.parseInt(request.getParameter("iIdEditorialAssistance"));}
	catch (Exception e)	{}
	EditorialAssistance edit = EditorialAssistance.getEditorialAssistance(iIdEditorialAssistance);
	
	String sPageUseCaseId = "IHM-DESK-AR-007";
	Vector<EditorialAssistanceLibrary> vLibOrganisation = EditorialAssistanceLibrary.getAllEditorialAssistanceLibraryFromEditorialAssistanceAndReferenceAndTypeObjet((int)edit.getId(),personne.getIdOrganisation(),ObjectType.ORGANISATION);
	if(vLibOrganisation != null && vLibOrganisation.size()>0)
	{
		sPageUseCaseId = "IHM-DESK-AR-008";
	}
	
	if(personne.getIdPersonnePhysique() == edit.getIdPersonnePhysiqueAuteur())
	{	
		sPageUseCaseId = "IHM-DESK-AR-009";
	}
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<form name="formulaire" method="post" action="<%=response.encodeURL("supprimerEditorialAssistance.jsp")%>" >
	<input type="hidden" name="iIdEditorialAssistance" value="<%= iIdEditorialAssistance %>" />
<%
	String sMessTitle = "Attention !";
	String sMess = "Vous allez supprimer un contenu rédactionnel.";
	sMess += "\nCe contenu sera retiré de toutes les librairies de contenu.";
	sMess += "\nIl sera aussi retiré de son groupe.";
	String sUrlIcone = Icone.ICONE_WARNING;	
%>
<%@ include file="../../include/message.jspf" %>
	<div>
		<input type="submit" name="submit" value="Supprimer" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onclick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/editorial/afficherEditorialAssistance.jsp?iIdEditorialAssistance="+iIdEditorialAssistance) %>')" />
	</div>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>