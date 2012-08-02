<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,org.coin.fr.bean.*,modula.commission.*,java.util.*"%>
<%
	String sTitle = "Les membres de commission"; 
	String sPageUseCaseId = "IHM-DESK-COM-012";
	String sConstraint = " AND pers.id_personne_physique = -1 ";
	
	PersonnePhysique maPersonne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());

	if(	sessionUserHabilitation.isHabilitate("IHM-DESK-COM-18") )
	{
		sConstraint = "\n AND pers.id_organisation = " + maPersonne.getIdOrganisation();
	}
	
	if(	sessionUserHabilitation.isHabilitate("IHM-DESK-COM-012") )
	{
		sConstraint = "";
	}

	
	final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));

  	/*SearchEngine recherche 
  		= new SearchEngine("SELECT mbr.id_commission_membre "
  				+ "\n FROM commission_membre mbr ,personne_physique pers"
  				+ "\n WHERE pers.id_personne_physique = mbr.id_personne_physique "
  				+ sConstraint, nbElements);
	*/
	
	String sRequest = "SELECT " + new CommissionMembre().getSelectFieldsName("mbr.")
		+ ", mbr.id_commission_membre "
		+ "\n FROM commission_membre mbr ,personne_physique pers"
		+ "\n WHERE pers.id_personne_physique = mbr.id_personne_physique "
		+ sConstraint;
		
	SearchEngine recherche = new SearchEngine(sRequest + sConstraint ,nbElements){
		
		// Nouvelle méthode 
		public boolean isObjectToAdd(Object oItem, Object oContext){
			try
			{
				CommissionMembre item = (CommissionMembre) oItem;
			}
			catch(Exception e){	}
	
			return true;
		}
		
		public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
			CommissionMembre item = new CommissionMembre(rs.getInt(new CommissionMembre().SELECT_FIELDS_NAME_SIZE + 1));
			item .setFromResultSet(rs);
			return item ;
		}
	
	};
		
  	
	recherche.setParam("afficherTousCommissionMembre.jsp","pers.nom"); 
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	//recherche.load();
	recherche.getAllResultObjects();

	recherche.addFieldName("pers.nom" , "Nom" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("mbr.id_membre_role" , "Rôle" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("mbr.id_commission" , "Commission" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("mbr.id_commission" , "Acheteur public" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vMembres = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<%@ include file="../../../include/paveSearchEngineForm.jspf" %>
	<br />
		<table class="pave" >
			<tr>
				<td class="pave_titre_gauche"> Liste des personnes membres </td>
<%
	if(recherche.getNbResultats()>1){
%>
			<td class="pave_titre_droite"><%= recherche.getNbResultats()%> membres</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 membre</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas de membre</td>
<%
		}
	}
%>
			</tr>
			<tr>
				<td colspan="2">
					<table class="liste" >
						<%= recherche.getHeaderFields(response, rootPath) %>				
		
<%
	int j;
	for (int i = 0; i < vMembres.size(); i++)
	{
		CommissionMembre membre = (CommissionMembre ) vMembres.get(i);
		membre.load();
		PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(membre.getIdPersonnePhysique());
		Commission commission = Commission.getCommission(membre.getIdCommission());
		j = i%2;
		String sOrganisationRaisonSociale= "";
		try {
			Organisation organisation = Organisation.getOrganisation( commission.getIdOrganisation() );
			sOrganisationRaisonSociale = organisation.getRaisonSociale();
		} catch (Exception e) {	
			sOrganisationRaisonSociale= "non trouvé " + commission.getIdOrganisation() + ", interdit !";
		}
		
		String sMembreRoleName = "";
		try {
			sMembreRoleName = MembreRole.getMembreRoleName(membre.getIdMembreRole());
		} catch (Exception e) {
			sMembreRoleName = "indéfini (=" + membre.getIdMembreRole() + ") interdit !";
		}
%>
						<tr class="liste<%=j%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=j%>'" onclick="Redirect('<%=response.encodeRedirectURL("afficherCommissionMembre.jsp?iIdCommissionMembre="+membre.getIdCommissionMembre()) %>')">
						 	<td style="width:20%"><%= personne.getPrenomNom() %></td>
							<td style="width:20%"><%= sMembreRoleName %></td>
							<td style="width:25%"><%= commission.getNom() %></td>
							<td style="width:30%"><%= sOrganisationRaisonSociale %></td>
							<td  style="text-align:right;width:5%">
								<a href="<%=response.encodeURL("afficherCommissionMembre.jsp?iIdCommissionMembre="+membre.getIdCommissionMembre()) %>">
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/></a>
								&nbsp;
							</td>
						</tr>
<%
	}
%>
					</table>
				</td>
			</tr>
		</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
</html>