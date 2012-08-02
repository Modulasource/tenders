<%@ include file="/include/new_style/headerDesk.jspf" %>
<%
	Localize locButton = new Localize (request, LocalizationConstant.CAPTION_CATEGORY_ADDRESS_BOOK_PAGE_BUTTON);

	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-DELEG-1";
	String sTitle = "Liste des délégations";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	String sSelectPart = CoinDatabaseUtil.getSqlConcatFunction(
			"ppOwner.nom", "ppOwner.prenom", " ")
			+ " as owner,"
			+ CoinDatabaseUtil.getSqlConcatFunction("ppDelegate.nom",
					"ppDelegate.prenom", " ")
			+ " as delegate,"
			+ CoinDatabaseUtil
					.getSqlStandardDateFunction("del.date_start")
			+ " as dateStart,"
			+ CoinDatabaseUtil
					.getSqlStandardDateFunction("del.date_end")
			+ " as dateEnd,"
			+ CoinDatabaseUtil.getSqlLocalizationName(""+sessionLanguage.getId(),
            ""+ObjectType.DELEGATION_TYPE,
            "del.id_delegation_type")+" as delegType,"
            + CoinDatabaseUtil.getSqlLocalizationName(""+sessionLanguage.getId(),
                    ""+ObjectType.DELEGATION_STATE,
                    "del.id_delegation_state")+" as delegState,"
			+ "sign_template as sign";
%>
<script type="text/javascript" src="<%=rootPath%>dwr/interface/AutoFormSearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/mt.component.js?v=<%=JavascriptVersion.MT_COMPONENT_JS%>"></script>
<script type="text/javascript">

var mySearch = new mt.component.SearchEngine("search","search_dg","search_dg_pagination","infosSearchLeft","infosSearchRight","searchAdvancedFunction");

mySearch.lineBackgroundBis = "#DFEBFF";
mySearch.addLineCursor = true;
mySearch.lineBackgroundHover = "#FFF6C1";
mySearch.sIdInTable = "id_delegation";
mySearch.sMainTable = "delegation";
mySearch.sMainAliasTable = "del";
mySearch.sLabelElement = "delegation";
mySearch.bKindFemaleElement = true;
mySearch.uniqueSort = true;
mySearch.sSelectPart ="<%=SecureString.getSessionSecureString(sSelectPart,
									session)%>";

mySearch.addOtherTableWithLeftJoin("personne_physique ppOwner", "del.id_personne_physique_owner = ppOwner.id_personne_physique");
mySearch.addOtherTableWithLeftJoin("personne_physique ppDelegate", "del.id_personne_physique_delegate = ppDelegate.id_personne_physique");
mySearch.addOtherTableWithLeftJoin("delegation_type type", "del.id_delegation_type = type.id_delegation_type");
mySearch.addOtherTableWithLeftJoin("delegation_state state", "del.id_delegation_state = state.id_delegation_state");

mySearch.setGroupByClause("del.id_delegation, ppOwner.nom, ppOwner.prenom, ppDelegate.nom, ppDelegate.prenom, del.date_start, del.date_end, del.id_delegation_type, del.id_delegation_state");


mySearch.addHeader("Délégataire",["owner"],"owner","desc");
mySearch.addHeader("Délégué",["delegate"],"delegate");
mySearch.addHeader("Type",["delegType"],"delegType");
mySearch.addHeader("Etat",["delegState"],"delegState");
mySearch.addHeader("Début",["dateStart"],"dateStart");
mySearch.addHeader("Fin",["dateEnd"],"dateEnd");
mySearch.addHeader("Modèle de signature",["sign"],"sign");

mySearch.onLoad = function(){
	Element.hide('searchLoader');
	if (mySearch.iTotalCountCriterias>0) Element.show('search_dg');
}

mySearch.onBeforeSearch = function(){
	Element.hide('search_dg');
	Element.show('searchLoader');
	
	var keywordOwner = $('keywordOwner').value;
	if (!keywordOwner.isNull()) {
		mySearch.addFilter(["ppOwner.nom","ppOwner.prenom"],[keywordOwner],true);
	}
	var keywordDeleg = $('keywordDeleg').value;
	if (!keywordDeleg.isNull()) {
		mySearch.addFilter(["ppDelegate.nom","ppDelegate.prenom"],[keywordDeleg],true);
	}
	
	var types = $('types').value;
	if (types!=0) {
		mySearch.addFilter(["type.id_delegation_type"],[types],false);
	}

	var states = $('states').value;
	if (states!=0) {
		mySearch.addFilter(["state.id_delegation_state"],[states],false);
	}
}

mySearch.onSelect = function(item,line){
    location.href = "<%= response.encodeURL("modifyDelegationForm.jsp?&lId=")%>"+item[this.sIdInTable];
}



onPageLoad = function() {
	var types = <%=DelegationType.getJSONArray(sessionLanguage)%>;
	types.splice(0, 0, {lId:0, sName:"Tous"});
	$('types').populate(types, null, "lId", "sName");

	var states = <%=DelegationState.getJSONArray(sessionLanguage)%>;
	states.splice(0, 0, {lId:0, sName:"Tous"});
	$('states').populate(states, null, "lId", "sName");

	$('keywordOwner').focus();
	$('types').onchange = function() {mySearch.search();}
	$('searchButton').onclick = function() {mySearch.search();}
	mySearch.search();
}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="margin-top:10px" class="center">
<button onclick="Redirect('<%=response.encodeRedirectURL(rootPath
									+ "desk/organisation/delegation/modifyDelegationForm.jsp?sAction=create")%>')"
	><%=locButton.getValue (40, "Ajouter une délégation")%></button>
<button onclick="Redirect('<%=response.encodeRedirectURL(rootPath
									+ "desk/organisation/delegation/modifyDelegationForm.jsp?sAction=create&amp;lIdPersonnePhysiqueOwner="
									+ sessionUser.getIdIndividual())%>')">
	Ajouter une délégation pour mon compte</button>
</div>
<form onsubmit="return false;">
<div id="search" style="padding:15px">
	<div style="position:relative">
		<div class="searchBlock">
			<div style="padding:2px">
				<table class="formLayout">
					<tr>
						<td class="label">Délégataire :</td>
						<td class="value"><input id="keywordOwner" type="text" /></td>
						<td class="label">Délégué :</td>
						<td class="value"><input id="keywordDeleg" type="text" /></td>
						<td class="label">Type :</td>
						<td class="value"><select id="types"></select></td>
						<td class="label">Etat :</td>
						<td class="value"><select id="states"></select></td>
					</tr>
				</table>
			</div>
		</div>
		<button style="position:absolute;right:4px;bottom:4px" id="searchButton"><%=SearchEngine.getLocalizedLabel(
							SearchEngine.LABEL_SEARCH_BUT, sessionLanguage
									.getId())%></button>
	</div>
	<br/>
	<div class="searchTitle">
		<div id="infosSearchLeft" style="float:left"></div>
		<div id="infosSearchRight" style="float:right;text-align:right;"></div>
		<div style="clear:both"></div>
	</div>
	<div id="searchLoader" style="text-align:center;"><img src="<%=rootPath%>images/loading/ajax-loader.gif" alt="chargement..." title="chargement..."/></div>
	<div id="search_dg" style="margin-top:5px"></div>
	<div id="search_dg_pagination" style="margin-top:10px" class="center"></div>
	<div id="searchAdvancedFunction" style="display:none;margin-top:5px"></div>
</div>
</form>


<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.db.CoinDatabaseUtil"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.fr.bean.DelegationType"%>

<%@page import="org.coin.fr.bean.DelegationState"%>
<%@page import="org.coin.bean.ObjectType"%></html>