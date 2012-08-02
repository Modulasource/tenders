<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.util.*,org.coin.fr.bean.annonce.*,java.util.*,org.coin.bean.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";

	String sPageUseCaseId = "IHM-DESK-xxx";
	String sUseCaseIdBoutonAjouterOrganisation = "IHM-DESK-xxx";


	String sRestrictionClause = " AND id_annonce = -1 ";
	String sTitle = "Les parutions" ;

 	
	String sSqlQuery = "SELECT " + Annonce.getSelectFieldsName("") +  ", id_annonce"
		+ " FROM annonce "
		+ "";
	
	sRestrictionClause= " WHERE id_annonce = -1";
	
	if(sessionUserHabilitation.isHabilitate("IHM-DESK-ANN-004"))
	{
		// pas de restriction
		sRestrictionClause = "";
	}
	else
	{
		if(sessionUserHabilitation.isHabilitate("IHM-DESK-ANN-005"))
		{
			// restriction aux annonces de son organisation
			sRestrictionClause = " WHERE à faire";
			
		}
		else
		{
			if(sessionUserHabilitation.isHabilitate("IHM-DESK-ANN-006"))
			{
				// restriction à ses annonces
				sRestrictionClause 
					= " WHERE id_type_objet = " + ObjectType.PERSONNE_PHYSIQUE
					+ " AND id_reference_objet =  " + sessionUser.getIdIndividual();
					
			}
		}
		
	}
	// pas de restriction pour le moment
	
	final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));
	SearchEngine recherche = new SearchEngine(sSqlQuery + sRestrictionClause,nbElements)
	{
		// Nouvelle méthode 
		public boolean isObjectToAdd(Object oItem, Object oContext){
			Annonce aff = (Annonce) oItem;
			return true;
		}
		
		public Object getObjetFromResultSet(java.sql.ResultSet rs) throws java.sql.SQLException{
			Annonce annonce = new Annonce(rs.getInt(Annonce.SELECT_FIELDS_NAME_SIZE + 1));
			annonce.setFromResultSet(rs);
			return annonce;
		}
	
	};
	recherche.setParam("afficherToutesAnnonces.jsp","reference_externe"); 
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	
	// nouvelle méthode
	//recherche.load();
	recherche.getAllResultObjects();

 //	Vector vRecherche = recherche.getAllResults();

	recherche.addFieldName("libelle" , "Libellé" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("reference_externe" , "Réf. ext." , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("id_annonce_type" , "Type" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("id_annonce_etat" , "Etat" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vAnnonces = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
	<div class="titre_page"><%=sTitle%></div>
	<table class="menu" cellspacing="2" summary="menu">
	<tr>

<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterOrganisation ))
	{
%>
		<th>
			<a href="<%= response.encodeURL("ajouterAnnonceForm.jsp?") %>">
			<img src="../../images/icones/affaire.gif" 
				onmouseover="this.src='../../images/icones/affaire_over.gif'" 
				onmouseout="this.src='../../images/icones/affaire.gif'" 
				alt="ajouter une annonce" 
				title="ajouter une annonce" />
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
			<td class="pave_titre_gauche"> Liste des annonces</td>
<%
	if(recherche.getNbResultats()>1){
%>
			<td class="pave_titre_droite"><%= recherche.getNbResultats() %> annonces</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 annonce</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas d'annonce</td>
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
	for (int i = 0; i < vAnnonces.size(); i++)	{
		Annonce annonce = (Annonce) vAnnonces.get(i);
		j = i % 2;
		String sRedirectPage = "afficherAnnonce.jsp?iIdAnnonce=" + annonce.getIdAnnonce();
%>
		<tr class="liste<%=j%>" 
				 onmouseover="className='liste_over'" 
				 onmouseout="className='liste<%=j%>'" 
				 onclick="Redirect('<%= response.encodeRedirectURL(sRedirectPage) %>')"> 
			<td><%= annonce.getLibelle() %></td>
			<td><%= annonce.getReferenceExterne() %></td>
			<td><%= AnnonceType.getAnnonceTypeNameOptional( annonce.getIdAnnonceType() ) %></td>
			<td><%= AnnonceEtat.getAnnonceEtatNameOptional( annonce.getIdAnnonceEtat() ) %></td>
			<td style="text-align:right;width:5%">
				<a href="<%=response.encodeURL(sRedirectPage) %>">
				<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" style="width:21" height="21"  alt="Afficher" title="Afficher"/>
				</a>
			</td>
		</tr>
<%
	}
%>
					</table>
				</td>
			</tr>
		</table>
<%@ include file="../include/footerDesk.jspf" %>
</body>
</html>