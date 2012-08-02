<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.db.CoinDatabaseUtil"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.UserStatus"%>
<%@page import="org.coin.bean.UseCase"%>
<%@page import="org.coin.bean.CoinUserGroupType"%>
<%
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-1";
	String sTitle = "Utilisateurs du système";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	String sSelectPart = "usr.login as login,"
		//+ "CONCAT(pp.nom, ' ', pp.prenom) as name,"
		+  CoinDatabaseUtil.getSqlConcatFunction(
		    		"pp.nom",
		    		"pp.prenom",
		    		" ") +  " as name,"
		//+ "GROUP_CONCAT(DISTINCT grp.name SEPARATOR ' / ') as groups"
		+ CoinDatabaseUtil.getSqlGroupConcatFunction(
				"DISTINCT grp.name SEPARATOR ' / '",
				"groups");

	PersonnePhysique person = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());

%>
<%@page import="org.coin.bean.Group"%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/AutoFormSearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/mt.component.js?v=<%= JavascriptVersion.MT_COMPONENT_JS %>"></script>
<script type="text/javascript">

var mySearch = new mt.component.SearchEngine("search","search_dg","search_dg_pagination","infosSearchLeft","infosSearchRight","searchAdvancedFunction");

mySearch.lineBackgroundBis = "#DFEBFF";
mySearch.sIdInTable = "id_coin_user";
mySearch.sMainTable = "coin_user";
mySearch.sMainAliasTable = "usr";
mySearch.sLabelElement = "utilisateur";
mySearch.bKindFemaleElement = false;
mySearch.uniqueSort = true;
mySearch.sSelectPart ="<%= SecureString.getSessionSecureString( 
	sSelectPart	   
	, session) %>";

mySearch.addOtherTable("personne_physique pp", "usr.id_individual = pp.id_personne_physique");
mySearch.addOtherTableWithLeftJoin("coin_user_group ug", "ug.id_coin_user = usr.id_coin_user AND ug.id_coin_user_group_type=<%= CoinUserGroupType.TYPE_HABILITATE %>");
mySearch.addOtherTableWithLeftJoin("coin_group grp", "grp.id_coin_group = ug.id_coin_group");

//mySearch.setGroupByClause("usr.id_coin_user");
mySearch.setGroupByClause("usr.id_coin_user, usr.login, pp.nom, pp.prenom");


mySearch.addHeader("ID",["id_coin_user"],"id_coin_user","desc");
mySearch.addHeader("Login",["login"],"login");
mySearch.addHeader("Nom",["name"],"name").onPopulate = function(values, id) {
	return '<a href="<%=response.encodeRedirectURL("afficherUtilisateurGroupe.jsp?iIdUser=")%>'+id+'">'+values[0]+'</a>';
}
mySearch.addHeader("Groupes",["groups"],"groups");

mySearch.onLoad = function(){
	Element.hide('searchLoader');
	if (mySearch.iTotalCountCriterias>0) Element.show('search_dg');
}

mySearch.onBeforeSearch = function(){
	Element.hide('search_dg');
	Element.show('searchLoader');

<%
	if(!sessionUserHabilitation.isSuperUser())
	{
%>
mySearch.addFilter(["pp.id_organisation"],["<%= person.getIdOrganisation() %>"],false);
<%
	}
%>

	
	var keyword = $('keyword').value;
	if (!keyword.isNull()) {
		mySearch.addFilter(["usr.login"],[keyword],true);
	}
	
	var group = $('groups').value;
	if (group!=0) {
		mySearch.addFilter(["grp.id_coin_group"],[group],false);
	}

    var userStatus = $('userStatus').value;
    if (userStatus!=0) {
        mySearch.addFilter(["usr.id_coin_user_status"],[userStatus],true);
    }
}



onPageLoad = function() {
	var groups = <%= Group.getJSONArray() %>;
	groups.splice(0, 0, {lId:0, sName:"Tous"});
	$('groups').populate(groups, null, "lId", "sName");

    var userStatus = <%= UserStatus.getJSONArray() %>;
    userStatus.splice(0, 0, {lId:0, sName:"Tous"});
    $('userStatus').populate(userStatus, null, "lId", "sName");
	
	setTimeout(function(){
		$('keyword').focus();
	}, 1000);
    $('userStatus').onchange = function() {mySearch.search();}
    $('groups').onchange = function() {mySearch.search();}
	$('searchButton').onclick = function() {mySearch.search();}
	mySearch.search();
}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>

<form onsubmit="return false;">
<div id="search" style="padding:15px">
	<div style="position:relative">
		<div class="searchBlock">
			<div style="padding:2px">
				<table class="formLayout">
					<tr>
						<td class="label">Login :</td>
						<td class="value"><input id="keyword" type="text" /></td>
						<td class="label">Groupe :</td>
						<td class="value"><select id="groups"></select></td>
                        <td class="label">Etat :</td>
                        <td class="value"><select id="userStatus"></select></td>
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
	<div id="searchLoader" style="text-align:center;"><img src="<%= rootPath %>images/loading/ajax-loader.gif" alt="chargement..." title="chargement..."/></div>
	<div id="search_dg" style="margin-top:5px"></div>
	<div id="search_dg_pagination" style="margin-top:10px" class="center"></div>
	<div id="searchAdvancedFunction" style="display:none;margin-top:5px"></div>
</div>
</form>


<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%></html>