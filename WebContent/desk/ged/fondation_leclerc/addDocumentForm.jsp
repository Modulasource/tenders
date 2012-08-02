<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ged.GedDomain"%>
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


GedDocumentFondationLeclerc item = null;
JSONObject jsonData =  null;
long lId = HttpUtil.parseLong("lId", request, 0);

if (item==null){
	item = new GedDocumentFondationLeclerc();
	jsonData = new JSONObject();
}
HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
pave.bIsForm = true;

String sPageUseCaseId = "IHM-DESK-FONDATION-LECLERC-GERER-DOCUMENTS";

sTitle += "<span class=\"altColor\">Ajouter un document</span>"; 
sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

long lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request, 0);
long lIdReferenceObject = HttpUtil.parseLong("lIdReferenceObject", request, 0);
boolean bModeSelection = (lIdReferenceObject>0 && lIdTypeObject>0);
String sURLForm = response.encodeURL(rootPath+"desk/ged/fondation_leclerc/displayAllDocument.jsp?lId=" + GedFolder.ID_GED_FOLDER_FONDATION_LECLERC+"&lIdTypeObject="+lIdTypeObject+"&lIdReferenceObject="+lIdReferenceObject);
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentFondationLeclerc.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentContentType.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategory.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategorySelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentSelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentAttribute.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/gedCategoryComponent.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/gedAttributeComponent.js"></script>
</head>
<body>
<script type="text/javascript">
var bModeSelection = <%= bModeSelection %>;
var lIdTypeObject = <%= lIdTypeObject %>;
var lIdReferenceObject = <%= lIdReferenceObject %>;
var jsonGedDocumentContentType = <%=GedDocumentContentType.getJSONArray()%>;
var jsonGedDocumentAttributeType = <%=GedDocumentAttributeType.getJSONArray()%>;
var jsonData = <%= jsonData %>;
var suComponent;
var sUploadURL = "<%= response.encodeURL(rootPath + "desk/ged/fondation_leclerc/uploadDocument.jsp") %>";
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
           		alert("un problème est survenu lors de l'enregistrement des catégories");
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
           		alert("un problème est survenu lors de l'enregistrement des attributs");
         }else{
         	if(bModeSelection){
         		var oElt = {};
	 			oElt.lIdGedDocument = $("lId").value;
	 			oElt.lIdTypeObject = lIdTypeObject;
				oElt.lIdReferenceObject = lIdReferenceObject;
	   			GedDocumentSelection.storeFromJSONString(Object.toJSON(oElt), function(bSuccess){
					if (bSuccess) {
						uploadFile();
					} else {
						alert("Un problème est survenu lors de l'ajout");
					}
				});
         	}else{
         		uploadFile();
         	}
         }
    });
}
function onUploadDone(iCode, sMessage) {
	Element.hide('photo_loading');
	if (iCode==1) {
		closeGlobalLoader();
		if (confirm("Document correctement envoyé.\nAjouter un nouveau document ?")){
			location.href = "<%= response.encodeURL("addDocumentForm.jsp") %>?lIdTypeObject="+lIdTypeObject+"&lIdReferenceObject="+lIdReferenceObject;
		}else{
			location.href = '<%= response.encodeURL("modifyDocumentForm.jsp?bButtonAdd=true&lId=") %>'+$("lId").value+"&lIdTypeObject="+lIdTypeObject+"&lIdReferenceObject="+lIdReferenceObject;;
		}
	} else {
		closeGlobalLoader();
		alert(sMessage);
		Element.hide('photo_loading');
 		//Element.show('zonePhoto');
	}
	$('upload_form').getElementsByTagName("input")[0].value = "";
}
function uploadFile(){
	if (!bModeSelection) openGlobalLoader();
	$('upload_form').action = "<%=response.encodeRedirectURL("uploadDocument.jsp?sAction=modify&lId=")%>"+$("lId").value;
	$('upload_form').submit();
	Element.show('photo_loading');
	//$('photo').innerHTML = "";
}
function checkDuplicateOption(){
$("duplicateToJPG").checked="";
$("duplicateSpan").style.visibility = "hidden";
return;
	if ($("lIdGedDocumentContentType").value=="<%= GedDocumentContentType.TYPE_IMAGE_PHOTO %>"){
		$("duplicateSpan").style.visibility = "visible";
		var sFileName = $('upload_form').getElementsByTagName("input")[0].value;
		if (getFileExtension(sFileName)==".tif" || getFileExtension(sFileName)==".tiff"){
			$("duplicateToJPG").disabled=false;
			$("duplicateToJPG").checked="checked";
		}else{
			$("duplicateToJPG").disabled=true;
			$("duplicateToJPG").checked="";
		}
	}else{
		$("duplicateSpan").style.visibility = "hidden";
		$("duplicateToJPG").checked="";
	}
}
var ged_categories;
var ged_attributes;
function populate(){
	$('lIdGedDocumentContentType').populate(jsonGedDocumentContentType, "", "lId", "sLabel");
	ged_attributes = new gedAttributeComponent("gedAttributeCpt", jsonGedDocumentAttributeType);
	var dataset = [];
	jsonGedDocumentAttributeType.each(function(item){
		dataset.push({"lIdGedDocumentAttributeType":item.lId,"sName":item.sName,"sValue":""});
	});
	ged_attributes.populate(dataset || []);
	ged_categories = new gedCategoryComponent('gedCategoryCpt', <%=GedCategory.getJSONArrayFromParent(0)%>);

	$("sName").value="";
	$("sReference").value="";
	$("sDescription").value="";
}
onPageLoad = function() {
	checkDuplicateOption();
	populate();
    /*before controls*/
    $('formDocument').isValid = function() {
		var bValid = true;
		if ($('upload_form').getElementsByTagName("input")[0].value.isNull()){
			//mt.utils.displayFormFieldMsg($("document"), "Vous devez sélectionner un fichier à envoyer.");
			alert("Vous devez sélectionner un fichier à envoyer.");
			bValid = false;
		}
		return bValid;
	}

    /*if controls are valid*/
    $("formDocument").onValidSubmit = function(){
        $('submit_btn').disabled = true;
        $('submit_btn').innerHTML = "Chargement en cours...";  
    	var doc = new Object();
        try{doc.sName = $("sName").value;}catch(e){}
        try{doc.sDescription = $("sDescription").value;}catch(e){}
        try{doc.sReference = $("sReference").value;}catch(e){}
        try{doc.lIdGedDocumentContentType = $("lIdGedDocumentContentType").value;}catch(e){}
        try{doc.lIdGedFolder = <%= GedFolder.ID_GED_FOLDER_FONDATION_LECLERC %>;}catch(e){}
        try{doc.lIdGedDocumentType = <%= GedConstant.GED_DOCUMENT_FOND_LECLERC_DOCUMENT_ORIGINAL %>;}catch(e){}
        if (doc.lIdGedDocumentContentType==<%= GedDocumentContentType.TYPE_VIDEO_FLV %>){
        	doc.bOnHardDrive = <%= !Configuration.getConfigurationValueMemory("ged.pathOnHardDrive", "").equals("") %>;        	
        }else{
        	doc.bOnHardDrive = false;
        }
                
        GedDocumentFondationLeclerc.storeFromJSONString(Object.toJSON(doc), function(lId){
            if (lId>0) {
            	$("lId").value = lId;
	        	storeCategory(lId);
            } else {
                alert("un problème est survenu lors de l'enregistrement du document");
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
				var sGoodExtensions = getGoodExtensionsFromDocType($("lIdGedDocumentContentType").value).join(" ou ");				
				alert("Seuls les fichiers de type "+sGoodExtensions+" sont autorisés.");
				$('upload_form').getElementsByTagName("input")[0].value = "";
				bValid = false;
			}
		}
		checkDuplicateOption();
	}
	$("lIdGedDocumentContentType").onchange = function(){
		checkDuplicateOption();
		$('upload_form').getElementsByTagName("input")[0].value = "";
	}
}

</script>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form id="upload_form" action="<%=response.encodeRedirectURL("uploadDocument.jsp?sAction=modify&lId=")%>" method="post" enctype="multipart/form-data" target="uploadTarget">
<div id="fiche">
	<table class="formLayout" style="margin-left: 100px;">
			<tr>
				<td>
					<span style="font-weight: bold;">Type de document : </span>
			   		<select name="lIdGedDocumentContentType" id="lIdGedDocumentContentType"></select>
					<div id="photo_loading" style="display:none;">
    					Patientez SVP... Le fichier est en cours d'envoi. Cette opération peut prendre plusieurs minutes.
    				</div><br />
    				<span style="font-weight: bold;">Fichier : </span>
					<input name="document" id="document" type="file" style="width: 30px;" />
					<div id="duplicateSpan">
						<input name="duplicateToJPG" id="duplicateToJPG" type="checkbox" checked="checked" />
						<label for="duplicateToJPG">Créer une copie de cette image en JPEG</label>
					</div>
				</td>
			</tr>
	</table>
</div>
</form>
<iframe class="hide" align="top" style="padding:0;margin:0;width:1px;height:1px" name="uploadTarget" frameborder="0" src=""></iframe>
<form name="formDocument" id="formDocument" method="post" action="" class="validate-fields">
<div id="fiche">
		<input type="hidden" name="lId" id="lId" />
		<table style="margin-left: 10px;">
		<tr>
			<td style="vertical-align: top;">
			<table class="formLayout" >
				<tr>
					<td>
						<div style="font-weight: bold;">Nom du fichier : </div>
						<input type="text" id="sName" name="sName" class="dataType-notNull" style="width: 350px;"/>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Référence : </div>
						<input type="text" id="sReference" name="sReference" style="width: 350px;" />
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Descriptif : </div>
						<textarea id="sDescription" name="sDescription" style="width: 350px;height: 150px;"></textarea>
					</td>
				</tr>
			</table>
			</td>
			<td style="vertical-align: top;">
			<table class="formLayout" >
				<tr>
					<td>
						<div style="font-weight: bold;">Attributs : </div>
						<div id="gedAttributeCpt"></div>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Catégories : </div>
						<div id="gedCategoryCpt"></div>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</div>
<div id="fiche_footer">

	<button type="submit" id="submit_btn">Valider</button>
	<button type="button" onclick="javascript:doUrl('<%=
		sURLForm %>');" >
			Annuler</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ged.GedCategory"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocumentAttributeType"%>
<%@page import="org.coin.bean.ged.GedDocumentAttribute"%>
<%@page import="org.coin.bean.ged.GedDocumentSelection"%>
<%@page import="mt.fondationleclerc.GedDocumentFondationLeclerc"%>
<%@page import="mt.fondationleclerc.GedConstant"%>
</html>
<%

	ConnectionManager.closeConnection(conn);

%>