
<%@page import="org.coin.security.CertificateUtil"%>
<%@ page import="org.coin.security.token.*,com.oreilly.servlet.multipart.*,org.coin.bean.*,org.coin.bean.document.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-GED-001";
	String sFormPrefix = "";
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdOnglet = 0;
	try{iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e)	{}
	
	Document doc = null;
	if(sAction.equals("create"))
	{
		doc = new Document();
		doc.create();
		
		int iIdTypeObjet = ObjectType.SYSTEME;
		int iIdReferenceObjet = 0;
		String sVisibilite = "public";
		
		MultipartParser mp = null;
		Part part = null;
		try
		{
			mp = new MultipartParser(request, Integer.MAX_VALUE);
			part = mp.readNextPart();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		while (part != null)
		{
			if (part.isFile())
			{
				FilePart file = (FilePart)part;
				
				if (file.getName().equals(sFormPrefix+"sFilePath"))
				{
					doc.setFile(file.getInputStream());
					try {doc.storeFile();}
					catch (Exception e) {}
				
					doc.setFileName(file.getFileName());
					doc.setContentType(file.getContentType());
					
					try
					{
						doc.setSignatureInitiale(
								CertificateUtil.computeHashSha1File(doc.getFile()));
						
					}
					catch(Exception e){
						e.printStackTrace();
					}

					doc.setGenerateServletURL(Document.getGenerateServletURLFromContentType(doc.getContentType()));
				}
			}
			
			if (part.isParam())
			{
				ParamPart param = (ParamPart)part;

				if (param.getName().equalsIgnoreCase(sFormPrefix + "iIdPersonnePhysiqueAuteur"))
				{
					try{doc.setIdPersonnePhysiqueAuteur(Integer.parseInt(param.getStringValue()));}
					catch(Exception e){e.printStackTrace();}
				}
				if (param.getName().equalsIgnoreCase(sFormPrefix + "iIdDocumentType"))
				{
					try{doc.setIdDocumentType(Integer.parseInt(param.getStringValue()));}
					catch(Exception e){e.printStackTrace();}
				}
				if (param.getName().equalsIgnoreCase(sFormPrefix + "sNom"))
				{
					try{doc.setName(param.getStringValue());}
					catch(Exception e){e.printStackTrace();}
				}
				if (param.getName().equalsIgnoreCase(sFormPrefix + "sDescription"))
				{
					try{doc.setDescription(param.getStringValue());}
					catch(Exception e){e.printStackTrace();}
				}
				if (param.getName().equalsIgnoreCase(sFormPrefix + "sGenerateServletURL"))
				{
					try{doc.setGenerateServletURL(param.getStringValue());}
					catch(Exception e){e.printStackTrace();}
				}
				if (param.getName().equalsIgnoreCase(sFormPrefix + "sVisibilite"))
				{
					sVisibilite = param.getStringValue();
				}
				if (param.getName().equalsIgnoreCase(sFormPrefix + "iIdReferenceObjet"))
				{
					try{iIdReferenceObjet = Integer.parseInt(param.getStringValue());}
					catch(Exception e){e.printStackTrace();}
				}
				if (param.getName().equalsIgnoreCase(sFormPrefix + "iIdTypeObjet"))
				{
					try{iIdTypeObjet = Integer.parseInt(param.getStringValue());}
					catch(Exception e){e.printStackTrace();}
				}
			}

			try 
			{
				part = mp.readNextPart();
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		
		doc.store();
		DocumentLibrary lib = new DocumentLibrary();
		lib.setIdDocument((int)doc.getId());
		if(sVisibilite.equalsIgnoreCase("public"))
		{
			iIdReferenceObjet = 0;
			iIdTypeObjet = ObjectType.SYSTEME;
		}
		lib.setIdReferenceObjet(iIdReferenceObjet);
		lib.setIdTypeObjet(iIdTypeObjet);
		lib.create();
		
		if(iIdTypeObjet != ObjectType.PERSONNE_PHYSIQUE 
		|| (iIdTypeObjet == ObjectType.PERSONNE_PHYSIQUE && iIdReferenceObjet != doc.getIdPersonnePhysiqueAuteur())
		)
		{
			DocumentLibrary libAuteur = new DocumentLibrary();
			libAuteur.setIdDocument((int)doc.getId());
			libAuteur.setIdReferenceObjet(doc.getIdPersonnePhysiqueAuteur());
			libAuteur.setIdTypeObjet(ObjectType.PERSONNE_PHYSIQUE);
			libAuteur.create();
		}
	}
	if(sAction.equals("store"))
	{
		int iIdDocument = -1;
		try{iIdDocument = Integer.parseInt(request.getParameter("iIdDocument"));}
		catch (Exception e)	{}
		
		doc = Document.getDocument(iIdDocument);
		doc.setFromForm(request,"");	
		doc.store();
	}
	if(sAction.equals("removeFromAffaire"))
	{
		int iIdDocument = -1;
		try{iIdDocument = Integer.parseInt(request.getParameter("iIdDocument"));}
		catch (Exception e)	{}
		
		int iIdAffaire = -1;
		try{iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));}
		catch (Exception e)	{}
		
		doc = Document.getDocument(iIdDocument);
		doc.removeWithObjectAttached();
		
		response.sendRedirect(
				response.encodeRedirectURL(
						"afficherTousDocumentsGeneres.jsp?iIdAffaire=" + iIdAffaire 
						+ "&nonce=" + System.currentTimeMillis() ));
		return;
	}
	
	if(sAction.equals("removeFromDocument"))
	{
		int iIdDocument = -1;
		try{iIdDocument = Integer.parseInt(request.getParameter("iIdDocument"));}
		catch (Exception e)	{}
		
		doc = Document.getDocument(iIdDocument);
		doc.removeWithObjectAttached();
		
		int iIdDocumentRedirect = -1;
		try{iIdDocumentRedirect = Integer.parseInt(request.getParameter("iIdDocumentRedirect"));}
		catch (Exception e)	{}
		
		
		response.sendRedirect(
				response.encodeRedirectURL(
						"afficherDocument.jsp?iIdDocument=" + iIdDocumentRedirect 
						+ "&iIdOnglet=" + iIdOnglet
						+ "&nonce=" + System.currentTimeMillis() ));
		return;
	}
	
	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherDocument.jsp?iIdDocument=" + doc.getId() 
					+ "&iIdOnglet=" + iIdOnglet
					+ "&nonce=" + System.currentTimeMillis() ));
%>
