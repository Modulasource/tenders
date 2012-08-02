<%@ include file="/include/headerXML.jspf" %>

<%@ page import="com.oreilly.servlet.multipart.*, java.sql.*,modula.graphic.*,org.coin.fr.bean.*" %>
<%@ page import="modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sTitle = "Chargement de fichier";
	String rootPath = request.getContextPath()+"/";
	int iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	Organisation organisation = Organisation.getOrganisation(iIdOrganisation);
%>
<%@ include file="/desk/include/headerDesk.jspf" %>
</head>
<body>
<%
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	Part part;
	while ((part = mp.readNextPart()) != null)
	{
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			
			if (file.getName().equals("logoPath"))
			{
				organisation.setNomLogo(file.getFileName()); 
				organisation.setLogo(file.getInputStream()); 
				organisation.store();
				organisation.storeLogo(); 
			}
		}
	}
	String sNomLogo = organisation.getNomLogo(); 
	if (sNomLogo != null && !sNomLogo.equals("") )
	{
	}
	else
	{
		sNomLogo = "pas de logo chargé";
	}

	String sMessTitle="";
	String sMess = "Le logo suivant a bien été chargé :<br /><br />"+sNomLogo;
	String sUrlIcone = Icone.ICONE_SUCCES;
%>
<br /><br />
<%@ include file="/include/message.jspf"  %>	
	<br />	
	<br />
	<button type="button" 
		onclick="RedirectURL('<%= 
                response.encodeURL("afficherOrganisation.jsp?iIdOrganisation="+ organisation.getIdOrganisation() ) 
                %>')" 
        >Fermer la fenêtre</button>
            
</body >
</html>
