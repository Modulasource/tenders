<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%@ page import="org.coin.fr.bean.export.*,modula.*, modula.marche.*" %>
<%@ page import="modula.graphic.*" %>
<%
	int iIdAffaire = -1;
	String sIdAffaire = null;
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	String sTitle = "Afficher les publications des PAs"; 
	String sHeadTitre = "";
	boolean bAfficherPoursuivreProcedure = false;
	boolean bAucunePublication = true;
	Marche marche;
	int iIdOnglet = 0;
	String sAction = "";
	try {
		sIdAffaire = request.getParameter("iIdAffaire");
		iIdAffaire = Integer.parseInt(sIdAffaire );
	}
	catch (Exception e) 
	{
		out.println("<html><body>iIdAffaire n'est pas reconnu : " + sIdAffaire + "</body></html>");
		return;
	}
	try {iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));} 	
	catch (Exception e) {}

	marche = Marche.getMarche(iIdAffaire );
	Vector<Export> vExports ;
	String sUrlRedirect ="afficherToutesPublications.jsp?foo=1";
	
	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	
	// ici c'est different c'est l'organisme de presse !
	//Commission commission = Commission.getCommission(marche.getIdCommission());
	// Organisation organisation = Organisation.getOrganisation(commission.getIdOrganisation());
	PersonnePhysique personnePresse = PersonnePhysique.getPersonnePhysique(marche.getIdCreateur());
	Organisation organisationPresse = Organisation.getOrganisation(personnePresse.getIdOrganisation());
	
	vExports = Export.getAllExportFromSource (organisationPresse.getIdOrganisation(), TypeObjetModula.ORGANISATION);

	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";


	Vector<Onglet> vOnglets = new Vector<Onglet>();
	
	if(vExports.size() > 0)
	{
		for(int i = 0; i < vExports.size(); i++)
		{
			Export export = vExports.get(i);
			
			if(	export.getIdTypeObjetDestination() == TypeObjetModula.ORGANISATION
			&& 	export.getIdExportSens() == 2 )
			{
				Organisation organisationDestination 
					= Organisation.getOrganisation(export.getIdObjetReferenceDestination());
				
				if( organisationDestination.getIdOrganisationType() 
					== OrganisationType.TYPE_PUBLICATION)
				{
					bAucunePublication = false;
					vOnglets.add( 
						new Onglet(0, 
							false, 
							organisationDestination.getRaisonSociale() + " " + export.getName(), 
							"afficherToutesPublications.jsp?iIdOnglet=" + i) ); 
				
				}
			}
				
		}
	}
	
	if(bAucunePublication)
	{
		vOnglets.add( 
			new Onglet(0, 
				false, 
				"Pas de publication définie", 
				rootPath 
				+ "desk/organisation/afficherOrganisation.jsp?"
				+ "iIdOrganisation=" + organisationPresse.getIdOrganisation() 
				+ "&amp;iIdOnglet=" + Onglet.ONGLET_ORGANISATION_EXPORTS 
				) ); 
	
	}

	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;

%>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
<script type="text/javascript" >
function onLoadBody()
{
	montrer_cacher('paveExportDescription');
	montrer_cacher('paveExportMode');
	montrer_cacher('paveExportParametres');
}

</script>
</head>
<body onload="javascript:onLoadBody();" >
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<%@ include file="../../include/headerPetiteAnnonce.jspf" %>

<br/>
<div class="tabFrame">
<div class="tabs">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		onglet = vOnglets.get(i);
		if(!onglet.bHidden)
		try {
			String sImageInCreation = "" ;
			String sOnClick = "";
			
			
			%><div <%= (onglet.bIsCurrent?"class=\"active\"":"") %>
				onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl 
					+"&amp;iIdAffaire="+marche.getIdMarche()
					+"&amp;nonce=" + System.currentTimeMillis())%>';">
				<%= onglet.sLibelle %><%= sImageInCreation %></div>
			<%	
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
</div>
<div class="tabContent">
<%
	if(!bAucunePublication)
	{
		Export export = vExports.get(iIdOnglet);
		
		String sExportModeName = 
			ExportMode.getExportModeNameMemory(export.getIdExportMode());


		Organisation organisation
			= Organisation.getOrganisation(export.getIdObjetReferenceDestination());
		
		%>
<table class="pave" summary="none">
	<tr onclick="montrer_cacher('paveExportDescription')" >
		<td class="pave_titre_gauche" colspan="2">Description</td>
	</tr>
	<tr>
		<td>
		<table id="paveExportDescription" summary="Description de l'export">
			<tr>
				<td class="pave_cellule_gauche" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Libellé : </td>
				<td class="pave_cellule_droite"><%= export.getName() %></td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Mode : </td>
				<td class="pave_cellule_droite"><%= sExportModeName %></td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche" colspan="2">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
		
<br/>
		<%
		if (export.getIdExportMode() == ExportMode.MODE_EMAIL) 
		{
			ExportModeEmail  exportModeEmail = null;
			try{
				exportModeEmail = ExportModeEmail.getExportModeEmail(export.getIdExportModeId());
				Vector vDestinataires = ExportModeEmailDestinataire.getAllDestinatairesFromExport(export.getIdExport());
			%><%@ include file="../../export/pave/pageExportModeEmail.jspf" %><%
			}catch (Exception e) {}
		} 
		if (export.getIdExportMode() == ExportMode.MODE_FTP) 
		{
			ExportModeFTP  exportModeFTP = null;
			try{
				exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());
				
				%><%@ include file="../../export/pave/pageExportModeFtp.jspf" %><%
			}catch (Exception e) {}
		} 
		if (export.getIdExportMode() == ExportMode.MODE_HTTP) 
		{
		} 
		if (export.getIdExportMode() == ExportMode.MODE_WEB_SERVICE) 
		{
			ExportModeWS  exportModeWS = null;
			try{
				exportModeWS = ExportModeWS.getExportModeWS(export.getIdExportModeId());
				%><%@ include file="../../export/pave/pageExportModeWebService.jspf" %><%
			}catch (Exception e) {}
		} 
		%>	
		

<table class="pave" summary="none">
	<tr onclick="montrer_cacher('paveExportParametres')" >
		<td class="pave_titre_gauche" colspan="2">Transfert : paramètres complémentaires</td>
	</tr>
	<tr>
		<td>
		<table id="paveExportParametres" >
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
<%
	Vector<ExportParametre> vExportParametres = ExportParametre.getAllFromIdExport(export.getIdExport());

	for(int i=0; i< vExportParametres.size() ; i++)
	{
		ExportParametre param = vExportParametres.get(i);
 %>
		<tr>
			<td class="pave_cellule_gauche">
				<%= param.getName() %></td>
			<td class="pave_cellule_droite"><%= param.getValue() %></td>
		</tr>
<% }%>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		</table>
		</td>
	</tr>
</table>

	<br />
		<%@ include file="../../export/spqr/pave/paveSuiviPublication.jspf"%>
		

		<a href="<%= response.encodeURL( 
			rootPath + "desk/organisation/afficherOrganisation.jsp?" 
			+ "iIdOrganisation=" + organisationPresse.getIdOrganisation() 
			+ "&amp;iIdOnglet=" + Onglet.ONGLET_ORGANISATION_EXPORTS 
			) %>" >Modifier Export</a>
		<br/>
		<a href="<%= response.encodeURL( 
			rootPath + "desk/export/publication/afficherToutesPublications.jsp" 
			) %>" >Afficher toutes publications</a>
		<br/>
		<a href="<%= response.encodeURL( 
			rootPath + "desk/export/publication/afficherToutesPublicationsBoamp.jsp" 
			) %>" >Afficher toutes publications BOAMP</a>
		<br/>
		<%
		if (export.getIdExportMode() == ExportMode.MODE_FTP) 
		{
		 %>
		 <br />
		<a href="<%= response.encodeURL( 
			rootPath + "desk/export/xmedia/publissimo/envoyerAAPCParFTP.jsp?" 
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdExport=" + export.getIdExport()
			 + "&amp;nonce=" +System.currentTimeMillis()
			) %>" >Envoyer l'AAPC au format Publissimo </a>
		<br/>
		<a href="<%= response.encodeURL( 
			rootPath + "desk/export/spqr/envoyerAAPCParFTP.jsp?" 
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdExport=" + export.getIdExport()
			 + "&amp;nonce=" +System.currentTimeMillis()
			) %>" >Envoyer l'AAPC au format SPQR </a>
		<br/>
		<a href="<%= response.encodeURL( 
			rootPath + "desk/export/matamore/modula/envoyerPetiteAnnonceAAPCParFTP.jsp?" 
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdExport=" + export.getIdExport()
			 + "&amp;nonce=" +System.currentTimeMillis()
			) %>" >Envoyer la petite annonce AAPC au format Modula</a>
		<br/>
		<%} 
	}
		%>
</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>