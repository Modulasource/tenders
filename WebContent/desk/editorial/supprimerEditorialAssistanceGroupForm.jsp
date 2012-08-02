<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,org.coin.bean.editorial.*,org.coin.fr.bean.*" %>
<%
	String sTitle = "Suppression du groupe rédactionnel ";
	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	
	int iIdEditorialAssistanceGroup = -1;
	try{iIdEditorialAssistanceGroup = Integer.parseInt(request.getParameter("iIdEditorialAssistanceGroup"));}
	catch (Exception e)	{}
	EditorialAssistanceGroup group = EditorialAssistanceGroup.getEditorialAssistanceGroup(iIdEditorialAssistanceGroup);
	
	String sPageUseCaseId = "IHM-DESK-AR-024";
	Vector<EditorialAssistanceGroupLibrary> vLibOrganisation = EditorialAssistanceGroupLibrary.getAllEditorialAssistanceGroupLibraryFromGroupAndReferenceAndTypeObjet((int)group.getId(),personne.getIdOrganisation(),ObjectType.ORGANISATION);
	if(vLibOrganisation != null && vLibOrganisation.size()>0)
	{
		sPageUseCaseId = "IHM-DESK-AR-025";
	}
	
	if(personne.getIdPersonnePhysique() == group.getIdPersonnePhysiqueAuteur())
	{	
		sPageUseCaseId = "IHM-DESK-AR-026";
	}
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<form name="formulaire" method="post" action="<%=response.encodeURL("supprimerEditorialAssistanceGroup.jsp")%>" >
	<input type="hidden" name="iIdEditorialAssistanceGroup" value="<%= iIdEditorialAssistanceGroup %>" />
<%
	String sMessTitle = "Attention !";
	String sMess = "Vous allez supprimer un groupe rédactionnel.";
	sMess += "\nCe groupe sera retiré de toutes les librairies de groupe.";
	sMess += "\nTous les contenus associés à ce groupe vont être supprimées.";
	String sUrlIcone = Icone.ICONE_WARNING;	
%>
<%@ include file="../../include/message.jspf" %>
	<div>
		<input type="submit" name="submit" value="Supprimer" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onclick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/editorial/afficherEditorialAssistanceGroup.jsp?iIdEditorialAssistanceGroup="+iIdEditorialAssistanceGroup) %>')" />
	</div>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>