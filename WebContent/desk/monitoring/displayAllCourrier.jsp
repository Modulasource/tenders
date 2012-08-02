<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%
String sPageUseCaseId = "xxx";
String sTitle = "Les Courriers";
%>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/AutoFormSearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/mt.component.js?v=<%= JavascriptVersion.MT_COMPONENT_JS %>"></script>
<script type="text/javascript" >

var mySearch = new mt.component.SearchEngine("search","search_dg","search_dg_pagination","infosSearchLeft","infosSearchRight","searchAdvancedFunction");

mySearch.lineBackgroundBis = "#DFEBFF";
mySearch.sIdInTable = "id_courrier";
mySearch.sMainTable = "courrier";
mySearch.sMainAliasTable = "mail";
mySearch.sLabelElement = "courrier";
mySearch.bKindFemaleElement = false;
mySearch.uniqueSort = true;
mySearch.bUseHttpPrevent=false;
mySearch.sSelectPart = "<%=SecureString.getSessionSecureString(
	"mail.email_expediteur as exp,"+
	"mail.email_destinataire as dest,"+
	"mail.objet as subject,"+
	"type.libelle as type,"+
	"mail.contenu as content,"+
	"mail.contenu_html as content_html,"+
	"mail.id_object_reference as type_id,"+
    CoinDatabaseUtil.getSqlStandardDateFunction("mail.date_stockage") + " as stockage,"+
    CoinDatabaseUtil.getSqlStandardDateFunction("mail.date_envoi_prevue") + " as envoi_prevue,"+
    CoinDatabaseUtil.getSqlStandardDateFunction("mail.date_envoi_effectif") + " as envoi_effectif"
    //"DATE_FORMAT(mail.date_stockage,'%d/%m/%Y') as stockage,"+
	//"DATE_FORMAT(mail.date_envoi_prevue,'%d/%m/%Y') as envoi_prevue,"+
	//"DATE_FORMAT(mail.date_envoi_effectif,'%d/%m/%Y') as envoi_effectif"
	, session)%>";

/*
mySearch.setGroupByClause("mail.id_courrier, mail.email_expediteur, mail.email_destinataire, mail.objet, "
	+ "type.libelle, mail.id_object_reference, mail.date_stockage,mail.date_envoi_prevue, mail.date_envoi_effectif");
*/

mySearch.addOtherTableWithLeftJoin("type_objet_modula type", "type.id_type_objet_modula = mail.id_type_objet_modula");

mySearch.addHeader("ID",["id_courrier"],"id_courrier","desc");

mySearch.addHeader("expéditeur",["exp"],"exp");
mySearch.addHeader("destinataire",["dest"],"dest");

mySearch.addHeader("Sujet",["subject", "content", "content_html"],"subject").onPopulate = function(values, id) {
	var link = document.createElement("a");
	link.href = "javascript:void(0)";
	link.innerHTML = values[0];

	var div = document.createElement("div");

	var divText = document.createElement("div");
	divText.style.fontSize = "12px";
	divText.style.margin = "20px";
	divText.style.border = "1px solid #BBB";
	divText.style.padding = "10px";
	divText.style.overflow = "hidden";
	divText.innerHTML = values[1].replace(/\n/g,"<br/>");
	//divText.innerHTML = values[1].replace(/\n/g,"<br/>").replace(/\\/g, "");
	
	var divHTMLText = document.createElement("div");
	divHTMLText.style.margin = "20px";
	divHTMLText.style.border = "1px solid #BBB";
	divHTMLText.style.padding = "10px";
	divHTMLText.innerHTML = values[2];
	
	div.appendChild(divText);
	div.appendChild(divHTMLText);

	link.onclick = function(){
		mt.utils.displayModal({
			type:"div",
			content:div,
			title:values[0],
			width:popupWidth-150,
			height:popupHeight-250
		});
	}			

	return link;
};


mySearch.addHeader("Stockage",["stockage"],"stockage");
mySearch.addHeader("Envoi prévu",["envoi_prevue"],"envoi_prevue");
mySearch.addHeader("Envoi effectif",["envoi_effectif"],"envoi_effectif");


mySearch.addHeader("Objet Type",["type", "type_id"],"type").onPopulate = function(values, id){
	return (values[0]) ? values[0]+' ('+values[1]+')' : '';
}


mySearch.onLoad = function(){
	Element.hide('searchLoader');
	if (mySearch.iTotalCountCriterias>0) Element.show('search_dg');
}

mySearch.onBeforeSearch = function(){
	Element.hide('search_dg');
	Element.show('searchLoader');
	
	var keyword = $('keyword').value;
	if (!keyword.isNull()) {
		mySearch.addFilter(["mail.objet", "mail.email_expediteur", "mail.email_destinataire"],[keyword],true);
	}
	
	var objectType = $('objectType').value;
	if (objectType!=0) {
		mySearch.addFilter(["mail.id_type_objet_modula"],[objectType],false);
	}
	
}

onPageLoad = function() {
	var objectTypes = <%=ObjectType.getJSONArray()%>;
	objectTypes.splice(0, 0, {lId:0, sLibelle:"Tous"});
	$('objectType').populate(objectTypes, null, "lId", "sLibelle");

	setTimeout(function(){
		$('keyword').focus();
	}, 1000);
	$('objectType').onchange = function() {mySearch.search();}
	$('searchButton').onclick = function() {mySearch.search();}
	mySearch.search();
}

</script>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>

<form onsubmit="return false;">
<div id="search" style="padding:15px">
	<div style="position:relative">
		<div class="searchBlock">
			<div style="padding:2px">
				<table class="formLayout">
					<tr>
						<td class="label">Expediteur / Destinataire / Sujet :</td>
						<td class="value"><input id="keyword" type="text" /></td>
						<td class="label">Objet type :</td>
						<td class="value"><select id="objectType"></select></td>
					</tr>
				</table>
			</div>
		</div>
		<button style="position:absolute;right:4px;bottom:4px" id="searchButton">Rechercher</button>
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

<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.db.CoinDatabaseUtil"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
</html>