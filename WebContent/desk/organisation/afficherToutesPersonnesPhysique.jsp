<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.localization.Language"%>
<%@ page import="org.coin.security.*,org.coin.db.*,org.coin.util.*,org.coin.fr.bean.*,java.util.*,java.sql.*,org.coin.autoform.*" %>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="mt.common.addressbook.AddressBookOwner"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.SearchEngine"%>
<%@ page import="java.util.*" %>
<%@ page import="org.coin.util.*,org.coin.fr.bean.*,java.sql.*" %>
<%@ include file="pave/localizationObject.jspf" %>
<%
	String sTitle = "";
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	
	PersonnePhysique ppCtx = new PersonnePhysique();
    ppCtx.setAbstractBeanLocalization(sessionLanguage.getId()); 
    Adresse adrCtx = new Adresse();
    adrCtx.setAbstractBeanLocalization(sessionLanguage.getId());
    Organisation orgCtx = new Organisation();
    orgCtx.setAbstractBeanLocalization(sessionLanguage.getId());
   
    boolean bAfficheRefExt = true;
    boolean bUseCountryCriteria = false;
    
    boolean bUseUnderTypeFilter = false;
	JSONArray jsonUnderType = new JSONArray();
	String sUnderTypeFilterName = "";
	String sUnderTypeFilterRequest = "";
	String sUnderTypeFilterTable = "";
	String sUnderTypeFilterJoin = "";
    
	String sSelectPart = CoinDatabaseUtil.getSqlConcatFunction(
    		"pers.prenom",
    		"pers.nom",
    		" ") + " as nom," +
		"org.raison_sociale as organisation,"+
		"pers.email as email,"+
		"pers.tel as tel,"+
		"adr.commune as commune,"+
		"pers.reference_externe as refExt";
	String sGroupPart = "pers.prenom," +
    		"pers.nom," +
			"org.raison_sociale,"+
			"pers.email,"+
			"pers.tel,"+
			"adr.commune,"+
			"pers.reference_externe";
		
	if(sessionUserHabilitation.isSuperUser()) sSelectPart += ",pers.id_personne_physique as idPersonnePhysique";
		
	int iIdOrganisationType = -1;
	if(request.getParameter("iIdOrganisationType") != null)
		iIdOrganisationType = Integer.parseInt(request.getParameter("iIdOrganisationType"));

	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForDisplayAllIndividual(iIdOrganisationType);
	switch(iIdOrganisationType )
	{
		case OrganisationType.TYPE_ACHETEUR_PUBLIC  :
	 		sTitle = locTitle.getValue(19,"Utilisateurs");
			break;
		case OrganisationType.TYPE_CANDIDAT : 
			sTitle = locTitle.getValue(20,"Personnes candidates");
			break;
		case OrganisationType.TYPE_CONSULTANT : 
			sTitle = locTitle.getValue(21,"Personnes consultantes");
			break;
		case OrganisationType.TYPE_PUBLICATION : 
			sTitle = locTitle.getValue(22,"Contact des titres de publication");
			break;
		case OrganisationType.TYPE_ADMINISTRATEUR: 
			sTitle = locTitle.getValue(23,"Administrateurs systèmes");
			break;
		case OrganisationType.TYPE_ANNONCEUR: 
			sTitle = locTitle.getValue(24,"Rattaché à l'agence");
			break;
	    case OrganisationType.TYPE_CLIENT: 
            sTitle = locTitle.getValue(14,"Customers");
            bAfficheRefExt = false;
            bUseCountryCriteria = true;
            break;
	    case OrganisationType.TYPE_TRAIN_CUSTOMER: 
            sTitle = locTitle.getValue(38,"Public Transport Authority");
            bAfficheRefExt = false;
            bUseCountryCriteria = true;
            break;
        case OrganisationType.TYPE_HEAD_QUARTER: 
            sTitle = locTitle.getValue(26,"HQ Collaborators");
            bAfficheRefExt = false;
            bUseCountryCriteria = true;
            break;
	}
	
	JSONArray jsonCountry = new JSONArray();
	if(bUseCountryCriteria){
		jsonCountry = Pays.getJSONArray(true,sessionLanguage.getId(),true);
	}
	
	OrganisationType orgType = OrganisationType.getOrganisationType(iIdOrganisationType);
	orgType.setAbstractBeanLocalization(sessionLanguage);
	
	String sContraint = " pers.id_personne_physique = -1 ";
	boolean bRestrictionClauseAdded = false;
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
	if( !sessionUserHabilitation.isHabilitate(sPageUseCaseId ))
	{
		// on teste s'il a le droit de voir la sienne
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-PERS-7") )
		{
			sContraint = " ( pers.id_personne_physique = " + personneUser.getId();
			bRestrictionClauseAdded = true;
		} 
		
		// on teste s'il a le droit de voir celles de son organisation
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-PERS-15") )
		{
			sContraint += " OR org.id_organisation = " + personneUser.getIdOrganisation();
			bRestrictionClauseAdded = true;
		} 
		
		// on teste s'il a le droit de voir de facon hierarchique
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-PERS-BU-14") )
		{

			CoinDatabaseWhereClause wc 
				= OrganisationGroupPersonnePhysique
					.getWhereClauseIdOrganisationHerarchical(personneUser.getId());

			sContraint += " OR org.id_organisation in " + wc.generateArrayClause();
			bRestrictionClauseAdded = true;
		}		
		
		
		sContraint 
			+= " OR " 
			+ AddressBookOwner.getWhereClauseOwnerRestriction(sessionUser, "pers.", false, conn);
		bRestrictionClauseAdded = true;
		
		if(bRestrictionClauseAdded) 
		{
			sContraint += ") ";
		} else {
			sContraint = " pers.id_personne_physique = -1 ";
		}

	}
	else
	{
		// pas de restriction
		sContraint = "";
	}

	sContraint = Outils.stripNl(sContraint);
%>
<%@page import="org.coin.bean.Group"%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/AutoFormSearchEngine.js"></script>
<script type="text/javascript">

var mySearch = new mt.component.SearchEngine("search","search_dg","search_dg_pagination","infosSearchLeft","infosSearchRight","searchAdvancedFunction");

mySearch.lineBackgroundBis = "<%= Theme.getLineBackgroundBis() %>";
mySearch.sIdInTable = "id_personne_physique";
mySearch.sMainTable = "personne_physique";
mySearch.sMainAliasTable = "pers";
mySearch.sLabelElement = "<%= locTitle.getValue(27,"Personne") %>";
mySearch.sLabelPlurialElement = "<%= locTitle.getValue(28,"Personnes") %>";
mySearch.bKindFemaleElement = true;
mySearch.uniqueSort = true;
mySearch.addLineCursor = true;
mySearch.paginationIconPrefix = "<%= Theme.getIconPrefix() %>";
mySearch.headerIconPrefix = "<%= Theme.getIconPrefix() %>";
mySearch.lineBackgroundHover = "#EDD0D1";
mySearch.setGroupByClause("pers.id_personne_physique, <%= sGroupPart %>");
mySearch.sSelectPart ="<%= SecureString.getSessionSecureString( 
	sSelectPart	   
	, session) %>";
	

mySearch.addOtherTable("adresse adr", "pers.id_adresse = adr.id_adresse");
mySearch.addOtherTable("organisation org", "pers.id_organisation = org.id_organisation");
if(<%= bUseUnderTypeFilter %>){
	mySearch.addOtherTableWithLeftJoin("<%= sUnderTypeFilterTable %>", "<%= sUnderTypeFilterJoin %>");
}
mySearch.addHeader("<%= ppCtx.getNomLabel() %>",["nom"],"nom","asc");
mySearch.addHeader("<%= ppCtx.getIdOrganisationLabel() %>",["organisation"],"organisation");
mySearch.addHeader("<%= ppCtx.getEmailLabel() %>",["email"],"email");
mySearch.addHeader("<%= ppCtx.getTelLabel() %>",["tel"],"tel");
mySearch.addHeader("<%= adrCtx.getCommuneLabel() %>",["commune"],"commune");
if(<%= bAfficheRefExt %>) mySearch.addHeader("Ref. ext.",["refExt"],"refExt");
if(<%= sessionUserHabilitation.isSuperUser() %>) mySearch.addHeader("Id",["idPersonnePhysique"],"idPersonnePhysique");

mySearch.onLoad = function(){
	
	Element.hide('searchLoader');
	if (mySearch.iTotalCountCriterias>0) Element.show('search_dg');
}

mySearch.onSelect = function(item,line){
    location.href = "<%= response.encodeURL("afficherPersonnePhysique.jsp?iIdPersonnePhysique=" + ppCtx.getIdPersonnePhysique())%>"+item[this.sIdInTable];
}

mySearch.onBeforeSearch = function(){

	
	mySearch.addFilter(["org.id_organisation_type"], ["<%= iIdOrganisationType %>"], false);
	<% 
	if(!Outils.isNullOrBlank(sContraint)) { 
	%>
		mySearch.addFilter(["<%= sContraint %>"], [""], false, "FREE");
	<% 
	}
	%>
	
	Element.hide('search_dg');
	Element.show('searchLoader');

	/** COUNTRY */
	if(<%= bUseCountryCriteria%>){
		var country = $('countrySelect').value;
	    if (country!=0) {
	        mySearch.addFilter(["adr.id_pays"],[country],false);
	    }
	}

	/** DEPOT TYPE */
	if(<%= bUseUnderTypeFilter %>){
		var underType = $('underTypeSelect').value;
		if(underType>0) mySearch.addFilter(["<%= sUnderTypeFilterRequest %>"+underType], [""], false, "FREE");
	}

	var input = $('keyword').value;
	
	if (isNotNull(input)) {
        switch($('keywordSelect').value) {        
            case "0":
	            mySearch.addFilter(["pers.nom"],[input],true);
	            break;
            
            case "1":
	            mySearch.addFilter(["org.raison_sociale"],[input],true);
	            break;

            case "2":
                mySearch.addFilter(["pers.email"],[input],true);
                break;

            case "3":
                mySearch.addFilter(["pers.tel"],[input],true);
                break;

            case "4":
                mySearch.addFilter(["adr.commune"],[input],true);
                break;

			case "5":
				mySearch.addFilter(["pers.reference_externe"],[input],true);
				break;
			
			case "6":
				if(<%= sessionUserHabilitation.isSuperUser() %>) {
					mySearch.addFilter(["pers.id_personne_physique"],[input],true);
				}
				break;
        }
	}
}

onPageLoad = function() {

	if(<%= sessionUserHabilitation.isSuperUser() %>) {
		$('keywordSelect').populate([{value:"<%= ppCtx.getNomLabel() %>", data:0},
	                                {value:"<%= ppCtx.getIdOrganisationLabel() %>", data:1},
									{value:"<%= ppCtx.getEmailLabel() %>", data:2},
									{value:"<%= ppCtx.getTelLabel() %>", data:3},
									{value:"<%= adrCtx.getCommuneLabel() %>", data:4},
									{value:"Ref. ext.", data:5},
									{value:"Id", data:6}]);
	} else {
		$('keywordSelect').populate([{value:"<%= ppCtx.getNomLabel() %>", data:0},
	                                {value:"<%= ppCtx.getIdOrganisationLabel() %>", data:1},
									{value:"<%= ppCtx.getEmailLabel() %>", data:2},
									{value:"<%= ppCtx.getTelLabel() %>", data:3},
									{value:"<%= adrCtx.getCommuneLabel() %>", data:4},
									{value:"Ref. ext.", data:5}]);
	}

	if(<%= bUseCountryCriteria %>){
		var jsonCountry = <%= jsonCountry %>;
		Element.show("countryTd");
		mt.html.setSuperCombo($('countrySelect'));
	    jsonCountry.splice(0, 0, {data:0, value:"<%= adrCtx.getIdPaysLabel() %>"});
		$('countrySelect').populate(jsonCountry);
	}

	if(<%= bUseUnderTypeFilter %>){
		var jsonUnderType = <%= jsonUnderType %>;
		if(jsonUnderType.length>0) {
			Element.show("underTypeTd");
			mt.html.setSuperCombo($('underTypeSelect'));
			if(jsonUnderType.length>1) jsonUnderType.splice(0, 0, {lId:0, sName:"<%= sUnderTypeFilterName %>"});
			$('underTypeSelect').populate(jsonUnderType,0,"lId","sName");
		}
	}
	
	setTimeout(function(){
		$('keyword').focus();
	}, 1000);
	
	$('searchButton').onclick = function() {mySearch.search();}
	mySearch.search();
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<div id="search" style="padding:15px">
	<div style="position:relative">
		<div class="searchBlock">
			<div style="padding:2px">
				<table class="formLayout">
					<tr>
						<td class="label"><%= SearchEngine.getLocalizedLabel(SearchEngine.LABEL_SEARCH, sessionLanguage.getId()) %> : </td>
					    <td class="value"><select id="keywordSelect"></select></td>
					    <td class="label"><%= SearchEngine.getLocalizedLabel(SearchEngine.LABEL_CONTAINS, sessionLanguage.getId()) %> : </td>
					    <td class="value"><input id="keyword" type="text" /></td>
					    <td class="value" id="countryTd" style="display:none"><select id="countrySelect"></select></td>
						<td class="value" id="underTypeTd" style="display:none"><select id="underTypeSelect"></select></td>
					</tr>
				</table>
			</div>
		</div>
        <button style="position:absolute;right:4px;bottom:4px" id="searchButton"><%= 
		SearchEngine.getLocalizedLabel(SearchEngine.LABEL_SEARCH_BUT,sessionLanguage.getId()) %></button>
	</div>
	<br/>
	<div class="searchTitle">
		<div id="infosSearchLeft" style="float:left"></div>
		<div id="infosSearchRight" style="float:right;text-align:right;"></div>
		<div style="clear:both"></div>
	</div>
	<div id="searchLoader" style="text-align:center;"><img src="<%= rootPath %>images/loading/ajax-loader.gif" alt="<%= localizeButton.getValueLoading("Chargement...") %>" title="<%= localizeButton.getValueLoading("Chargement...") %>"/></div>
	<div id="search_dg" style="margin-top:5px"></div>
	<div id="search_dg_pagination" style="margin-top:10px" class="center"></div>
	<br/>
	<div id="searchAdvancedFunction" style="display:none;margin-top:5px"></div>
</div>
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%
	ConnectionManager.closeConnection(conn);
%>
</html>