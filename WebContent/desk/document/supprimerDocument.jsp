<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.document.*,java.util.*,org.coin.fr.bean.*,org.coin.bean.*" %>
<%
	String sTitle = "Suppression de l'organisation ";

	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	
	int iIdDocument = -1;
	try{iIdDocument = Integer.parseInt(request.getParameter("iIdDocument"));}
	catch (Exception e)	{}
	Document doc = Document.getDocument(iIdDocument);
	
	String sPageUseCaseId = "IHM-DESK-GED-005";
	Vector<DocumentLibrary> vLibOrganisation = DocumentLibrary.getAllDocumentLibraryFromDocumentAndReferenceAndTypeObjet((int)doc.getId(),personne.getIdOrganisation(),ObjectType.ORGANISATION);
	if(vLibOrganisation != null && vLibOrganisation.size()>0)
	{
		sPageUseCaseId = "IHM-DESK-GED-018";
	}
	
	if(personne.getIdPersonnePhysique() == doc.getIdPersonnePhysiqueAuteur())
	{	
		sPageUseCaseId = "IHM-DESK-GED-017";
	}
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<%
doc.removeWithObjectAttached();

String sMessTitle = "Succès !";
String sMess = "La suppression du document a bien été effectuée.";
String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;	
%>
<%@ include file="../../include/message.jspf" %>
<div><input type="button" name="retour" value="Retour à la liste des documents" 
	onclick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/document/afficherTousDocuments.jsp") %>')" />
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>