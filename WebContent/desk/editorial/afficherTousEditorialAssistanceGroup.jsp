<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.sql.*,org.coin.fr.bean.*,modula.*,org.coin.util.*,org.coin.bean.editorial.*,java.util.*" %>
<%
	String sTitle = "Les Groupes rédactionnels" ;
	String sPageUseCaseId = "IHM-DESK-AR-013";
	
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
	Organisation orgUser = Organisation.getOrganisation(personneUser.getIdOrganisation());
	
	int iIdTypeObjet = ObjectType.SYSTEME;
	int iIdReferenceObjet = 0;
	String sUseCaseIdBoutonAjouterGroup = "IHM-DESK-AR-018";
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterGroup))
	{
		sUseCaseIdBoutonAjouterGroup = "IHM-DESK-AR-019";
		iIdTypeObjet = ObjectType.ORGANISATION;
		iIdReferenceObjet = (int)orgUser.getId();
		if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterGroup))
		{
			sUseCaseIdBoutonAjouterGroup = "IHM-DESK-AR-020";
			iIdTypeObjet = ObjectType.PERSONNE_PHYSIQUE;
			iIdReferenceObjet = (int)personneUser.getId();
		}
	}

	String sRequete = EditorialAssistanceGroup.getSelectAllEditorialAssistanceGroupWithHabilitations(sessionUser,sessionUserHabilitation);

	final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));
	SearchEngine recherche = new SearchEngine(sRequete,nbElements)
	{
		public boolean isObjectToAdd(Object oItem, Object oContext){
			EditorialAssistanceGroup group = (EditorialAssistanceGroup) oItem;
			return true;
		}
		
		public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
			EditorialAssistanceGroup group = new EditorialAssistanceGroup(rs.getInt(new EditorialAssistanceGroup().SELECT_FIELDS_NAME_SIZE + 1));
			group.setFromResultSet(rs);
			return group;
		}
	
	};
	recherche.setParam("afficherTousEditorialAssistanceGroup.jsp","groupe.nom"); 
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	recherche.getAllResultObjects();

	recherche.addFieldName("groupe.nom" , "Nom" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("pp.nom" , "Auteur" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("groupe.date_creation" , "Date de création" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("lib.id_type_objet_modula" , "Visibilité" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vGroups = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
	<table class="menu" cellspacing="2">
	<tr>

<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterGroup ))
	{
%>
		<th>
			<a href="<%= response.encodeURL("ajouterEditorialAssistanceGroupForm.jsp?iIdTypeObjet="+iIdTypeObjet+"&amp;iIdReferenceObjet="+iIdReferenceObjet) %>">
			<img src="<%= rootPath %>images/icones/ajouter-aideredac.gif" 
				onmouseover="this.src='<%= rootPath %>images/icones/ajouter-aideredac-on.gif'" 
				onmouseout="this.src='<%= rootPath %>images/icones/ajouter-aideredac.gif'" 
				alt="ajouter un groupe" 
				title="ajouter un groupe" />
			&nbsp;
			</a>
		</th>
<%
	}
%>		<td>&nbsp;</td>
	</tr>
</table>
<br />
<%@ include file="../../include/paveSearchEngineForm.jspf" %>
<br />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche"> Liste des Groupes Editoriaux</td>
			<%
				if(recherche.getNbResultats()>1){
			%>
			<td class="pave_titre_droite"><%= recherche.getNbResultats() %> groupes</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 groupe</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas de groupe</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<%= recherche.getHeaderFields(response, rootPath) %>
					
					<%@ include file="pave/paveTousEditorialAssistanceGroup.jspf" %>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>