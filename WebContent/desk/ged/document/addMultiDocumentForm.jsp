<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentContentType"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.InputStreamDownloader"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.coin.util.Outils"%>
<% 
	String sTitle = "Document : "; 
	Connection conn = ConnectionManager.getConnection();


	GedDocument item = new GedDocument();
	GedFolder folder = GedFolder.getGedFolder(Integer.parseInt(request.getParameter("lIdGedFolder")));
	GedFolderType folderType = GedFolderType.getGedFolderType(folder.getIdGedFolderType());
	JSONObject jsonData =  new JSONObject();
	String sPageUseCaseId = "xxx";
	
	sTitle += "<span class=\"altColor\">Ajouter des documents</span>"; 
	item.setIdGedFolder(folder.getId());

	folderType = GedFolderType.getGedFolderType(folder.getIdGedFolderType());

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	String sURLForm = response.encodeURL(rootPath+"desk/ged/folder/displayFolder.jsp?lId=" + folder.getId());
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocument.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentContentType.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategory.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategorySelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/gedCategoryComponent.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/swfupload/swfupload_handlers.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/swfobject.js"></script>
</head>
<body>
<script type="text/javascript">
var jsonGedDocumentContentType = <%=GedDocumentContentType.getJSONArray()%>;
var jsonData = <%= jsonData %>;
var suComponent;
var sUploadURL = "<%= response.encodeURL(rootPath + "desk/ged/document/uploadDocument.jsp") %>";
mt.config.enableAutoLoading = false;

function getFileExtension(sFilename){
	var r = new RegExp("\.([^\.]*$)", "gi");
	var aR = sFilename.match(r);
	if (aR.length==0) return "";
	return (aR[aR.length-1]).toLowerCase();  
}

function getGoodExtensionsFromDocType(iId){
    for (var i=0;i<jsonGedDocumentContentType.length;i++){
		if (iId==jsonGedDocumentContentType[i].lId){
			if (jsonGedDocumentContentType[i].sExtensions.length==0) return [];
			return jsonGedDocumentContentType[i].sExtensions.split(" ");		
		}
	}
	return [];
}
function isGoodExtension(sFilename){
    var sExt = getFileExtension(sFilename);
    var arrExt = getGoodExtensionsFromDocType($("lIdGedDocumentContentType").value);
    for (var j=0;j<arrExt.length;j++){
        if (sExt=="."+arrExt[j]) return true;
    }
    return false;
}
function getFileTypeFromContentType(iId){
	var arrExt = getGoodExtensionsFromDocType(iId);
    for (var j=0;j<arrExt.length;j++){
        arrExt[j] = "*."+arrExt[j];
    }
    return arrExt.join(";");
}
function paramSuComponent(){
	var docType = jsonGedDocumentContentType.find(function(type){return (type.lId==$("lIdGedDocumentContentType").value);});
    suComponent.setFileTypes(getFileTypeFromContentType($("lIdGedDocumentContentType").value), docType.sLabel+" ("+getFileTypeFromContentType($("lIdGedDocumentContentType").value)+")");
    FeaturesUpload.deleteAll();
}

function initSWFUpload(){
	var docType = jsonGedDocumentContentType.find(function(type){return (type.lId==$("lIdGedDocumentContentType").value);});
    // Instantiate a SWFUpload Instance
    suComponent = new SWFUpload({
        // Backend Settings
        upload_url: sUploadURL, // I can pass query strings here if I want
        use_query_string : false,
        post_params: { "bDisplayHTML": "false"},    // Here are some POST values to send. These can be changed dynamically
        file_post_name: "document",    // This is the "name" of the file item that the server-side script will receive. Setting this doesn't work in the Linux Flash Player
        requeue_on_error: false,

        // File Upload Settings
        file_size_limit : "10 MB",
        file_types : getFileTypeFromContentType($("lIdGedDocumentContentType").value),
        file_types_description : docType.sLabel,
        file_upload_limit : "30",

        // Event Handler Settings
        swfupload_loaded_handler : FeaturesUpload.swfUploadLoaded,
        file_dialog_start_handler : FeaturesUpload.fileDialogStart,
        file_queued_handler : addFile,
        file_queue_error_handler : FeaturesUpload.fileQueueError,
        file_dialog_complete_handler : FeaturesUpload.fileDialogComplete,
        upload_start_handler : FeaturesUpload.uploadStart,
        upload_progress_handler : FeaturesUpload.uploadProgress,
        upload_error_handler : FeaturesUpload.uploadError,
        upload_success_handler : FeaturesUpload.uploadSuccess,
        
        upload_complete_handler : uploadComplete,
        debug_handler : FeaturesUpload.debug,
        
        // Flash Settings
        flash_url : "<%= rootPath+"include/js/swfupload/swfupload_f9.swf" %>", // Relative to this file

        // Debug Settings
        debug: <%= Configuration.getConfigurationValueMemory("debug.session").equalsIgnoreCase("enable") %> // For the purposes of this demo I wan't debug info shown
    });
    paramSuComponent();
    FeaturesUpload.init("FeaturesUploadDiv",
                        "<%= rootPath+"images/icons/cross.gif" %>",
                        "<%= rootPath+"images/icons/arrow_right.gif" %>",
                        "<%= rootPath+"images/icons/accept.gif" %>",
                        "<%= rootPath+"images/icons/exclamation.gif" %>");
    $("btnBrowse").onclick = function(){
        suComponent.selectFiles();
        this.blur();
    }
}
function storeCategory(lIdDocument){
	// Adding Categories :
	var cat = new Object();
	try{cat.lIdTypeObject = <%= ObjectType.GED_DOCUMENT %>;}catch(e){}
    try{cat.lIdReferenceObject = lIdDocument;}catch(e){}
    try{cat.sCategoryList = ged_categories.getSelectionsToString();}catch(e){}
         	
    GedCategorySelection.storeMultiFromJSONString(Object.toJSON(cat), function(lReturn){
		if (lReturn<0){
           		alert("un problème est survenu lors de l'enregistrement des catégories");
         	}
    });
}
function storeAndUpload(){
    var iIndex = FeaturesUpload.iCurrentIndex;
    if (iIndex<FeaturesUpload.arrFile.length){
        if (iIndex == 0) FeaturesUpload.displayStartedUpload();
        FeaturesUpload.displayMessageInItem(iIndex, "Création...");
        var sPrefix = "doc_"+FeaturesUpload.arrFile[iIndex].id+"_";
        var doc = new Object();
        try{doc.lIdGedFolder = $("lIdGedFolder").value;}catch(e){}
        try{doc.lIdGedDocumentContentType = $("lIdGedDocumentContentType").value;}catch(e){}
        try{doc.sName = $(sPrefix+"sName").value;}catch(e){}
        try{doc.sDescription = $(sPrefix+"sDescription").value;}catch(e){}
        try{doc.sReference = $(sPrefix+"sReference").value;}catch(e){}
        
        GedDocument.storeFromJSONString(Object.toJSON(doc), function(lId){
            if (lId>0) {
            	var sUrlUpload = sUploadURL+"?lId="+lId;
	        	FeaturesUpload.SU.setUploadURL(sUrlUpload);
	        	FeaturesUpload.uploadStart();
	        	FeaturesUpload.SU.startUpload(FeaturesUpload.arrFile[iIndex].id);
	        	storeCategory(lId);
            } else {
                alert("un problème est survenu lors de l'enregistrement du document");
            }
        });
    }else{
        location.href = "<%=sURLForm%>";
    }
}
function addFile(file){
    FeaturesUpload.addFile(file);
    var sFileId = file.id;
    var divFile = $("item_"+sFileId);
    var sPrefix = "doc_"+sFileId+"_";
    
    var divClear = document.createElement("div");
    divClear.style.clear = "both";
    divFile.appendChild(divClear);
    
    var docType = jsonGedDocumentContentType.find(function(type){return (type.lId==$("lIdGedDocumentContentType").value);});
    
    var divForm = document.createElement("div");
    divForm.innerHTML = '<table class=\"formLayout\" cellspacing=\"3\">'+
    '<tr><td class="pave_cellule_gauche">Type de document :</td>'+
       '<td class="pave_cellule_droite">'+docType.sLabel+
           '<input type="hidden" name="'+sPrefix+'lIdGedDocumentContentType" id="'+sPrefix+'lIdGedDocumentContentType" value="'+docType.lId+'"'+
    '</td></tr>'+
	'<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Reference :", "temp_sReference", item.getReference(),"size=\"100\"")) %>'+
	'<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Name :", "temp_sName", item.getName(),"size=\"100\"")) %>'+
	'<tr><td class="pave_cellule_gauche">Description :</td>'+
       '<td class="pave_cellule_droite">'+
           '<textarea cols="97" rows="5" name="'+sPrefix+'sDescription" id="'+sPrefix+'sDescription"><%= item.getDescription() %></textarea>'+
    '</td></tr>'+
    '<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Légende :", "sLegende", "","size=\"100\"")) %>'+
    '<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Date :", "sDate", "","size=\"100\"")) %>'+
    '<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Légende :", "sLegende", "","size=\"100\"")) %>'+
    '<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Titre :", "sTitre", "","size=\"100\"")) %>'+
    '<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Mots clés :", "sMotCle", "","size=\"100\"")) %>'+
    '<%= Outils.getStringForJavascriptFonction(pave.getHtmlTrInput("Crédit :", "sCredit", "","size=\"100\"")) %>'+
	'</table>';

    divFile.appendChild(divForm);
    
    $("temp_sReference").id = $("temp_sReference").name = sPrefix+"sReference";
    $("temp_sName").id = $("temp_sName").name = sPrefix+"sName";

    $(sPrefix+"sName").value = file.name;
    //$(sPrefix+"sName").disabled = true;
}
function uploadComplete(){
    FeaturesUpload.uploadComplete();
    $("item_"+FeaturesUpload.arrFile[FeaturesUpload.iCurrentIndex].id).style.backgroundColor = "#6FC764";
    FeaturesUpload.iCurrentIndex++;
    storeAndUpload();
}
var ged_categories;
function populate(){
	$('lIdGedDocumentContentType').populate(jsonGedDocumentContentType, jsonData.lIdGedDocumentContentType, "lId", "sLabel");
	$('lIdGedDocumentContentType').onchange = paramSuComponent;
	ged_categories = new gedCategoryComponent('gedCategoryCpt', <%=GedCategory.getJSONArrayFromParent(0)%>);
	var dataset = [];
	if (jsonData.gedCategories) {
		jsonData.gedCategories.each(function(item){dataset.push(item.GedCategory);});
	}
	ged_categories.populate(dataset || []);
}
onPageLoad = function() {

	populate();
    checkFlashVersion('<%= Configuration.getConfigurationValueMemory("plugin.flash.version","9.0.124") %>', 
                      '<%= Configuration.getConfigurationValueMemory("plugin.flash.link","http://www.adobe.com/go/BPCKN") %>',
                      $("checkFlashVersion"),
                      $("fiche"));


    /*before controls*/
    $('formDocument').isValid = function() {
		var bValid = true;
		
		if (FeaturesUpload.arrFile.length<1){
			mt.utils.displayFormFieldMsg($("btnBrowse"), "Vous devez sélectionner au moins un fichier à envoyer.");
			bValid = false;
		}
		return bValid;
	}
	/*if controls are valid*/
    $('formDocument').ajaxBeforeControl = function() {    
        $('btnBrowse').disabled = true;
        $('submit_btn').disabled = true;
        $('submit_btn').innerHTML = "Chargement en cours...";
        
        storeAndUpload();
    }
    
    /*if controls are not valid*/
    $("formDocument").onIncompleteSubmit = function(){
        return false;
    }
    
    initSWFUpload();
}



function removeItem()
{
    if(confirm("Do you want to delete this Ged document ?")){
         GedDocument.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllFolderType.jsp") %>';
           });
     }
}
</script>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form name="form" id="formDocument" method="post" action="" class="validate-fields">
<table style="width: 800px;">
	<tr>
		<td style="width:150px;">
		<div style="padding: 2px; text-align: center;">
			<img src="<%= rootPath %>images/icons/64x64/folder_full_purple.png" alt="" style="padding: 2px; display: block; margin-right: auto; margin-left: auto;"/>
			<%= folder.getName() %>
		</div>
		</td>
		<td style="width:650px;">
	 		<table class="formLayout" cellspacing="3">
				<tr>
					<td class="pave_cellule_gauche">Type :</td>
					<td class="pave_cellule_droite">
						<%= folderType.getName() %>
					</td>
				</tr>
				<tr>
					<td class="pave_cellule_gauche">Référence :</td>
					<td class="pave_cellule_droite">
						<%= folder.getReference() %>
					</td>
				</tr>
				<tr>
					<td class="pave_cellule_gauche" style="width: 550px;">Description :</td>
					<td class="pave_cellule_droite"><%= 
							folder.getDescription() %></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<div id="checkFlashVersion" style="display: none;"></div>
<div id="fiche">
        <input type="hidden" name="lId" id="lId" value="<%= item.getId() %>" />
		<input type="hidden" name="lIdGedFolder" id="lIdGedFolder" value="<%= folder.getId() %>" />
		<input type="hidden" name="category_selection" id="category_selection" />
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Catégories :</td>
				<td class="pave_cellule_droite" id="gedCategoryCpt"></td>
			</tr>
			<tr>
			    <td class="pave_cellule_gauche">Type de document </td>
			    <td class="pave_cellule_droite">
			   		<select name="lIdGedDocumentContentType" id="lIdGedDocumentContentType"></select>
			    </td>
			  </tr>
			<tr>
			    <td class="pave_cellule_gauche">Fichiers * </td>
			    <td class="pave_cellule_droite">
			     <button id="btnBrowse" type="button" style=""><img src="<%= rootPath %>images/icons/32x32/document_add.png" style="padding-right: 3px; vertical-align: bottom;">Ajouter un fichier</button>
			     <div id="FeaturesUploadDiv" />
			    </td>
			  </tr>
		</table>



</div>
<div id="fiche_footer">

	<button type="submit" id="submit_btn">Valider</button>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("../folder/displayFolder.jsp?lId=" + item.getIdGedFolder()) %>');" >
			Annuler</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ged.GedCategory"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
</html>
<%

	ConnectionManager.closeConnection(conn);

%>