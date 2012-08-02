<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%
	Localize locTitle = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TITLE);
	Localize locButton = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_BUTTON);
	Localize locMessage = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_MESSAGE);
	Localize locTab = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TAB);
	
	GedDocument gedDocumentLoc = new GedDocument ();
	gedDocumentLoc.setAbstractBeanLocalization(sessionLanguage);

    String sTitle = locTitle.getValue (71, "Display all Folder");
    Vector<GedFolder> vItem = GedFolder.getAllStatic();
%>
<jsp:include page="/include/js/localization/localizationGEC.jsp" flush="false">
	<jsp:param name="lIdLanguage" value="<%= sessionLanguage.getId() %>" />
</jsp:include>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/mt.component.SearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/layout/mt.component.layout.FolderLayout.js"></script>
<script type="text/javascript">
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
mt.config.enableAutoLoading = false;
var jsonFolderType = <%= GedFolderType.getJSONArray() %>; 
var engine = new mt.component.SearchEngine();

var layoutDetail = new mt.component.layout.TableLayout('results');
	
layoutDetail.enableSelections(false, "id_ged_folder");

layoutDetail.addHeader("Id").getCellContent = function(obj) {
    return obj.id_ged_folder;
}

layoutDetail.addHeader("<%=gedDocumentLoc.getNameLabel()%>").getCellContent = function(obj, cell) {
    //cell.style.borderTop = "1px solid #C3D9FF";
    cell.style.padding = "5px 5px 2px 6px";
    cell.style.fontWeight = "bold";
    cell.style.color = "#36C";
    cell.style.fontSize = "12px";
    cell.style.verticalAlign = "middle";
    var div = document.createElement("div");
    var br = document.createElement("br");
    
    var img = document.createElement("img");
    img.src = "<%= rootPath %>images/icons/32x32/folder_full_purple.png";
    img.alt = "";
    img.style.padding = "2px";

    
    var linkDoc = document.createElement("a");
    linkDoc.href = "<%= response.encodeURL("displayFolder.jsp?lId=") %>" + obj.id_ged_folder;
    linkDoc.innerHTML = (obj.name.length>0?obj.name:"Sans titre");

	div.appendChild(img);
	div.appendChild(br);
    div.appendChild(linkDoc);
    return div;
}

layoutDetail.addHeader("<%=gedDocumentLoc.getIdGedDocumentContentTypeLabel()%>").getCellContent = function(obj) {
    return obj.typeName;
}
layoutDetail.addHeader("<%=gedDocumentLoc.getReferenceLabel()%>").getCellContent = function(obj) {
    return obj.reference;
}

layoutDetail.addHeader("<%=locTitle.getValue (33, "Date")%>").getCellContent = function(obj) {
    return obj.date;
}

var layoutMosaic = new mt.component.layout.FolderLayout('results');
layoutMosaic.setItemDisplay = function(obj) {
	var sURL = "<%= response.encodeURL("displayFolder.jsp?lId=") %>" + obj.id_ged_folder;

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
    img.src = "<%= rootPath %>images/icons/64x64/folder_full_purple.png";
    img.alt = "";
    img.style.padding = "2px";
    img.style.display = "block";
    img.style.marginRight = "auto";
    img.style.marginLeft = "auto";
    
    var linkDoc = document.createElement("a");
    linkDoc.href = sURL;
    linkDoc.innerHTML = (obj.name.length>0?getReducedWord(obj.name, 12):"Sans titre");
    
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

engine.setLayoutProvider(layoutMosaic);

engine.setPaginationElements('pagination', 'paginationContent');
engine.setMainTable("ged_folder", "f");


engine.setSelectPart("<%=SecureString.getSessionSecureString(
		"f.id_ged_folder, f.name, t.name AS typeName, f.reference, f.description, "+
		"IF(f.date_creation IS NOT NULL,DATE_FORMAT(f.date_creation,'%d/%m/%Y'),'') AS date"
		, session)%>");

engine.setGroupByClause("f.id_ged_folder");
engine.setOrderBy("f.date_modification DESC, f.id_ged_folder_type DESC");

engine.onBeforeSearch = function(){
	//engine.addTable("ged_folder_type t", "f.id_ged_folder_type=t.id_ged_folder_type", []);
	engine.addTableWithLeftJoin("ged_folder_type t", "f.id_ged_folder_type=t.id_ged_folder_type", []);
	if ($('lIdGedFolderType').value>0){
		engine.addWhereClause("f.id_ged_folder_type=?", [$('lIdGedFolderType').value]);
	}
	var sKeyword = $('keyword').value;
	if (isNotNull(sKeyword)){
		// on utilise CONCAT_WS pour éviter plusieurs LIKE et en sachant que CONCAT_WS("aa", NULL) ne donne pas NULL
		engine.addWhereClause("CONCAT_WS('', f.name, f.description, f.reference) LIKE ?", ["%"+sKeyword.trim()+"%"]);
	}
	/** Gestion des MATCH AGAINST
		keyword = keyword.replace("'", " ").replace(",", " ");
		var words = keyword.split(" ");
		var realWords = [];
		for (var z=0; z<words.length; z++){
			if (words[z].trim().length>3) realWords.push(words[z].trim());
		}
		keyword = "*"+realWords.join("* *")+"*";
		var wordsCount = realWords.length;
		
		if (watchResumeContent) {
			engine.addWhereClause("MATCH (ccs.job_title, jcat.label, jpos.label, rf.text_content) AGAINST (? IN BOOLEAN MODE)=?", [keyword, wordsCount]);
		} else {
			engine.addWhereClause("MATCH (ccs.job_title, jcat.label, jpos.label) AGAINST (? IN BOOLEAN MODE)=?", [keyword, wordsCount]);
		}
	
	**/
	return true;
};
engine.onAfterSearch = function(result){
//	$('resultCount').innerHTML = result.dataset.length;
}
function populate(){
	var aType = [{"lId":0,"sName":"-"}];
	$('lIdGedFolderType').populate(aType.concat(jsonFolderType), "", "lId", "sName");
}
onPageLoad = function() {
	populate();
	$('displayDetail').onclick = function(){
		engine.setLayoutProvider(layoutDetail);
		engine.run(true);
	}
	$('displayMosaic').onclick = function(){
		engine.setLayoutProvider(layoutMosaic);
		engine.run(true);
	}
	engine.run(true);
	FORM = $('form');
	FORM.onsubmit = function() {
		engine.run(true);
		return false;
	}
}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
	<form id="form" method="post">
    <div class="left">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyFolderForm.jsp?sAction=create") 
                %>';" ><img src="<%= rootPath %>images/icons/32x32/folder_add_purple.png" alt="Add" style="margin-right: 5px;width:24px;" /><%=locButton.getValue (5, "Créer un dossier")%></button>
    </div>
        <div class="round blockTitle " corner="6" border="1" style="width:450px;margin-left: auto;margin-right: auto;">
            <div style="padding:5px">
                <table class="formLayout">
                    <tr>
                        <td class="label" style="width:222px;"><%=locTitle.getValue (15, "Type")%> : <select id="lIdGedFolderType"></select></td>
                        <td class="label" style="width:222px;"><%=locTitle.getValue (16, "Mot clé")%> : <input id="keyword" class="searchInput" type="text" style="margin-left: auto;" /></td>
                    </tr>
                    <tr>               
                        <td colspan="2" style="width:445px;text-align: center;"><button style="width:150px;" id="searchButton" type="submit"><%=localizeButton.getValueSearch("Rechercher")%></button></td>
                    </tr>
                </table>
            </div>
        </div>
    <br/>
    </form>
    <div id="display">
    	<a id="displayDetail" href="javascript:void(0);">
    		<img src="<%=rootPath %>images/icons/disp_detail.png" alt="<%=locTitle.getValue (72, "Détail")%>" /> <%=locButton.getValue (30, "Affichage détaillé") %>
    	</a>
    	<a id="displayMosaic" href="javascript:void(0);">
    		<img src="<%=rootPath %>images/icons/disp_mosaic.png" alt="<%=locTitle.getValue (73, "Mosaïque") %>" /> <%=locButton.getValue (31, "Affichage en mosaïque") %></div>
    	</a>
	<div id="results"></div>
	<div id="pagination" style="padding-top:10px;display:none"><div id="paginationContent" style="text-align:center;font-size:12px;font-weight:bold"></div></div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.db.SearchEngine"%>
</html>

