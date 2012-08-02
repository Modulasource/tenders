<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="java.util.Vector"%>
<%@page import="modula.graphic.Onglet"%>
<%@ page import="org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.db.AbstractBeanArray"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@ include file="../pave/localizationObject.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<%
	String sAction =  HttpUtil.parseStringBlank("sAction", request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request , 0);
	long lIdOrganigramNode = HttpUtil.parseInt("lIdOrganigramNode", request , 0);
	
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	
	Organisation organisation = null;
	OrganisationService service = null;
	OrganigramNode onService = null;
	
	try{
		onService = OrganigramNode.getOrganigramNode(lIdOrganigramNode);
		service = OrganisationService.getOrganisationService(
						onService.getIdReferenceObject());

	} catch (CoinDatabaseLoadException e) {
		
		int iIdReferenceObjet = HttpUtil.parseInt("iIdReferenceObjet", request, 0);
		if(iIdReferenceObjet > 0)
		{
			service = OrganisationService.getOrganisationService(
					iIdReferenceObjet);
		} else {
			service = OrganisationService.getOrganisationService(
					HttpUtil.parseInt("lIdOrganisationService", request ));
		}
		onService = service.getOrganigramNodeInterService();
	}
	
	/** TABS */
	String sTabNameAdminData = "Service";
	String sTabNameMembres = "Membres";
	String sTabNameBinder = "Classeurs";
	String sTabNameCA = "Carnet d'adresses du service";
	String sTabNameCircuits = "Circuits spécifiques";
	String sTabNameGED = "Dossiers du service (GED)";
	String sTabNameGraphicCharter = "Charte graphique";

	String sRedirectURL = response.encodeURL("displayOrganisationService.jsp?lIdOrganisationService=" + service.getId()+"&lIdOrganigramNode="+lIdOrganigramNode+"&iIdOnglet=");
	
	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(Onglet.ONGLET_SERVICE_DONNEES_ADMINISTRATIVES, false, sTabNameAdminData, sRedirectURL+Onglet.ONGLET_SERVICE_DONNEES_ADMINISTRATIVES) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_SERVICE_MEMBRES, false, sTabNameMembres, sRedirectURL+Onglet.ONGLET_SERVICE_MEMBRES) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_SERVICE_BINDER, false, sTabNameBinder, sRedirectURL+Onglet.ONGLET_SERVICE_BINDER) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_SERVICE_CA, false, sTabNameCA, sRedirectURL+Onglet.ONGLET_SERVICE_CA) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_SERVICE_CIRCUITS, false, sTabNameCircuits,sRedirectURL+Onglet.ONGLET_SERVICE_CIRCUITS) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_SERVICE_GED, false, sTabNameGED, sRedirectURL+Onglet.ONGLET_SERVICE_GED) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_SERVICE_GRAPHIC_CHARTER, false, sTabNameGraphicCharter, sRedirectURL+Onglet.ONGLET_SERVICE_GRAPHIC_CHARTER) ); 
		
	Onglet onglet = Onglet.getOnglet(vOnglets,iIdOnglet);
	onglet.bIsCurrent = true;
	
	Onglet ongletBinder = Onglet.getOnglet(vOnglets,Onglet.ONGLET_SERVICE_BINDER );
	

	organisation = Organisation.getOrganisation( (int)service.getIdOrganisation());
	String sTitle = "Service " + service.getNom() + " ";
	sTitle += organisation.getRaisonSociale();

	String sStateActive = "";
	String sStateArchived = "";
		
	long lOrgState = service.getIdOrganisationServiceState();
	if(lOrgState == OrganisationServiceState.TYPE_ACTIVE)
		sStateActive = " checked='checked'  ";
	else
		sStateArchived = " checked='checked'  ";	
	
	OrganisationServiceState state = null;
	try{
		state = OrganisationServiceState .getOrganisationServiceState(service.getIdOrganisationServiceState());
	} catch(CoinDatabaseLoadException e) {
		state = new OrganisationServiceState();
	}
	state.setAbstractBeanLocalization(sessionLanguage);
	
	OrganisationService orgServiceDepend = null;
	try {
		orgServiceDepend = OrganisationService.getOrganisationService(
				service.getIdOrganisationServiceDepend());
	} catch (Exception e) {
		orgServiceDepend = new OrganisationService ();
	}

	Organigram organigram = null;
	Vector vNode = null;
	Vector vOrganigram = Organigram.getAllFromObject(ObjectType.ORGANISATION_SERVICE, service.getId());
	if(vOrganigram.size() ==1)
	{
		organigram = (Organigram ) vOrganigram.get(0);
		vNode =  OrganigramNode.getAllFromIdOrganigram(organigram .getId());

	}
	else{
		vNode = new Vector();
	}

	Vector vPersonne = PersonnePhysique.getAllFromIdOrganisation( (int) service.getIdOrganisation());
	Vector vPoste = OrganigramNodeType.getAllStatic();

	OrganigramNode.computeName(vNode, vPersonne, vPoste);

	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;
	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn);
	
	request.setAttribute("personne", personne);
	request.setAttribute("organisation", organisation);
	request.setAttribute("service", service);
	request.setAttribute("conn", conn);
	request.setAttribute("localizeButton", localizeButton);
	
%>
</head>
<body>
<script type="text/javascript">
mt.config.enableAutoRoundPave = false;
function removeService()
{
	if(<%= vNode.size() %> > 0)
	{
	    alert("Vous devez d'abord supprimer toutes les membres du service");
	    return;
	}

    if(confirm("Etes-vous sûr de vouloir supprimer ce service ?"))
    {
	    Redirect('<%=
	            response.encodeURL("modifyOrganisationService.jsp?sAction=remove&lIdOrganigramNode="
	                    +onService.getId() )
	            %>');
    }
}
</script>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<%@include file="../pave/paveHeaderOrganisationService.jspf" %>	
<br/>
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets) %>
<div class="tabContent">
	<%if( iIdOnglet == Onglet.ONGLET_SERVICE_DONNEES_ADMINISTRATIVES){%>
	<div align="right" >
		<button type="button" name="<%= localizeButton.getValueModify() %>" onclick="Redirect('<%=
			response.encodeRedirectURL("modifyOrganisationServiceForm.jsp?sAction=store&amp;lIdOrganigramNode="
					+onService.getId())
			%>')" ><%= localizeButton.getValueModify() %></button>
	</div>
	<br/>
	<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Service</td>
	</tr>
	<%= hbFormulaire.getHtmlTrInput("Nom :", "sNom", service.getNom() ) %>
	<%= hbFormulaire.getHtmlTrInput("Matricule :", "sMatricule", service.getMatricule() ) %>
	<%= hbFormulaire.getHtmlTrInput("Reference externe :", "sReferenceExterne", service.getReferenceExterne() , "size=40" ) %>		
	<%= hbFormulaire.getHtmlTrSelect("Etat :","lIdOrganisationServiceState",state) %>
	</table>
	<%}%> 
	<%if( iIdOnglet == Onglet.ONGLET_SERVICE_BINDER){
	String sUrlRedirect = rootPath+"desk/organisation/groupe/displayOrganisationService.jsp?lIdOrganigramNode="+lIdOrganigramNode+"&iIdOnglet="+iIdOnglet;
			
	int iIdObjetReferenceSource = (int) service.getId();
	long lIdReferenceObjectOwner =  service.getId();	
	%>	
	<!-- 
	   file="../../paraph/folder/binder/displayAllBinder.jsp"
	 -->		
	<%}%> 
	<%if( iIdOnglet == Onglet.ONGLET_SERVICE_CA){%>
	<div align="right" >
		<button onclick="doUrl('<%= 
			response.encodeURL(
					rootPath + 
					"desk/organisation/ajouterOrganisationForm.jsp"
					+ "?iIdOrganisationType=" + OrganisationType.TYPE_EXTERNAL
					+ "&lIdObjectTypeOwner=" + ObjectType.ORGANISATION_SERVICE
					+ "&lIdObjectReferenceOwner=" + service.getId()
					) %>')" >Ajouter une organisation externe</button>
		<input type="hidden" 
        id="own_lIdObjectReferenceOwnedOrganization" 
        name="own_lIdObjectReferenceOwnedOrganization"  />
	<button type="button" 
        id="AJCL_but_own_lIdObjectReferenceOwnedOrganization" 
        name="AJCL_but_own_lIdObjectReferenceOwnedOrganization"
         ><%= locBloc.getValue(34,"Lier une organisation") %></button>				

	<input type="hidden" 
        id="own_lIdObjectReferenceOwnedIndividual" 
        name="own_lIdObjectReferenceOwnedIndividual"  />
	<button type="button" 
        id="AJCL_but_own_lIdObjectReferenceOwnedIndividual" 
        name="AJCL_but_own_lIdObjectReferenceOwnedIndividual"
         ><%= locBloc.getValue(35,"Lier une personne") %></button>				

	<button type="button"
		id="btnValidOrganizationOwned" 
		onclick="Owner_linkOwnerOrganisation()" 
		style="display: none;" 
		>Valider</button>
	
	<button type="button" 
		 id="btnValidIndividualOwned"
		 onclick="Owner_linkOwnerIndividual()" 
		 style="display: none;" ><%= localizeButton.getValueSubmit() %></button>

	<script type="text/javascript">
	var g_aclOrganization;
	var g_aclIndividual;
	
	var g_urlToOwn = "<%= 
		response.encodeURL(
				rootPath 
				+ "desk/organisation/groupe/modifyOrganisationService.jsp"
				+ "?lIdOrganisationService=" + service.getId()
				+ "&iIdOnglet=" + iIdOnglet
				) %>";
	
	/**
	 * TODO : 
	 */
	function Owner_detachOwnerOrganisation()
	{
		
	}
	
	function Owner_linkOwnerOrganisation()
	{
		var id = $("own_lIdObjectReferenceOwnedOrganization").value;
		
		doUrl(g_urlToOwn 
				+ "&sAction=linkOwner"
				+ "&own_lIdObjectReferenceOwned=" + id
				+ "&own_lIdObjectTypeOwned=<%= ObjectType.ORGANISATION %>" );
	}
	
	function Owner_linkOwnerIndividual()
	{
		var id = $("own_lIdObjectReferenceOwnedIndividual").value;
		
		doUrl(g_urlToOwn 
				+ "&sAction=linkOwner"
				+ "&own_lIdObjectReferenceOwned=" + id
				+ "&own_lIdObjectTypeOwned=<%= ObjectType.PERSONNE_PHYSIQUE %>" );
	}
	
	
	
	function Owner_populateOwnerOrganization()
	{
		Element.show("btnValidOrganizationOwned");
	}
	
	function Owner_populateOwnerIndividual()
	{
		Element.show("btnValidIndividualOwned");
	}
	
	
	Event.observe(window,"load",function(){
		
		g_aclOrganization = new AjaxComboList(
				"own_lIdObjectReferenceOwnedOrganization", 
				"getRaisonSociale",
				"left",
				"Owner_populateOwnerOrganization()",
				true);
	
		g_aclIndividual
		 = new AjaxComboList(
			"own_lIdObjectReferenceOwnedIndividual", 
			"getPersonnePhysiqueAllTypeWithOrg",
			"left",
			"Owner_populateOwnerIndividual()",
			true);
	});
	
	</script>
	</div>
	<br/>
	<jsp:include page="/desk/organisation/bloc/blocDisplayAllOrganizationServiceOwned.jsp">
	<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
	</jsp:include>
	
<%
	}
	
	if( iIdOnglet == Onglet.ONGLET_SERVICE_CIRCUITS)
	{
		
		
%>
	<jsp:include page="/desk/organisation/groupe/bloc/blocOrganisationServiceParaphFolderTemplate.jsp">
	<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
	</jsp:include>
<%
	}

	if( iIdOnglet == Onglet.ONGLET_SERVICE_GED)
	{
	%>
	
	<%
	}
	
	
	if( iIdOnglet == Onglet.ONGLET_SERVICE_GRAPHIC_CHARTER)
	{
	%>
<jsp:include page="../bloc/blocDisplayOrganizationServiceMultimedia.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>	
	<%
	}
	
	if( iIdOnglet == Onglet.ONGLET_SERVICE_MEMBRES)
	{
		Vector<ObjectGroup> vServiceMembre
		= ObjectGroup.getAllGroupObjectFromIdGroupTypeAndObjectReference(
				ObjectGroupType.GROUP_ORGANISATION_SERVICE_MEMBRE,
				ObjectType.ORGANISATION_SERVICE,
				service.getId());

		ObjectGroup og = new ObjectGroup();
	
		Vector<PersonnePhysique> vPPServiceMembre = new Vector<PersonnePhysique> ();
		Vector<ObjectGroupItem> vServiceMembreItem = null;
		PersonnePhysique membreResponsable = null;
		if(	vServiceMembre.size() == 0)
		{
			// le service n'a pas de membre affecté
			membreResponsable = new PersonnePhysique();
		}
		else
		{
			if(	vServiceMembre.size() == 1)
			{
				og = vServiceMembre.get(0);
				if(og.getIdTypeObjectHead() != ObjectType.PERSONNE_PHYSIQUE)
				{
					throw new Exception("Le responsable doit être une personne physique");
				}
	
				try{
					membreResponsable = PersonnePhysique.getPersonnePhysique(og.getIdReferenceObjectHead());
				} catch (Exception e) {
					// le service n'a pas de membre affecté
					membreResponsable = new PersonnePhysique();
				}
				vServiceMembreItem
					= ObjectGroupItem.getAllObjectGroupItemFromIdObjectGroup((int)og.getId() );
				vPPServiceMembre
					= ObjectGroupItem.getAllPersonnePhysique(vServiceMembreItem	);
	
			}
			else
			{
				throw new Exception("Deux groupes de membres, ce n'est pas permis !");
			}
		}
	
		Vector vPPServiceMembreDispo
			= PersonnePhysique.getAllWithWhereAndOrderByClauseStatic(
					" WHERE id_organisation=" + organisation.getId(),
					"");
	%>
	<script type="text/javascript">
function addMembre()
{
	var id = document.getElementById("membreToAdd");

	doUrl("<%= response.encodeURL("modifyOrganisationServiceMembre.jsp?"
			+ "" + og.getId()
			+ "&lIdOrganisationService=" + service.getId()
			)
			%>&sAction=addMembre&lIdPersonnePhysiqueMembre=" + id.value);
}

function setMembreResponsable()
{
	var id = document.getElementById("membreResponsableToSet");

	doUrl("<%= response.encodeURL("modifyOrganisationServiceMembre.jsp?"
			+ "" + og.getId()
			+ "&lIdOrganisationService=" + service.getId()
			)
			%>&sAction=setMembreResponsable&lIdPersonnePhysiqueMembre=" + id.value);
}

</script>
		<div align="right" >
			<%if (organigram == null){%>
			<button type="button"
				onclick="Redirect('<%=
					response.encodeURL(
						"modifyOrganisationServiceOrganigram.jsp?sAction=create"
						+ "&lIdOrganigramNode=" + onService.getId()
					) %>');"
			 >Ajouter organigramme</button>
			<%}else{%>
			<button type="button"
				onclick="Redirect('<%=
					response.encodeURL(
						"modifyOrganisationServiceOrganigramNodeForm.jsp?sAction=create"
						+ "&lIdOrganigram=" + organigram.getId()
					) %>');"
			 >Ajouter poste</button>
			<%}%>
		</div>
		<br/>
		
		<table class="pave">
		<tr><td>
		<%
		AbstractBeanArray aba = OrganigramNode.generateAbstractBeanArray( vNode);
		aba.addUnplacedBean(vNode);

		for (int i =0; i <= aba.iMaxRow ; i++)
		{
			int k = i % 2;
			OrganigramNode osTmp = null;
			String sUrlDisplay = "";
			for (int j =0; j <= aba.iMaxColumn  + 1; j++)
			{
				osTmp = (OrganigramNode) aba.table[i][j] ;
				if(osTmp != null)
				{
					sUrlDisplay =
						"onclick=\"Redirect('"
						+ response.encodeURL( rootPath
							+ "desk/organisation/groupe/"
							+ "modifyOrganisationServiceOrganigramNodeForm.jsp?sAction=store&lIdOrganigramNode="
							+ osTmp.getId() )
						+ "')\"" ;
					break;
				}
			}

			String sNodeState = "";
			String sCellStype = "";
			String sCellNotActivatedStyle = "color: grey;";
			for (int j =0; j <= aba.iMaxColumn  + 1; j++)
			{
				OrganigramNode os = (OrganigramNode) aba.table[i][j] ;
				if(os != null)
				{
					switch( (int) os.getIdOrganigramNodeState())
					{
					case OrganigramNodeState.STATE_ACTIVATED:
						sNodeState = "";
						sCellStype = "";
						break;
					case OrganigramNodeState.STATE_DEACTIVATED:
						sNodeState = "State: Désactivé";
						sCellStype = sCellNotActivatedStyle;
						break;
					case OrganigramNodeState.STATE_ARCHIVED:
						sNodeState = "State: Archivés";
						sCellStype = sCellNotActivatedStyle;
						break;
					}
					
					PersonnePhysique person = null;
					try{
						person
							= PersonnePhysique.getPersonnePhysique(
								os.getIdReferenceObject(),
								vPersonne);
					} catch (Exception e) {
						person = new PersonnePhysique();
						person.setNom("ERREUR : personne supprimée de l'organisation id : " + os.getIdReferenceObject());
						os.setName(person.getName());
					}

					String sUserIcon = "user.gif";
					switch((int)person.getIdPersonnePhysiqueCivilite() ){
					case PersonnePhysiqueCivilite.MONSIEUR:
					case PersonnePhysiqueCivilite.UNDEFINED:
						 sUserIcon = "user.gif";
						 break;
					case PersonnePhysiqueCivilite.MADAME:
					case PersonnePhysiqueCivilite.MADEMOISELLE:
						 sUserIcon = "user_female.png";
						 break;
					}
					
					%>
						<div style="margin-top:3px;padding-left: <%= (j * 20) %>px;<%= sCellStype %>" >
							<img src="<%= rootPath
			                            + "images/icons/" + sUserIcon %>"
								style='cursor : pointer;' "
			                    onclick="parent.addParentTabForced('chargement en cours...','<%=
			                       	response.encodeURL( rootPath
			                           + "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="
			                           + os.getIdReferenceObject() )
			                            %>');" 
			                 />
							<a href="javascript:void(0)" style="<%= sCellStype %>" <%= sUrlDisplay %>><%= os.getName()%></a><%= " "+ sNodeState%>
						</div>
					
					<%
				}
	

			}
		}
		%>
		</td></tr></table>
	<%}%> 
</div>
<br/>
<div id="fiche_footer">
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%
	ConnectionManager.closeConnection(conn);
%>

<%@page import="mt.paraph.folder.ParaphFolder"%>
<%@page import="mt.paraph.folder.ParaphFolderType"%>
<%@page import="org.coin.util.CalendarUtil"%></html>

