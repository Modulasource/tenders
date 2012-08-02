<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="com.oreilly.servlet.multipart.*,modula.graphic.*" %>
<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Chargement de fichier";
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%
	
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	
	Part part;
	while ((part = mp.readNextPart()) != null)
	{
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			
			if (file.getName().equals("aapcPath"))
			{
				marche.setNomAAPC(file.getFileName());
				marche.setAAPC(file.getInputStream());
				marche.store();
				marche.storeAAPC();
			}
		}
	}
	String sNomAAPCLibre = marche.getNomAAPC();
	if (sNomAAPCLibre != null && !sNomAAPCLibre.equals("") )
	{
	}
	else
	{
		sNomAAPCLibre = "pas de document associé";
	}

	String sMessTitle="";
	String sMess = "Le document suivant a bien été chargé :<br /><br />"+sNomAAPCLibre;
	String sUrlIcone = Icone.ICONE_SUCCES;
	
	String sURLRedirect = response.encodeURL(rootPath+"desk/marche/algorithme/affaire/afficherAffaire.jsp?iIdOnglet=8&amp;sAction=store&amp;iIdAffaire="
			+ marche.getIdMarche() );
%>
<br /><br />
<%@ include file="/include/message.jspf"  %>	
	<br />	
	<br />
	<button type="button"
	onclick="closeModalAndRedirectTabActive('<%= sURLRedirect %>')" >Fermer la fenêtre</button>
	
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body >
</html>
