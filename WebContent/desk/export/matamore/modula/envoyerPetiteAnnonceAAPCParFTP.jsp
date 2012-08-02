<%@ include file="../../../../include/headerXML.jspf" %>

<%@ page import="modula.ws.spqr.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="modula.algorithme.*,java.io.*,java.util.*,org.coin.fr.bean.export.*,modula.*,modula.marche.*,modula.candidature.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdAffaire = -1;
	String sIdAffaire = null;
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	Marche marche;
	
	sIdAffaire = request.getParameter("iIdAffaire");
	marche = Marche.getMarche(Integer.parseInt(sIdAffaire ));
	Export export = Export.getExport(Integer.parseInt(request.getParameter("iIdExport")));
	Organisation publication = Organisation.getOrganisation(export.getIdObjetReferenceDestination());
	
	if (export.getIdExportMode() != ExportMode.MODE_FTP) 
	{
		throw new Exception("L'export " + export.getIdExport() + " n'est pas du mode FTP");
	} 
	ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());

	int iIdMarchePassation = -1;
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	if(iTypeProcedure ==  AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE)
		iIdMarchePassation = marche.getPetiteAnnoncePassation();
	else
		iIdMarchePassation = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdMarchePassation();
	
	
	String sXml = 
		 "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n"
		+ "<modula:petiteAnnonce >\n"
		+ "\t<typeAnnonce>1</typeAnnonce>\n"
		+ "\t<reference>" + marche.getReference() + "</reference>\n"
		+ "\t<objet>" + marche.getObjet() + "</objet>\n"
		+ "\t<dateDebutMiseEnLignePublisher></dateDebutMiseEnLignePublisher>\n"
		+ "\t<dateFinMiseEnLignePublisher></dateFinMiseEnLignePublisher>\n"
		+ "\t<typeDePrestation>" + marche.getIdMarcheType() + "</typeDePrestation>\n"
		+ "\t<modeDePassation>" + iIdMarchePassation + "</modeDePassation>\n"
		+ "\t<libelle>\n" + marche.getPetiteAnnonceTexteLibre()
		+ "\t</libelle>\n"
		+ "</modula:petiteAnnonce >\n";
		
	try {
		sXml = new String(sXml.getBytes("utf-8"));
	}
	catch(Exception e)
	{
		// TODO mettre dans la log
		// e.p;
	}
	
	sun.net.ftp.FtpClient ftpClient = new sun.net.ftp.FtpClient(exportModeFTP.getAdresseIP());
	ftpClient.openServer(exportModeFTP.getAdresseIP());
	ftpClient.login(exportModeFTP.getUserName(), exportModeFTP.getUserPass());
	ftpClient.binary();
	ftpClient.cd(exportModeFTP.getPathRemote());

	sun.net.TelnetOutputStream outFtp = ftpClient.put("modula_pa_" + System.currentTimeMillis() + ".xml");
	outFtp.write(sXml.getBytes() );
	outFtp.close();
%><pre>
<%=org.coin.util.Outils.getTextToHtml(sXml)%>
</pre>
