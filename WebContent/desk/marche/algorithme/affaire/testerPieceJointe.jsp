<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,modula.*,modula.candidature.*,org.coin.security.token.*" %>
<%@ page import="java.io.*,java.security.cert.*" %>
<%@ page import="org.coin.util.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	int iIdPieceJointe = -1;
	int iIdTypeObjetModula = -1;
	byte[] bytesFileHash = null;
	byte[] bytesSignatureClair = null;
	byte[] bytesSignatureChiffre = null;
	boolean bFichierClair = false;
	boolean bFichierChiffre = false;
	ByteArrayInputStream bisCertificat = null;
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";

	iIdPieceJointe = Integer.parseInt(request.getParameter("iIdPieceJointe"));
	iIdTypeObjetModula = Integer.parseInt(request.getParameter("iIdTypeObjetModula"));

	switch(iIdTypeObjetModula)
	{
		case TypeObjetModula.ENVELOPPE_A:
			EnveloppeAPieceJointe envAPJ = EnveloppeAPieceJointe.getEnveloppeAPieceJointe(iIdPieceJointe);
			bytesFileHash  = envAPJ.computeHashPieceJointe();
			bytesSignatureChiffre = envAPJ.getSignatureChiffre();
			bytesSignatureClair = envAPJ.getSignatureClair();
			bisCertificat = new ByteArrayInputStream(envAPJ.getCertificatPublic());
			break;
		
		case TypeObjetModula.ENVELOPPE_B:
			EnveloppeBPieceJointe envBPJ = EnveloppeBPieceJointe.getEnveloppeBPieceJointe(iIdPieceJointe);
			bytesFileHash  = envBPJ.computeHashPieceJointe();
			bytesSignatureChiffre = envBPJ.getSignatureChiffre();
			bytesSignatureClair = envBPJ.getSignatureClair();
			bisCertificat = new ByteArrayInputStream(envBPJ.getCertificatPublic());
			break;
	}
	
	X509Certificate oX509Certificate = null;
	CertificateFactory cf;
	try 
	{
		cf = CertificateFactory.getInstance("X.509");
		oX509Certificate = (X509Certificate) cf.generateCertificate(bisCertificat);
	} 
	catch (CertificateException e) 
	{
	
	}	
	bFichierClair = CertificateUtil.verifySign(oX509Certificate.getPublicKey(),bytesFileHash,bytesSignatureClair ,"SHA1withRSA",Crypto.BC_PROVIDER);
	bFichierChiffre = CertificateUtil.verifySign(oX509Certificate.getPublicKey(),bytesFileHash,bytesSignatureChiffre ,"SHA1withRSA",Crypto.BC_PROVIDER);
	
	sMessTitle = "Echec de l'&eacute;tape";
	sMess = InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_ERROR_VALIDATION_PRESIDENT);
	sUrlIcone = Icone.ICONE_ERROR;
	String sTitle = "Tester pièce jointe" ;
%>
<%@page import="modula.graphic.Icone"%>

<%@page import="org.coin.security.CertificateUtil"%>
<html>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
	Fichier chiffré : <%= bFichierChiffre %><br />
	Fichier clair : <%= bFichierClair %>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>