<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="modula.graphic.Theme"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%@ include file="../pave/localizationObject.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.security.*,org.coin.db.*,org.coin.util.*,org.coin.fr.bean.*,java.util.*,java.sql.*,org.coin.autoform.*" %>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="mt.common.addressbook.AddressBookOwner"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.SearchEngine"%>
<%@ page import="java.util.*" %>
<%@ page import="org.coin.util.*,org.coin.fr.bean.*,java.sql.*" %>
<%
	String rootPath = request.getContextPath() +"/";
	LocalizeButton localizeButton = null;
	try {
		localizeButton = new LocalizeButton(request);
	}catch (Exception e) {
		e.printStackTrace();
	}


	String sTitle = "";
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	
	PersonnePhysique ppCtx = new PersonnePhysique();
    ppCtx.setAbstractBeanLocalization(sessionLanguage.getId()); 
    Adresse adrCtx = new Adresse();
    adrCtx.setAbstractBeanLocalization(sessionLanguage.getId());
    Organisation orgCtx = new Organisation();
    orgCtx.setAbstractBeanLocalization(sessionLanguage.getId());
    Organisation organisation = (Organisation) request.getAttribute("organisation");
    boolean bAfficheRefExt = true;
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
		
	int	iIdOrganisationType = organisation.getIdOrganisationType();	
	
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
		case OrganisationType.TYPE_BUSINESS_UNIT: 
			sTitle = locTitle.getValue(25,"Collaborators");
			bAfficheRefExt = false;
			break;
	    case OrganisationType.TYPE_CLIENT: 
            sTitle = locTitle.getValue(14,"Customers");
            bAfficheRefExt = false;
            break;
	    case OrganisationType.TYPE_TRAIN_CUSTOMER: 
            sTitle = locTitle.getValue(38,"Train customers");
            bAfficheRefExt = false;
            break;
        case OrganisationType.TYPE_FOURNISSEUR: 
            sTitle = locTitle.getValue(15,"Manufacturers");
            bAfficheRefExt = false;
            break;
        case OrganisationType.TYPE_HEAD_QUARTER: 
            sTitle = locTitle.getValue(26,"HQ Collaborators");
            bAfficheRefExt = false;
            break;
	}
	
	OrganisationType orgType = OrganisationType.getOrganisationType(iIdOrganisationType);
	orgType.setAbstractBeanLocalization(sessionLanguage);
	
	String sContraint = " ";	
	boolean bRestrictionClauseAdded = false;
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual() );
	sContraint += " org.id_organisation = " + organisation.getId();

	
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
mySearch.addHeader("<%= ppCtx.getNomLabel() %>",["nom"],"nom","asc");
//mySearch.addHeader("<%= ppCtx.getIdOrganisationLabel() %>",["organisation"],"organisation");
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
	var sUrl = 
		"<%=
			rootPath + "desk/organisation/"
			+ response.encodeURL("afficherPersonnePhysique.jsp?iIdPersonnePhysique=" )%>" 
			+ item[this.sIdInTable];

	parent.addParentTabForced("...", sUrl );
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

	var input = $('keyword').value;
	
	if (isNotNull(input)) {
        switch($('keywordSelect').value) {        
            case "0":
	            mySearch.addFilter(["pers.nom"],[input],true);
	            break;
            
            case "1":
	            mySearch.addFilter(["pers.prenom"],[input],true);
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
	                                {value:"<%= ppCtx.getPrenomLabel() %>", data:1},
									{value:"<%= ppCtx.getEmailLabel() %>", data:2},
									{value:"<%= ppCtx.getTelLabel() %>", data:3},
									{value:"<%= adrCtx.getCommuneLabel() %>", data:4},
									{value:"Ref. ext.", data:5},
									{value:"Id", data:6}]);
	} else {
		$('keywordSelect').populate([{value:"<%= ppCtx.getNomLabel() %>", data:0},
		                             {value:"<%= ppCtx.getPrenomLabel() %>", data:1},
									{value:"<%= ppCtx.getEmailLabel() %>", data:2},
									{value:"<%= ppCtx.getTelLabel() %>", data:3},
									{value:"<%= adrCtx.getCommuneLabel() %>", data:4},
									{value:"Ref. ext.", data:5}]);
	}
	
	setTimeout(function(){
		$('keyword').focus();
	}, 1000);
	
	$('searchButton').onclick = function() {mySearch.search();}
	mySearch.search();
}
</script>
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
	
	<div style="display:none;" >	
	<div id="searchAdvancedFunction" style="display:none;margin-top:5px" ></div> </div>
	</div>
</div>
<%
	ConnectionManager.closeConnection(conn);
%>
