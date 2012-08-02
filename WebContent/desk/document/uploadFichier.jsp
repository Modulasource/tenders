<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.graphic.*" %>
<%@ page import="org.coin.bean.document.*,org.coin.bean.*" %>
<%
	String sTitle = "Modification du fichier";
	
	int iIdDocument = -1;
	try{iIdDocument = Integer.parseInt(request.getParameter("iIdDocument"));}
	catch (Exception e)	{}
	
	int iIdDocumentRedirect = -1;
	try{iIdDocumentRedirect = Integer.parseInt(request.getParameter("iIdDocumentRedirect"));}
	catch (Exception e)	{iIdDocumentRedirect = iIdDocument;}
	if(iIdDocumentRedirect == -1)
		iIdDocumentRedirect = iIdDocument;
	
	int iIdOnglet = -1;
	try{iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e)	{}
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdDocumentType = -1;
	try{iIdDocumentType = Integer.parseInt(request.getParameter("iIdDocumentType"));}
	catch (Exception e)	{}
	
	Document doc = Document.getDocument(iIdDocument);
	
	if(sAction.equalsIgnoreCase("create"))
	{
		Document docCreate = new Document();
		docCreate.setIdDocumentType(iIdDocumentType);
		docCreate.setIdPersonnePhysiqueAuteur(sessionUser.getIdIndividual());
		docCreate.setName(doc.getName());
		docCreate.create();
		docCreate.setFromFormMultiPart(request,"");
		docCreate.store();
		
		DocumentLibrary libReference = new DocumentLibrary();
		libReference.setIdDocument((int)docCreate.getId());
		libReference.setIdTypeObjet(ObjectType.DOCUMENT);
		libReference.setIdReferenceObjet(iIdDocument);
		libReference.create();
	}
	else
	{
		doc.setFromFormMultiPart(request,"");
		doc.store();
	}
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<%
	String sMessTitle=sTitle;
	String sMess = "Le document suivant a bien été chargé : "+doc.getFileName();
	String sUrlIcone = Icone.ICONE_SUCCES;
%>
<%@ include file="../../include/message.jspf"  %>		
<input type="button" value="Fermer la fenêtre" onclick="RedirectURL('<%= response.encodeURL("afficherDocument.jsp?iIdOnglet="+iIdOnglet+"&amp;iIdDocument="+ iIdDocumentRedirect ) %>')" />
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body >
</html>
