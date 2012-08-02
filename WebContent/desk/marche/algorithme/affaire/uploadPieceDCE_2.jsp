<%@ include file="/include/headerXML.jspf" %>

<%@ page import="java.sql.*" %>
<%@ page import="modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Chargement de fichier";
	String rootPath = request.getContextPath()+"/";

	if(marche.getIdMarche() == -1)
	{
		%><%@ include file="../../../include/headerDesk.jspf" %>
		</head><body>ERROR : l'identifiant de l'affaire est erroné</body ><%@page import="java.util.Iterator"%><%@page import="org.apache.commons.fileupload.FileUploadException"%>
</html><%
		return;
	}


	DiskFileItemFactory factory = new DiskFileItemFactory();
	//factory.setSizeThreshold();
	//factory.setRepository();
	ServletFileUpload upload = new ServletFileUpload(factory);
	//upload.setSizeMax(-1);

	System.out.println("isMultipart = " + ServletFileUpload.isMultipartContent(request));
	List items = null;
	try {
		items = upload.parseRequest(request);
	} catch (FileUploadException e) {
		e.printStackTrace();
	}
	MarchePieceJointe pj = new MarchePieceJointe();
	int nbPiecesJointes = -1;
	int typeFile = -1;
	boolean bLienActif = true;
	int iIdLot = 0;
	
	Iterator iter = items.iterator();
	while (iter.hasNext()) 
	{
		FileItem item = (FileItem) iter.next();
		if (item.isFormField())
		{
			if (item.getFieldName().equals("nbPiecesJointes"))
				nbPiecesJointes = Integer.parseInt(item.getString()) - 1;
				
			if (item.getFieldName().equals("typeFile"))
			{
				typeFile = Integer.parseInt(item.getString());
			}
			
			if (item.getFieldName().equals("iIdLot"))
			{
				iIdLot = Integer.parseInt(item.getString());
			}
			
			if (item.getFieldName().equals("actif"))
			{
				if (item.getString().equalsIgnoreCase("false"))
					bLienActif = false;
			}
		}
		else {
			if (item.getFieldName().equals("filePath"))
			{
				pj.setIdMarche(marche.getIdMarche());
				pj.setNomPieceJointe(item.getName());
				pj.setPieceJointe(item.getInputStream());
				pj.setDateCreation(new Timestamp(System.currentTimeMillis()));
				pj.setDateModif(new Timestamp(System.currentTimeMillis()));
				pj.setIdMarchePieceJointeType(typeFile);
				pj.setLienActif(bLienActif);
				pj.setIdMarcheLot(iIdLot);
				
				pj.create();
				pj.storePieceJointe();
			}
		}
	}

	boolean bIsDCEDisponible = marche.isDCEDisponible(false);
	
	if (bIsDCEDisponible)
	{
		marche.setDCEModifieApresPublication(true); 
		marche.setCandidatsPrevenusModificationDCE(false);
		marche.store();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherAffaire.jsp?iIdOnglet=7&sAction=store&iIdAffaire=" + marche.getIdMarche())); 

%>