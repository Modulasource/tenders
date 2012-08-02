<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page language="java" %>
<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="mt.website.*"%>
<%@page import="org.json.JSONObject"%>
<% 
	String sTitle = "Edition d'une actualité : ";
	String sWebsitePublicationWord = "actualité";
	boolean bKindFemaleElement = true;

	WebsitePublication item = null;
	JSONObject jsonData = null;
	String sPageUseCaseId = "IHM-DESK-WEBSITE-PUBLICATION";
	
	long lId = HttpUtil.parseLong("lId", request, 0);
	// Type de WebsitePublication (permet de décliner sous plusieurs rubriques d'actu)
	long lIdWebsitePublicationType = HttpUtil.parseLong("lIdWebsitePublicationType", request, WebsitePublicationType.TYPE_DEFAULT);
	
	String sAction = HttpUtil.parseString("sAction", request, "create");
	if (lId>0){
		try{item = WebsitePublication.getWebsitePublication(lId);
			jsonData = item.toJSONObject();
			lIdWebsitePublicationType = item.getIdWebsitePublicationType();
		}catch(Exception e){e.printStackTrace();}
	}
	if (item==null){
		item = new WebsitePublication();
		jsonData = new JSONObject();
	}
	
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_HOMMAGE){
		sTitle = "Hommage";
		sWebsitePublicationWord = "hommage";
		bKindFemaleElement = false;
	}
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_ACTUALITE_CULTURELLE){
		sTitle = "Actualité culturelle";
		sWebsitePublicationWord = "actualité culturelle";
		bKindFemaleElement = true;
	}
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_NOUVEAUX_OUVRAGES){
		sTitle = "Nouveaux ouvrages";
		sWebsitePublicationWord = "nouvel ouvrage";
		bKindFemaleElement = false;
	}
	if(lIdWebsitePublicationType==WebsitePublicationType.TYPE_ASSOCIATION){
		sTitle = "Billet des 15 régiments";
		sWebsitePublicationWord = "nouvel article";
		bKindFemaleElement = false;
	}

%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsitePublication.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsitePublicationTemplate.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/dragdrop.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/livepipe.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/window.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentSelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/gedSelectionComponent.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/js/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
</head>
<body>
<script type="text/javascript">
mt.config.enableAutoLoading = false;
var jsonData = <%= jsonData %>;
var jsonTemplate = <%=WebsitePublicationTemplate.getJSONArray()%>;
var jsonGedDocumentSelection = [];
var jsonState = [{"lId":<%=WebsitePublication.STATE_ACTIVE%>, "sLabel":"Actif"}, {"lId":<%=WebsitePublication.STATE_INACTIVE%>, "sLabel":"Inactif"}];

tinyMCE.init({
		// General options
		language : 'fr',
		mode : "none",
		theme : "advanced",
		plugins : "safari,pagebreak,style,preview,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,template",

		// Theme options
		theme_advanced_buttons1 : "bold,italic,underline,|,cut,copy,pastetext,pasteword,|,undo,redo,|,link,unlink,|,image,code,removeformat,fullscreen,print,|",
		theme_advanced_buttons2 : "strikethrough,justifyleft,justifycenter,justifyright,justifyfull,bullist,numlist,formatselect,undo,redo,|,sub,sup,|",
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

var editor = tinyMCE.get('sContent');
var editorSubtitle = tinyMCE.get('sSubtitle');

// retourne si sDate1>sDate2
function dateCompare(sDate1, sDate2){
	var aDate = sDate1.split("/");
	var d1 = new Date(aDate[2], aDate[1], aDate[0]); 
	aDate = sDate2.split("/");
	var d2 = new Date(aDate[2], aDate[1], aDate[0]);
	return (d1>d2);
}
function formatToComponent(sDate){
	if (!sDate) return "";
	var aDate = sDate.substring(0, 10).split("-");
	return aDate[2]+"/"+aDate[1]+"/"+aDate[0]; 
}
function removeItem(){
	if (confirm("Supprimer cette actualité ?")){
		$('submit_btn').disabled = true;	
		$('submit_btn').innerHTML = "Chargement en cours...";
		$('remove_btn').disabled = true;
		var obj = {};
		obj.lId = $("lId").value;
		WebsitePublication.removeFromIdJSON($("lId").value, function(bSuccess){
			if (bSuccess) {
				var oElt = {};
				oElt.lIdGedDocument = 0;
				oElt.lIdTypeObject = <%= ObjectType.WEBSITE_PUBLICATION %>;
				oElt.lIdReferenceObject = $("lId").value;
				GedDocumentSelection.removeFromJSONString(Object.toJSON(oElt), function(bSuccess){
					if (bSuccess) {
						location.href = "<%=response.encodeRedirectURL("displayAll.jsp")%>";
					}else{
						alert("un problème est survenu lors de la suppression");
					}
				});
				
			} else {
				alert("un problème est survenu lors de la suppression");
			}
		});
	}
}

var ged_selections;
function populate(){
	if (!jsonData.lId){
		$('remove_btn').disabled = true;
	}else if(jsonData.lId>0){
		var lIdTypeObject = <%= ObjectType.WEBSITE_PUBLICATION %>;
		var lIdReferenceObject = jsonData.lId;
		var sURLItem = "<%= response.encodeURL(rootPath
        		+"fondation-leclerc/document?"
        		+"sURL="+response.encodeURL(rootPath+"desk/GedDocumentDownloadServlet")+"&sRevision=last_revision&lId=") %>";
		var sURLAdd = "<%= response.encodeURL(rootPath+"desk/ged/fondation_leclerc/addDocumentForm.jsp") %>";
		var sURLSelect = "<%= response.encodeURL(rootPath+"desk/ged/fondation_leclerc/displayAllDocument.jsp") %>";
				
		ged_selections = new gedSelectionComponent("gedSelectionCpt", lIdTypeObject, lIdReferenceObject, sURLItem, sURLAdd, sURLSelect);
		ged_selections.load();
	}
	$('lIdWebsitePublicationTemplate').populate(jsonTemplate, <%=item.getIdWebsitePublicationTemplate()%>, "lId", "sLabel");
	$('lState').populate(jsonState, <%=item.getState()%>, "lId", "sLabel");
	$('lId').value = jsonData.lId || "";
	$('sTitle').value = jsonData.sTitle || "";
	$('sSubtitle').value = jsonData.sSubtitle || "";
	tinyMCE.execCommand('mceToggleEditor',false,'sSubtitle');	
	var d = new Date();
	var sDate = d.getDate()+"/"+(d.getMonth()+1)+"/"+d.getFullYear();
	$('tsDatePublish').value = formatToComponent(jsonData.tsDatePublish) || sDate;
	d = new Date(d.getTime() + (1000 * 60 * 60 * 24 * 21));
	sDate = d.getDate()+"/"+(d.getMonth()+1)+"/"+d.getFullYear();
	$('tsDateArchive').value = formatToComponent(jsonData.tsDateArchive) || sDate;
	$("sContent").value=jsonData.sContent || "";
	tinyMCE.execCommand('mceToggleEditor',false,'sContent');	
}
onPageLoad = function() {
	populate();
	$("formDocument").isValid = function(){
		var bValid = true;
		if (dateCompare($('tsDatePublish').value, $('tsDateArchive').value)){
			mt.utils.displayFormFieldMsg($("formDocument").tsDateArchive, "Cette date doit être postérieure à la date de parution");
			bValid = false;
		}
		return bValid;
	}
	$("formDocument").onValidSubmit = function() {
		$('submit_btn').disabled = true;	
		$('submit_btn').innerHTML = "Chargement en cours...";
		$('remove_btn').disabled = true;
		
		var obj = {};
		obj.lId = $("lId").value;
		<% if (sAction.equalsIgnoreCase("create")){ %>
		obj.lIdWebsitePublicationType = "<%= lIdWebsitePublicationType %>";
		<% } %>
		obj.lIdWebsitePublicationTemplate = $("lIdWebsitePublicationTemplate").value;
		obj.sTitle = $("sTitle").value;
		var ed = tinyMCE.get('sSubtitle');
		try{obj.sSubtitle = ed.getContent();}catch(e){alert("Error : "+e);}
		ed = tinyMCE.get('sContent');
		try{obj.sContent = ed.getContent();}catch(e){alert("Error : "+e);}

		var d = $("tsDatePublish").value.trim().split("/");
		obj.tsDatePublish = (new Date(parseInt(d[2],10), parseInt(d[1],10)-1, parseInt(d[0],10))).dateFormat("Y-m-d H:i:s");
		d = $("tsDateArchive").value.trim().split("/");
		obj.tsDateArchive = (new Date(parseInt(d[2],10), parseInt(d[1],10)-1, parseInt(d[0],10))).dateFormat("Y-m-d H:i:s");
		obj.lState = $("lState").value;
		WebsitePublication.storeFromJSONString(Object.toJSON(obj), function(lId){
			if (lId>0) {
				location.href = "<%=response.encodeRedirectURL("modifyForm.jsp?lId=")%>"+lId;
			} else {
				alert("un problème est survenu lors de l'enregistrement");
			}
		});
		return false;
	}
	/*if controls are not valid*/
    $("formDocument").onIncompleteSubmit = function(){
        return false;
    }
}

</script>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<form name="formDocument" id="formDocument" class="validate-fields" action="" method="post">
<div id="fiche">
        <input type="hidden" id="lId" name="lId" />
		<input type="hidden" id="sAction" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
			<tr>
				<td colspan="2" style="padding: 4px; margin-top: 20px; text-transform: uppercase; font-weight: bold; color: rgb(51, 102, 204);">
				Composition de l'article
				</td>
			</tr>
			<tr>
				<td class="label">Titre * :</td>
				<td class="value"><input id="sTitle" name="sTitle" maxlength="250" class="dataType-notNull" style="width:250px;" /></td>
			</tr>
			<tr>
				<td class="label">Sous-titre / chapeau :</td>
				<td class="value">
					<textarea rows="5" cols="20" id="sSubtitle" name="sSubtitle" style="width:450px;"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label">Contenu de l'article :</td>
				<td class="value" style="width:550px;">
					<textarea id="sContent" name="sContent" style="width: 100%;height: 350px;"></textarea>
				</td>
			</tr>
			<% if (lId>0){ %>
			<tr>
				<td class="label">Documents associés :</td>
				<td class="value" style="width:550px;">
					<div id="gedSelectionCpt"></div>
				</td>
			</tr>
			<% } %>
			<tr>
				<td class="label">Présentation :</td>
				<td class="value"><select id="lIdWebsitePublicationTemplate"></select></td>
			</tr>
			<tr>
				<td colspan="2" style="padding: 4px; margin-top: 20px; text-transform: uppercase; font-weight: bold; color: rgb(51, 102, 204);">
				Publication
				</td>
			</tr>
			<tr>
				<td class="label">Date de parution :</td>
				<td class="value"><input id="tsDatePublish" class="dataType-date dataType-notNull"  maxlength="10" /></td>
			</tr>
			<tr>
				<td class="label">Date d'archivage :</td>
				<td class="value"><input id="tsDateArchive" class="dataType-date dataType-notNull"  maxlength="10" /></td>
			</tr>
			<tr>
				<td class="label">Etat :</td>
				<td class="value"><select id="lState"></select></td>
			</tr>
		</table>
</div>
<div id="fiche_footer">
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("displayAll.jsp") %>');" >
			Retour</button>
	<button type="submit" id="submit_btn" >Valider</button>
	<button id="remove_btn" type="button" onclick="javascript:removeItem();">Supprimer</button>
</div>
</form>
<%@ include file="/desk/include/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedDocumentSelection"%>
</html>