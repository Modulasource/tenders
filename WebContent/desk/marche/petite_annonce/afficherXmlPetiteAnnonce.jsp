<%@ include file="../../../../include/headerXML.jspf" %>

<%@ page import="modula.fqr.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.io.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdAffaire = -1;
	String sIdAffaire = null;
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	String sTitle = "Afficher le XML Petite annonce"; 
	String sHeadTitre = "";
	boolean bAfficherPoursuivreProcedure = false;
	boolean bAucunePublication = true;
	Marche marche;
	
	try {
		sIdAffaire = request.getParameter("iIdAffaire");
		iIdAffaire = Integer.parseInt(sIdAffaire );
	}
	catch (Exception e) 
	{
		out.println("<html><body>iIdAffaire n'est pas reconnu : " + sIdAffaire + "</body></html>");
		return;
	}
	
	marche = Marche.getMarche(iIdAffaire );

	int iIdMarchePassation = -1;
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	if(iTypeProcedure ==  AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE)
		iIdMarchePassation = marche.getPetiteAnnoncePassation();
	else
		iIdMarchePassation = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdMarchePassation();
	
	
	String sXmlPetiteAnnonce 
		= "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n"
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
		
	
	/*sun.net.ftp.FtpClient ftpClient = new sun.net.ftp.FtpClient("serveur2.matamore.com");
	ftpClient.openServer(exportModeFTP.getAdresseIP());
	ftpClient.login("sources_modula", "modula");
	ftpClient.binary();

	sun.net.TelnetOutputStream outFtp = ftpClient.put("coin_remote_" + System.currentTimeMillis() + ".txt");
	outFtp.write(sXmlPetiteAnnonce.getBytes() );
	outFtp.close();
	*/
	
%><pre>
<%= org.coin.util.Outils.getTextToHtml(sXmlPetiteAnnonce) %>
</pre>
