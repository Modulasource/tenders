<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,org.coin.bean.document.*,modula.marche.*,org.coin.fr.bean.*,modula.*" %>
<%
	String sTitle = "Suppression du document ";
	
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
<form name="formulaire" method="post" action="<%=response.encodeURL("supprimerDocument.jsp")%>" >
	<input type="hidden" name="iIdDocument" value="<%= iIdDocument %>" />
<%
	String sMessTitle = "Attention !";
	String sMess = "Vous allez supprimer un document.";
	sMess += "\nCe document sera retiré de toutes les librairies de documents.";
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;	
%>
<%@ include file="../../include/message.jspf" %>
	<div>
		<input type="submit" name="submit" value="Supprimer" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onclick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/document/afficherDocument.jsp?iIdDocument="+iIdDocument) %>')" />
	</div>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>