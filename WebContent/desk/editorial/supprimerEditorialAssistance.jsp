<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.editorial.*,java.util.*,org.coin.fr.bean.*,org.coin.bean.*" %>
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
<%
edit.removeWithObjectAttached();

String sMessTitle = "Succès !";
String sMess = "La suppression du contenu a bien été effectuée.";
String sUrlIcone = Icone.ICONE_SUCCES;	
%>
<%@ include file="../../include/message.jspf" %>
<div><input type="button" name="retour" value="Retour à la liste des contenus rédactionnels" 
	onclick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/editorial/afficherTousEditorialAssistance.jsp") %>')" />
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>