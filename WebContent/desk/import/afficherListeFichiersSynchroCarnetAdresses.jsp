<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.w3c.dom.*,org.coin.util.*" %>
<% 
	String sTitle = "Synchronisation du carnet d'adresses : Liste des fichiers reçus" ;
	String sPathFileFTP = sessionUser.getPath() + "/web/ftp/carnetAdresses";
	String sPageUseCaseId = "CU-PUBLISSIMO-001";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"><%="Liste des fichiers reçus dans : " + sPathFileFTP %></td>
		</tr>
		<tr>
			<td>
				<table class="liste" summary="Liste des fichiers reçus">
					<tr>
						<th style="width:50%">Fichier</th> 
						<th style="width:40%">Nombre d'organismes à synchroniser</th>
						<th style="width:10%">Synchroniser</th> 
					</tr>
		
	<%
		Document doc ;
		// filtrer sur les noms en *.xml
		String caListeFichiers[] = org.coin.fr.bean.CarnetAdresseWrapper.getFiles(sPathFileFTP);
		String sUseCaseIdBoutonSynchroniser = "IHM-DESK-";
		if (caListeFichiers != null) 
		for(int i = 0 ; i < caListeFichiers.length  ; i++)
		{
			String sFileName = caListeFichiers[i];
			doc = BasicDom.parseXmlFile(sPathFileFTP + "/" + sFileName, false);
			if (doc != null)
			{
				Node nodeOrganisme = BasicDom.getFirstChildElementNode(BasicDom.getFirstChildElementNode(doc));
				String sUrlSynchroniser = "synchroniserFichierCarnetAdresses.jsp?sFilename=" + sFileName;
	%>
				<%@include file="pave/paveFichiersAImporter.jspf" %>
 	<%
			}
		}
	%>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
