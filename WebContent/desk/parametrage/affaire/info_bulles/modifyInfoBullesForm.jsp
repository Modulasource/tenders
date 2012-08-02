<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*,org.coin.bean.conf.*,java.util.*" %>
<%
	String sTitle = "Avertissement : ";
	InfosBulles item = null;
	String sPageUseCaseId = "xxx";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	if (sAction.equals("create")) {
		item = new InfosBulles();
	}
	if (sAction.equals("store")) {
		long lId = HttpUtil.parseLong("lId", request);

		item = InfosBulles.getInfosBullesMemory(lId);
		sTitle += "<span class=\"altColor\">" + item.getId()
		+ "</span>";

	}
%>
<script type="text/javascript" src="<%=rootPath%>include/js/tinymce/jscripts/tiny_mce/tiny_mce_gzip.jsp"></script>
<script type="text/javascript">

tinyMCE_GZ.init({//extraction des plugins du fichier  tiny_mce_gzip
    plugins : 'paste,preview',
    themes : 'advanced',
    languages : 'fr',
    disk_cache : true,
    debug : false
});


tinyMCE.init({
    theme : "advanced",
    language : 'fr',
    mode : "exact",
    elements : "sName",//contenu à traiter///////////////////////////////////////////////////////////////////
    skin : "o2k7",
    plugins:"paste,preview",//plugins à utiliser//////////////////////////////////////////////////////////////////////
    //convert_urls : false,
    relative_urls : true, 
    document_base_url : '<%= rootPath %>',
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_path_location : "bottom",
    theme_advanced_buttons1 : "bold,italic,underline,|,bullist,numlist,|,link,unlink,|,preview,image",
    theme_advanced_buttons2 : "formatselect,fontselect,fontsizeselect",
    theme_advanced_buttons3 : "",
    //theme_advanced_buttons1 : "separator,insertdate,inserttime,preview,zoom,separator,forecolor,backcolor",
    //theme_advanced_buttons2 : "bullist,numlist,separator,outdent,indent,separator,undo,redo,separator",
    //theme_advanced_buttons3 : "hr,removeformat,visualaid,separator,sub,sup,separator,charmap",
    plugin_preview_pageurl:"<%=rootPath%>include/js/tinymce/jscripts/tiny_mce/plugins/preview/preview.jsp",//page qui sert à afficher la preview
    content_css : "<%=rootPath%>include/css/tinymce.css",
    
    //external_image_list_url : "<%=rootPath%>include/js/tinymce/lists/image_list.js",

    theme_advanced_width : "600",
    theme_advanced_height : "600",
    
    theme_advanced_resizing : true,
    theme_advanced_resize_horizontal : true,
    plugin_preview_width : "600",
    plugin_preview_height : "600"
});

</script>
<script type="text/javascript">
function displayAllItems() {
	location.href = "<%=
		response.encodeURL("displayAllInfoBulles.jsp")
		%>";
}

function removeItem(id)
{
    if(confirm("Etes-vous sûr de vouloir supprimer cet avertissement ?")){
     var sUrl = "<%=
        response.encodeURL(
                rootPath
                +"desk/parametrage/affaire/info_bulles/modifyInfoBulles.jsp")%>?sAction=remove&lId="+id;

    location.href = sUrl;
    }
   
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyInfoBulles.jsp") %>" method="post" name="formulaire">
<div id="fiche">
		<input type="hidden" name="lId" id="lId" value="<%=item.getId()%>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />

		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="pave_cellule_gauche">Contenu :</td>
				<td class="pave_cellule_droite"><textarea cols="97" rows="30"
					name="sName"><%=item.getName()%></textarea></td>
			</tr>
		</table>
</div>


<div id="fiche_footer">
<button type="submit">Valider</button>
<%
if (sAction.equals("store")) {
%>
	<button type="button" onclick="removeItem(<%= item.getId() %>);">Supprimer</button>
<%
}
%>
	<button type="button" onclick="javascript:displayAllItems();">Annuler</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.util.InfosBulles"%>
</html>
