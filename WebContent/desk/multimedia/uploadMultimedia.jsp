<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ include file="../organisation/pave/localizationObject.jspf" %>
<%@ page import="java.io.*,com.oreilly.servlet.multipart.*, modula.graphic.*,org.coin.fr.bean.*" %>
<%
	String sTitle = "Chargement du média"; 
	String sUrlRedirect = "";

	Multimedia multi = new Multimedia();
	multi.create();
	
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	Part part;
	while ((part = mp.readNextPart()) != null)
	{
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			if (file.getName().equals("sFilePath"))
			{
				multi.setFileName(file.getFileName()); 
				multi.setMultimediaFile(file.getInputStream()); 
				multi.setContentType(file.getContentType()); 
				if(multi.getFileName().endsWith(".pdf"))
					multi.setContentType("application/pdf");
				try{
					multi.store();
					multi.storeMultimediaFile();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		if (part.isParam())
		{
			ParamPart param = (ParamPart)part;

			if (param.getName().equals("iIdMultimediaType")){
				multi.setIdMultimediaType( Integer.parseInt(  param.getStringValue()) );
			}
			if (param.getName().equals("iIdReferenceObjet")){
				multi.setIdReferenceObjet( Integer.parseInt(  param.getStringValue()) );
			}
			if (param.getName().equals("iIdTypeObjet")){
				multi.setIdTypeObjet( Integer.parseInt(  param.getStringValue()) );
			}
			if (param.getName().equals("sLibelle")){
				multi.setLibelle(param.getStringValue());
			}
			if (param.getName().equals("sUrlRedirect")){
				sUrlRedirect = param.getStringValue() ;
			}
			if ((param.getName().equals("bIsPhysique"))&&(Integer.parseInt(param.getStringValue()) == 1)){
				
				try{
					if (!param.getStringValue().equals("")){
						String sCommonDocumentRoot = Configuration.getConfigurationValueMemory("multimedia.documentRoot");
						String sSelfDocumentRoot = sCommonDocumentRoot+"/"+
													OrganisationParametre.getOrganisationParametreValue(multi.getIdReferenceObjet(),"organisation.multimedia.documentRoot");
						File fichier = new File(sSelfDocumentRoot);
						fichier.mkdirs();
						
						File fichierMultimedia = new File(sSelfDocumentRoot+"/"+multi.getFileName());
						FileUtil.convertInputStreamInFile(
								Multimedia.getInputStreamMultimediaFile(multi.getIdMultimedia()), 
								fichierMultimedia);
						
						
						/*
						if((multi.getIdMultimediaType()==MultimediaType.TYPE_LOGO)
						||(multi.getIdMultimediaType()==MultimediaType.TYPE_BANDEAU)){
							BufferedImage im = ImageIO.read(Multimedia.getInputStreamMultimediaFile(multi.getIdMultimedia()));
							ImageIO.write(im,"JPG",fichierImage);
						}
						else{
							PrintWriter sortie ;
							InputStreamReader ipsr=new InputStreamReader(Multimedia.getInputStreamMultimediaFile(multi.getIdMultimedia()));
							BufferedReader br=new BufferedReader(ipsr);
							String line;
							sortie = new PrintWriter( new FileWriter (new File(sSelfDocumentRoot+"/"+multi.getFileName()))) ;
							while ((line = br.readLine()) != null) 
								sortie.println(line);
							sortie.close();
						}
						*/
						
						
						multi.isPhysique(true);
						multi.setPathFile(sSelfDocumentRoot+"/"+multi.getFileName());
					}
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		
		multi.store();
	}
	
	String sMessTitle="";
	String sMess = locMessage.getValue(61,"Le média à bien été chargé");
	String sUrlIcone = Icone.ICONE_SUCCES;
	
	String sRedirectURL = response.encodeRedirectURL(
			sUrlRedirect 
			+ "&iIdReferenceObjet=" + multi.getIdReferenceObjet() 
			+ "&iIdTypeObjet=" + multi.getIdTypeObjet()
			+ "&nonce=" +System.currentTimeMillis() );
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="../../include/message.jspf"  %>	
	<div style="text-align:center">
	<button type="button" onclick="javascript:closeModalAndRedirectTabActive('<%= sRedirectURL %>')" ><%= localizeButton.getValueCloseWindow("Fermer la fenêtre") %></button>
	</div>
</body>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
<%@page import="org.coin.util.FileUtil"%>
</html>
