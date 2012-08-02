<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.sql.*,org.coin.fr.bean.*,org.coin.util.*,org.coin.bean.document.*,java.util.*" %>
<%
	String sTitle = "Les Documents" ;
	String sPageUseCaseId = "IHM-DESK-GED-008";
	
	String sUseCaseIdBoutonAjouterDocument = "IHM-DESK-GED-001";
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
	Organisation orgUser = Organisation.getOrganisation(personneUser.getIdOrganisation());
	
	int iIdTypeObjet = ObjectType.SYSTEME;
	int iIdReferenceObjet = 0;
	if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterDocument))
	{
		sUseCaseIdBoutonAjouterDocument = "IHM-DESK-GED-012";
		iIdTypeObjet = ObjectType.ORGANISATION;
		iIdReferenceObjet = (int)orgUser.getId();
		if(!sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterDocument))
		{
			sUseCaseIdBoutonAjouterDocument = "IHM-DESK-GED-011";
			iIdTypeObjet = ObjectType.PERSONNE_PHYSIQUE;
			iIdReferenceObjet = (int)personneUser.getId();
		}
	}
	
	String sRequete = Document.getSelectAllDocumentWithHabilitations(sessionUser,sessionUserHabilitation);
	
	final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));
	SearchEngine recherche = new SearchEngine(sRequete,nbElements)
	{
		public boolean isObjectToAdd(Object oItem, Object oContext){
			Document doc = (Document) oItem;
			return true;
		}
		
		public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
			Document doc = new Document(rs.getInt(new Document().SELECT_FIELDS_NAME_SIZE + 1));
			doc.setFromResultSet(rs);
			return doc;
		}
	
	};
	recherche.setParam("afficherTousDocuments.jsp","doc.nom"); 
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	recherche.getAllResultObjects();

	recherche.addFieldName("doc.nom" , "Nom" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("doc.id_coin_document_type" , "Type" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("doc.date_creation" , "Date de création" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("lib.id_type_objet_modula" , "Visibilité" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vDocuments = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
	<table class="menu" cellspacing="2" summary="menu">
	<tr>

<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterDocument ))
	{
%>
		<th>
			<a href="<%= response.encodeURL("ajouterDocumentForm.jsp?iIdTypeObjet="+iIdTypeObjet+"&amp;iIdReferenceObjet="+iIdReferenceObjet) %>">
			<img src="<%= rootPath %>images/icones/ajouter-document.gif" 
				onmouseover="this.src='<%= rootPath %>images/icones/ajouter-document-on.gif'" 
				onmouseout="this.src='<%= rootPath %>images/icones/ajouter-document.gif'" 
				alt="ajouter un document" 
				title="ajouter un document" />
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
			<td class="pave_titre_gauche"> Liste des documents</td>
			<%
				if(recherche.getNbResultats()>1){
			%>
			<td class="pave_titre_droite"><%= recherche.getNbResultats() %> documents</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 document</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas de documents</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<%= recherche.getHeaderFields(response, rootPath) %>
					
					<%@ include file="pave/paveTousDocuments.jspf" %>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>