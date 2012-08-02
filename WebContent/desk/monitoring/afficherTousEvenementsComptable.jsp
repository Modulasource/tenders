<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.util.treeview.*,modula.algorithme.*,java.text.*,org.coin.util.*, java.util.*, modula.journal.*, org.coin.fr.bean.*, modula.marche.*, modula.commission.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "événements comptables";
	String sType = "";
	String sConstraint = "";
	String sExtraParam = "";
	String sUrlObjet = "";
	String sIdObjet = "";
	final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));
  	SearchEngine recherche 
  			= new SearchEngine(
  				  "SELECT DISTINCT evt.id_evenement "
  				+ "\n FROM evenement evt, type_evenement typ "
  				+ "\n WHERE evt.id_type_evenement=typ.id_type_evenement "
  				+ "\n AND evt.id_type_evenement="+TypeEvenementModula.TYPE_EVENEMENT_CPT_PROC,
  				nbElements);
							
	recherche.setParam("afficherTousEvenementsComptable.jsp","evt.date_debut_evenement"); 
	recherche.setFromFormPrevent(request, "");
	
	recherche.load();
 	Vector vRecherche = recherche.getAllResults();


	recherche.addFieldName("evt.date_debut_evenement" , "Date debut" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("typ.id_type_objet_modula" , "Objet" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("evt.id_reference_objet" , "Référence" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("typ.libelle" , "Type" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("evt.commentaire_libre" , "Commentaire" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("evt.id_coin_user" , "User" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vEvenementsAAfficher = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<%@ include file="../../include/paveSearchEngineForm.jspf" %>
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Liste des événements </td>
<%
	if(vEvenementsAAfficher.size()>1){
%>
			<td class="pave_titre_droite"><%=vEvenementsAAfficher.size() %> &eacute;v&eacute;nements</td>
<%
	}
	else{
		if(vEvenementsAAfficher.size()==1){
%>
			<td class="pave_titre_droite">1 &eacute;v&eacute;nements</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas d'&eacute;v&eacute;nement</td>
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
	for (int i = 0; i < vEvenementsAAfficher.size(); i++)
	{
		String sIdEvt = (String) vEvenementsAAfficher.get(i) ;
		Evenement oEvenement = Evenement.getEvenement(Integer.parseInt(sIdEvt));
		TypeEvenement oTypeEvenement = TypeEvenement.getTypeEvenementMemory(oEvenement.getIdTypeEvenement());
		String sReference = "?";
		
		try {
			sReference =modula.TypeObjetModula.getIdObjetReferenceName(oTypeEvenement.getIdTypeObjet(), oEvenement.getIdReferenceObjet()); 
		}catch (Exception e) {
			sReference = "non trouvé pour " 
				+ oTypeEvenement.getIdTypeObjet() 
				+  " id = " + oEvenement.getIdReferenceObjet();
		}
		String sUtilisateur = "";
		try {
			org.coin.bean.User oUser = org.coin.bean.User.getUser(oEvenement.getIdUser() );
			PersonnePhysique oPers = PersonnePhysique.getPersonnePhysique( oUser.getIdIndividual() );
			sUtilisateur = oPers.getPrenom() + " " + oPers.getNom();
		}catch (Exception e) {
			sUtilisateur = "CRON Serveur" ;
		}
			
		
		String sHorodatage = "non";
		if (oEvenement.getIdJetonHorodatage() != 0){
			sHorodatage = "oui";
		}
		j = i % 2;
		
		String sUrlDisplayEvt = rootPath 
						+ "desk/journal/afficherEvenement.jsp?"
						+ "iIdEvenement=" + oEvenement.getIdEvenement()
						+ sExtraParam;
%>
				<tr class="liste<%=j%>" 
					onmouseover="className='liste_over'" 
					onmouseout="className='liste<%=j%>'" 
					onclick="Redirect('<%=response.encodeRedirectURL(sUrlDisplayEvt ) %>')"> 
				<td><%= org.coin.util.CalendarUtil.getDateFormattee(oEvenement.getDateDebutEvenement())%></td>
				<td><%= modula.TypeObjetModula.getTypeObjetModulaName( oTypeEvenement.getIdTypeObjet()) %></td>
				<td><%= sReference %></td>
				<td><%= oTypeEvenement.getLibelle() %></td>
				<td><%= oEvenement.getCommentaireLibre() %></td>
				<td><%= sUtilisateur %></td>
				<td>
					<a href="<%=response.encodeURL(sUrlDisplayEvt )%>" >
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
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
<%@ include file="../include/footerDesk.jspf"%>
</body>
</html>