<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentContentType"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.InputStreamDownloader"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.coin.util.Outils"%>
<% 
	/**
	 * Localization
	 */
	Localize locButton = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_BUTTON);
	Localize locTitle = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TITLE);
	Localize locMessage = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_MESSAGE);
	
	String sTitle = locTitle.getValue (38, "Ajouter un document"); 
	Connection conn = ConnectionManager.getConnection();
	
	
	
	GedDocument item = null;
	JSONObject jsonData =  null;
	boolean bModalMode = HttpUtil.parseBoolean("bModalMode", request, false);
	long lId = HttpUtil.parseLong("lId", request, 0);
	
	if (item==null){
		item = new GedDocument();
		item.setAbstractBeanLocalization (sessionLanguage);
		jsonData = new JSONObject();
	}
	GedFolder folder = GedFolder.getGedFolder(Integer.parseInt(request.getParameter("lIdGedFolder")));
	folder.setAbstractBeanLocalization(sessionLanguage);
	GedFolderType folderType = GedFolderType.getGedFolderType(folder.getIdGedFolderType());
	folderType.setAbstractBeanLocalization(sessionLanguage);
	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	
	String sPageUseCaseId = "xxx";
	
	sTitle += "<span class=\"altColor\">" + locTitle.getValue (38, "Ajouter un document") + "</span>"; 
	//sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	String sURLForm = response.encodeURL(rootPath+"desk/ged/folder/displayFolder.jsp?bRefreshEngineGED=true&lId=" + folder.getId());
	
	request.setAttribute("rootPath",rootPath);
	request.setAttribute("folder",folder);
	request.setAttribute("locTitle", locTitle);
	request.setAttribute("locButton", locButton);
	request.setAttribute("locMessage", locMessage);
	request.setAttribute("localizeButton", localizeButton);
%>
<jsp:include page="/include/js/localization/localizationGEC.jsp" flush="false">
	<jsp:param name="lIdLanguage" value="<%= sessionLanguage.getId() %>" />
</jsp:include>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedFolder.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocument.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentContentType.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategory.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategorySelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentAttribute.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/gedCategoryComponent/gedCategoryComponent.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/gedAttributeComponent.js"></script>
<script type="text/javascript">
var jsonGedDocumentContentType = <%=GedDocumentContentType.getJSONArray (sessionLanguage)%>;
var jsonGedDocumentAttributeType = <%=GedDocumentAttributeType.getJSONArray()%>;
var jsonData = <%= jsonData %>;
var bModalMode = <%= bModalMode %>;
var suComponent;
var sUploadURL = "<%= response.encodeURL(rootPath + "desk/ged/document/uploadDocument.jsp") %>";
var bChangeFilename = false;
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
function storeCategory(lIdDocument){
	// Adding Categories :
	var cat = new Object();
	try{cat.lIdTypeObject = <%= ObjectType.GED_DOCUMENT %>;}catch(e){}
    try{cat.lIdReferenceObject = lIdDocument;}catch(e){}
    try{cat.sCategoryList = ged_categories.getSelectionsToString();}catch(e){}
         	
    GedCategorySelection.storeMultiFromJSONString(Object.toJSON(cat), function(lReturn){
		if (lReturn<0){
           		alert("<%=locMessage.getValue (28, "Un problème est survenu lors de l'enregistrement des catégories.")%>");
         }else{
         	storeAttribute(lIdDocument);
         }
    });
}

function storeAttribute(lIdDocument){
	// Adding Attributes :
	var obj = new Object();
    try{obj.lIdGedDocument = lIdDocument;}catch(e){}
    try{obj.arrList = ged_attributes.getSelections();}catch(e){}
         	
    GedDocumentAttribute.storeMultiFromJSONString(Object.toJSON(obj), function(lReturn){
		if (lReturn<0){
           		alert("<%=locMessage.getValue (29, "Un problème est survenu lors de l'enregistrement des attributs.")%>");
         }else{
         	uploadFile();
         }
    });
}

function closeModal(){
	try{parent.g_modal.close();
	}catch(e){
		try{parent.Control.Modal.close();
		}catch(e){}
	}
}

function onUploadDone(iCode, sMessage) {
	if (!bModalMode) closeGlobalLoader();
	Element.hide('photo_loading');
	if (iCode==1) {
		if (bModalMode) closeModal();
		else location.href = '<%= sURLForm %>';
	} else {
		alert(sMessage);
		Element.hide('photo_loading');
 		//Element.show('zonePhoto');
	}
	$('upload_form').getElementsByTagName("input")[0].value = "";
}
function uploadFile(){
	if (!bModalMode) openGlobalLoader();
	$('upload_form').action = "<%=response.encodeRedirectURL("uploadDocument.jsp?sAction=modify&lId=")%>"+$("lId").value;
	$('upload_form').submit();
	Element.show('photo_loading');
	//$('photo').innerHTML = "";
}
var ged_categories;
var ged_attributes;
function populate(){
	$('lIdGedDocumentContentType').populate(jsonGedDocumentContentType, "", "lId", "sLabel");
	//ged_attributes = new gedAttributeComponent("gedAttributeCpt", jsonGedDocumentAttributeType);
	ged_categories = new gedCategoryComponent('gedCategoryCpt',
		<%=GedCategory.getJSONArrayFromParent(0, sessionLanguage)%>,
		<%=sessionLanguage.getId ()%>);

	$("sName").value="";
	$("sReference").value="";
	$("sDescription").value="";
	if (bModalMode){
		$('ButCancel').onclick=function(){
			closeModal();
		}
	}else{
		doUrl('<%=response.encodeURL("displayAllDocument.jsp") %>'); 
	}
}
onPageLoad = function() {
	populate();
	$("sName").onkeypress = function(){bChangeFilename=true;};
		
    /*before controls*/
    $('formDocument').isValid = function() {
		var bValid = true;
		if ($('upload_form').getElementsByTagName("input")[0].value.isNull()){
			//mt.utils.displayFormFieldMsg($("document"), "<%=locMessage.getValue (26, "Vous devez sélectionner un fichier à envoyer.")%>");
			alert("<%=locMessage.getValue (26, "Vous devez sélectionner un fichier à envoyer.")%>");
			bValid = false;
		}
		return bValid;
	}

    /*if controls are valid*/
    $("formDocument").onValidSubmit = function(){
        $('submit_btn').disabled = true;
        $('ButCancel').disabled = true;
        $('submit_btn').innerHTML = "<%=locMessage.getValue (3, "Chargement en cours...")%>";  
    	var doc = new Object();
        try{doc.sName = $("sName").value;}catch(e){}
        try{doc.sDescription = $("sDescription").value;}catch(e){}
        try{doc.sReference = $("sReference").value;}catch(e){}
        try{doc.lIdGedDocumentContentType = $("lIdGedDocumentContentType").value;}catch(e){}
        try{doc.lIdGedFolder = <%= folder.getId() %>;}catch(e){}
        
        GedDocument.storeFromJSONString(Object.toJSON(doc), function(lId){
            if (lId>0) {
            	$("lId").value = lId;
	        	storeCategory(lId);
            } else {
                alert("<%=locMessage.getValue (27, "Un problème est survenu lors de l'enregistrement du document.")%>");
            }
        });
    	return false;
    }
    /*if controls are not valid*/
   
    $("formDocument").onIncompleteSubmit = function(){
        return false;
    }
	$('upload_form').getElementsByTagName("input")[0].value = "";
	$('upload_form').getElementsByTagName("input")[0].onchange = function() {
		var sFileName = $('upload_form').getElementsByTagName("input")[0].value;
		var bValid = true;
		if (!sFileName.isNull()){
			if (!isGoodExtension(sFileName)){
				var sGoodExtensions = getGoodExtensionsFromDocType($("lIdGedDocumentContentType").value).join(" <%=locMessage.getValue (30, "ou")%> ");				
				alert("<%=locMessage.getValue (24, "Seuls les fichiers de type")%> "+sGoodExtensions+" <%=locMessage.getValue (25, "sont autorisés.")%>");
				$('upload_form').getElementsByTagName("input")[0].value = "";
				bValid = false;
			}else{
				if ($("sName").value.isNull()) bChangeFilename = false; 
				if (!bChangeFilename){
					//var arr = sFileName.match(new RegExp("[\\\|\\/]([^\\\|^\\/]*$)", "gi"));
					$("sName").value = sFileName;  
				}
			}
		}
	}
	$("lIdGedDocumentContentType").onchange = function(){
		$('upload_form').getElementsByTagName("input")[0].value = "";
	}
}

</script>
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
.ContextButton{
	border:none;
	border-right:1px solid #CCCCCC;
	height:20px;
	background-color: transparent;
	text-align: left;
	font-size: 10px;
	vertical-align:middle;
	cursor:pointer;
	margin-top:1px;
	margin-left: 1px;
}
.ContextButton:HOVER{
	background-color: #EEEEEE;
	/*border: #EEEEEE 1px inset;
	margin-top:0;
	margin-left:0;*/
}
.ContextButton:HOVER img{
	vertical-align:middle;
	/*margin-top:0;
	margin-left:0;*/
}
.ContextButton:ACTIVE{
	background-color: #FFFFFF;
}
.ContextButton img{
	vertical-align:middle;
	position: relative;
}
</style>
</head>
<body style="background-color: #FFFFFF;">
<span id="pageTitle" style="display:none"><%=sTitle%></span>
<div class="ficheTablePadding">
<div style="background-color:#FFF;padding:0px 10px 0 10px">
<% Border bordGedFolder = new Border("cdc0c7", 5, 100, "tr", request);%>
<% if (!bModalMode){ %>
<%=bordGedFolder.getHTMLTop()%>
<jsp:include page="/desk/ged/folder/include/headerFolder.jsp"></jsp:include>
<% } %>

<div style="padding:10px 5px 0 5px">
<%
Border bordForm = new Border("eeeeee", 5, 100, "tblr", request);
if (!bModalMode) 
	out.println(bordForm.getHTMLTop());
%>
<form id="upload_form" action="<%=response.encodeRedirectURL("uploadDocument.jsp?sAction=modify&lId=")%>" method="post" enctype="multipart/form-data" target="uploadTarget">
<div id="fiche">
	<table class="formLayout" style="margin-left: 100px;">
			<tr>
				<td>
					<span style="font-weight: bold;"><%=locTitle.getValue (35, "Nature du document")%> : </span>
			   		<select name="lIdGedDocumentContentType" id="lIdGedDocumentContentType"></select>
					<div id="photo_loading" style="display:none;">
    					Patientez SVP... Le fichier est en cours d'envoi. Cette opération peut prendre plusieurs minutes.
    				</div><br />
    				<span style="font-weight: bold;"><%=locTitle.getValue (34, "Fichier")%> : </span>
					<input name="document" id="document" type="file" style="" />
				</td>
			</tr>
	</table>
</div>
</form>
<iframe class="hide" align="top" style="padding:0;margin:0;width:1px;height:1px" name="uploadTarget" frameborder="0" src=""></iframe>
<form name="formDocument" id="formDocument" method="post" action="" class="validate-fields">
<input type="hidden" name="lId" id="lId" />
<div id="fiche">
		<table class="formLayout" style="margin-left: 100px;">
			<tr>
				<td>
					<div style="font-weight: bold;"><%=locTitle.getValue (37, "Nom du fichier") %> : </div>
					<input type="text" id="sName" name="sName" style="width: 350px;"/>
				</td>
			</tr>
			<tr>
				<td>
					<div style="font-weight: bold;"><%=item.getReferenceLabel()%> : </div>
					<input type="text" id="sReference" name="sReference" style="width: 200px;" />
				</td>
			</tr>
			<tr>
				<td>
					<div style="font-weight: bold;"><%=locTitle.getValue (36, "Catégories") %> : </div>
					<div id="gedCategoryCpt"></div>
				</td>
			</tr>
			
			<tr>
				<td>
					<div style="font-weight: bold;"><%=item.getDescriptionLabel()%> : </div>
					<textarea id="sDescription" name="sDescription" style="width: 350px;height: 125px;"></textarea>
				</td>
			</tr>
			<tr style="display:none;">
				<td>
					<div style="font-weight: bold;"><%=locTitle.getValue (43, "Attributs")%> : </div>
					<div id="gedAttributeCpt"></div>
				</td>
			</tr>
		</table>



</div>
<div id="" style="text-align: center;">

	<button type="submit" id="submit_btn"><%=localizeButton.getValueSubmit ()%></button>
	<button type="button" id="ButCancel"><%=localizeButton.getValueCancel ()%></button>
</div>

</form>
<% if (!bModalMode) out.println(bordForm.getHTMLBottom()); %>
</div>
<% if (!bModalMode) out.println(bordGedFolder.getHTMLBottom()); %>
</div>
</body>
<%@page import="org.coin.bean.ged.GedCategory"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocumentAttributeType"%>
<%@page import="org.coin.bean.ged.GedDocumentAttribute"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>

<%@page import="org.coin.ui.Border"%></html>
<%

	ConnectionManager.closeConnection(conn);

%>