<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.sql.*,org.coin.fr.bean.*,org.coin.util.*,org.coin.bean.editorial.*,java.util.*" %>
<%
	String sTitle = "Les Contenus rédactionnels" ;
	String sPageUseCaseId = "IHM-DESK-AR-013";
	
	String sUseCaseIdBoutonAjouterContenu = "IHM-DESK-AR-001";
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
	Organisation orgUser = Organisation.getOrganisation(personneUser.getIdOrganisation());
	
	int iIdTypeObjet = ObjectType.SYSTEME;
	int iIdReferenceObjet = 0;
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterContenu))
	{
		sUseCaseIdBoutonAjouterContenu = "IHM-DESK-AR-002";
		iIdTypeObjet = ObjectType.ORGANISATION;
		iIdReferenceObjet = (int)orgUser.getId();
		if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterContenu))
		{
			sUseCaseIdBoutonAjouterContenu = "IHM-DESK-AR-003";
			iIdTypeObjet = ObjectType.PERSONNE_PHYSIQUE;
			iIdReferenceObjet = (int)personneUser.getId();
		}
	}

	String sRequete = EditorialAssistance.getSelectAllEditorialAssistanceWithHabilitations(sessionUser,sessionUserHabilitation);

	final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));
	SearchEngine recherche = new SearchEngine(sRequete,nbElements)
	{
		public boolean isObjectToAdd(Object oItem, Object oContext){
			EditorialAssistance edit = (EditorialAssistance) oItem;
			return true;
		}
		
		public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
			EditorialAssistance edit = new EditorialAssistance(rs.getInt(new EditorialAssistance().SELECT_FIELDS_NAME_SIZE + 1));
			edit.setFromResultSet(rs);
			return edit;
		}
	
	};
	recherche.setParam("afficherTousEditorialAssistance.jsp","edit.nom"); 
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	recherche.getAllResultObjects();

	recherche.addFieldName("edit.nom" , "Nom" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("type.libelle" , "Type" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("groupe.nom" , "Groupe" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("pp.nom" , "Auteur" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("edit.date_creation" , "Date de création" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("lib.id_type_objet_modula" , "Visibilité" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vContenus = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
	<table class="menu" cellspacing="2" summary="menu">
	<tr>

<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterContenu))
	{
%>
		<th>
			<a href="<%= response.encodeURL("ajouterEditorialAssistanceForm.jsp?iIdTypeObjet="+iIdTypeObjet
					+"&amp;iIdReferenceObjet="+iIdReferenceObjet) %>">
			<img src="<%= rootPath %>images/icones/ajouter-aideredac.gif" 
				onmouseover="this.src='<%= rootPath %>images/icones/ajouter-aideredac-on.gif'" 
				onmouseout="this.src='<%= rootPath %>images/icones/ajouter-aideredac.gif'" 
				alt="ajouter un contenu" 
				title="ajouter un contenu" />
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
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"> Liste des Contenus Editoriaux</td>
			<%
				if(recherche.getNbResultats()>1){
			%>
			<td class="pave_titre_droite"><%= recherche.getNbResultats() %> contenus</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 contenu</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas de contenu</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<%= recherche.getHeaderFields(response, rootPath) %>
					
					<%@ include file="pave/paveTousEditorialAssistance.jspf" %>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>