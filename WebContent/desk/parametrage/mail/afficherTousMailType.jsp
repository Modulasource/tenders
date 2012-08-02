<%@ include file="../../../include/new_style/headerDesk.jspf" %>
<%
	String sPageUseCaseId = "IHM-DESK-PARAM-001";
	String sTitle = "Les Mails Type";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/AutoFormSearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/mt.component.js?v=<%= JavascriptVersion.MT_COMPONENT_JS %>"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/MailType.js"></script>
<script type="text/javascript" >

function deleteMail(id) {
	if(confirm("Etes-vous sûr de vouloir effacer ce mail type ?")) {
		MailType.removeFromId(id, function(){
			window.location.reload(true);
		});
	}
}

var mySearch = new mt.component.SearchEngine("search","search_dg","search_dg_pagination","infosSearchLeft","infosSearchRight","searchAdvancedFunction");

mySearch.lineBackgroundBis = "#DFEBFF";
mySearch.sIdInTable = "id_mail_type";
mySearch.sMainTable = "mail_type";
mySearch.sMainAliasTable = "mail";
mySearch.sLabelElement = "mail type";
mySearch.bKindFemaleElement = false;
mySearch.uniqueSort = true;
mySearch.sSelectPart =
	"<%= SecureString.getSessionSecureString( "mail.libelle as label,"+
	"mail.objet_type as subject", session)%>";

mySearch.setGroupByClause("mail.id_mail_type, mail.libelle, mail.objet_type");

mySearch.addHeader("ID",["id_mail_type"],"id_mail_type","desc");
mySearch.addHeader("Libellé",["label"],"label").onPopulate = function(values, id) {
	return '<a href="<%=response.encodeRedirectURL("modifierMailTypeForm.jsp?sAction=store&iIdMailType=")
	%>'+id+'">'+values[0]+'</a>';
};
mySearch.addHeader("Sujet",["subject"],"subject");
mySearch.addHeader('').onPopulate = function(obj){
	return '<img src="<%=rootPath%>images/pdf.gif" class="handCursor" onclick="affichePDF('+obj.id_mail_type+')"/>';
}
mySearch.addHeader('').onPopulate = function(obj){
	return '<img src="<%=rootPath%>images/delete.gif" class="handCursor" onclick="deleteMail('+obj.id_mail_type+')" />';
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
		mySearch.addFilter(["mail.libelle", "mail.objet_type"],[keyword],true);
	}
	
}
onPageLoad = function() {

	setTimeout(function(){
		$('keyword').focus();
	}, 1000);
	$('searchButton').onclick = function() {mySearch.search();}
	mySearch.search();
}

</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<br/>
<div >
	<button type="button" onclick="javascript:displayURL('<%=
		response.encodeRedirectURL("modifierMailTypeForm.jsp?sAction=create") 
		%>')" >Ajouter un mail type</button>
	<button type="button" onclick="javascript:displayURL('<%=
		response.encodeRedirectURL("modifyAllBatchMailTypeForm.jsp") 
		%>')" >Modifier en masse les mails</button>
</div>

<form onsubmit="return false;">
<div id="search" style="padding:15px">
	<div style="position:relative">
		<div class="searchBlock">
			<div style="padding:2px">
				<table class="formLayout">
					<tr>
						<td class="label">Libellé / Sujet :</td>
						<td class="value"><input id="keyword" type="text" /></td>
					</tr>
				</table>
			</div>
		</div>
		<button style="position:absolute;right:4px;bottom:4px" id="searchButton"><%= SearchEngine.getLocalizedLabel(SearchEngine.LABEL_SEARCH_BUT,sessionLanguage.getId()) %></button>
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


<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
</html>