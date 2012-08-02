<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,org.w3c.dom.*,org.coin.util.*,modula.ws.marco.*,modula.marche.*,modula.graphic.*" %>

<%@page import="org.quartz.JobExecutionException"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<% 
	String sTitle = "Petites annonces " ;
	String sPathFileFTP = sessionUser.getPath() + "/web/ftp/pa";
	String sFileName = sPathFileFTP + "/" + request.getParameter("sFilename");
	// TODO : filtrer sur les noms en *.xml
	
	Document doc = BasicDom.parseXmlFileWithException(/*sPathFileFTP + "/" + */sFileName, false);
	// TODO : Ajouter la validation avec le XSD
	if (doc == null)
	{
		return ;
	}
	Node nodeListePetiteAnnonce = BasicDom.getFirstChildElementNode(doc);
	Vector vPetitesAnnonces = modula.marche.PetiteAnnonceWrapper.getPetitesAnnonces(nodeListePetiteAnnonce);
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
	<form action="<%=response.encodeURL("importerFichierPetitesAnnonces.jsp?sFilename="+ java.net.URLEncoder.encode(sFileName)+"&amp;sSelectedItems=all"+"&#ancreHP")%>" method="post" name="formaulaire">
<div style="text-align:center">
	<input type="button" value="Importer toutes les petites annonces" 
		onclick="Redirect('<%=
			response.encodeRedirectURL("importerFichierPetitesAnnonces.jsp?sFilename="+ 
					java.net.URLEncoder.encode( sFileName)+"&#ancreHP") %>')" />&nbsp;
	<input type="submit" value="Importer les petites annonces sélectionnées" />
</div>
<% 
	for(int i = 0; i < vPetitesAnnonces.size() ;i++)
	{
		PetiteAnnonceWrapper pa = (PetiteAnnonceWrapper ) vPetitesAnnonces.get(i);
		if (pa.getReference() == null)
		{
			pa.setReference("Indéfinie");
		}
		if (pa.getObjet() == null)
		{
			pa.setObjet("Indéfini");
		}
		java.sql.Timestamp tsDateDebutMiseEnLignePublisher = pa.getDateDebutMiseEnLignePublisher() ;
		java.sql.Timestamp tsDateFinMiseEnLignePublisher = pa.getDateFinMiseEnLignePublisher() ;
		String sDateDebutMiseEnLignePublisher ;
		String sDateFinMiseEnLignePublisher ;
		
		if (tsDateDebutMiseEnLignePublisher == null)
		{
			sDateDebutMiseEnLignePublisher = "Indéfinie";
		}
		else
		{
			sDateDebutMiseEnLignePublisher = tsDateDebutMiseEnLignePublisher.toString();
		}

		if (tsDateFinMiseEnLignePublisher == null)
		{
			sDateFinMiseEnLignePublisher = "Indéfinie";
		}
		else
		{
			sDateFinMiseEnLignePublisher = tsDateFinMiseEnLignePublisher.toString();
		}

		String sPetiteAnnonceTexteLibre = pa.getLibelle();
		sPetiteAnnonceTexteLibre = Outils.replaceAll(sPetiteAnnonceTexteLibre , "\n", "<br />");
		sPetiteAnnonceTexteLibre = WindowsEntities.cleanUpWindowsEntities(sPetiteAnnonceTexteLibre);
        //sPetiteAnnonceTexteLibre = Outils.replaceAll(sPetiteAnnonceTexteLibre,"¤","&euro;");
		//sPetiteAnnonceTexteLibre = Outils.replaceAll(sPetiteAnnonceTexteLibre,"?","'");
		
		MarchePassation passation = null;
		try{
			passation = MarchePassation.getMarchePassationMemory(Integer.parseInt(pa.getPassation()));
		}
		catch(Exception e){}
		String sTypeAnnonce = "";
		if(pa.getTypeAnnonce().equals("1"))
					sTypeAnnonce = "AAPC";
		else if(pa.getTypeAnnonce().equals("2"))
					sTypeAnnonce = "AATR";
%>
<%@include file="pave/pavePetiteAnnonceAImporter.jspf" %>
<%

	}
%>
<div style="text-align:center">
	<input type="button" value="Importer toutes les petites annonces" 
		onclick="Redirect('<%=
			response.encodeRedirectURL("importerFichierPetitesAnnonces.jsp?sFilename="+ 
					java.net.URLEncoder.encode( sFileName)+"&#ancreHP") %>')" />&nbsp;
	<input type="submit" value="Importer les petites annonces sélectionnées" />
</div>
	</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
