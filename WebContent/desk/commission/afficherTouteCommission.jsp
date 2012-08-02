<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.commission.*,java.util.*,org.coin.fr.bean.*,org.coin.util.*,java.sql.*"%>
<%
	String sTitle = "Les commissions des acheteurs publics"; 
	
	String sPageUseCaseId = "IHM-DESK-COM-001";
	String sUseCaseIdBoutonAjouterCommission = "IHM-DESK-COM-002";
	
	
	if( !sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterCommission) )
	{
		// proposer la création restreinte à son organisation
		sUseCaseIdBoutonAjouterCommission = "IHM-DESK-COM-19";
	}
	final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));

	String sRequest
	  = " SELECT "+ new Commission().getSelectFieldsName("com.") + ", com.id_commission "
	  + " FROM commission com, organisation org WHERE com.id_organisation = org.id_organisation";

				
	// pour vérouiller la recherche
	String sConstraint = "\n AND org.id_organisation = -1 ";
	if(	!sessionUserHabilitation.isHabilitate("IHM-DESK-COM-001") )
	{
		// il ne peut pas afficher la liste de toutes les commissions, il faut contraindre la recherche.
		PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
		
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-COM-14") )
		{
			// restriction aux organisations auxquelles il appartient.
			sConstraint = " AND org.id_organisation = " + personne.getIdOrganisation();
		
			if( sessionUserHabilitation.isHabilitate("IHM-DESK-COM-15") )
			{
				sRequest
				  = " SELECT "+ new Commission().getSelectFieldsName("com.") + ", com.id_commission "
				  + " FROM commission com, organisation org, commission_membre mbr "
						+ "\n WHERE com.id_organisation = org.id_organisation "
						+ "\n AND mbr.id_commission = com.id_commission "  
						+ "\n AND ( mbr.id_personne_physique = " + personne.getIdPersonnePhysique()
						+ "\n OR org.id_organisation = " + personne.getIdOrganisation() + ") ";
				
				sConstraint = "";
						
			}
			
		}
		// TODO : ajouter un CU pour les commissions qu'il a créé
		else
		{
			// Afficher les commissions dans lesquels on est membre ...
			if( sessionUserHabilitation.isHabilitate("IHM-DESK-COM-15") )
			{
				sRequest
				  = " SELECT "+ new Commission().getSelectFieldsName("com.") + ", com.id_commission "
				  + " FROM commission com, organisation org, commission_membre mbr "
						+ "\n WHERE com.id_organisation = org.id_organisation "
						+ "\n AND mbr.id_commission = com.id_commission "  
						+ "\n AND mbr.id_personne_physique = " + personne.getIdPersonnePhysique();
				
				sConstraint = "";
						
			}
		}
	}
	else
	{
		// pas de contrainte 
		sConstraint = "";
	}

	SearchEngine recherche = new SearchEngine(sRequest + sConstraint ,nbElements){
		
		public boolean isObjectAddable(String sItem, Object oContext){
			int iIdCommission = -1;
			try	{ iIdCommission = Integer.parseInt(sItem);	} catch(Exception e){}
			try
			{
				Commission com = Commission.getCommission(iIdCommission);
			}
			catch(Exception e){}
	
			return true;
		}

		// Nouvelle méthode 
		public boolean isObjectToAdd(Object oItem, Object oContext){
			try
			{
				Commission com = (Commission) oItem;
			}
			catch(Exception e){	}
	
			return true;
		}
		
		public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
			Commission com = new Commission(rs.getInt(new Commission().SELECT_FIELDS_NAME_SIZE + 1));
			com.setFromResultSet(rs);
			return com;
		}
	
	};
				
	
	recherche.setCutSearchWithMaxElement(false);
	recherche.setParam("afficherTouteCommission.jsp","org.raison_sociale"); 
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	recherche.getAllResultObjects();


	recherche.addFieldName("org.raison_sociale" , "Acheteur public" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("com.nom" , "Nom de la commission" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("com.competence" , "Compétence" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vCommissions = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br />

<%@ include file="../../../include/paveSearchEngineForm.jspf" %><br />
		<table class="pave" summary="none">
		 	<tr>
				<td class="pave_titre_gauche"> Liste des commissions </td>
<%
if(recherche.getNbResultats() > 1){
%>
<td class="pave_titre_droite"><%= recherche.getNbResultats() %> commissions</td>
<%
}
else{
	if(recherche.getNbResultats() ==1 ){
%>
<td class="pave_titre_droite">1 commission</td>
<%
}
else{
%>
<td class="pave_titre_droite">Pas de commission</td>
<%
	}
}
%>
</tr>
<tr>
	<td colspan="2">
		<table class="liste" summary="none">
			<%= recherche.getHeaderFields(response, rootPath) %>				
			
<%
int j;
for (int i = 0; i < vCommissions.size(); i++)
{
	Commission commission = (Commission) vCommissions.get(i);
	Organisation organisation = Organisation.getOrganisation( commission.getIdOrganisation() );
	j = i % 2;
%>
		<tr class="liste<%=j%>" 
			onmouseover="className='liste_over'" 
			onmouseout="className='liste<%=j%>'" 
			onclick="Redirect('<%=response.encodeRedirectURL("afficherCommission.jsp?iIdCommission="+commission.getIdCommission()) %>')">
		 	<td style="vertical-align:middle;width:40%"><%= organisation.getRaisonSociale() %></td>
		 	<td style="vertical-align:middle;width:25%"><%= commission.getNom() %></td>
			<td style="vertical-align:middle;width:30%"><%= commission.getCompetence() %></td>
			<td style="text-align:right;vertical-align:middle;width:5%">
				<a href="<%=response.encodeURL("afficherCommission.jsp?iIdCommission="
							+commission.getIdCommission()) %>">
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
				</a>
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
</html>