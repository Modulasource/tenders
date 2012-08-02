<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%@ page import="com.oreilly.servlet.multipart.*,org.coin.fr.bean.security.*,org.coin.security.token.*,java.security.cert.*,java.io.*,modula.candidature.*, java.util.*" %>
<%
	String sTitle = "Test CRL";
 %>

</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<%
	String sFileName = "";	
	String sContentType = "";	
	X509CRL crlTested = null;
	
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
				crlTested = (X509CRL)cf.generateCRL(file.getInputStream());
			}
		}
	}
	ListeRevocation listRev = new ListeRevocation();
	listRev.setCRL(crlTested);
	listRev.setLibelle("initio");
	listRev.create();
	Set listeCert = crlTested.getRevokedCertificates();
	for (Iterator it=listeCert.iterator(); it.hasNext(); ) 
	{
       X509CRLEntry crlEntry = (X509CRLEntry)it.next();
%>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Certificat</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Num de serie : </td>
		<td class="pave_cellule_droite"><%= crlEntry.getSerialNumber() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Date de r&eacute;vocation : </td>
		<td class="pave_cellule_droite"><%= crlEntry.getRevocationDate() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">encoded : </td>
		<td class="pave_cellule_droite"><%= CertificateUtil.getHexaStringValue(crlEntry.getEncoded()) %>
		</td>
	</tr>
</table>
<br />
<%
}
%>
<%@ include file="../../include/new_style/footerFiche.jspf" %>

</body>
<%@page import="org.coin.security.CertificateUtil"%>
</html>
