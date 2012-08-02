<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="com.oreilly.servlet.multipart.*, java.sql.*, java.io.*" %>
<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Chargement de fichier";

	MultipartParser mp = new MultipartParser(request,Integer.MAX_VALUE, true, false);
	MarchePieceJointe pj = new MarchePieceJointe();
	int nbPiecesJointes = -1;
	int typeFile = -1;
	boolean bLienActif = true;
	int iIdLot = 0;

	/* Récupération des parties de la requête HTTP */
	Part part = null;
	try {
		part = mp.readNextPart();
	}
	catch(IOException e){
	}
	while (part != null)
	{
		if (part.isParam())
		{
			ParamPart param = (ParamPart)part;
	
			if (param.getName().equals("nbPiecesJointes"))
				try{
				nbPiecesJointes = Integer.parseInt(param.getStringValue()) - 1;
				}
				catch(UnsupportedEncodingException e){}
	
			if (param.getName().equals("typeFile"))
			{
				try{
				typeFile = Integer.parseInt(param.getStringValue());
				}
				catch(UnsupportedEncodingException e){}
			}
			
			if (param.getName().equals("iIdLot"))
			{
				try{
				iIdLot = Integer.parseInt(param.getStringValue());
				}
				catch(UnsupportedEncodingException e){}
			}
			
			if (param.getName().equals("actif"))
			{
				try{
				if (param.getStringValue().equalsIgnoreCase("false"))
					bLienActif = false;
				}
				catch(UnsupportedEncodingException e){}
			}
		}
		
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			
			if (file.getName().equals("filePath"))
			{
				pj.setIdMarche(marche.getIdMarche());
				pj.setNomPieceJointe(file.getFileName());
				pj.setPieceJointe(file.getInputStream());
				pj.setDateCreation(new Timestamp(System.currentTimeMillis()));
				pj.setDateModif(new Timestamp(System.currentTimeMillis()));
				pj.setIdMarchePieceJointeType(typeFile);
				pj.setLienActif(bLienActif);
				pj.setIdMarcheLot(iIdLot);
				pj.create();
				pj.storePieceJointe();
			}
		}
		try 
		{
			part = mp.readNextPart();
		}
		catch(IOException e){e.printStackTrace();}
	}
	boolean bIsDCEDisponible = marche.isDCEDisponible(false);
	
	if (bIsDCEDisponible)
	{
		marche.setDCEModifieApresPublication(true); 
		marche.setCandidatsPrevenusModificationDCE(false);
		marche.store();
	}
	response.sendRedirect(response.encodeRedirectURL("afficherAffaire.jsp?iIdOnglet=7&sAction=store&iIdAffaire=" + marche.getIdMarche())); 

%>