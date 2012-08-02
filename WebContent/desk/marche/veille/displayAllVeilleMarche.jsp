<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,modula.graphic.*" %>
<% 
	String sTitle = "Afficher toutes les veilles de marché"; 
	Vector vItem = VeilleMarcheAbonnes.getAllStatic();
	String sPageUseCaseId = "IHM-DESK-xxx";
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">


	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche">Liste veilles de marché</td>
<%
	if(vItem.size() > 1){
%>
			<td class="pave_titre_droite"><%= vItem.size() %> items</td>
<%
	}
	else {
		if(vItem.size() == 0) {
%>
			<td class="pave_titre_droite">aucune</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 item</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" >
					<tr>
						<th>Organisation portail (design id)</th>
						<th>Personne</th>
						<th>Mots Clés</th>
						<th>Code CPF</th>
						<th>&nbsp;</th>
					</tr>
<%
	for (int i=0; i < vItem.size(); i++)
	{
		VeilleMarcheAbonnes item = (VeilleMarcheAbonnes ) vItem.get(i);
		String sUrlDisplayItem = response.encodeRedirectURL("displayVeilleMarche.jsp?iIdVeilleMarche="+item.getId());
		String sOrganisationName = "";
		try{
			sOrganisationName = Organisation.getOrganisation(item.getIdOrganisation()).getRaisonSociale();
		}catch(CoinDatabaseLoadException e) {
			sOrganisationName = "?? " + item.getIdOrganisation();
		}
        String sPersonnePhysiqueName = "";
        String sOrganisationNameVeille = "";
		try{
			PersonnePhysique pp = PersonnePhysique
				.getPersonnePhysique(item.getIdPersonnePhysique());
			sPersonnePhysiqueName = pp.getCivilitePrenomNomFonction();
			sOrganisationNameVeille = Organisation.getOrganisation(pp.getIdOrganisation()).getRaisonSociale();
			
		}catch(CoinDatabaseLoadException e) {}
		
		String sCompetenceSelected = "";
		Vector<BoampCPFItem> vItems = BoampCPFItem.getAllFromTypeAndReferenceObjet(
    			ObjectType.PERSONNE_PHYSIQUE, 
    			item.getIdPersonnePhysique());
    	
		for(BoampCPFItem itemCPF : vItems){
			try{sCompetenceSelected += BoampCPF.getBoampCPFMemory(itemCPF.getIdOwnedObject()).getName()+"<br/>\n";}
			catch(Exception e){}
		}
		
%>
				  	<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" 
				  		onmouseout="className='liste<%=i%2%>'" onclick="Redirect('<%=
				  			sUrlDisplayItem %>')">
				    	<td><%=sOrganisationName  %></td>
				    	<td><%=sPersonnePhysiqueName + " " + sOrganisationNameVeille %></td>
				    	<td><%= item.getKeyWord()  %></td>
				    	<td><%= sCompetenceSelected %></td>
				    	<td style="width:5%;text-align:right"><a href="<%=
				    		sUrlDisplayItem  %>" >
						<img src="<%=rootPath+ Icone.ICONE_FICHIER_DEFAULT 
							%>" alt="Afficher" title="Afficher"/>
				    	</a></td>
				  	</tr>
<%
}
%>

				</table>
			</td>
		</tr>
	</table>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.VeilleMarcheAbonnes"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
</html>
