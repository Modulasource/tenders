<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%@page import="java.util.Vector"%>
<%
	/**
	 * Localization
	 */
	Localize locButton = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_BUTTON);
	Localize locTitle = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TITLE);
	Localize locMessage = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_MESSAGE);

	String sButtonAddFolder = locButton.getValue (6, "Ajouter un classeur");
	String sButtonDeleteFolder = locButton.getValue (7, "Supprimer ce classeur");
	String sButtonCloseFolder = locButton.getValue (8, "Cloturer le classeur");
	String sButtonAddDocument = locButton.getValue (9, "Ajouter un document");
	String sButtonDeleteDocuments = locButton.getValue (10, "Supprimer les documents");
	String sButtonThumbnailView = locButton.getValue (11, "Afficher en miniature");
	String sButtonDetailView = locButton.getValue (12, "Afficher en détail");
	String sButtonAddSubFolder = locButton.getValue (14, "Ajouter un sous-classeur");
	
	String sTitleAuthor = locTitle.getValue (5, "Auteur");
	String sTitleCreated = locTitle.getValue (6, "Création");
	String sTitleSubFolder = locMessage.getValue(13, "Sous-classeurs");
	String sTitleDocument = locTitle.getValue (40, "Document");
	String sTitleFileSize = locTitle.getValue (75, "Taille du fichier");
	
	
	GedDocumentState gedDocumentStateInProcess = GedDocumentState.getGedDocumentState(GedDocumentState.STATE_IN_PROCESS);
	gedDocumentStateInProcess.setAbstractBeanLocalization(sessionLanguage);
	GedDocumentState gedDocumentStateClosed = GedDocumentState.getGedDocumentState(GedDocumentState.STATE_CLOSED);
	gedDocumentStateClosed.setAbstractBeanLocalization(sessionLanguage);
	GedDocumentState gedDocumentStateDraft = GedDocumentState.getGedDocumentState(GedDocumentState.STATE_DRAFT);
	gedDocumentStateDraft.setAbstractBeanLocalization(sessionLanguage);
	

	String sTitle = ""; 


	GedFolder folder = null;
	GedFolderType type = null;
	GedFolderState state = null;
	String sPageUseCaseId = "xxx";

	folder = GedFolder.getGedFolder(Integer.parseInt(request.getParameter("lId")));
	folder.setAbstractBeanLocalization(sessionLanguage);
	try{
		type = GedFolderType.getGedFolderType(folder.getIdGedFolderType());
	} catch (CoinDatabaseLoadException e) {
		type = new GedFolderType();
	}
	try {
		state = GedFolderState.getGedFolderState(folder.getIdGedFolderState());
	} catch (CoinDatabaseLoadException e) {
		state = new GedFolderState ();
	}

	sTitle += folder.getName(); 

	//sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	
	String sarrDisplayModeArray[] 
	     = new String[] {
			 "detail",
			 "miniature"
		};
	
    String sarrDisplayModeArrayLabel[] 
            = new String[] {
                "Détail",
                "Miniatures"
       };
	
	
	String sDisplayModeArrayDocument = HttpUtil.parseString("sDisplayModeArrayDocument", request, "detail");
	boolean bRefreshEngineGED = HttpUtil.parseBoolean("bRefreshEngineGED", request, false);
	
	
    
    
	request.setAttribute("rootPath",rootPath);
	request.setAttribute("folder",folder);
	request.setAttribute("locTitle", locTitle);
	request.setAttribute("locButton", locButton);
	request.setAttribute("locMessage", locMessage);
	request.setAttribute("localizeButton", localizeButton);
	
	
%>
<style type="text/css">
<!--
#results th{
    text-align: left;
}
-->
a:ACTIVE, a:link, a:visited{
	text-decoration: none;
	color: #000;
}
.LabelContentType{
	position:"absolute";
	z-index: "2";
	font-size: "10px";
	color: "#EEE";
	background-color: "#990000";
	filter:Alpha(opacity=84);-moz-opacity:0.84; 
	width: "40px";
	height: "12px";
	text-align: "center";
	vertical-align: "middle";
	margin-top: "42px";
	margin-left: "25px";
}
</style>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SearchEngine.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedFolder.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocument.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/mt.component.SearchEngine.js?v=3"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/layout/mt.component.layout.DocumentLayout.js?v=1"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/layout/mt.component.layout.FolderLayout.js?v=1"></script>

<script type="text/javascript">
var self = this;
var lIdGedFolder = <%= folder.getId() %>;
var g_lIdGedFolderStateInProcess = <%= GedFolderState.STATE_IN_PROCESS %>;
var g_lIdGedFolderStateClosed = <%= GedFolderState.STATE_CLOSED %>;
var g_bIsClosed = <%= (folder.getIdGedFolderState()==GedFolderState.STATE_CLOSED) %>
var g_lIdGedParent = <%= folder.getIdGedFolderParent() %>;
var g_jsonGedCategory = <%= GedCategory.getJSONArrayWithParentLabel() %>;
var bRefreshEngineGED = <%= bRefreshEngineGED %>;
mt.config.enableAutoLoading = false;
var rootPath = "<%= rootPath %>";
var jsonDisplay = [{"sLabel":"Affichage détaillé","sId":"detail"},{"sLabel":"Affichage en miniature","sId":"miniature"}];
var sDisplayModeArrayDocument = "<%= sDisplayModeArrayDocument %>";
var g_sLinkDisplayDocument = "<%= 
    response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision&lId=") 
    %>";
var g_sURLDisplayDocument = "<%= response.encodeURL(rootPath+"desk/ged/document/displayDocument.jsp?lId=")  %>";
var engine = new mt.component.SearchEngine();
var engineSubFolder = new mt.component.SearchEngine();
var g_modal;
var g_RelativeModale=null;
var g_TimeoutOpen=null;
var g_TimeoutClose=null;
function closeRelativeModale(){
	if (g_TimeoutOpen!=null) clearTimeout(g_TimeoutOpen);
	if (g_TimeoutClose!=null) clearTimeout(g_TimeoutClose);
	if (g_RelativeModale!=null) g_RelativeModale.close();
}
function refreshEngineGED(){
	if (g_lIdGedParent==0){
		//try{parent.engineGED.run(true);
		try{parent.launchGEDSearch();
		}catch(e){};
	}
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

function getContentTypeLabel(iContentType, sLabel, sName){
	var divType = document.createElement("div");
		
	if (iContentType==<%= GedDocumentContentType.TYPE_IMAGE_PHOTO %>){
		divType.innerHTML = "IMG";
	}else if (iContentType==<%= GedDocumentContentType.TYPE_DOCUMENT_PDF %>){
		divType.innerHTML = "PDF";
	}else if (iContentType==<%= GedDocumentContentType.TYPE_DOCUMENT_WORD %>){
		divType.innerHTML = "WORD";
	}else if (iContentType==<%= GedDocumentContentType.TYPE_VIDEO_FLV %>){
			divType.innerHTML = "FLV";
	}else{
		var splited = sName.split(".");
		divType.innerHTML = splited[splited.length - 1];
	}
	divType.style.position = "absolute";
	divType.style.zIndex = "2";
	divType.style.fontSize = "10px";
	divType.style.color = "#EEE";
	divType.style.backgroundColor = "#990000";
	divType.style.width = "40px";
	divType.style.height = "12px";
	divType.style.textAlign = "center";
	divType.style.marginTop = "0px";
	divType.style.marginLeft = "0px";
	//divType.style.float = "left";
	return divType;
}


function getLinkDisplayDocument(obj) {

	 var linkDoc = document.createElement("a");
     linkDoc.href=g_sURLDisplayDocument+obj.id_ged_document+"&tn=false";
     linkDoc.style.background="url('"+g_sLinkDisplayDocument+obj.id_ged_document+"') no-repeat";
     linkDoc.style.paddingLeft="20px";
     linkDoc.innerHTML = obj.name.stripSlashes();

     return linkDoc;
}
function getLinkDisplayDocumentOnNewTab(obj, bComplete) {
    var linkDoc = document.createElement("span");
    
    var img = document.createElement("img");
    img.alt = img.title = "Voir le document";
    img.src = "<%= rootPath +"images/icons/application_edit.gif" %>";
    
    img.onclick = function(){
        parent.addParentTabForced(obj.name,g_sLinkDisplayDocument+obj.id_ged_document+"&tn=false");
    }
    linkDoc.appendChild(img);
    return linkDoc;
}

function getLinkModifyDocument(obj, bComplete) {

	var linkDoc = document.createElement("div");
	
	var img = document.createElement("img");
	img.alt = img.title = "<%=locTitle.getValue (31, "Modifier")%>";
	img.src = "<%= rootPath + "images/icons/application_edit.gif" %>";
	
    var aLink = document.createElement("a");
    aLink.href=g_sURLDisplayDocument+ obj.id_ged_document;
    aLink.style.paddingLeft="5px";
    aLink.innerHTML = "<%=localizeButton.getValueEdit("Editer")%>";    
    
    if (!bComplete){
    	aLink.innerHTML = "";
    	aLink.appendChild(img);
    	return aLink;
    }    
    
    linkDoc.appendChild(img);
    linkDoc.appendChild(aLink);
    return linkDoc;
}




function getLinkDownloadDocument(obj, bComplete) {
	var sURL = g_sLinkDisplayDocument + obj.id_ged_document+"&dl=false";
	var linkDoc = document.createElement("div");
	
	var img = document.createElement("img");
	img.alt = img.title = "<%=locTitle.getValue (30, "Ouvrir le document")%>";
	img.src = "<%= rootPath + Icone.ICONE_DOWNLOAD_NEW_STYLE %>";

	img.onclick = function(){
        window.open(sURL);
	}

    var aLink = document.createElement("a");
    aLink.href="javascript:void(0)";
    aLink.onclick=function(){
        window.open(sURL);
        return false;
    }
    aLink.style.paddingLeft="5px";
    aLink.innerHTML = "<%=localizeButton.getValueOpen("Ouvrir")%>";    
    
    if (!bComplete){
    	aLink.innerHTML = "";
    	aLink.appendChild(img);
    	return aLink;
    }  
    //linkDoc.onclick=window.open(sURL);
    linkDoc.appendChild(img);
    linkDoc.appendChild(aLink);
    return linkDoc;
}

function updateAllDocumentSelected()
{
    $$('.selectedDocument').each(function(item){
    	item.checked = $("selectedDocumentAll").checked;        
    }) 
}


function removeSelectedDocument(){
	var selections;
	switch(sDisplayModeArrayDocument){
		case "detail":
			selections = layoutDetail.getSelections();
			break;
		default:
			selections = layoutMosaic.getSelections();
			break;
	}    
    if (selections.length==0) {
        alert("<%=locMessage.getValue (22, "Aucun document sélectionné.")%>\n\n<%=locMessage.getValue (23, "Cochez les cases des documents pour les sélectionner.")%>");   
        return false;
    }
	var arrSelectedItem = [];
    var arrSelectedItemName = [];
    selections.each(function(item){
        arrSelectedItem.push(item.id_ged_document);
        arrSelectedItemName.push("- " + (item.name.length>0?item.name:"<%=locTitle.getValue (32, "Sans titre")%>"));
    });
       

    if(confirm("<%=locMessage.getValue (21, "Souhaitez-vous supprimer ces documents ?")%>\n"+arrSelectedItemName.join(",\n"))){
    	openGlobalLoader();
    	var obj = {};
    	try{obj.sList = arrSelectedItem.join(",");}catch(e){}
	    GedDocument.removeFromJSONString(Object.toJSON(obj), function(b){
			if (!b){
           		alert("<%=locMessage.getValue (7, "un problème est survenu lors de la suppression")%>");
	         }else{
	         	alert("<%=locMessage.getValue (20, "Le ou les documents ont correctement été effacé.")%>");
	         }
			engine.run(true);
	        refreshEngineGED();
	        closeGlobalLoader();
	    });
     }
    
}
function setCookie (name, value) {
	var argv=setCookie.arguments;
	var argc=setCookie.arguments.length;
	var expires=(argc > 2) ? argv[2] : null;
	var path=(argc > 3) ? argv[3] : null;
	var domain=(argc > 4) ? argv[4] : null;
	var secure=(argc > 5) ? argv[5] : false;
	document.cookie=name+"="+escape(value)+
		((expires==null) ? "" : ("; expires="+expires.toGMTString()))+
		((path==null) ? "" : ("; path="+path))+
		((domain==null) ? "" : ("; domain="+domain))+
		((secure==true) ? "; secure" : "");
}
function getCookieVal(offset) {
	var endstr=document.cookie.indexOf (";", offset);
	if (endstr==-1)
      		endstr=document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}
function getCookie (name) {
	var arg=name+"=";
	var alen=arg.length;
	var clen=document.cookie.length;
	var i=0;
	while (i<clen) {
		var j=i+alen;
		if (document.cookie.substring(i, j)==arg)
                        return getCookieVal (j);
                i=document.cookie.indexOf(" ",i)+1;
                        if (i==0) break;}
	return null;
}
function getCategoryLabel(lId){
	for (var i=0;i<g_jsonGedCategory.length;i++){
		if (g_jsonGedCategory[i].lId==lId){
			return (g_jsonGedCategory[i].sParentLabel?g_jsonGedCategory[i].sParentLabel+" / ":"")+g_jsonGedCategory[i].sLabel;
		}
	}
	return "";
}
<%
GedDocument gedDocument = new GedDocument ();
gedDocument.setAbstractBeanLocalization(sessionLanguage);
%>

/**
 * Définition des LAYOUT et du contenu des cellules
 */

function getTagTitleForHeader(obj){
	//return "<%=localizeButton.getValueEdit("Editer")%>";
	return "<%=sTitleFileSize%> : "+getDisplayedFileSize(obj.document_length);
}
/* Définition du layout détail */
var layoutDetail = new mt.component.layout.TableLayout('results');
layoutDetail.enableSelections(true, "id_ged_document");
layoutDetail.setTableWidth("100%");

var header = layoutDetail.addHeader("<%=gedDocument.getReferenceLabel()%>");
header.getCellContent = function(obj, cell) {
	cell.style.verticalAlign = "middle";
	cell.title = getTagTitleForHeader(obj);
	cell.style.cursor = "pointer";
    cell.onclick = function(){location.href=g_sURLDisplayDocument+obj.id_ged_document};
    return obj.reference;
}
header.enableSorting(true, "ged_document.reference", "asc");

var header = layoutDetail.addHeader("<%=gedDocument.getNameLabel()%>");
header.getCellContent = function(obj, cell) {
    cell.style.color = "#000000";
    cell.style.fontSize = "12px";
    cell.style.verticalAlign = "middle";
    cell.title = getTagTitleForHeader(obj);
    cell.style.cursor = "pointer";
    cell.onclick = function(){location.href=g_sURLDisplayDocument+obj.id_ged_document};
    var div = document.createElement("div");
   
    var linkDoc = document.createElement("a");
    linkDoc.href="javascript:void(0)";
    linkDoc.innerHTML = (obj.name.length>0?obj.name.stripSlashes():"<%=locTitle.getValue (32, "Sans titre")%>");
    
    div.appendChild(linkDoc);
    return div;
}
header.enableSorting(true, "ged_document.name", "asc");

var header = layoutDetail.addHeader("<%=gedDocument.getIdGedDocumentTypeLabel()%>");
header.getCellContent = function(obj, cell) {
	cell.style.verticalAlign = "middle";
	cell.title = getTagTitleForHeader(obj);
	cell.style.cursor = "pointer";
    cell.onclick = function(){location.href=g_sURLDisplayDocument+obj.id_ged_document};
    if (obj.cat==undefined || obj.cat.length==0) return "";
    var arr = obj.cat.split(",");
    var arrContent = [];
    for (var i=0;i<arr.length;i++){
		arrContent.push(getCategoryLabel(arr[i]));
    } 
    return arrContent.join(", ");
}

var header = layoutDetail.addHeader("<%=gedDocument.getIdGedDocumentContentTypeLabel()%>");
header.getCellContent = function(obj, cell) {
	cell.style.verticalAlign = "middle";
	if (obj.labelContentType==undefined) return "???";
	cell.title = getTagTitleForHeader(obj);
	cell.style.cursor = "pointer";
    cell.onclick = function(){location.href=g_sURLDisplayDocument+obj.id_ged_document};
    return obj.labelContentType;
}
header.enableSorting(true, "labelContentType", "asc");

var header = layoutDetail.addHeader("<%=locTitle.getValue (33, "Date")%>");
header.getCellContent = function(obj, cell) {
	cell.style.verticalAlign = "middle";
	cell.title = getTagTitleForHeader(obj);
	cell.style.cursor = "pointer";
    cell.onclick = function(){location.href=g_sURLDisplayDocument+obj.id_ged_document};
	//if (obj.labelContentType="undefined") return "";
    return obj.date_creation;
}
header.enableSorting(true, "ged_document.date_creation", "asc");

var header = layoutDetail.addHeader("<%=gedDocument.getIdGedDocumentStateLabel()%>"); 
header.getCellContent = function(obj, cell) {
	cell.style.verticalAlign = "middle";
    cell.title = getTagTitleForHeader(obj);
    cell.style.cursor = "pointer";
    cell.onclick = function(){location.href=g_sURLDisplayDocument+obj.id_ged_document};
    //cell.style.textAlign = "center";
    var div = document.createElement("div");
    var label=document.createElement("label");
    var img = document.createElement("img");
    if (obj.id_ged_document_state=="<%= GedDocumentState.STATE_IN_PROCESS %>"){
    	label.innerHTML = img.alt=img.title="<%=gedDocumentStateInProcess.getName()%>";
    	img.src = "<%= rootPath %>images/icons/default.gif";
    }else if (obj.id_ged_document_state=="<%= GedDocumentState.STATE_CLOSED %>"){
    	label.innerHTML = img.alt=img.title="<%=gedDocumentStateClosed.getName()%>";
    	img.src = "<%= rootPath %>images/icons/lock.gif";
    }else{
    	label.innerHTML = img.alt=img.title="<%=gedDocumentStateDraft.getName()%>";
    	img.src = "<%= rootPath %>images/icons/application_edit.gif";
    }
    img.style.padding = "0px";
    img.style.position = "relative";

	div.appendChild(label);
	//div.appendChild(img);
	return div;
}
header.enableSorting(true, "ged_document.id_ged_document_state", "asc");
/*
layoutDetail.addHeader("").getCellContent = function(obj, cell) {
    cell.style.verticalAlign = "middle";
    cell.title = getTagTitleForHeader(obj);
    cell.style.cursor = "pointer";
    cell.onclick = function(){location.href=g_sURLDisplayDocument+obj.id_ged_document};
    var div = document.createElement("div");
   	var label=document.createElement("label");
    var img = document.createElement("img");
    if (obj.id_ged_document_state=="<%= GedDocumentState.STATE_IN_PROCESS %>"){
    	label.innerHTML = img.alt=img.title="<%=gedDocumentStateInProcess.getName()%>";
    	img.src = "<%= rootPath %>images/icons/default.gif";
    }else if (obj.id_ged_document_state=="<%= GedDocumentState.STATE_CLOSED %>"){
    	label.innerHTML = img.alt=img.title="<%=gedDocumentStateClosed.getName()%>";
    	img.src = "<%= rootPath %>images/icons/lock.gif";
    }else{
    	label.innerHTML = img.alt=img.title="<%=gedDocumentStateDraft.getName()%>";
    	img.src = "<%= rootPath %>images/icons/application_edit.gif";
    }
    img.style.padding = "0px";
    img.style.position = "relative";

	//div.appendChild(label);
	div.appendChild(img);
    return div;
}
*/

var header = layoutDetail.addHeader(""); 
header.getCellContent = function(obj, cell) {
	cell.style.verticalAlign = "middle";
	cell.style.textAlign = "right";
	var div = document.createElement("div");
    //div.appendChild(getLinkModifyDocument(obj, true));
    div.appendChild(getLinkDownloadDocument(obj, true));
    return div;
}


/**
 * Layout MOSAIC 
 */

var layoutMosaic = new mt.component.layout.DocumentLayout('results');
layoutMosaic.enableSelections(true, "id_ged_document");
layoutMosaic.setItemDisplay = function(obj) {
	var sTitle = (obj.name.length>0?obj.name.stripSlashes():"<%=locTitle.getValue (32, "Sans titre")%>");
    //var sTitle = (obj.name.length>0?getReducedWord(obj.name, 12):"Sans titre");
	var sURLDownload = g_sLinkDisplayDocument+ obj.id_ged_document+"&tn=true";
	var sURL = g_sURLDisplayDocument+ obj.id_ged_document;

    var div = document.createElement("div");
    //div.style.backgroundColor = "lightyellow";
    //div.style.border = "1px solid #CCC";
    div.style.margin = "2px";
    div.style.padding = "5px";
    div.style.width = "100px";
    //div.style.minHeight = "100px";
    div.style.textAlign = "center";
    
    var br = document.createElement("br");
    
    var divImg = document.createElement("div");
    divImg.style.width = divImg.style.height = "64px";
    //divImg.style.border = "1px solid #E0E0E0";
    divImg.style.marginRight = "auto";
    divImg.style.marginLeft = "auto";
    divImg.style.verticalAlign = "bottom";
    divImg.style.backgroundImage = "url('"+rootPath+"images/loading/ajax-loader.gif')";
    divImg.style.backgroundRepeat = "no-repeat";
    divImg.style.backgroundPosition = "center center";
    
    var img = document.createElement("img");
    img.src = sURLDownload;
    img.alt = "...";
    img.title = obj.name;
    img.style.border = "1px solid #EEEEEE";
    img.style.borderRight = img.style.borderBottom = "1px solid #CCCCCC";
    img.style.display = "block";
    img.style.marginRight = "auto";
    img.style.marginLeft = "auto";
    img.style.cursor = "pointer";
    img.style.verticalAlign = "bottom";
    img.onclick = function(){
    	//window.open(sURL, "Document", "menubar=no, resizable=yes,scrollbars=yes, width=500, height=300");
    	parent.addParentTabForced(obj.name,sURL);
    }
    divImg.appendChild(img);
    
    
    var linkDoc = document.createElement("span");
    linkDoc.innerHTML = sTitle;
    linkDoc.title = obj.name;

   	var divStatut = document.createElement("div");
    //divStatut.appendChild(getLinkDisplayDocumentOnNewTab(obj, false));
    divStatut.appendChild(getLinkModifyDocument(obj, false));
    divStatut.appendChild(getLinkDownloadDocument(obj, false));
    
    var label = document.createElement("div");
    label.style.width = "90px";
    label.style.height = "150px";
    label.style.padding = "2px";
    label.style.textAlign = "center";
    label.style.overflow = "hidden";
    label.style.cursor = "pointer";
    label.title = sTitle;
    label.onclick = function(){
    	//document.location.href = sURL;
    }
    
    var divType = getContentTypeLabel(obj.id_ged_document_content_type, obj.labelContentType, obj.name);

    
    label.appendChild(divImg);
    label.appendChild(divStatut);
    label.appendChild(linkDoc);
    div.appendChild(divType);
    div.appendChild(label);
	
    return div;
}

engine.enablePagination(false);
engine.setMainTable("ged_document", "ged_document");
engine.setSelectPart("<%=SecureString.getSessionSecureString(
        "ged_document.id_ged_document_state," +
        "ged_document.id_ged_document_type, ged_document_content_type.id_ged_document_content_type, ged_document_content_type.label AS labelContentType, " +
        "ged_document.document_name," +
		"ged_document.reference," +
	    "ged_document.name, ged_document.document_length," +
	    "IF(ged_document.date_creation IS NOT NULL,DATE_FORMAT(ged_document.date_creation,'%e/%m/%Y'),'') AS date_creation,"+
	    "GROUP_CONCAT(ged_category_selection.id_ged_category SEPARATOR ',') AS cat"
    , session)%>");

engine.setGroupByClause("ged_document.id_ged_document");
engine.setOrderBy("ged_document.date_creation", "desc");

engine.onBeforeSearch = function(){
	engine.addTableWithLeftJoin("ged_document_content_type", "ged_document_content_type.id_ged_document_content_type=ged_document.id_ged_document_content_type", []);
	engine.addTableWithLeftJoin("ged_category_selection", "ged_category_selection.id_reference_object=ged_document.id_ged_document AND ged_category_selection.id_type_object = ?", [<%= ObjectType.GED_DOCUMENT %>]);
	//$('resultCount').innerHTML = '';
    engine.addWhereClause("ged_document.id_ged_folder=?", [lIdGedFolder]);  
    return true;
}

engine.onAfterSearch = function(result){
	$("butDisplayMode").disabled = false;
	if(result.dataset.length==0){
		$('divMessage').innerHTML = "<h5 style=\"text-align:center\"><%=locMessage.getValue (14, "Ce classeur ne contient aucun document")%>.</h5>";
		Element.hide("contentFolder");
		Element.show("divMessage");
		Element.hide("butDelete");
		Element.hide("butDisplayMode");
	}else{
		Element.show("contentFolder");
		Element.hide("divMessage");
		Element.show("butDelete");
		Element.show("butDisplayMode");
	}
}


/**
 * SearchEngine for sub-folders
 */
var layoutMosaicSubFolder = new mt.component.layout.FolderLayout('resultsSubFolder');
layoutMosaicSubFolder.setItemDisplay = function(obj) {
	var sURL = "<%= response.encodeURL("displayFolder.jsp?lId=") %>" + obj.id_ged_folder;
	
	var div = document.createElement("div");
	//div.style.backgroundColor = "lightyellow";
	//div.style.border = "1px solid #CCC";
	div.style.margin = "5px";
	div.style.padding = "5px";
	div.style.width = "85px";
	//div.style.minHeight = "100px";
	div.style.textAlign = "center";
	
	var br = document.createElement("br");
	
	var img = document.createElement("img");
	img.src = "<%= rootPath %>images/icons/32x32/folder_closed_purple.png";
	img.alt = "";
	img.style.padding = "2px";
	img.style.display = "block";
	img.style.marginRight = "auto";
	img.style.marginLeft = "auto";
	
	var linkDoc = new Element("a",{"href":sURL}
			).update((obj.name.length>0?obj.name.stripSlashes():"<%=locTitle.getValue (32, "Sans titre")%>")+" ("+obj.nb_doc+")");
	
	var label = new Element("div",
			{"style":"width:90px;padding:2px;text-align:center;overflow:hidden;cursor:pointer;"});
	label.onclick = function(){
		document.location.href = sURL;
	}
	
	label.appendChild(img);
	label.appendChild(linkDoc);
	
	div.appendChild(label);

	// Rollover modale
	div.onmouseover = function(){
		var sColor = "cdc0c7";
		var iOpacity = 90;
		var arrPosition = Element.cumulativeOffset(div);
		var divContent = new Element("div",{className:"",style:"width:100%;height:100%;color:#000000;padding:5px;"});
		var tagTitle = new Element("div",{style:"font-size:12px;font-weight:bold;background-color:#EEEEEE;margin-bottom:2px;padding:2px;"});
		var tagDescr = new Element("span",{style:""});
		tagTitle.innerHTML = obj.name.stripSlashes();
		tagDescr.innerHTML = "<%=sTitleAuthor%> : "+obj.owner;
		if (obj.date_detail.length>0) tagDescr.innerHTML += "<br /><%=sTitleCreated%> : "+obj.date_detail;
	
		var iNbDoc = obj.nb_doc;
		GedFolder.getFolderListFromParent(obj.id_ged_folder, function(s){
	     	if (s){
	     		tagDescr.innerHTML += "<br /><%=sTitleSubFolder%> : "+s.evalJSON().length;
	     	}
	     	tagDescr.innerHTML += "<br /><%=sTitleDocument%> : "+obj.nb_doc;
		});	
		divContent.appendChild(tagTitle);
		divContent.appendChild(tagDescr);
		closeRelativeModale();
		g_RelativeModale = new Control.Window(false,{  
			//hover: true,
			className: 'window',
			constrainToViewport:true,
			fade:false,
			offsetLeft: 10,
			offsetTop: 10,
			position:[arrPosition[0], arrPosition[1]+Element.getHeight(div)],  
			width: 200,
			height:100
		});
		g_RelativeModale.container.style.backgroundImage = "url("+rootPath+"Fill?w=10&h=10&c="+sColor+"&a="+iOpacity+")";
		
		g_RelativeModale.container.insert(divContent);
		g_TimeoutOpen = setTimeout(function(){g_RelativeModale.open();},1500);
		g_TimeoutClose = setTimeout(function(){g_RelativeModale.close();},6000);
		return;
	};
	div.onmouseout = function(){closeRelativeModale();return;};
	
	return div;
}
engineSubFolder.setLayoutProvider(layoutMosaicSubFolder);
engineSubFolder.setPaginationElements('pagination', 'paginationContent');
engineSubFolder.setMainTable("ged_folder", "f");

engineSubFolder.setSelectPart("<%=SecureString.getSessionSecureString(
		"f.id_ged_folder, f.name, t.name AS typeName, f.reference, f.description, f.id_ged_folder_state, "+
 		"COUNT(id_ged_document) AS nb_doc, "+
 		"IF(pp.id_personne_physique IS NOT NULL,CONCAT(pp.prenom, ' ', UPPER(pp.nom)),'?') AS owner,"+
 		"IF(f.date_creation IS NOT NULL,DATE_FORMAT(f.date_creation,'%d/%m/%Y'),'') AS date, "+
 		"IF(f.date_creation IS NOT NULL,DATE_FORMAT(f.date_creation,'%e/%m/%Y'),'') AS date_detail"
 		, session)%>");

engineSubFolder.setGroupByClause("f.id_ged_folder");
engineSubFolder.setOrderBy("f.date_modification DESC, f.id_ged_folder_type DESC");

engineSubFolder.onBeforeSearch = function(){
	engineSubFolder.addTableWithLeftJoin("ged_folder_type t", "f.id_ged_folder_type=t.id_ged_folder_type", []);
	engineSubFolder.addTableWithLeftJoin("ged_folder_entity fe", 
			"fe.id_ged_folder=f.id_ged_folder AND fe.id_type_object=? AND fe.id_ged_document_entity_type=?", [<%= ObjectType.PERSONNE_PHYSIQUE %>, <%= GedDocumentEntityType.TYPE_WRITER %>]);
	engineSubFolder.addTableWithLeftJoin("personne_physique pp", "fe.id_reference_object=pp.id_personne_physique", []);
	engineSubFolder.addTableWithLeftJoin("ged_document doc", "doc.id_ged_folder=f.id_ged_folder", []);
 	engineSubFolder.addWhereClause("f.id_ged_folder_parent=?", [lIdGedFolder]);
 	engineSubFolder.addWhereClause("f.id_ged_folder_type=?", [<%= GedFolderType.TYPE_GED %>]);
 	return true;
};
engineSubFolder.onAfterSearch = function(result){
	if(result.dataset.length==0){
		Element.hide("contentSubFolder");
	}else{
		if(result.dataset.length==1) $("resultCountSubFolder").innerHTML = "<%=locMessage.getValue (11, "Ce classeur contient un sous-classeur")%> :";
		else $("resultCountSubFolder").innerHTML = "<%=locMessage.getValue (12, "Ce classeur contient")%> "+result.dataset.length+" <%=locMessage.getValue (13, "sous-classeurs").toLowerCase()%> :";
		Element.show("contentSubFolder");
	}
// 	$('resultCountSubFolder').innerHTML = result.dataset.length;
}

function switchDisplay(){
	var img = document.createElement("img");
	img.alt = "";
	var label = document.createElement("label");
	label.style.marginLeft = "2px";
	$("butDisplayMode").innerHTML = "";
	switch(sDisplayModeArrayDocument){
		case "detail":
			sDisplayModeArrayDocument = "miniature";
			img.src = "<%= rootPath %>images/icons/disp_mosaic.png";
			label.innerHTML = "<%=sButtonThumbnailView%>";
			break;
		default:
			sDisplayModeArrayDocument = "detail";
			img.src = "<%= rootPath %>images/icons/disp_detail.png";
			label.innerHTML = "<%=sButtonDetailView%>";
			break;
	}
	setCookie("GEDDisplayDocument", sDisplayModeArrayDocument);
	$("butDisplayMode").appendChild(img);
	$("butDisplayMode").appendChild(label);
	launchSearch();
}
function launchSearch(){
	$("butDisplayMode").disabled = true;
	switch(sDisplayModeArrayDocument){
	case "detail":
		engine.setLayoutProvider(layoutDetail);
		break;
	default:
		engine.setLayoutProvider(layoutMosaic);
		break;
	}
	engine.run(true);
}
function populate(){
	if (bRefreshEngineGED) refreshEngineGED();
	Element.hide("contentSubFolder");
	sDisplayModeArrayDocument = ((getCookie("GEDDisplayDocument")==null)?"detail":getCookie("GEDDisplayDocument"));
	//$('selectDisplay').populate(jsonDisplay, sDefaultDisplay, "sId", "sLabel");
	//$('selectDisplay').onchange = function(){switchDisplay();}
	if (!g_bIsClosed){
		Element.show("butCloseFolder");
	}
	$("butCloseFolder").onclick = function(){
		if (confirm("<%=locMessage.getValue (38, "Clôturer ce classeur ?")%>")){
			$("butCloseFolder").innerHTML = "<%=locMessage.getValue (3, "Chargement...")%>";
			var obj = {};
			obj.lId = g_lIdGedFolder;
			obj.lIdGedFolderState = g_lIdGedFolderStateClosed;
			obj.tsDateClotured = (new Date().dateFormat("Y-m-d H:i:s"));
			GedFolder.storeFromJSONString(Object.toJSON(obj), function(lId){
				if (lId>0) {
					// Refreshing list of folders
					if (g_bIsParent) refreshEngineGED();	
				} else {
					alert("<%=locMessage.getValue (1, "un problème est survenu lors de l'enregistrement")%>");
				}
				self.location.href = g_sURLDisplayFolder+"lId="+g_lIdGedFolder;
			});
		}
	}
	$("butDisplayMode").onclick = function(){switchDisplay();}
	$("butDelete").onclick=function(){removeSelectedDocument();}
	$("butAddFolder").onclick=function(){
		g_modal = parent.mt.utils.displayModal({
			type:"iframe",
			url:"<%= response.encodeURL(rootPath
					+ "desk/ged/folder/modifyFolderForm.jsp?sAction=create&bModalMode=true&lIdGedFolderType="
					+ GedFolderType.TYPE_GED+"&lIdGedFolderParent="+folder.getId())%>",
			title:g_sFolderName+" : <%=sButtonAddSubFolder%>",
			width:popupWidth,
			height:popupHeight-250,
			color:"8A6D7C",
			opacity:70,
			titleColor:"fff",
			options:{
				afterClose:function(){
					self.engineSubFolder.run(true);
				}
			}
		});
	}
	$("butAddDocument").onclick=function(){
		g_modal = parent.mt.utils.displayModal({
			type:"iframe",
			url:"<%= response.encodeURL(rootPath 
				+ "desk/ged/document/addDocumentForm.jsp?&bModalMode=true&lIdGedFolder=" + folder.getId()) %>",
			title:g_sFolderName+" : <%=locTitle.getValue (38, "Ajouter un document")%>",
			width:popupWidth,
			height:popupHeight-250,
			color:"8A6D7C",
			opacity:70,
			titleColor:"fff",
			options:{
				afterClose:function(){
					try{self.launchSearch();
					}catch(e){alert("afterClose1:"+e);}
				}
			}
		});
	}
	try{engineSubFolder.run(true);
	}catch(e){alert("erreur : "+e);}
	launchSearch();
}

onPageLoad = function() {
	// Préchargement de l'image par défaut :
	var img = new Image(16, 16);
	img.src = rootPath+"images/icons/application.gif";
	var img2 = new Image(16, 16);
	img2.src = rootPath+"images/loading/ajax-loader.gif";
	populate();
    
    var pathArray = [{name:"Tableau de bord",url:"#"},
                     {name:"All folders",url:"<%= response.encodeURL( rootPath + "desk/ged/folder/displayAllFolder.jsp" ) %>"},
                     {name:"folder <%= folder.getName() %>",url:"#"}];
    parent.updateParentNavPath(pathArray,"leftBottomPath");
}

</script>

</head>
<body style="background-color: #FFFFFF;">
<span id="pageTitle" style="display:none"><%=sTitle%></span>
<div class="ficheTablePadding">
	
<!-- cdc0c7 8A6D7C -->
<div style="background-color:#FFF;padding:0px 10px 0 10px">
<%Border bordGedFolder = new Border("cdc0c7", 5, 100, "tr", request);%>
<%=bordGedFolder.getHTMLTop()%>
<jsp:include page="/desk/ged/folder/include/headerFolder.jsp"></jsp:include>	
	
	<div style="margin:5px;">
	<%
	Border bordButton = new Border("eeeeee", 5, 100, "tblr", request);
	bordButton.setStyle("text-align: center;width:100%;");
	out.print(bordButton.getHTMLTop());
	%>	
		<button type="button" id="butAddFolder" style="" class="ContextButton" >
		<img src="<%= rootPath %>images/icons/16x16/folder_purple_add.png" alt="" style="vertical-align:middle;"/>
		<%=sButtonAddSubFolder%></button>
		
		<button type="button" id="butCloseFolder" class="ContextButton" style="display:none;">
		<img src="<%= rootPath %>images/icons/lock.gif" alt="" />
		<%=sButtonCloseFolder%></button>
		
		<button type="button" id="butAddDocument" class="ContextButton">
		<img src="<%= rootPath %>images/icons/16x16/file_document_add.png" alt="" style="vertical-align:middle;"/>
		<%=sButtonAddDocument%></button>
		
		<button type="button" id="butDelete" class="ContextButton" style="display:none;">
	    <img src="<%= rootPath %>images/icons/16x16/file_document_multi_del.png" alt="" />
	    <%=sButtonDeleteDocuments%></button>
		
		<button id="butDisplayMode" type="button" class="ContextButton">
			<img src="<%= rootPath %>images/icons/disp_mosaic.png" alt="" />
		<%=sButtonThumbnailView%></button>
		
	<%= bordButton.getHTMLBottom() %>
	</div>
	<%
	Border bordContentFolder = new Border("ffffff", 5, 100, "tblr", request);
	%>	
	<div id="contentSubFolder" style="margin:0 5px 5px 5px;display: none;">
	    <%= bordContentFolder.getHTMLTop() %>
	    <div id="resultCountSubFolder" style="font-weight: bold;margin: 5px 0 0 5px;"></div>
	    <div id="resultsSubFolder"></div>
	    <div id="pagination" style="padding-top:10px;display:none"><div id="paginationContent" style="text-align:center;font-size:12px;font-weight:bold"></div></div>
	    <%= bordContentFolder.getHTMLBottom() %>
	</div>
	
	<div id="contentFolder" style="margin:0 5px 0 5px;">
	    <div id="resultCount"></div>
	    <%= bordContentFolder.getHTMLTop() %>
	    <div id="results"></div>
	    <%= bordContentFolder.getHTMLBottom() %>
	</div>
	<div id="divMessage" style="display:none;margin:0 5px 0 5px;"></div>
<% bordGedFolder = new Border("cdc0c7", 5, 100, "tblr", request);%>
<%=bordGedFolder.getHTMLBottom()%>

</div>
</div>

</body>


<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ged.GedDocumentContentType"%>

<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.util.StringUtil"%>
<%@page import="org.coin.util.Outils"%>

<%@page import="org.coin.bean.ged.GedFolderState"%>
<%@page import="org.coin.bean.ged.GedDocumentState"%>
<%@page import="org.coin.ui.Border"%>
<%@page import="org.coin.bean.ged.GedCategory"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedDocumentEntityType"%></html>
