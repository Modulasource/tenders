<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*,modula.graphic.*,org.coin.fr.bean.*,modula.algorithme.*,org.coin.util.*,modula.commission.*,modula.marche.*,java.util.*,java.text.*,modula.*"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="mt.modula.searchengine.SearchEnginePADesk"%>
<%
	GregorianCalendar gc = new GregorianCalendar();
	gc.setTimeInMillis(System.currentTimeMillis());
	gc.set(Calendar.YEAR,gc.get(Calendar.YEAR)-1);
	String sYearAttributions = Integer.toString(gc.get(Calendar.YEAR));

	String sTitle = "Petites annonces ";
	String[] PAToDelete = null;
	String sSelected = "selected = \"selected\"";
	try{
		PAToDelete = request.getParameterValues("PAToDelete");  
	}
	catch(Exception e){	}
	
	if (PAToDelete != null)
	for(int i=0;i<PAToDelete.length;i++){
		Marche mToDelete = Marche.getMarche(Integer.parseInt(PAToDelete[i]));
		mToDelete.removeWithObjectAttached();
	}

%>
<%@ include file="pave/paveSearchEnginePA.jspf" %>
<script type="text/javascript" >
	function removePA()
	{
		if (confirm("Vous allez supprimer définitivement les petites annonces sélectionnées. Etes vous sûr(e)?"))
			document.formulaire.submit();
	}
	function removePAArchivees()
	{
 		return confirm("Vous allez supprimer définitivement les petites annonces Archivées. Etes vous sûr(e)?");

	}

	window.onload = function(){
		Element.hide("searchButton");
	}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="pave/paveMenuAfficherToutesPetitesAnnonces.jspf" %>

<form action="<%= response.encodeURL("afficherToutesPetitesAnnonces.jsp") %>" name="formulaire" method="post">
<%@ include file="pave/paveFilterSearchEngineForm.jspf" %>
<%@ include file="/include/paveSearchEngineForm.jspf" %>
<table class="pave" >
	<%@ include file="/include/paveHeaderSearchEngineResultListe.jspf" %>
	<tr>
		<td colspan="2">
			<table class="liste" >
				<%= recherche.getHeaderFields(response, rootPath) %>
<%
	int j;

// OPTIMISATION
CoinDatabaseWhereClause wcWhereClause =
	new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);

/*	for (int i = 0; i < vMarches.size(); i++)
{
	Marche marche = (Marche) vMarches.get(i);
	wcWhereClause .add(marche.getIdCreateur());
}

*/
	for (int i = 0; i < vMarches.size(); i++)
	{
		//String sTypeAffaire = "";
		iIdMarche = -1;
		Marche marche = (Marche )vMarches.get(i);
		Organisation orga = Organisation.getOrganisation(marche.getIdOrganisationFromMarche());
		j = i % 2;

		Vector<Validite> vValiditesAnnonce = Validite.getAllValiditeAffaireFromAffaire(marche.getIdMarche());
		Validite oValiditeAnnonce = null;
		java.sql.Timestamp tsDateAnnonceDebut = null;
		java.sql.Timestamp tsDateAnnonceFin = null;
		java.sql.Timestamp tsDateCreationAffaire = null;
		sStatut = "";
		boolean bAffairePublieeSurPublisher = false;
		if(vValiditesAnnonce != null)
		{
			if(vValiditesAnnonce.size() == 1) 
			{
				oValiditeAnnonce = vValiditesAnnonce.firstElement();
				tsDateAnnonceDebut = oValiditeAnnonce.getDateDebut();
				tsDateAnnonceFin = oValiditeAnnonce.getDateFin();
				bAffairePublieeSurPublisher = marche.isAffairePublieeSurPublisher(false) ;
				
			}		
		}
		tsDateCreationAffaire = marche.getDateCreation();
					
		if(marche.isAffaireAATR(false)) sTypeAffaire = "AATR";
		if(marche.isAffaireAAPC(false)) sTypeAffaire = "AAPC";
		if(marche.isRecapAATR(false)) sTypeAffaire = "RA";
			
		boolean bAffaireValidee = marche.isAffaireValidee(false);
		boolean bAffaireArchivee = marche.isAffaireArchivee(false);
	
		
		sStatut = "A modérer";
	
		if(bAffaireValidee)
			sStatut = "Validée, en attente de mise en ligne";
	
		if (bAffairePublieeSurPublisher ) 
			sStatut = "<span class='rouge' >En ligne</span>";
		
		if(bAffaireArchivee)
			sStatut = "<span class='rouge'>Archivée</span>";
	
%>
<%@ include file="pave/paveListAllPetitesAnnonces.jspf" %>
<%
	}
%>
			</table>
		</td>
	</tr>
</table>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>