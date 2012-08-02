<%@ include file="../../../../include/headerXML.jspf" %>

<%@ page import="modula.ws.spqr.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.io.*,java.util.*,modula.*, modula.marche.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<% 
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Envoi des affaires au SPQR";
%>
<%@ include file="../../include/headerDesk.jspf" %> 
</head>
<body>
<a name="ancreHP">&nbsp;</a>
<div class="titre_page"><%=sTitle %></div>
<table class="pave" summary="none">
	<tr>
		<td class="pave_cellule_droite">
		<img src="<%= rootPath + modula.graphic.Icone.ICONE_WARNING%>" style="vertical-align:middle" />
		&nbsp;Génération du flux XML, cette opération peut prendre quelques instants, merci de patienter.
		</td>
	</tr>
<%
	Vector vPublicationSpqr = PublicationSpqr.getAllPublicationSpqr();
	int iNbPublicationEnvoyees = 0;
	for(int i= 0;i<vPublicationSpqr.size();i++){
		PublicationSpqr publi = null;
		try {
			publi = (PublicationSpqr) vPublicationSpqr.get(i);
			if ((publi.getNomFichier()!="")&&(publi.getIdPublicationEtat()== PublicationEtat.ETAT_A_ENVOYER)){
				iNbPublicationEnvoyees++;
				String sXmlToSend = publi.getFichier();
				int	iIdExport = publi.getIdExport();
		
				Export export = Export.getExport(iIdExport);
		
				if (export.getIdExportMode() != ExportMode.MODE_FTP) 
					throw new Exception("L'export " + export.getIdExport() + " n'est pas du mode FTP");
		
				Marche marche = Marche.getMarche(publi.getIdReferenceObjet());
%>
	<tr>
		<td class="pave_cellule_droite">
		<img src="<%= rootPath + modula.graphic.Icone.ICONE_SUCCES%>" style="vertical-align:middle" />
		&nbsp;Envoi de l'affaire ref.<%=marche.getReference() %> au SPQR.
		</td>
	</tr>
<%
				out.flush();
				ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());
				Connection conn = ConnectionManager.getConnection();
				String sNomFichier = PublicationSpqr.computeNomFichierStatic(export, conn) ;
				ConnectionManager.closeConnection(conn);
				
				sun.net.ftp.FtpClient ftpClient = new sun.net.ftp.FtpClient(exportModeFTP.getAdresseIP());
				ftpClient.openServer(exportModeFTP.getAdresseIP());
				ftpClient.login(exportModeFTP.getUserName(), exportModeFTP.getUserPass());
				ftpClient.binary();
				ftpClient.cd(exportModeFTP.getPathRemote());
				sun.net.TelnetOutputStream outFtp = ftpClient.put(sNomFichier);
				outFtp.write(sXmlToSend.getBytes() );
				outFtp.close();
		
				publi.setDateEnvoiEffective(new java.sql.Timestamp(System.currentTimeMillis()));
				publi.setIdPublicationEtat(PublicationEtat.ETAT_ENVOI_ACCEPTE);
				publi.store();
				ExportParametre.resetIntValue(export.getIdExport(),"spqr.filename.xml.send.count");
			}
		}catch(Exception e){e.printStackTrace();}

	}
	String sUrlRedirect =
		response.encodeRedirectURL(rootPath+"desk/marche/petitesAnnonces/afficherToutesPetitesAnnonces.jsp?"
				+ "nonce=" + System.currentTimeMillis()
				+"&#ancreHP");
%>
	<tr>
		<td class="pave_cellule_droite">
		<img src="<%= rootPath + modula.graphic.Icone.ICONE_SUCCES%>" style="vertical-align:middle" />
			&nbsp;<%=(iNbPublicationEnvoyees>0)?iNbPublicationEnvoyees+" affaires envoyées ":"Aucune affaire envoyée " %>au SPQR.
		</td>
	</tr>
</table>
	<br /><br />
	<input type="button" value="Retour à la liste des petites annonces" onclick="Redirect('<%= sUrlRedirect %>')" />
<%@include file="../../include/footerDesk.jspf" %>
</body>
<%@page import="org.coin.db.ConnectionManager"%>
</html>