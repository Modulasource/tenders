<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.editorial.*,java.util.*,org.coin.fr.bean.*,org.coin.bean.*" %>
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
<%
group.removeWithObjectAttached();

String sMessTitle = "Succès !";
String sMess = "La suppression du groupe a bien été effectuée.";
String sUrlIcone = Icone.ICONE_SUCCES;	
%>
<%@ include file="../../include/message.jspf" %>
<div><input type="button" name="retour" value="Retour à la liste des groupes rédactionnels" 
	onclick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/editorial/afficherTousEditorialAssistanceGroup.jsp") %>')" />
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>