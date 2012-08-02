<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%@page import="org.coin.bean.ged.GedDocumentSelection"%>
<%@page import="java.util.Vector"%>
<% 
	String sTitle = ""; 


	GedFolder item = null;
	String sPageUseCaseId = "IHM-DESK-FONDATION-LECLERC-GERER-DOCUMENTS";
	

	item = GedFolder.getGedFolder(GedFolder.ID_GED_FOLDER_FONDATION_LECLERC);
	sTitle += "<span class=\"altColor\">"+item.getName()+"</span>"; 

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = false;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	
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
	
	
	String sDisplayModeArrayDocument = HttpUtil.parseString("sDisplayModeArrayDocument", request, "miniature");
	
	long lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request, 0);
	long lIdReferenceObject = HttpUtil.parseLong("lIdReferenceObject", request, 0);
	boolean bModeSelection = (lIdReferenceObject>0 && lIdTypeObject>0);
%>
<style type="text/css">
<!--
#results th{
    text-align: left;
}
-->
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
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentSelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentFondationLeclerc.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/mt.component.SearchEngine.js?v=3"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/searchEngine/layout/mt.component.layout.DocumentLayout.js?v=1"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategory.js"></script>

<script type="text/javascript">
mt.config.enableAutoLoading = false;
var bModeSelection = <%= bModeSelection %>;
var lIdTypeObject = <%= lIdTypeObject %>;
var lIdReferenceObject = <%= lIdReferenceObject %>;
var jsonGedDocumentContentType = <%=GedDocumentContentType.getJSONArray()%>;
var jsonGedCategory = <%= GedCategory.getJSONArrayWithParentLabel() %>
for (var i=0;i<jsonGedCategory.length;i++){
	if (jsonGedCategory[i].lIdGedCategoryParent>0){
		jsonGedCategory[i].sLabel = jsonGedCategory[i].sParentLabel+" > "+jsonGedCategory[i].sLabel;
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

var engine = new mt.component.SearchEngine();


/**
 * comme pour XP ou Vista :
 *
 * - list,
 * - detail,
 * - miniature,
 * - small_icon ,
 * - medium_icon ,
 * - large_icon ,
 * - very_large_icon 
 * 
 */
var sDisplayModeArrayDocument = "<%= sDisplayModeArrayDocument %>";

function getContentTypeLabel(iContentType, sLabel){
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
		divType.innerHTML = "???";
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
     linkDoc.href="<%= 
         response.encodeURL(rootPath+"desk/ged/fondation_leclerc/modifyDocumentForm.jsp?lId=") 
            %>" + obj.id_ged_document;
     //linkDoc.style.background="url(<%= rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>) no-repeat";
     linkDoc.style.background="url(<%= 
        response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision&tn=true&lId=") 
           %>"+obj.id_ged_document+") no-repeat";
     linkDoc.style.paddingLeft="20px";
     linkDoc.innerHTML = obj.name;

     return linkDoc;
}
function getLinkModifyDocument(obj, bComplete) {

	var linkDoc = document.createElement("span");
	
	var img = document.createElement("img");
	img.alt = img.title = "Modifier";
	img.src = "<%= rootPath + "images/icons/application_edit.gif" %>";
	
    var aLink = document.createElement("a");
    aLink.href="<%= 
        response.encodeURL(rootPath+"desk/ged/fondation_leclerc/modifyDocumentForm.jsp?lId=") 
           %>" + obj.id_ged_document;
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

function getLinkDownloadDocument(obj, bComplete) {
	var linkDoc = document.createElement("span");
	
	var img = document.createElement("img");
	img.alt = img.title = "Télécharger";
	img.src = "<%= rootPath + Icone.ICONE_DOWNLOAD_NEW_STYLE %>";
    
    var aLink = document.createElement("a");
    aLink.href="<%= 
        response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision&dl=true&lId=") 
           %>" + obj.id_ged_document;
    aLink.style.paddingLeft="5px";
    aLink.innerHTML = "Télécharger";
    
    if (!bComplete){
    	aLink.innerHTML = "";
    	aLink.appendChild(img);
    	return aLink;
    }
    
    linkDoc.appendChild(img);
    linkDoc.appendChild(aLink);
    return linkDoc;
}

/**
 * Définition des LAYOUT et du contenu des cellules
 */ 

/* Définition du layout détail */
var layoutDetail = new mt.component.layout.TableLayout('results');
layoutDetail.enableSelections(true, "id_ged_document");
layoutDetail.addHeader("Id").getCellContent = function(obj) {
    return obj.id_ged_document;
}
layoutDetail.addHeader("Nom").getCellContent = function(obj, cell) {
    //cell.style.borderTop = "1px solid #C3D9FF";
    cell.style.padding = "5px 5px 2px 6px";
    cell.style.fontWeight = "bold";
    cell.style.color = "#36C";
    cell.style.fontSize = "12px";
    cell.style.verticalAlign = "middle";
    var div = document.createElement("div");
    var br = document.createElement("br");
    
    var img = document.createElement("img");
    img.src = "<%= response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?tn=true&sRevision=last_revision") %>&lId="+obj.id_ged_document;
    img.alt = "";
    img.style.padding = "2px";
    img.style.width = "32px";

    
    var linkDoc = document.createElement("a");
    linkDoc.href="<%= 
        response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet?sRevision=last_revision&lId=") 
           %>" + obj.id_ged_document;
    linkDoc.innerHTML = (obj.name.length>0?obj.name:"Sans titre");
    
	div.appendChild(img);
	div.appendChild(br);
    div.appendChild(linkDoc);
    return div;
}

layoutDetail.addHeader("Type").getCellContent = function(obj) {
	if (obj.labelContentType==undefined) return "???";
    return obj.labelContentType;
}
layoutDetail.addHeader("Référence").getCellContent = function(obj) {
    return obj.reference;
}

layoutDetail.addHeader("Date").getCellContent = function(obj) {
	if (obj.labelContentType="undefined") return "";
    return obj.date;
}

	
layoutDetail.addHeader("").getCellContent = function(obj) {
	var div = document.createElement("div");
	var br = document.createElement("br");
	
    div.appendChild(getLinkModifyDocument(obj, true));
    div.appendChild(br);
    div.appendChild(getLinkDownloadDocument(obj, true));
    return div;
}


var layoutMosaic = new mt.component.layout.DocumentLayout('results');
layoutMosaic.enableSelections(!bModeSelection, "id_ged_document");
layoutMosaic.setItemDisplay = function(obj) {
	var sTitle = (obj.name.length>0?getReducedWord(obj.name, 12):"Sans titre");
	var sURL = "<%= 
        response.encodeURL(rootPath
        		+"fondation-leclerc/document?"
        		+"sURL="+response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet")+"&sRevision=last_revision&lId=") 
           %>" + obj.id_ged_document;
           
    
    var div = document.createElement("div");
    //div.style.backgroundColor = "lightyellow";
    //div.style.border = "1px solid #CCC";
    div.style.margin = "1px";
    //div.style.padding = "5px";
    div.style.width = "100px";
    //div.style.minHeight = "100px";
    div.style.textAlign = "center";
    
    var br = document.createElement("br");
    
    var divImg = document.createElement("div");
    divImg.style.width = divImg.style.maxHeight = "64px";
    //divImg.style.border = "solid blue 1px";
    divImg.style.marginRight = "auto";
    divImg.style.marginLeft = "auto";
    
    var img = document.createElement("img");
    img.src = sURL+"&tn=true";
    img.alt = img.title = sTitle;
    //img.style.display = "block";
    img.style.marginRight = "auto";
    img.style.marginLeft = "auto";
    img.style.height = "64px";
    img.style.cursor = "pointer";
    //img.style.marginTop = "-50%";
    //img.style.top = "50%";
    //img.style.position = "relative";
    img.onclick = function(){
    	window.open(sURL, "Document", "menubar=no, resizable=yes,scrollbars=yes, width=500, height=300");
    }
    divImg.appendChild(img);
    
    
    var linkDoc = document.createElement("a");
    linkDoc.href = sURL;
    linkDoc.target = "_blank";
    linkDoc.innerHTML = linkDoc.title = sTitle;
    
   	var divStatut = document.createElement("div");
   	if (bModeSelection){
   		var butSelection = document.createElement("button");
   		butSelection.style.textAlign = "left";
   		butSelection.style.padding = "1px";
   		butSelection.style.fontSize = "10px";
   		butSelection.style.fontWeight = "lighter";
   		butSelection.style.height = "25px";
   		butSelection.style.width = "80px";
   		butSelection.style.margin = "0px";
   		butSelection.style.border = "solid 1px";
   		
   		var imgCheckChecked = document.createElement("img");
   		imgCheckChecked.src = "<%= rootPath + "images/check_checked.png" %>";
   		
   		var imgCheckEmpty = document.createElement("img");
   		imgCheckEmpty.src = "<%= rootPath + "images/check_empty.png" %>";
   		
   		var labButtonChecked = document.createElement("label");
   		labButtonChecked.innerHTML = "Retirer";
   		
   		var labButtonEmpty = document.createElement("label");
   		labButtonEmpty.innerHTML = "Sélectionner";
   		
   		if (obj.bSelected=="1"){
   			butSelection.style.backgroundColor = "#FF9933";
   			butSelection.appendChild(imgCheckChecked);
   			butSelection.appendChild(labButtonChecked);
   		}else{
   			butSelection.appendChild(imgCheckEmpty);
   			butSelection.appendChild(labButtonEmpty);
   		}
   		
   		butSelection.onclick = function(){
   			butSelection.innerHTML = "Chargement...";
 		   	var oElt = {};
 			oElt.lIdGedDocument = obj.id_ged_document;
 			oElt.lIdTypeObject = lIdTypeObject;
			oElt.lIdReferenceObject = lIdReferenceObject;
   			if (obj.bSelected=="1"){
	   			GedDocumentSelection.removeFromJSONString(Object.toJSON(oElt), function(bSuccess){
					if (bSuccess) {
						butSelection.style.backgroundColor = "transparent";
						butSelection.innerHTML = "";
			   			butSelection.appendChild(imgCheckEmpty);
			   			butSelection.appendChild(labButtonEmpty);
			   			obj.bSelected = "";
					} else {
						alert("Un problème est survenu lors de la suppression");
					}
				});
   			}else{  			
	   			GedDocumentSelection.storeFromJSONString(Object.toJSON(oElt), function(bSuccess){
					if (bSuccess) {
						butSelection.style.backgroundColor = "#FF9933";
						butSelection.innerHTML = "";
			   			butSelection.appendChild(imgCheckChecked);
			   			butSelection.appendChild(labButtonChecked);
			   			obj.bSelected = "1";
					} else {
						alert("un problème est survenu lors de l'ajout");
					}
				});
   			}
   			return false;
   		}
   		divStatut.appendChild(butSelection);
   	}else{
   		divStatut.appendChild(getLinkDownloadDocument(obj, false));
   		divStatut.appendChild(getLinkModifyDocument(obj, false));
   	}
    
    
    var label = document.createElement("div");
    label.style.width = "90px";
    label.style.height = "110px";
    label.style.padding = "2px";
    label.style.textAlign = "center";
    label.style.overflow = "hidden";
    label.style.cursor = "pointer";
    label.title = sTitle;
    label.onclick = function(){
    	//document.location.href = sURL;
    }
    
    var divType = getContentTypeLabel(obj.id_ged_document_content_type, obj.labelContentType);

    
    label.appendChild(divImg);
    label.appendChild(divStatut);
    label.appendChild(linkDoc);
    div.appendChild(divType);
    div.appendChild(label);

    return div;
}


if(sDisplayModeArrayDocument == "list" || sDisplayModeArrayDocument == "detail"){
	engine.setLayoutProvider(layoutDetail);
}else if(sDisplayModeArrayDocument == "miniature" 
|| sDisplayModeArrayDocument == "small_icon"
|| sDisplayModeArrayDocument == "medium_icon"
|| sDisplayModeArrayDocument == "large_icon"
|| sDisplayModeArrayDocument == "very_large_icon"){
	engine.setLayoutProvider(layoutMosaic);
}

engine.enablePagination(false);
engine.setMainTable("ged_document", "doc");
engine.setSelectPart("<%=SecureString.getSessionSecureString(
        "doc.id_ged_document_state," +
        "doc.id_ged_document_type, ct.id_ged_document_content_type, ct.label AS labelContentType, " +
        "doc.document_name," +
		"doc.reference," +
	    "doc.name," +
	    "doc.date_creation"
	    + (bModeSelection?", IF(gds.id_ged_document_selection>0, 1, 0) AS bSelected":"")
    , session)%>");



engine.setGroupByClause("doc.id_ged_document");
if (bModeSelection)	engine.setOrderBy("bSelected DESC, doc.document_name", "");
else engine.setOrderBy("doc.document_name", "asc");


function addBaseJointures() {

    // exemple de jointure
 
}

engine.onBeforeSearch = function(){
	engine.addTableWithLeftJoin("ged_document_content_type ct", "ct.id_ged_document_content_type=doc.id_ged_document_content_type", []);
	if (bModeSelection)
		engine.addTableWithLeftJoin("ged_document_selection gds", "gds.id_ged_document=doc.id_ged_document AND gds.id_type_object=? AND gds.id_reference_object=?", [lIdTypeObject, lIdReferenceObject]);
    $('resultCount').innerHTML = '';
    
    var sKeyword = $('keyword').value;
	if (isNotNull(sKeyword)){
		// on utilise CONCAT_WS pour éviter plusieurs LIKE et en sachant que CONCAT_WS("aa", NULL) ne donne pas NULL
		engine.addWhereClause("CONCAT_WS('', doc.name, doc.description, doc.reference) LIKE ?", ["%"+sKeyword.trim()+"%"]);
	}
    
    if ($('lIdGedDocumentContentType').value>0){
		engine.addWhereClause("doc.id_ged_document_content_type=?", [$('lIdGedDocumentContentType').value]);
	}
	if ($('lIdGedCategory').value>0){
		engine.addTable("ged_category_selection gcs", "gcs.id_ged_category=? AND gcs.id_type_object=<%= ObjectType.GED_DOCUMENT %> AND gcs.id_reference_object=doc.id_ged_document ", [$('lIdGedCategory').value]);
		//engine.addWhereClause("doc.id_ged_document_content_type=?", [$('lIdGedDocumentContentType').value]);
	}
	    
    engine.addWhereClause("doc.id_ged_folder=?", [<%= item.getId() %>]);
    
    engine.addWhereClause("doc.id_ged_document_type=?", [<%= GedConstant.GED_DOCUMENT_FOND_LECLERC_DOCUMENT_ORIGINAL %>]);
    
    
    return true;
}

engine.onAfterSearch = function(result){
	if(result.dataset.length==0) $('contentFolder').innerHTML = "<h5>Ce répertoire ne contient aucun document.</h5>";
}

function removeItem(){
    if(confirm("Supprimer ce répertoire et tous les documents qu'il contient ?")){
    	openGlobalLoader();
         GedFolder.removeFromIdJSON(<%= item.getId() %>, function(bSuccess){
         	closeGlobalLoader();
			if (bSuccess) {
				alert("Le répertoire a été correctement supprimé.");
				location.href = '<%= response.encodeURL("displayAllFolder.jsp") %>';
			} else {
				alert("un problème est survenu lors de la suppression");
			}
		});
     }
     return false;
}
function removeDocument(id, name)
{
    if(confirm("Do you want to delete the document \"" + name + "\" ?")){
         location.href = '<%= 
             response.encodeURL("../document/modifyDocument.jsp?sAction=remove&lId=") %>' + id;
     }
}

function updateAllDocumentSelected()
{
    $$('.selectedDocument').each(function(item){
    	item.checked = $("selectedDocumentAll").checked;        
    }) 
}


function removeDocumentSelected(){
	var selections;
	switch($('selectDisplay').value){
		case "detail":
			selections = layoutDetail.getSelections();
			break;
		default:
			selections = layoutMosaic.getSelections();
			break;
	}
	

	var sSelectedItemUrlParam = "";
    var sSelectedItemListDocumentName = "";
    
    if (selections.length==0) {
        alert("Pas de document sélectionné");   
        return false;
    }

    selections.each(function(item){
        if(sSelectedItemUrlParam != "") {
            sSelectedItemUrlParam += ",";
            sSelectedItemListDocumentName += ",\n";
        }
        sSelectedItemUrlParam += item.id_ged_document ;
        sSelectedItemListDocumentName += "- " + item.name ;
    });
      

    if(confirm("Souhaitez-vous supprimer ces documents ?\n"+ sSelectedItemListDocumentName)){
        /*
         location.href = '<%= 
             response.encodeURL(rootPath+"desk/ged/fondation_leclerc/modifyDocument.jsp?sAction=removeAll&arrayId=")
             %>' + sSelectedItemUrlParam;
        */
    	var obj = {};
    	try{obj.sList = sSelectedItemUrlParam;}catch(e){}
         	
	    GedDocumentFondationLeclerc.removeMultiFromJSONString(Object.toJSON(obj), function(b){
			if (!b){
	           		alert("un problème est survenu lors de la suppression");
	         }else{
	         	alert("Document(s) correctement effacé(s)");
	         	engine.run(true);
	         }
	    });

     }
    return false;
    
}

function removeDocumentSelectedOld()
{
    var bAtLeastOneSelected = false;
	var sSelectedItemUrlParam = "";
    var sSelectedItemListDocumentName = "";
	$$('.selectedDocument').each(function(item){
		if(item.checked)
		{
	        bAtLeastOneSelected = true;   
			if(sSelectedItemUrlParam != "") {
                sSelectedItemUrlParam += ",";
                sSelectedItemListDocumentName += ",\n";
			}
			sSelectedItemUrlParam += item.value ;
	        sSelectedItemListDocumentName += "- " + item.name ;
	    }
	}) 

	
	if(!bAtLeastOneSelected)
	{
		alert("Pas de document sélectionné");	
		return false;
	}
	
	if(confirm("Do you want to delete this documents ? \n" 
			+ sSelectedItemListDocumentName
			 )){
         location.href = '<%= 
             response.encodeURL("../document/modifyDocument.jsp?sAction=removeAll&arrayId=") %>' + sSelectedItemUrlParam;
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
function switchDisplay(){
	switch($('selectDisplay').value){
		case "detail":
			engine.setLayoutProvider(layoutDetail);
			break;
		default:
			engine.setLayoutProvider(layoutMosaic);
			break;
	}
		
	engine.run(true);
	setCookie("GEDDisplayDocument", $('selectDisplay').value);
}
var jsonDisplay = [{"sLabel":"Affichage en miniature","sId":"miniature"},{"sLabel":"Affichage détaillé","sId":"detail"}];

var ged_categories;
function populate(){
	var aType = [{"sExtensions":"","sLabel":"-","lId":0}];
	$('lIdGedDocumentContentType').populate(aType.concat(jsonGedDocumentContentType), "", "lId", "sLabel");
	$('lIdGedCategory').populate([{"sLabel":"-","lId":0}].concat(jsonGedCategory), "", "lId", "sLabel");
	if (bModeSelection){
		$("buttonsAction1").hide();
		$("buttonsAction2").hide();
		engine.setLayoutProvider(layoutMosaic);
		engine.run(true);
	}else{
		var sDefaultDisplay = ((getCookie("GEDDisplayDocument")==null)?"miniature":getCookie("GEDDisplayDocument"));
		$('selectDisplay').populate(jsonDisplay, sDefaultDisplay, "sId", "sLabel");
		$('selectDisplay').onchange = function(){switchDisplay();}
		switchDisplay();
	}
}

onPageLoad = function() {   
	populate();
	// Préchargement de l'image par défaut :
	var img = new Image(16, 16);
	img.src = "<%= rootPath %>images/icons/application.gif";

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
<form id="form" method="post">
<div>

        <div class="round blockTitle " corner="6" border="1" style="width:560px;margin-left: auto;margin-right: auto;margin-top: 10px;">
          <div id="buttonsAction1" style="padding:5px;margin-left: auto;margin-right: auto;text-align: center;">
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath 
					+ "desk/ged/fondation_leclerc/addDocumentForm.jsp?lIdGedFolder=" + item.getId()) 
			%>');" style="border:none;background-color: transparent;">
			<img src="<%= rootPath %>images/icons/32x32/document_add.png" alt="" style="padding: 2px; display: block; margin-right: auto; margin-left: auto;"/>
			Ajouter un document</button>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath 
					+ "desk/ged/fondation_leclerc/addMultiDocumentForm.jsp?lIdGedFolder=" + item.getId()) 
			%>');" style="border:none;background-color: transparent;" disabled="disabled">
			<img src="<%= rootPath %>images/icons/32x32/document_add_multi.png" alt="" style="padding: 2px; display: block; margin-right: auto; margin-left: auto;"/>
			Ajouter des documents</button>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath 
					+ "desk/ged/fondation_leclerc/scanDocumentForm.jsp?lIdGedFolder=" + item.getId()) 
			%>');" style="border:none;background-color: transparent;" disabled="disabled">
			<img src="<%= rootPath %>images/icons/32x32/document_add_scan.png" alt="" style="padding: 2px; display: block; margin-right: auto; margin-left: auto;"/>
			Numériser un document</button>
  		</div>
            <div style="padding:5px;margin-left: auto;margin-right: auto;text-align: center;">
                <table class="formLayout" style="width:550px;">
                    <tr>
                        <td class="label" style="text-align: center;">Type : <select id="lIdGedDocumentContentType"></select></td>
                        <td class="label" style="text-align: center;">Mot clé : <input id="keyword" class="searchInput" type="text" style="margin-left: auto;" /></td>
                    </tr>
                    <tr>
                        <td class="label" style="text-align: center;" colspan="2">Catégories : <select id="lIdGedCategory"></select></td>
                    </tr>
                    <tr>               
                        <td colspan="2" style="text-align: center;"><button style="width:150px;" id="searchButton" type="submit">Rechercher</button></td>
                    </tr>
                </table>
            </div>
        </div>

</div>



<div id="contentFolder" style="margin-right:5px; margin-left: 5px;">
	<div id="buttonsAction2" style="width:560px;margin-right:auto; margin-left: auto;margin-bottom: 10px;text-align: center;">
	    <button style="font-size: 11px; padding: 0;background-color: transparent;border: none;" onclick="removeDocumentSelected();return false;">
	    <img src="<%= rootPath %>images/icons/32x32/document_del.png" alt="" style="padding: 2px;"/>
	    Supprimer la sélection</button>
	    <select name="selectDisplay" id="selectDisplay">
	    </select>
	</div>
    <div id="resultCount"></div>
    <div id="results"></div>



</div>



<%@ include file="/include/new_style/footerFiche.jspf" %>
</form>
</body>


<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.HttpUtil"%><%@page import="org.coin.bean.ged.GedDocumentContentType"%>
<%@page import="mt.fondationleclerc.GedConstant"%>
<%@page import="org.coin.bean.ged.GedCategory"%>
<%@page import="org.coin.bean.ObjectType"%>
</html>
