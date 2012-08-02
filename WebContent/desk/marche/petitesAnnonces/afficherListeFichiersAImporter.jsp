<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,org.w3c.dom.*,org.coin.util.*" %>
<% 
	String sTitle = "Petites annonces : Liste des fichiers reçus" ;
	String sPathFileFTP = sessionUser.getPath() + "/web/ftp/pa";
	String sPageUseCaseId = "IHM-DESK-PA-6";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"><%=sTitle + " dans " + sPathFileFTP %></td>
		</tr>
		<tr>
			<td>
				<table class="liste" summary="none">
					<tr>
						<th style="width:30%">Fichier</th>
						<th style="width:30%">Date de mise à jour</th>
						<th style="width:30%">Nombre de petites annonces</th>
						<th style="width:10%">Import</th>
					</tr>
		
	<%
		Document doc = null;
		// filtrer sur les noms en *.xml
		String saListeFichiers[] = modula.marche.PetiteAnnonceWrapper.getFiles(sPathFileFTP);
		String sUseCaseIdBoutonSupprimerFichier = "IHM-DESK-PA-8";
		String sUseCaseIdBoutonImporterFichier = "IHM-DESK-PA-7";
		if (saListeFichiers != null) 
		for(int i = 0 ; i < saListeFichiers.length  ; i++)
		{
			String sFileName = saListeFichiers[i];
			String sErrorParsing = "";
			doc = null;
			try {
				doc = BasicDom.parseXmlFileWithException(sPathFileFTP + "/" + sFileName, false);
			} catch (Exception e) {
				sErrorParsing  = "<br/>\n" + e.getMessage();
				
			}
			String sUrlAfficherFichier = "afficherFichierPetiteAnnonceAImporter.jsp?sFilename=" 
				+ java.net.URLEncoder.encode(sFileName, "ISO-8859-1") ;
			String sUrlSupprimerFichier = "modifierFichierPetiteAnnonceAImporter.jsp?sAction=remove&amp;sFilename=" 
				+ java.net.URLEncoder.encode(sFileName, "ISO-8859-1") ;

			// TODO : Ajouter la validation avec le XSD
			Vector vPetitesAnnonces = null;
			if (doc != null)
			{
				Node nodeListePetiteAnnonce = BasicDom.getFirstChildElementNode(doc);
				vPetitesAnnonces = modula.marche.PetiteAnnonceWrapper.getPetitesAnnonces(nodeListePetiteAnnonce);
				
			}
			else {
				vPetitesAnnonces =new Vector();
			}
		%>
				<%@include file="pave/paveFichiersAImporter.jspf" %>
 	<%
		}
	%>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
