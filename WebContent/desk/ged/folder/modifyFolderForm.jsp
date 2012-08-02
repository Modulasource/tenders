<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%
	/**
	 * Localization
	 */
	Localize locTitle = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_TITLE);
	Localize locMessage = new Localize (sessionLanguage.getId (), LocalizationConstant.CAPTION_CATEGORY_GEC_PAGE_MESSAGE);

	Connection conn = ConnectionManager.getConnection();
	String sTitle = locTitle.getValue (14, "Classeur");
	String sWebsitePublicationWord = locTitle.getValue (14, "Classeur").toLowerCase();
	boolean bKindFemaleElement = true;

	GedFolder item = null;
	JSONObject jsonData = null;
	String sPageUseCaseId = "XXX";
	
	long lId = HttpUtil.parseLong("lId", request, 0);
	long lIdGedFolderType = HttpUtil.parseLong("lIdGedFolderType", request, 0);
	long lIdGedFolderParent = HttpUtil.parseLong("lIdGedFolderParent", request, 0);
	boolean bModalMode = HttpUtil.parseBoolean("bModalMode", request, false);
	
	String sAction = HttpUtil.parseString("sAction", request, "create");
	
	int iIdPersonnePhysique = sessionUser.getIdIndividual();
	PersonnePhysique ppUser = new PersonnePhysique();
	try{ppUser = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);		
	}catch(Exception e){}
	
	
	
	if (lId>0){
		try{item = GedFolder.getGedFolder(lId);
			jsonData = item.toJSONObject();
			lIdGedFolderParent = item.getIdGedFolderParent();
		}catch(Exception e){e.printStackTrace();}
	}
	
	String sJsonService = "";
	if (item==null){
		item = new GedFolder();
		jsonData = new JSONObject();
		
		long lIdReferenceObjectOwnerParent = 0;
		// If subfolder then the service is the same as parent's folder
		if (lIdGedFolderParent>0){
			try{
				GedFolder parentFolder = GedFolder.getGedFolder(lIdGedFolderParent);
				if (parentFolder.getIdTypeObjectOwner()==ObjectType.ORGANISATION_SERVICE){
					lIdReferenceObjectOwnerParent = parentFolder.getIdReferenceObjectOwner();
				}
			}catch(Exception e){e.printStackTrace();};
		}
		Vector<OrganigramNode> vOrgaNode = new Vector<OrganigramNode>();
		try{vOrgaNode=OrganisationService.getAllOrganigramNodeFromIndividual(ppUser.getIdOrganisation(), ppUser.getId(), conn);
		}catch(Exception e){}
		
		for (int i=0;i<vOrgaNode.size();i++){
			JSONObject jsonNode = vOrgaNode.get(i).toJSONObject();
			OrganisationService orgService = OrganisationService.getOrganisationServiceFromIdOrganigramNode(vOrgaNode.get(i).getId(), ppUser.getIdOrganisation(), conn);
			orgService.setAbstractBeanLocalization(sessionLanguage);
			jsonNode.put("sServiceName", orgService.getName());
			jsonNode.put("iIdOrganisationService", orgService.getId());
			//vOrgaNode.get(i).getIdReferenceObject()
			if (lIdReferenceObjectOwnerParent>0){
				if(orgService.getId()==lIdReferenceObjectOwnerParent){
					sJsonService += jsonNode.toString();
				}
			}else{
				if (i>0) sJsonService += ",";
				sJsonService += jsonNode.toString();
			}
		}		
	}else{
		if (item.getIdTypeObjectOwner()==ObjectType.ORGANISATION_SERVICE){
			OrganisationService orgService = null;
			try{orgService=OrganisationService.getOrganisationService(item.getIdReferenceObjectOwner());
			}catch(Exception e){}
			if (orgService!=null){
				orgService.setAbstractBeanLocalization(sessionLanguage);
				JSONObject jsonNode = orgService.toJSONObject();
				jsonNode.put("sServiceName", orgService.getName());
				jsonNode.put("iIdOrganisationService", orgService.getId());
				sJsonService += jsonNode.toString();
			}
		}
	}
	
	item.setAbstractBeanLocalization(sessionLanguage);
	
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedFolder.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedFolderEntity.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategory.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedCategorySelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/gedCategoryComponent.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/js/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
</head>
<body>

<script type="text/javascript">
var jsonData = <%= jsonData %>;
var jsonState = <%= GedFolderState.getJSONArray() %>;
var jsonService = [<%= sJsonService %>];
var lIdGedFolderTypeDefault = <%= lIdGedFolderType %>;
var lIdGedFolderParent = <%= lIdGedFolderParent %>;
var bModalMode = <%= bModalMode %>;
var lIdTypeObjectOwner = <%= ObjectType.ORGANISATION_SERVICE %>;

var sOwner = "<%= ppUser.getPrenomNom() %>";
var lIdPersonnePhysique = <%= ppUser.getIdPersonnePhysique() %>;
var lIdTypeObjectPP = <%= ObjectType.PERSONNE_PHYSIQUE %>;
var lIdGedDocumentEntityType = <%= GedDocumentEntityType.TYPE_WRITER %>
tinyMCE.init({
		// General options
		language : '<%=sessionLanguage.getShortLabel().substring(0, 2)%>',
		mode : "none",
		theme : "advanced",
		plugins : "safari,pagebreak,style,preview,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,template",

		// Theme options
		theme_advanced_buttons1 : "bold,italic,underline,|,cut,copy,pastetext,pasteword,|,undo,redo,|,link,unlink,|,bullist,numlist,|",
		theme_advanced_buttons2 : "",
		theme_advanced_buttons3 : "",
		theme_advanced_buttons4 : "",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : true,
		
		setup : function(ed) {
			// Gets executed before DOM to HTML string serialization
			ed.onPreProcess.add(function(ed, o) {
				// State get is set when contents is extracted from editor
				/*
				if (o.get) {
					// Add span element to each strong/b element
					tinymce.each(ed.dom.select('strong,b', o.node), function(n) {
						n.appendChild(ed.dom.create('span', {style : 'border: 1px solid green'}, 'Content.'));
					});
				}*/
			});
			// Gets executed after DOM to HTML string serialization
			ed.onPostProcess.add(function(ed, o) {
				// State get is set when contents is extracted from editor
				/*
				if (o.get) {
					// Replace all strong/b elements with em elements
					o.content = o.content.replace(/<(strong|b)([^>]*)>/g, '');
					o.content = o.content.replace(/<\/(strong|b)>/g, '');
				}*/
			});
		},

		cleanup_on_startup : true,
		convert_urls : false,
    	relative_urls : true,
    	extended_valid_elements : "a[href],span[class|align|style]",
		paste_create_paragraphs : false,
		paste_create_linebreaks : false,
		paste_use_dialog : true,
		paste_auto_cleanup_on_paste : true,
		paste_convert_middot_lists : false,
		paste_unindented_list_class : "unindentedList",
		paste_convert_headers_to_strong : true,


		// Example content CSS (should be your site CSS)
		//content_css : "css/content.css",

		// Drop lists for link/image/media/template dialogs
		/*
		template_external_list_url : "lists/template_list.js",
		external_link_list_url : "lists/list_of_links.js",
		external_image_list_url : "lists/image_list.js",
		media_external_list_url : "lists/media_list.js",
		*/

		// Replace values for the template plugin
		template_replace_values : {
			username : "Some User",
			staffid : "991234"
		}
});
function formatToComponent(sDate){
	if (!sDate) return "";
	var aDate = sDate.substring(0, 10).split("-");
	return aDate[2]+"/"+aDate[1]+"/"+aDate[0]; 
}
var editor = tinyMCE.get('sDescription');

function removeItem(){
    if(confirm("<%=locMessage.getValue (6, "Supprimer ce classeur et tout ce qu'il contient ?")%>")){
		$('submit_btn').disabled = true;	
		$('submit_btn').innerHTML = "<%=locMessage.getValue (3, "Chargement en cours...")%>";
		$('ButRemove').disabled = true;
         GedFolder.removeFromId($("lId").value,function(bSuccess) { 
        	 if (bSuccess) {
				alert("ok");
 			} else {
 				alert("<%=locMessage.getValue (7, "un problème est survenu lors de la suppression")%>");
 			}
           });
     }
}
function initOwner(){
	var spanOwner = new Element("span");
	spanOwner.innerHTML = sOwner;
	$("owner").insert(spanOwner);
	// if a user is associated with many sercices then we display a select
	var labelService = new Element("label");
	if (jsonService.length>1){
		labelService.setAttribute("for", "lIdReferenceObjectOwner");
		labelService.innerHTML = " <%=locTitle.getValue (13, "pour le service")%> : ";
		$("owner").insert(labelService);
		
		var select =  new Element("select", {id:"lIdReferenceObjectOwner"});
		mt.html.setSuperCombo(select);
		select.populate(jsonService, "", "iIdOrganisationService", "sServiceName");
		$("owner").insert(select);
	}else if (jsonService.length==1){
		labelService.innerHTML = " <%=locTitle.getValue (13, "pour le service")%> "+jsonService[0].sServiceName;
		$("owner").insert(labelService);
		var hidden = new Element("input", {type:"hidden", id:"lIdReferenceObjectOwner", value:jsonService[0].iIdOrganisationService});
		$("owner").insert(hidden);
	}else{
		labelService.innerHTML = "Error : no owner was found";
		$("owner").insert(labelService);
	}
}
function updateDateClotured(){
	if ($('lIdGedFolderState').value==<%= GedFolderState.STATE_CLOSED %>){
		Element.show("SpanDateClotured");
	}else{
		Element.hide("SpanDateClotured");
	}
}
function populate(){
	if (!jsonData.lId){
		$('ButRemove').disabled = true;
		//$("lIdReferenceObjectOwner").value = lIdReferenceObjectOwner;
		$("lIdTypeObjectOwner").value = lIdTypeObjectOwner;
		//$('lIdGedFolderState').value = <%= GedFolderState.STATE_IN_PROCESS %>;
	}else{
		/*$('lIdGedFolderState').populate(jsonState, jsonData.lIdGedFolderState, "lId", "sName");
		$('lIdGedFolderState').onchange = function(){
			updateDateClotured();
		}
		updateDateClotured();*/
		$('ButRemove').onclick=function(){removeItem();};
		
	}
	initOwner();
	if (bModalMode){
		Element.hide("ButRemove");
		$('back_btn').onclick=function(){
			try{parent.g_modal.close();
			}catch(e){
				try{parent.Control.Modal.close();
				}catch(e){}
			}
		}
	}
	var dataset = [];
	/*
	ged_categories = new gedCategoryComponent('gedCategoryCpt', <%=GedCategory.getJSONArrayFromParent(0)%>);
	if (jsonData.gedCategories) {
		jsonData.gedCategories.each(function(item){dataset.push(item.GedCategory);});
	}
	ged_categories.populate(dataset || []);
	*/
	$('lId').value = jsonData.lId || "";
	$('sName').value = jsonData.sName || "";	
	$("sDescription").value=jsonData.sDescription || "";
	tinyMCE.execCommand('mceToggleEditor',false,'sDescription');
	$("sReference").value=jsonData.sReference || "";
	//$('tsDateClotured').value = formatToComponent(jsonData.tsDateClotured) || "";
	$('lIdGedFolderType').value = jsonData.lIdGedFolderType || lIdGedFolderTypeDefault;
	//$('lIdGedFolderState').value = jsonData.lIdGedFolderState || "";

}
onPageLoad = function() {
	if(bModalMode) mt.config.enableAutoLoading = false;
	populate();
	$("formDocument").isValid = function(){
		var bValid = true;
		return bValid;
	}
	$("formDocument").onValidSubmit = function() {
		$('submit_btn').disabled = true;	
		$('submit_btn').innerHTML = "<%=locMessage.getValue (3, "Chargement en cours...")%>";
		$('ButRemove').disabled = true;
		var obj = {};
		obj.lId = $("lId").value;
		obj.sName = $("sName").value;
		var ed = tinyMCE.get('sDescription');
		try{obj.sDescription = ed.getContent();}catch(e){alert("<%=locMessage.getValue (4, "Error")%> : "+e);}
		obj.sReference = $("sReference").value;
		obj.lIdGedFolderType = $("lIdGedFolderType").value;
		//obj.lIdGedFolderState = $("lIdGedFolderState").value;
		obj.lIdGedFolderParent = lIdGedFolderParent;
		if (!jsonData.lId){
			obj.lIdReferenceObjectOwner = $("lIdReferenceObjectOwner").value;
			obj.lIdTypeObjectOwner = $("lIdTypeObjectOwner").value;
		}
		/*
		var d = $("tsDateClotured").value.trim().split("/");
		obj.tsDateClotured = (new Date(parseInt(d[2],10), parseInt(d[1],10)-1, parseInt(d[0],10))).dateFormat("Y-m-d H:i:s");
		*/
		GedFolder.storeFromJSONString(Object.toJSON(obj), function(lId){
			if (lId>0) {
				if (jsonData.lId){						
					if (bModalMode){
						alert("<%=locMessage.getValue (36, "Classeur correctement modifié")%>.");
						try{parent.g_modal.close();
						}catch(e){
							try{parent.Control.Modal.close();
							}catch(e){}
						}
					}else{
						location.href = "<%=response.encodeRedirectURL("modifyFolderForm.jsp?lId=")%>"+lId;
					}
				}else{
					var oe = {};
					oe.lIdGedFolder = lId;
					oe.lIdTypeObject = lIdTypeObjectPP;
					oe.lIdReferenceObject = lIdPersonnePhysique;
					oe.lIdGedDocumentEntityTypfloe = lIdGedDocumentEntityType;
					
					GedFolderEntity.storeFromJSONString(Object.toJSON(oe), function(lIdGedFolderEntity){
						if (lIdGedFolderEntity>0) {
							if (bModalMode){
								alert("<%=locMessage.getValue (2, "Classeur correctement créé")%>.");
								try{parent.g_modal.close();
								}catch(e){
									try{parent.Control.Modal.close();
									}catch(e){}
								}
							}else{
								location.href = "<%=response.encodeRedirectURL("modifyFolderForm.jsp?lId=")%>"+lId;
							}
						}else{
							alert("<%=locMessage.getValue (1, "un problème est survenu lors de l'enregistrement")%>");
						}
					});
				}
			} else {
				alert("<%=locMessage.getValue (1, "un problème est survenu lors de l'enregistrement")%>");
			}
		});
		return false;
	}
	/*if controls are not valid*/
    $("formDocument").onIncompleteSubmit = function(){
        document.location.href="#";
        alert("<%=locMessage.getValue (5, "La saisie de certains champs n'est pas complète, merci de vérifier")%>");
        return false;
    }
}
function validForm(){
	//$('sCategoryList').value = ged_categories.getSelectionsToString();
	return true;
}
</script>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="" method="post" name="formDocument" id="formDocument" class="validate-fields">
<div id="fiche">
        <input type="hidden" name="lId" id="lId" />
		<input type="hidden" name="sAction" id="sAction" value="<%= sAction %>" />
		<input type="hidden" name="sCategoryList" id="sCategoryList" />
		<input type="hidden" name="lIdGedFolderType" id="lIdGedFolderType" />
		<table class="formLayout" cellspacing="3">
			<tr>
				<td colspan="2" style="padding: 4px; margin-top: 20px; text-transform: uppercase; font-weight: bold; color: rgb(51, 102, 204);">
				<%=locTitle.getValue (7, "Composition du classeur")%>
			<%
			if (lId==0){
			%>
			<!-- <input type="hidden" name="lIdGedFolderState" id="lIdGedFolderState" />
			<input type="hidden" name="tsDateClotured" id="tsDateClotured" />-->
			<input type="hidden" name="lIdTypeObjectOwner" id="lIdTypeObjectOwner" />
			<%} %>
				</td>
			</tr>
			<tr>
				<td class="label"><%=item.getNameLabel ()%> * :</td>
				<td class="value"><input id="sName" name="sName" maxlength="250" class="dataType-notNull" style="width:250px;" /></td>
			</tr>
			<tr>
				<td class="label"><%=item.getIdReferenceObjectOwnerLabel()%> :</td>
				<td class="value" id="owner"></td>
			</tr>
			<%
			if (false){
			%>
			<tr>
				<td class="label"><%=item.getIdGedFolderStateLabel()%> :</td>
				<td class="value"><select id="lIdGedFolderState"></select>
					<span id="SpanDateClotured" style="display:none;">&nbsp;<%=item.getDateClosedLabel()%> : <input id="tsDateClotured" class="dataType-date"  maxlength="10" /></span>
				</td>
			</tr>
			<%} %>
			<tr>
				<td class="label"><%=item.getReferenceLabel()%> :</td>
				<td class="value"><input id="sReference" name="sReference" maxlength="250" class="" style="width:250px;" /></td>
			</tr>
			<tr>
				<td class="label"><%=item.getDescriptionLabel()%> :</td>
				<td class="value" style="width:550px;">
					<textarea id="sDescription" name="sDescription" style="width: 100%;height: 150px;"></textarea>
				</td>
			</tr>
			<!-- 
			<tr>
				<td class="label">Catégorie :</td>
				<td class="value" id="gedCategoryCpt"></td>
			</tr>
			-->
		</table>
</div>
<div id="fiche_footer">
	<button id="back_btn" type="button"><%=localizeButton.getValueBack("Retour")%></button>
	<button type="submit" id="submit_btn" ><%=localizeButton.getValueSubmit()%></button>
	<button id="ButRemove" type="button"><%=localizeButton.getValueDelete ()%></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%
ConnectionManager.closeConnection(conn);
%>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.coin.bean.ged.GedCategory"%>

<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ged.GedFolderState"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeState"%>
<%@page import="org.coin.bean.ged.GedDocumentEntityType"%></html>