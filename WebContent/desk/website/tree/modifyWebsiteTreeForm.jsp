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

String sPageUseCaseId = "IHM-DESK-WEBSITE-TREEVIEW"; //"IHM-DESK-FONDATION-LECLERC-GERER-DOCUMENTS";

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
var jsonWebsiteTreeStatus = <%=WebsiteTreeStatus.getJSONArray()%>;
var jsonSitemapChangefreq = <%=SitemapChangefreq.getJSONArray()%>;
var jsonSitemapPriority = <%=SitemapPriority.getJSONArray() %>;
var jsonBoolean = [{"sLabel":"Oui","lId":true},{"sLabel":"Non","lId":false}];
var jsonAccessRights = [{"sLabel":"Administrateur","lId":<%= WebsiteTree.ACCESS_RIGHT_ADMIN %>},{"sLabel":"L'utilisateur peut modifier la page","lId":<%= WebsiteTree.ACCESS_RIGHT_USER_MODIFY %>}];
var jsonData = <%= jsonData %>;

mt.config.enableAutoLoading = false;

function formatToComponent(sDate){
	if (!sDate) return "";
	var aDate = sDate.substring(0, 10).split("-");
	return aDate[2]+"/"+aDate[1]+"/"+aDate[0]; 
}
tinyMCE.init({
		// General options
		language : 'fr',
		mode : "none",
		theme : "advanced",
		plugins : "safari,pagebreak,style,preview,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,template,table,advimage,advlink",

		// Theme options
		theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,forecolor,backcolor,fontselect,fontsizeselect,|,sub,sup,|,cut,copy,pastetext,pasteword,|,undo,redo,|,link,unlink,|",
		theme_advanced_buttons2 : "justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,outdent,indent,blockquote,|,formatselect,charmap,|,tablecontrols,image,code,removeformat,fullscreen,print,|",
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
    	extended_valid_elements : "a[id|style|rel|rev|charset|hreflang|dir|lang|tabindex"
				+ "|accesskey|type|name|href|title|class|onfocus|onblur|onclick"
				+ "|ondblclick|onmousedown|onmouseup|onmouseover"
				+ "|onmousemove|onmouseout|onkeypress|onkeydown|onkeyup]"
				+ ",span[class|align|style]",
		paste_create_paragraphs : false,
		paste_create_linebreaks : false,
		paste_use_dialog : true,
		paste_auto_cleanup_on_paste : true,
		paste_convert_middot_lists : false,
		paste_unindented_list_class : "unindentedList",
		paste_convert_headers_to_strong : true,

/*
		// Example content CSS (should be your site CSS)
		content_css : "css/content.css",

		// Drop lists for link/image/media/template dialogs
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
function addMeta(sMeta){
	var sContent = "";
	if ($("sMetaTags").value.length>0) $("sMetaTags").value += "\n";
	if (sMeta=="contentType"){
		$("sMetaTags").value += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
	}else{
		if (sMeta=="google") sContent="notranslate";		
		$("sMetaTags").value += "<meta name=\""+sMeta+"\" content=\""+sContent+"\" />";
	}
}
function addJavascriptTag(){
	$("sJavascriptCode").value += "<script language=\"Javascript\" type=\"text/javascript\">\n";
	$("sJavascriptCode").value += "<\/script>";
}
var editor = tinyMCE.get('sContent');
function populate(){
	$("checkout").onclick = function(){
		window.open("<%= rootPath %>"+jsonData.sCompletePath);
	}
	$('lIdWebsiteTreeStatus').populate(jsonWebsiteTreeStatus, <%=item.getIdWebsiteTreeStatus()%>, "lId", "sLabel");
	$('lIdSitemapChangefreq').populate([{"sLabel":"-","lId":0}].concat(jsonSitemapChangefreq), <%=item.getIdSitemapChangefreq()%>, "lId", "sLabel");
	$('lIdSitemapPriority').populate(jsonSitemapPriority, <%=item.getIdSitemapPriority()%>, "lId", "sLabel");
	if (jsonData.hasChild){
		$('bDisplayAsAPage').populate(jsonBoolean, (jsonData.bDisplayAsAPage), "lId", "sLabel");
		$('bDisplayAsAPage').value = jsonData.bDisplayAsAPage; 
	}else{
		$('bDisplayAsAPage').populate([{"sLabel":"Oui","lId":true}], true, "lId", "sLabel");
	}
	$('bDisplay').populate(jsonBoolean, <%=item.isDisplay()%>, "lId", "sLabel");
	$('bDisplay').value = jsonData.bDisplay;
	$('bDisplayInMenu').populate(jsonBoolean, <%=item.isDisplayInMenu()%>, "lId", "sLabel");
	$('bDisplayInMenu').value = jsonData.bDisplayInMenu; 
	$('tsSitemapLastmod').value = formatToComponent(jsonData.tsSitemapLastmod) || "";
	$("sName").value=jsonData.sName || "";
	$("sIndexName").value=jsonData.sIndexName || "";
	$("sDescription").value=jsonData.sDescription || "";
	$("sMetaTags").value=jsonData.sMetaTags || "";
	$("sContent").value=jsonData.sContent || "";
	tinyMCE.execCommand('mceToggleEditor',false,'sContent');
	$("sJavascriptCode").value=jsonData.sJavascriptCode || "";	
	$("lAccessRights").populate(jsonAccessRights, (jsonData.lAccessRights || jsonAccessRights[0].lId), "lId", "sLabel");
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
        try{obj.sName = $("sName").value;}catch(e){}
        try{obj.sDescription = $("sDescription").value;}catch(e){}
        try{obj.sMetaTags = $("sMetaTags").value;}catch(e){}
        var ed = tinyMCE.get('sContent');
        try{obj.sContent = ed.getContent();}catch(e){alert("Error : "+e);}
        try{obj.sIndexName = $("sIndexName").value;}catch(e){}
        try{obj.lIdWebsiteTreeStatus = $("lIdWebsiteTreeStatus").value;}catch(e){}
        try{obj.lIdSitemapChangefreq = $("lIdSitemapChangefreq").value;}catch(e){}
        try{obj.lIdSitemapPriority = $("lIdSitemapPriority").value;}catch(e){}
        try{obj.bDisplay = $("bDisplay").value;}catch(e){alert(e);}
        try{obj.bDisplayInMenu = $("bDisplayInMenu").value;}catch(e){alert(e);}
        try{obj.bDisplayAsAPage = $("bDisplayAsAPage").value;}catch(e){alert(e);}
        try{obj.lAccessRights = $("lAccessRights").value;}catch(e){}
        try{obj.sJavascriptCode = $("sJavascriptCode").value;}catch(e){alert(e);}
        if ($("bUpdateLastmod").checked){
        	var d = new Date();
			obj.tsSitemapLastmod = d.dateFormat("Y-m-d H:i:s");
        }else{
        	var d = $("tsSitemapLastmod").value.trim().split("/");
			obj.tsSitemapLastmod = (new Date(d[2], parseInt(d[1])-1, d[0])).dateFormat("Y-m-d H:i:s");
		}
        
        WebsiteTree.storeFromJSONString(Object.toJSON(obj), function(lId){
            if (lId>0) {
            	if (confirm("Page correctement modifiée.\nRetourner à l'arborescence ?"))
	        		location.href="<%=response.encodeURL("displayAllWebsiteTree.jsp") %>";
	        	else
	        		location.href="<%=response.encodeURL("modifyWebsiteTreeForm.jsp?lIdWebsiteTree="+lId) %>";
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
			<td style="vertical-align: top;">
			<table class="formLayout" >
				<tr>
					<td>
						<div style="font-weight: bold;">Aperçu de la page : </div>
						<button type="button" id="checkout">Aperçu de la page sur le site</button>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Titre de la page <sup>(1)</sup> : </div>
						<input type="text" id="sName" name="sName" class="dataType-notNull" style="width: 350px;"/>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Nom de l'index <sup>(2)</sup> : </div>
						<input type="text" id="sIndexName" name="sIndexName" style="width: 350px;"  class="dataType-notNull"/>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Définir l'index comme une page <sup>(3)</sup> ?</div>
						<select id="bDisplayAsAPage"></select>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Statut : </div>
						<select id="lIdWebsiteTreeStatus"></select>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Afficher cette page : </div>
						<select id="bDisplay"></select> NB : Cette page et ses fils seront masqués du site.
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Afficher cette page dans le menu du site : </div>
						<select id="bDisplayInMenu"></select> NB : Apparait dans le sitemap mais pas dans le menu.
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Droits : </div>
						<select id="lAccessRights"></select>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Balises meta : </div>
						<div style="background-color: #EEEEEE;font-size: 9px;width: 450px;">
							<a href="javascript:void(0);" onclick="addMeta('description');" title="Ajouter une balise meta description">+ Description</a>
							<a href="javascript:void(0);" onclick="addMeta('google');" title="Ajouter une balise meta google notranslate">+ Google notranslate</a>
							<a href="javascript:void(0);" onclick="addMeta('robots');" title="Ajouter une balise meta robots">+ Robots</a>
							<a href="javascript:void(0);" onclick="addMeta('contentType');" title="Ajouter une balise meta content-type">+ charset</a>
							<a href="http://www.webrankinfo.com/dossiers/on-page/guide-balises-meta" target="blank">(infos sur les balises meta)</a>
						</div>
						<textarea id="sMetaTags" name="sMetaTags" style="width: 450px;height: 100px;"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Descriptif : </div>
						<textarea id="sDescription" name="sDescription" style="width: 350px;height: 150px;"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Explications : </div>
						<sup>(1)</sup> : Le titre officiel de la page<br />
						<sup>(2)</sup> : L'index correspond à l'URL de la page. Par exemple, pour le titre "Page d'accueil", l'index peut être "page-accueil".<br />
						<sup>(3)</sup> : Lorsqu'une page n'a pas de fils, elle est forcément définie comme étant une page.<br />
						Or lorsqu'une page a au moins un fils, elle peut être considérée comme un simple répertoire.
						Exemple : si l'index est "page-accueil" par défaut l'URL vers cette page sera : "/page-accueil.html".
						Dans le cas contraire, l'URL sera comme un répertoire : "/page-accueil/le-1er-fils.htm".
					</td>
				</tr>
			</table>
			</td>
			<td style="vertical-align: top;">
			<table class="formLayout" >
				<tr>
					<td>
						<div style="font-weight: bold;">Sitemap :</div>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Changefreq <sup>(4)</sup> : </div>
						<select id="lIdSitemapChangefreq"></select>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Priority <sup>(5)</sup> : </div>
						<select id="lIdSitemapPriority"></select>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Lastmod <sup>(6)</sup> : </div>
						<input id="tsSitemapLastmod" class="dataType-date"  maxlength="10" />
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;"></div>
						<sup>(4)</sup> : Fréquence de modification de la page.<br />La valeur "always" (toujours) 
						doit être utilisée pour décrire les documents qui changent à chaque accès. 
						La valeur "never" (jamais) doit être utilisée pour décrire les URL archivées.<br />
						<sup>(5)</sup> : Priorité de cette URL par rapport aux autres URL.<br />Cette valeur n'a aucune incidence sur la comparaison de vos pages avec celles d'autres sites. Elle permet uniquement de signaler aux moteurs de recherche les pages que vous jugez les plus importantes pour les robots d'exploration.
						La priorité par défaut d'une page est égale à 0,5.<br />
						<sup>(6)</sup> : Date de la dernière modification du fichier.
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div style="font-weight: bold;">Code Javascript</div>
				<div style="background-color: #EEEEEE;font-size: 9px;width: 450px;">
					<a href="javascript:void(0);" onclick="addJavascriptTag();" title="Ajouter une balise Javascript">Balise Javascript</a>
				</div>
				<textarea id="sJavascriptCode" name="sJavascriptCode" style="width: 450px;height: 100px;"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div style="font-weight: bold;">Contenu : </div>
				<textarea id="sContent" name="sContent" style="width: 100%;height: 350px;"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div style="text-align: center;">
					<input id="bUpdateLastmod" name="bUpdateLastmod" value="1" type="checkbox" checked="checked" />
					<label for="bUpdateLastmod">Mettre à jour la date du Lastmod automatiquement</label>
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="fiche_footer">

	<button type="submit" id="submit_btn">Valider</button>
	<button type="button" onclick="javascript:doUrl('<%=
		response.encodeURL("displayAllWebsiteTree.jsp") %>');" >
			Annuler</button>
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