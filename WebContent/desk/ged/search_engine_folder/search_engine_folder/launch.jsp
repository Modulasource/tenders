<%@ include file="/include/new_style/headerDesk.jspf"%>

<%@ page import="org.coin.bean.html.*"%>
<%@page import="java.util.Vector"%>
<%
	String sTitle = "";

	SearchEngineFolder item = null;
	String sPageUseCaseId = "XXX";
	JSONObject jsonData = null;

	long lId = HttpUtil.parseLong("lId", request, 0);
	if (lId > 0) {
		try {
			item = SearchEngineFolder.getSearchEngineFolder(lId);
			jsonData = item.toJSONObject();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	sTitle += "<span class=\"altColor\">Gestion des dossiers de recherche</span>";

	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	String sarrDisplayModeArray[] = new String[]{"detail", "miniature"};

	String sarrDisplayModeArrayLabel[] = new String[]{"Détail",
			"Miniatures"};
%>
<style type="text/css">
<!--
#results th {
	text-align: left;
}

-->
.LabelContentType {
	position: "absolute";
	z-index: "2";
	font-size: "10px";
	color: "#EEE";
	background-color: "#990000";
	filter: Alpha(opacity = 84);
	-moz-opacity: 0.84;
	width: "40px";
	height: "12px";
	text-align: "center";
	vertical-align: "middle";
	margin-top: "42px";
	margin-left: "25px";
}
</style>
<script type="text/javascript"
	src="<%=rootPath%>dwr/interface/SearchEngine.js"></script>
<script type="text/javascript"
	src="<%=rootPath%>dwr/interface/SearchEngineFolder.js"></script>
<script type="text/javascript"
	src="<%=rootPath%>include/js/searchEngine/mt.component.SearchEngine.js?v=3"></script>
<script type="text/javascript"
	src="<%=rootPath%>include/js/searchEngine/layout/mt.component.layout.DocumentLayout.js?v=1"></script>
	<script type="text/javascript"
	src="<%=rootPath%>include/js/searchEngine/layout/mt.component.layout.FolderLayout.js?v=1"></script>

<script type="text/javascript">
var jsonData = <%=jsonData%>;
mt.config.enableAutoLoading = false;
var sURLModify = "<%=response
									.encodeURL(rootPath
											+ "desk/ged/search_engine_folder/search_engine_folder/modifyForm.jsp?lId=")%>";
var rootPath = "<%=rootPath%>"; 

function formatToComponent(sDate){
	if (!sDate) return "";
	var aDate = sDate.substring(0, 10).split("-");
	return aDate[2]+"/"+aDate[1]+"/"+aDate[0]; 
}

function getReducedWord(sWord, iNumberChar){
// fonction en cours de dev
	if (sWord.length==0) return "";
	var arrWords = sWord.split(new RegExp("\\W", "g"));
	if (arrWords.length==0){
		if(sWord.length>iNumberChar) return sWord.substring(0, iNumberChar)+"...";
		else return sWord;
	}
	for (var i=0;i<arrWords.length;i++){
		if (arrWords[i].length>iNumberChar) arrWords[i]=arrWords[i].substring(0, iNumberChar)+"...";
	}
	return arrWords.join(" ");
}

function getBooleanModeExactKeyword(sString){
	return '"'+sString+'"';
}
/*
bOptionAllWords : Search with "and" if true (must content all words)
				else search with "or" (content one or more words)
*/
function getBooleanModeWordOption(sString, bOptionAllWords){
	if (sString.indexOf(",")==-1){
		var a = sString.split(" ");
	} else {
		var a = sString.split(",");
	}
	var a2 = [];
	if (bOptionAllWords){
		a.each(function(item){a2.push("+"+item.trim()+"*");});
	} else {
		a.each(function(item){a2.push(item.trim()+"*");});
	}
	return a2.join(" ");
}
function getLinkModifyDocument(obj, bComplete) {
	var linkDoc = document.createElement("span");
	
	var img = document.createElement("img");
	img.alt = img.title = "Modifier";
	img.src = "<%=rootPath + "images/icons/application_edit.gif"%>";
	
    var aLink = document.createElement("a");
    aLink.href= sURLModify + obj.id_search_engine_folder;
    aLink.style.paddingLeft="5px";
    aLink.innerHTML = "Modifier";    
    
    if (!bComplete){
    	aLink.innerHTML = "";
    	aLink.appendChild(img);
    	return aLink;
    }    
    
    linkDoc.appendChild(img);
    linkDoc.appendChild(aLink);
    return linkDoc;
}

///////////////////////////////////

var engine0 = new mt.component.SearchEngine();
var layoutMosaic0 = new mt.component.layout.FolderLayout('results0');
layoutMosaic0.setItemDisplay = function(obj) {
	var sURL = "<%= response.encodeURL("displayFolder.jsp?lId=") %>" + obj.id_ged_category;

    var div = document.createElement("div");
    //div.style.backgroundColor = "lightyellow";
    //div.style.border = "1px solid #CCC";
    div.style.margin = "10px";
    div.style.padding = "10px";
    div.style.width = "100px";
    //div.style.minHeight = "100px";
    div.style.textAlign = "center";
    
    var br = document.createElement("br");
    
    var img = document.createElement("img");
    img.src = "<%= rootPath %>images/icons/64x64/document.png";
    img.alt = "";
    img.style.padding = "2px";
    img.style.display = "block";
    img.style.marginRight = "auto";
    img.style.marginLeft = "auto";
    
    var linkDoc = document.createElement("a");
    linkDoc.href = sURL;
    linkDoc.innerHTML = obj.label;
    
    var label = document.createElement("div");
    label.style.width = "90px";
    label.style.height = "97px";
    label.style.padding = "2px";
    label.style.textAlign = "center";
    label.style.overflow = "hidden";
    label.style.cursor = "pointer";
    label.onclick = function(){
    	document.location.href = sURL;
    }
    
    label.appendChild(img);
    label.appendChild(linkDoc);

    div.appendChild(label);
    return div;
}

engine0.setLayoutProvider(layoutMosaic0);



engine0.setPaginationElements('pagination0', 'paginationContent0');
engine0.setMainTable("ged_category", "c");

engine0.setSelectPart("<%=SecureString
									.getSessionSecureString(
											"c.id_ged_category, c.label",
											session)%>");

engine0.setGroupByClause("c.id_ged_category");
engine0.setOrderBy("c.label");

engine0.onBeforeSearch = function(){
    $('resultCount0').innerHTML = '';
	var sKeyword = $('keyword0').value;
	if (isNotNull(sKeyword)){
		// on utilise CONCAT_WS pour éviter plusieurs LIKE et en sachant que CONCAT_WS("aa", NULL) ne donne pas NULL
		engine0.addWhereClause("CONCAT_WS('', c.label) LIKE ?", ["%"+sKeyword.trim()+"%"]);
	}

    return true;
}


engine0.onAfterSearch = function(result){
	if(result.dataset.length==0){
		$('resultCount0').innerHTML = "<h5>Aucun résultat n'a été trouvé.</h5>";
		$('results0').innerHTML = "";
	}else $('resultCount0').innerHTML = (result.dataset.length)+" résultat"+((result.dataset.length>1)?"s":"");
}






var engine1 = new mt.component.SearchEngine();

var layoutDetail1 = new mt.component.layout.TableLayout('results1');
layoutDetail1.enableSelections(false, "id_ged_folder");
layoutDetail1.addHeader("Id").getCellContent = function(obj) {
    return obj.id_ged_folder;
}

layoutDetail1.addHeader("Nom").getCellContent = function(obj, cell) {
    //cell.style.borderTop = "1px solid #C3D9FF";
    cell.style.padding = "5px 5px 2px 6px";
    cell.style.fontWeight = "bold";
    cell.style.color = "#36C";
    cell.style.fontSize = "12px";
    cell.style.verticalAlign = "middle";
    var div = document.createElement("div");
    var br = document.createElement("br");
    
    var img = document.createElement("img");
    img.src = "<%=rootPath%>images/icons/32x32/folder_full_purple.png";
    img.alt = "";
    img.style.padding = "2px";

    
    var linkDoc = document.createElement("a");
    linkDoc.href = "<%=response.encodeURL("displayFolder.jsp?lId=")%>" + obj.id_ged_folder;
    linkDoc.innerHTML = (obj.name.length>0?obj.name:"Sans titre");

	div.appendChild(img);
	div.appendChild(br);
    div.appendChild(linkDoc);
    return div;
}

layoutDetail1.addHeader("Type").getCellContent = function(obj) {
    return obj.typeName;
}
layoutDetail1.addHeader("Référence").getCellContent = function(obj) {
    return obj.reference;
}

layoutDetail1.addHeader("Date").getCellContent = function(obj) {
    return obj.date;
}
engine1.setPaginationElements('pagination1', 'paginationContent1');
engine1.setMainTable("ged_folder", "f");

engine1.setSelectPart("<%=SecureString
									.getSessionSecureString(
											"f.id_ged_folder, f.name, t.name AS typeName, f.reference, f.description, "
													+
													//			"f.id_ged_folder, f.name, '' AS typeName, f.reference, f.description, "+
													"IF(f.date_creation IS NOT NULL,DATE_FORMAT(f.date_creation,'%d/%m/%Y'),'') AS date",
											session)%>");

engine1.setGroupByClause("f.id_ged_folder");
engine1.setOrderBy("f.date_modification DESC, f.id_ged_folder_type DESC");

engine1.onBeforeSearch = function(){
    $('resultCount1').innerHTML = '';
    engine1.addTableWithLeftJoin("ged_folder_type t", "f.id_ged_folder_type=t.id_ged_folder_type", []);
	var sKeyword = $('keyword1').value;
	if (isNotNull(sKeyword)){
		// on utilise CONCAT_WS pour éviter plusieurs LIKE et en sachant que CONCAT_WS("aa", NULL) ne donne pas NULL
		engine1.addWhereClause("CONCAT_WS('', f.name, f.description, f.reference) LIKE ?", ["%"+sKeyword.trim()+"%"]);
	}

    return true;
}


engine1.onAfterSearch = function(result){
	if(result.dataset.length==1){
		$('resultCount1').innerHTML = "<h5>Aucun résultat n'a été trouvé.</h5>";
		$('results1').innerHTML = "";
	}else $('resultCount1').innerHTML = (result.dataset.length)+" résultat"+((result.dataset.length>1)?"s":"");
}

engine1.setLayoutProvider(layoutDetail1);






function populate(){
	engine0.run(true);
}

onPageLoad = function() {
	
	// Préchargement de l'image par défaut :
	var img = new Image(16, 16);
	img.src = rootPath+"images/icons/application.gif";
	var imgDoc = new Image(64, 64);
	imgDoc.src = rootPath+"images/icons/64x64/document.png";
	var arrCriterias = jsonData.criterias;
	$("trSE").innerHTML = "";
	for (var i=0;i<arrCriterias.length;i++){
		var img = document.createElement("img");
		img.alt=img.title=arrCriterias[i].sName;
		if (arrCriterias[i].sIconPath.length>0)
			img.src = rootPath+arrCriterias[i].sIconPath;
		else img.src = imgDoc.src;
		$("tabIcons").appendChild(img);

		var td = document.createElement("td");
		td.style.borderRight = "thin 1px #90B8E7";
		td.innerHTML = "Recherche par "+arrCriterias[i].sName;
		$("trSE").appendChild(td);
		//{"sCode":"","sIconPath":"","sDescription":"","lId":4,"sTableNameId":"","sTableName":"","sName":"Catégorie","lIdSearchEngineCriteriaType":1
	}
	if (arrCriterias.length==0){
		$("tabIcons").innerHTML = "Aucun paramètre n'a été défini";
	}
	var td = document.createElement("td");
	td.innerHTML = "Recherche de documents";
	$("trSE").appendChild(td);
	
	populate();

	FORM = $('form0');
	FORM.onsubmit = function() {
		engine0.run(true);
		return false;
	}

	FORM = $('form1');
	FORM.onsubmit = function() {
		engine1.run(true);
		return false;
	}
}

</script>

</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf"%>
<div style="clear: both; margin-bottom: 5px;" />

<div id="tabIcons" class="round blockTitle " corner="6" border="1"
	style="width: 560px; margin-left: 5px; margin-top: 10px; text-align: left;">
Chargement...</div>

<table style="width: 100%;">
	<tr id="trSE">
		<td style="border-right: thin 1px #90B8E7;">Chargement...</td>
	</tr>
</table>




<table style="width: 100%;">
	<tr id="">
		<td style="border-right: thin 1px #90B8E7; vertical-align: top;">
		<form id="form0" method="post">
		<div id="contentFolder"
			style="margin-right: 5px; margin-left: 5px; padding-bottom: 15px;">
		<div>
		<div class="round blockTitle " corner="6" border="1"
			style="width: 560px; margin-left: auto; margin-right: auto; margin-top: 10px;">
		<div
			style="padding: 5px; margin-left: auto; margin-right: auto; text-align: center;">
		<table class="formLayout" style="width: 550px;">
			<tr>
				<td class="label" style="text-align: center;">Mot clé : <input
					id="keyword0" class="searchInput" type="text"
					style="margin-left: auto;" /></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center;">
				<button style="width: 150px;" id="searchButton0" type="submit">Rechercher</button>
				</td>
			</tr>
		</table>
		</div>
		</div>

		</div>
		<div id="resultCount0"
			style="text-align: center; font-weight: bold; font-size: 11px; padding: 2px;"></div>
		<div id="results0"></div>
		<div id="pagination0" style="padding-top: 10px; display: none">
		<div id="paginationContent0"
			style="text-align: center; font-size: 12px; font-weight: bold"></div>
		</div>
		</div>
		</form>
		</td>
		<td style="vertical-align: top;">
		<form id="form1" method="post">
		<div id="contentFolder"
			style="margin-right: 5px; margin-left: 5px; padding-bottom: 15px;">
		<div>
		<div class="round blockTitle " corner="6" border="1"
			style="width: 560px; margin-left: auto; margin-right: auto; margin-top: 10px;">
		<div
			style="padding: 5px; margin-left: auto; margin-right: auto; text-align: center;">
		<table class="formLayout" style="width: 550px;">
			<tr>
				<td class="label" style="text-align: center;">Mot clé : <input
					id="keyword1" class="searchInput" type="text"
					style="margin-left: auto;" /></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center;">
				<button style="width: 150px;" id="searchButton1" type="submit">Rechercher</button>
				</td>
			</tr>
		</table>
		</div>
		</div>

		</div>
		<div id="resultCount1"
			style="text-align: center; font-weight: bold; font-size: 11px; padding: 2px;"></div>
		<div id="results1"></div>
		<div id="pagination1" style="padding-top: 10px; display: none">
		<div id="paginationContent1"
			style="text-align: center; font-size: 12px; font-weight: bold"></div>
		</div>
		</div>
		</form>
		</td>
	</tr>
</table>

<%@ include file="/include/new_style/footerFiche.jspf"%>
</body>


<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>


<%@page import="mt.searchenginefolder.SearchEngineFolder"%>
<%@page import="org.json.JSONObject"%></html>
