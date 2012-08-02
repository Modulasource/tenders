   <%@ include file="../../../../include/headerXML.jspf" %>

<%@ page import="modula.ws.spqr.*,modula.ws.boamp.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*" %>
<%@ page import="org.coin.fr.bean.export.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.io.*,java.util.*,modula.*, modula.marche.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	int iIdPublication = Integer.parseInt(request.getParameter("iIdPublication"));
	String sXmlToSend = "";

	PublicationSpqr publi = PublicationSpqr.getPublicationSpqr(iIdPublication);
	sXmlToSend = publi.getFichier();
	int	iIdExport = publi.getIdExport();

	Export export = Export.getExport(iIdExport);

	if (export.getIdExportMode() != ExportMode.MODE_FTP) 
		throw new Exception("L'export " + export.getIdExport() + " n'est pas du mode FTP");

	ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());
	
	sun.net.ftp.FtpClient ftpClient = new sun.net.ftp.FtpClient(exportModeFTP.getAdresseIP());
	ftpClient.openServer(exportModeFTP.getAdresseIP());
	ftpClient.login(exportModeFTP.getUserName(), exportModeFTP.getUserPass());
	ftpClient.binary();
	ftpClient.cd(exportModeFTP.getPathRemote());
	sun.net.TelnetOutputStream outFtp = ftpClient.put(publi.getNomFichier());
	outFtp.write(sXmlToSend.getBytes() );
	outFtp.close();

	publi.setDateEnvoiEffective(new java.sql.Timestamp(System.currentTimeMillis()));
	publi.setIdPublicationEtat(PublicationEtat.ETAT_ENVOI_ACCEPTE);
	publi.store();

	Marche marche = Marche.getMarche(iIdAffaire);
	
	if (marche.getIdOrganisationFromMarche() != modula.algorithme.AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE)
	{		
		response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?iIdAffaire="+iIdAffaire
				+"&iIdOnglet="+iIdOnglet));
	}else
	{
		response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/marche/petitesAnnonces/afficherToutesPublications.jsp?iIdAffaire="+iIdAffaire
				+"&iIdOnglet="+iIdOnglet));
	}
%>
