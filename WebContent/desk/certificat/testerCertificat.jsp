<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%@ page import="com.oreilly.servlet.multipart.*,org.coin.fr.bean.security.*,org.coin.security.token.*,java.security.cert.*,java.io.*,modula.candidature.*, java.util.*" %>
<%@ page import="org.coin.security.CertificateUtil" %>
<%
	String sTitle = "Afficher export";
%>

</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<%
	String sFileName = "";	
	String sContentType = "";	
	X509Certificate certTested = null;

	//certTested = AutoriteCertificationRacine.getX509CertificateFromFilename("c:\\_sources\\minefi\\certeurope\\ComodoSecurityServicesCA2018.crt");
	
	
	MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE);
	Part part;
	while ((part = mp.readNextPart()) != null)
	{
		/* Traitement de l'upload du fichier */
		if (part.isFile())
		{
			FilePart file = (FilePart)part;
			
			if (file.getName().equals("sFilePath"))
			{
				sFileName = file.getFileName(); 
				sContentType = file.getContentType(); 
			 
				CertificateFactory cf = CertificateFactory.getInstance("X.509");
				certTested = (X509Certificate)cf.generateCertificate(file.getInputStream());
				
			}
		}
	}
		
	Vector<X509Certificate > vChaineCertification = new Vector<X509Certificate > ();
	boolean bIsChainValid = false;
	try {
		vChaineCertification = AutoriteCertificationRacine.getChainedCertificate(certTested);
		bIsChainValid = true;
	} catch(Exception e)	
	{
		vChaineCertification.add(certTested);
	}

%>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Chaîne de certification </td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Chaîne : </td>
		<td class="pave_cellule_droite"><%= bIsChainValid?"Valide":"Invalide !!!" %>
		</td>
	</tr>
</table>
<br />
<%
	for(int i=0 ; i< vChaineCertification.size(); i++)
	{	
		X509Certificate cert = vChaineCertification.get(i);
		Calendar calNotBefore = Calendar.getInstance();
		calNotBefore.setTimeInMillis(cert.getNotBefore().getTime());
		Calendar calNotAfter = Calendar.getInstance();
		calNotAfter.setTimeInMillis(cert.getNotAfter().getTime());
		
%>


<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Chaîne de certification</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche">Numéro de série : </td>
		<td class="pave_cellule_droite"><%= cert.getSerialNumber().toString() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Délivré à : </td>
		<td class="pave_cellule_droite"><%= CertificateUtil.getX500PrincipalInfos(cert.getSubjectX500Principal(), "<br />" )%>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Délivré par : </td>
		<td class="pave_cellule_droite"><%= CertificateUtil.getX500PrincipalInfos(cert.getIssuerX500Principal() , "<br />" ) %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Valide à partir du : </td>
		<td class="pave_cellule_droite"><%= org.coin.util.CalendarUtil.getDateFormattee( calNotBefore ) %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Valide jusqu'au : </td>
		<td class="pave_cellule_droite"><%= org.coin.util.CalendarUtil.getDateFormattee( calNotAfter) %>
		</td>
	</tr>
		<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<br />
<%
	}
%>

<button type="button" onclick="Redirect('<%= 
	response.encodeURL("afficherToutesAutoriteCertification.jsp" ) 
	%>')" >Retour</button>
<%@ include file="../../include/new_style/footerFiche.jspf" %>

</body>
</html>
