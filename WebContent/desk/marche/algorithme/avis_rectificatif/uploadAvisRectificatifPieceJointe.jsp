<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="com.oreilly.servlet.multipart.*,modula.graphic.*" %>
<%@ page import="modula.marche.*" %>
<%
	String sTitle = "Chargement de fichier";
	AvisRectificatif avis 
	= AvisRectificatif.getAvisRectificatif(
		Integer.parseInt( request.getParameter("iIdAvisRectificatif") ));
	
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	
	
	Part part;
	while ((part = mp.readNextPart()) != null)
	{
	/* Traitement de l'upload du fichier */
	if (part.isFile())
	{
		FilePart file = (FilePart)part;
		
		if (file.getName().equals("avisRectificatifPieceJointe"))
		{
			if( file.getFileName() == null)
			{
				avis.setPieceJointeNom( "");  
			}
			else
			{
				avis.setPieceJointeNom( file.getFileName());  
			}
			
			avis.store();
			avis.setPieceJointe(file.getInputStream());
			avis.storePieceJointe(); 
		}
	}
	}
	String sNomPieceJointe = avis.getPieceJointeNom(); 
	if (sNomPieceJointe != null && !sNomPieceJointe.equals("") )
	{
	}
	else
	{
		sNomPieceJointe = "pas de document associé";
	}
	
	String sMessTitle="";
	String sMess = "Le document suivant a bien été chargé :<br /><br />"+sNomPieceJointe;
	String sUrlIcone = Icone.ICONE_SUCCES;
	
	String sUrlRedirect = "afficherAffaire";
	int iOngletRectificatif = Onglet.ONGLET_AFFAIRE_RECTIFICATIF;
	if(avis.getIdAvisRectificatifType() == 2 ){
		sUrlRedirect = "afficherAttribution";
		iOngletRectificatif = Onglet.ONGLET_ATTRIBUTION_RECTIFICATIF;
	}
	
	String sURLRedirect = response.encodeURL(rootPath
			+"desk/marche/algorithme/affaire/"+sUrlRedirect
			+".jsp?sActionRectificatif=store&amp;iIdAvisRectificatif=" 
			+ avis.getIdAvisRectificatif() + "&amp;iIdOnglet=" + iOngletRectificatif
			+ "&amp;iIdAffaire=" + avis.getIdMarche() );

%>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFichePopUp.jspf" %>
<div style="padding:15px">
<%@ include file="../../../../include/message.jspf"  %>	
<div align="center">
	<button type="button"  onclick="closeModalAndRedirectTabActive('<%= sURLRedirect %>')" >Fermer la fenêtre</button>
</div>
</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body >
</html>
