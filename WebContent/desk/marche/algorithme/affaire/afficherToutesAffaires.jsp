<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.fr.bean.*,java.sql.*,modula.*,modula.algorithme.*,org.coin.util.*,modula.commission.*,modula.marche.*,java.util.*,java.text.*"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<% 
	boolean bPrintArchived = false;
	String sType = "";
	try{
		if(!Outils.isNullOrBlank(request.getParameter("type"))){
			sType = request.getParameter("type");
			if(sType.equalsIgnoreCase("archive")) bPrintArchived = true;	
		}
	}
	catch(Exception e){}
	
	String sTitle = "Affaires en cours";
	if(bPrintArchived)
		sTitle = "Affaires archivées";
	
	//final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));
 	final int nbElements = 12;

 	String sFilterCommission = "";
 	int iIdCommission= HttpUtil.parseInt("iIdCommission",request,0);
	if(iIdCommission>0)
	{
		sFilterCommission = " AND com.id_commission=" + iIdCommission;
	}
 	
 	
	Connection conn = ConnectionManager.getDataSource().getConnection(); 

	String sRequest = Marche.getSelectAllMarchePublicFromMarcheCommissionOrganisationCorrespondant();  
 	// pour vérouiller la recherche
	String sConstraint = " AND com.id_organisation = -1 ";
	if(	!sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-3") ) // Afficher toutes les affaires  
	{
		String sConstraintTemp = null; 
		String sConstraintList = ""; 
		boolean bFirstConstraint = true;  
		
		// il ne peut pas afficher la liste de toutes les affaires, il faut contraindre la recherche.
		PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-5") ) // Afficher les affaires de son organisation
		{
			// restriction aux marchés de son organisation.
			sConstraintTemp = " com.id_organisation = " + personne.getIdOrganisation();
			
		}
		
		if( sConstraintTemp != null)
		{
			if(bFirstConstraint ) { bFirstConstraint = false ; }
			else { sConstraintList += "\n OR ";	}
			
			sConstraintList += sConstraintTemp ;
			sConstraintTemp = null;
		}
		
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-42") ) // Afficher les affaires que l'on a créé
		{
			sConstraintTemp = " mar.id_createur = " + personne.getIdPersonnePhysique();
		}

		if( sConstraintTemp != null)
		{
			if(bFirstConstraint ) { bFirstConstraint = false ; }
			else { sConstraintList += "\n OR ";	}
			
			sConstraintList +=  sConstraintTemp; 
			sConstraintTemp = null;
		}

		//FIXME: JR: modification du filtre avec le syst des corresp
		// à vérifier
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-43") )
		{
			sConstraintTemp = " corres.id_personne_physique = " + personne.getIdPersonnePhysique();
		}

		if( sConstraintTemp != null)
		{
			if(bFirstConstraint ) { bFirstConstraint = false ; }
			else { sConstraintList += "\n OR ";	}
			
			sConstraintList +=  sConstraintTemp; 
			sConstraintTemp = null;
		}

		if(!sConstraintList.equals(""))
		{
			sConstraint = "\n AND ( " + sConstraintList + " ) ";
		}
	}
	else
	{
		// pas de contrainte 
		sConstraint = "";
	}
	
	/* TRI */
	String tri = " marche.date_dern_modif desc "; /* Tri par default */
	if (request.getParameter("tri") != null)
		tri = org.coin.security.PreventInjection.preventStore(request.getParameter("tri"));
	String sTri = "";//" ORDER BY "+tri;
	/* /TRI */

	SearchEngine recherche = new SearchEngine(
			sRequest 
			+ sConstraint
			+ sFilterCommission
			+ sTri,
			nbElements)
	{
		public boolean isObjectToAdd(Object oItem, Object oContext){
			Marche aff = (Marche) oItem;
			boolean bArchive = aff.isAffaireArchivee(false); 
			
			boolean bPrintArchived = (Boolean)oContext;
			
			if(bPrintArchived && bArchive) return true;
			else if(!bPrintArchived && !bArchive) return true;
	
			return false;
		}
		
		public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
			
			Marche marche = new Marche ();
			marche.setFromResultSet(rs);
			marche.setIdMarche(rs.getInt(marche.SELECT_FIELDS_NAME_SIZE + 1));
			
			return marche;
		}
	
	};
	recherche.conn = conn;
	recherche.setContext(bPrintArchived);

	recherche.setCutSearchWithMaxElement(false);
	recherche.setParam("afficherToutesAffaires.jsp","mar.date_dern_modif desc"); 
	recherche.setExtraParamHeaderUrl("&amp;type="+sType);

	//TODO:security
	recherche.setFromFormPrevent(request, "");


	recherche.getAllResultObjects();
	Vector vRecherche = recherche.getAllResults();
	recherche.addFieldName("" , "Statut" , SearchEngineArrayHeaderItem.FIELD_TYPE_NONE);
	recherche.addFieldName("mar.reference" , "Référence" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("org.raison_sociale" , "Acheteur Public" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("mar.objet" , "Objet" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("mar.date_cloture" , "date de clôture" , SearchEngineArrayHeaderItem.FIELD_TYPE_NONE);
	recherche.addFieldName("pass.libelle" , "Mode de passation" , SearchEngineArrayHeaderItem.FIELD_TYPE_NONE);
	if(sessionUserHabilitation.isSuperUser())
	{
	    recherche.addFieldName("mar.id_marche" , "Id Interne" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	}
	Vector vMarches = recherche.getCurrentPage();

	//TODO:security
	recherche.preventFromForm();
	
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="search" style="padding:15px">
<%@ include file="/include/paveSearchEngineForm.jspf" %>
<div class="searchTitle">
	<div id="infosSearchLeft" style="float:left">Liste des affaires</div>
	<div id="infosSearchRight" style="float:right;text-align:right;">
	<%if(recherche.getNbResultats()>1){%>
	<%=recherche.getNbResultats() %> affaires
	<%}else{if(recherche.getNbResultats()==1){%>
	1 affaire
	<%}	else{%>
	Pas d'affaire
	<%	}}%>
	</div>
	<div style="clear:both"></div>
</div>
<div id="search_dg" style="margin-top: 5px;">
<form action="<%= response.encodeURL("afficherToutesAffaires.jsp") %>" method="post" id="form1" name="form1" >
<table class="dataGrid" cellspacing="1">
	<tbody>
		<%= recherche.getHeaderFieldsNewStyle(response, rootPath) %>
		<%
			int j;
			CoinDatabaseWhereClause wcWhereClause =
				new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		
			CoinDatabaseWhereClause wcWhereClause2 =
				new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		
			
			
			for (int i = 0; i < vMarches.size(); i++)
			{
				Marche marche = (Marche) vMarches.get(i);
				wcWhereClause .add(marche.getIdCommission());
				wcWhereClause2.add(marche.getIdAlgoAffaireProcedure());
			}
			Vector vCommission = 
				Commission.getAllWithWhereAndOrderByClauseStatic("WHERE " 
						+ wcWhereClause.generateWhereClause("id_commission"), "");
			
			wcWhereClause.clear();
			for (int i = 0; i < vCommission.size(); i++)
			{
				Commission commission = (Commission ) vCommission.get(i);
				wcWhereClause .add(commission.getIdOrganisation());
			}
			Vector vOrganisation = 
				Organisation.getAllWithWhereAndOrderByClauseStatic("WHERE " 
						+ wcWhereClause.generateWhereClause("id_organisation"), "");
		
			for (int i = 0; i < vMarches.size(); i++)
			{
				int iIdMarche = -1;
				Marche marche = (Marche) vMarches.get(i);
				String sRedirectPage = "";
				String sStatut= "";
				if(marche.isAffaireAAPC(false))
				{
					sRedirectPage = "afficherAffaire.jsp";
					sStatut = "AAPC";
				}
			
				if(marche.isAffaireAATR(false))
				{
					sRedirectPage = "afficherAttribution.jsp";
					sStatut = "AATR";
				}
				
				try {
					if(marche.isAAPCEnLigne() || marche.isAATREnLigne() )
					{
						sStatut += " EN LIGNE";
					}
				} catch(Exception e){ }
		
				Organisation orga =
					(Organisation ) Organisation
						.getCoinDatabaseAbstractBeanFromId(
								marche.getIdOrganisationFromMarche(
										vCommission), vOrganisation);
				
				j = i % 2;
				
				String sUrlDisplayAffaire = response.encodeURL(sRedirectPage+"?iIdAffaire="+marche.getIdMarche());
		%>
		<tr class="line<%=j%>" 
			onmouseover="className='liste_over'" 
			onmouseout="className='line<%=j%>'"
			style="cursor:pointer;"
			onclick="Redirect('<%= sUrlDisplayAffaire %>')"> 
			<td class="cell" style="text-align:left;width:5%"><%= sStatut %></td>
			<td class="cell" style="text-align:left;width:15%"><%= (!marche.getReference().equals(""))? marche.getReference():"Indéfinie"%>&nbsp;</td>
			<td class="cell" style="text-align:left;width:20%"><%= orga.getRaisonSociale() %>&nbsp;</td>
			<td class="cell" style="text-align:left;width:25%"><%= (!marche.getObjet().equals(""))?marche.getObjet():"Indéfini" %>&nbsp;</td>
			<td class="cell" style="text-align:left;width:15%">
			<%
			Vector<Validite> vValiditesEnveloppeB 
				= Validite.getAllValiditeEnveloppeBFromAffaire(marche.getIdMarche());
			Validite oLastValiditeB = null;
			Timestamp tsDateCloture = null;
			if(vValiditesEnveloppeB != null)
			{
				if(vValiditesEnveloppeB.size() > 0)
				{
					oLastValiditeB = vValiditesEnveloppeB.lastElement();
					tsDateCloture = oLastValiditeB.getDateFin();
				}
			}
			if(tsDateCloture == null) {%> 
			<%="Indéfinie"%>
			<% }else{%>
			
			<%= org.coin.util.CalendarUtil.getDateFormattee(tsDateCloture)%><%}%>
			</td>
			<td class="cell" style="text-align:left;width:15%">
			<%
				String sPassation = "";
		    	try
		    	{
		    		int iIdMarchePassation 
		    			= AffaireProcedure.getAffaireProcedureMemory(
		    					marche.getIdAlgoAffaireProcedure()).getIdMarchePassation();
		    		sPassation = MarchePassation.getMarchePassationNameMemory(iIdMarchePassation);
			    	}
			    	catch(Exception e){}
			    	
			    	boolean bAffaireAnnulee = marche.isAffaireAnnulee(false);
					boolean bAffaireValidee = marche.isAffaireValidee(false);
					if(bAffaireAnnulee && bAffaireValidee){
						sPassation += "<br /><span class='rouge' style='font-weight:bold'>";
						sPassation += "(Déclaré sans suite)";
						sPassation += "</span>";
					}
				%>
				<%= (sPassation != null)? sPassation:"Indéfini"%>
				</td>
				<td class="cell" style="text-align:right;width:5%">
					<img src="<%= rootPath %>images/icons/application_edit.gif" alt="Afficher" title="Afficher">
				</td>
				</tr>
<%
	}
	
	ConnectionManager.closeConnection(conn);
	
%>
	</tbody>
</table>
</form>
</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>