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
String sTitle = "Page : "; 
Connection conn = ConnectionManager.getConnection();


WebsiteTree item = null;
JSONObject jsonData =  null;
long lId = HttpUtil.parseLong("lIdWebsiteTree", request, 0);
boolean bButtonAdd = HttpUtil.parseBoolean("bButtonAdd", request, false);

if (lId>0){
	try{item = WebsiteTree.getWebsiteTree(lId);
	jsonData = item.toJSONObject();
	}catch(Exception e){e.printStackTrace();}
}
if (item==null){
	item = new WebsiteTree();
	jsonData = new JSONObject();
}
HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
pave.bIsForm = true;

String sPageUseCaseId = "IHM-DESK-WEBSITE-TREEVIEW-PAGE"; //"IHM-DESK-FONDATION-LECLERC-GERER-DOCUMENTS";

sTitle += "<span class=\"altColor\">Modifier une page</span>"; 
sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

String sURLForm = response.encodeURL(rootPath+"desk/website/tree/displayAllWebsiteTree.jsp");
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsiteTree.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsiteTreeStatus.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SitemapChangefreq.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SitemapPriority.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/js/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>

</head>
<body>
<script type="text/javascript">
var jsonData = <%= jsonData %>;

mt.config.enableAutoLoading = false;

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
function populate(){
	$("checkout").onclick = function(){
		window.open("<%= rootPath %>"+jsonData.sCompletePath);
	}
	$("divTitle").innerHTML = "Modification de la page : \""+jsonData.sName+"\"";
	$("sContent").value=jsonData.sContent || "";
	tinyMCE.execCommand('mceToggleEditor',false,'sContent');	
}
onPageLoad = function() {
	populate();
    /*before controls*/
    $('formDocument').isValid = function() {
		return true;
	}

    /*if controls are valid*/
    $("formDocument").onValidSubmit = function(){
        $('submit_btn').disabled = true;
        $('submit_btn').innerHTML = "Chargement en cours...";  
    	var obj = new Object();
    	try{obj.lId = jsonData.lId;}catch(e){}
        var ed = tinyMCE.get('sContent');
        try{obj.sContent = ed.getContent();}catch(e){alert("Error : "+e);}
        var d = new Date();
		obj.tsSitemapLastmod = d.dateFormat("Y-m-d H:i:s");
        
        WebsiteTree.storeFromJSONString(Object.toJSON(obj), function(lId){
            if (lId>0) {
                $('submit_btn').disabled = false;
        		$('submit_btn').innerHTML = "Valider";  
            	alert("Page correctement modifiée.");
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
<form name="formDocument" id="formDocument" method="post" action="" class="validate-fields">
<div id="fiche">
        <input type="hidden" name="lId" id="lId" value="<%= item.getId() %>" />
		<table style="margin-left: 10px;padding: 5px;">
		<tr>
			<td colspan="2">
				<div id="divTitle" style="font-weight: bold;">Contenu : </div>
				<div><button type="button" id="checkout">Aperçu de la page sur le site</button></div>
				<textarea id="sContent" name="sContent" style="width: 750px;height: 450px;"></textarea>
			</td>
		</tr>
	</table>
</div>
<div id="fiche_footer">

	<button type="submit" id="submit_btn">Valider</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ged.GedCategory"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocumentAttribute"%>
<%@page import="mt.website.WebsiteTree"%>
<%@page import="mt.website.WebsiteTreeStatus"%>
<%@page import="mt.website.SitemapChangefreq"%>
<%@page import="mt.website.SitemapPriority"%>
</html>
<%

	ConnectionManager.closeConnection(conn);

%>