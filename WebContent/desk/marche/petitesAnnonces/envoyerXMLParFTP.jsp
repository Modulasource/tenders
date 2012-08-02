
<%@ page import="modula.ws.spqr.ExportXml.*,modula.ws.spqr.*,modula.ws.boamp.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.io.*,java.util.*,modula.*, modula.marche.*,org.coin.bean.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	String sXmlToSend = "";
	String sTitle = "Envoi des annonces au SPQR";
%>
<%@ include file="../../include/headerDesk.jspf" %> 
</head>
<body>
<div class="titre_page"><%=sTitle %></div>
<table class="pave" summary="none">
<%
	/* C'est un batch uniquement pour les exports d'une organisation
	*  C'est Pour ne pas se mélanger les pinceaux.
	*/	
	Export export = null;//= Export.getExport(Integer.parseInt(request.getParameter("iIdExport")));
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	Vector<Export> vExports = Export.getAllExportFromSource (personneUser.getIdOrganisation(), ObjectType.ORGANISATION);
	int iIdOrganisationSpqr = PublicationSpqr.getIdOrganisationSpqrOptional();

	// recherche de l'Transfert vers l'organisation SPQR
	for(int i = 0; i < vExports.size(); i++)
	{
		Export exp = vExports.get(i);
		if(exp.getIdObjetReferenceDestination() == iIdOrganisationSpqr)
			export = exp;
	}
	
	if(export ==null)
	{
		// Export non trouvé !
		return ;
	}

	// Contrôle du export
	if (export.getIdExportMode() != ExportMode.MODE_FTP) 
		throw new Exception("L'export " + export.getIdExport() + " n'est pas du mode FTP");
	ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());

	
	Vector<PublicationSpqr> vPublications 
		= PublicationSpqr.getAllPublicationSpqrFromExportAndPublicationEtat(  
			export.getIdExport(),
			PublicationEtat.ETAT_A_ENVOYER);
	
	if(vPublications.size()!= 0){
		
		/* pour chaque publication liée à l'export
		 * vérifier si la publication est conforme aux attentes
		 * vérifier si la publication n'a pas déja été envoyé
		 * ajouter celle-ci au flux XML
		 * store() des flux dans les publications
		 * envoyer par FTP la le flux XML
		 *
		*/
		String sNomFichier = PublicationSpqr.computeNomFichier(export) ;
%>
	<tr>
		<td class="pave_cellule_droite">
		<img src="<%= rootPath + modula.graphic.Icone.ICONE_SUCCES%>" style="vertical-align:middle" />&nbsp;Création du flux XML à envoyer au SQPR.
		</td>
	</tr>
<%
		
		sXmlToSend = ExportXml.XML_HEADER + ExportXml.getRootNode( export, sNomFichier)+ "\n";
		for(int i = 0; i < vPublications .size(); i++)
		{
			PublicationSpqr publi = vPublications .get(i);
			sXmlToSend += publi.getFichier();
		}
	
		sXmlToSend += ExportXml.getEndNode(); 

%>
	<tr>
		<td class="pave_cellule_droite">
			<img src="<%= rootPath + modula.graphic.Icone.ICONE_SUCCES%>" style="vertical-align:middle" />
			&nbsp;Envoi flux XML au SQPR. Cette opération peut durer quelques instants, merci de patienter.
		</td>
	</tr>
<%
		sun.net.ftp.FtpClient ftpClient = new sun.net.ftp.FtpClient(exportModeFTP.getAdresseIP());
		ftpClient.openServer(exportModeFTP.getAdresseIP());
		ftpClient.login(exportModeFTP.getUserName(), exportModeFTP.getUserPass());
		ftpClient.binary();
		ftpClient.cd(exportModeFTP.getPathRemote());
		sun.net.TelnetOutputStream outFtp = ftpClient.put(sNomFichier);
		outFtp.write(sXmlToSend.getBytes() );
		outFtp.close();
	
		// Mise à jour des publications si envoi OK
		for(int i = 0; i < vPublications.size(); i++)
		{
			PublicationSpqr publi = vPublications .get(i);
			publi.setNomFichier(sNomFichier);
			publi.setDateEnvoiEffective(new java.sql.Timestamp(System.currentTimeMillis()));
			publi.setIdPublicationEtat(PublicationEtat.ETAT_ENVOI_ACCEPTE);
			publi.store();
		}
	}
	else {
%>
	<tr>
		<td class="pave_cellule_droite">
			<img src="<%= rootPath + modula.graphic.Icone.ICONE_WARNING %>" style="vertical-align:middle" />&nbsp;
			 Il n'y a aucune annonce à envoyer au SPQR.<br />
		</td>
	</tr>
<%
	}
	String sUrlRedirect =
		response.encodeRedirectURL(rootPath+"desk/marche/petitesAnnonces/afficherToutesPetitesAnnonces.jsp?"
				+ "nonce=" + System.currentTimeMillis()
				+"&#ancreHP");
%>
</table>
	<br /><br />
	<input type="button" value="Retour à la liste des petites annonces" onclick="Redirect('<%= sUrlRedirect %>')" />
<%@include file="../../include/footerDesk.jspf" %>
</body>
</html>