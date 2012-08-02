<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
	Localize locMessage = new Localize (request, LocalizationConstant.CAPTION_CATEGORY_PARAPH_ADMIN_PAGE_MESSAGE);
	Localize locButton = new Localize (request, LocalizationConstant.CAPTION_CATEGORY_PARAPH_ADMIN_PAGE_BUTTON);

	String sTitle = "Page d'accueil : "; 
	sTitle += "<span class=\"altColor\">Personnalisation</span>"; 
	String sPageUseCaseId = "IHM-DESK-PARAM-HOME-1";
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	
	if(sAction.equals("store"))
	{
		Theme.updateAllWelcomeBlocks(request);
		sTitle += "<span class=\"altColor\"> Page d'accueil enregistrée</span>"; 
	} 
	if(sAction.equals("create"))
	{
		Theme.addWelcomeBlock();
		sTitle += "<span class=\"altColor\"> Nouveau bloc ajouté</span>"; 
	} 
	if(sAction.equals("remove"))
	{
		String sId = HttpUtil.parseStringBlank("sId",request);
		Theme.removeWelcomeBlock(sId);
		sTitle += "<span class=\"altColor\"> Bloc supprimé</span>"; 
	}
	if(sAction.equals("reinitialize"))
	{
		for (PersonnePhysiqueParametre parametre : PersonnePhysiqueParametre.getAllWithWhereAndOrderByClauseStatic("where name='desk.welcome.popup.disabled'", ""))
				parametre.remove ();		
		sTitle += "<span class=\"altColor\"> | " + locMessage.getValue (6, "Page message de bienvenue réinitialisé pour tous les utilisateurs") + "</span>";
	}
	
	Vector<Configuration> vBlocks = Theme.getAllWelcomeBlocks();
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	int iIdxContent=0;
	String sContentIds = "";
	for(Configuration block : vBlocks){
		sContentIds += block.getIdString()+((iIdxContent<vBlocks.size()-1)?",":"") ;
		iIdxContent++;
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
    elements : "<%= sContentIds %>",
    skin : "o2k7",
    plugins:"paste,preview",//plugins à utiliser//////////////////////////////////////////////////////////////////////
    //convert_urls : false,
    relative_urls : true, 
    document_base_url : '<%= rootPath %>',
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_path_location : "bottom",
    theme_advanced_buttons1 : "bold,italic,underline,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,link,unlink,|,preview,image",
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
    plugin_preview_height : "800"
});
</script>
<script type="text/javascript">
<!--
function displayHtmlModal(id){
	openModal(id,null);
}

function openModal(id,obj){
	var modal, div ;
	
	try{div = createModal(id,obj,parent.document);}
	catch(e){div = createModal(id,obj,document);}
	
	try {modal = new parent.Control.Modal(false,{contents: div});}
	catch(e) {modal = new Control.Modal(false,{contents: div});}

    modal.container.insert(div);
	modal.open();
}

function createModal(id, obj, doc){
	
	var modal_princ = doc.createElement("div");
	
	var divControls = doc.createElement("div");
	divControls.className = "modal_controls";
		
	var divTitle = doc.createElement("div");
	divTitle.className = "modal_title";
	divTitle.innerHTML = "HTML Généré";
	
	
	var img = doc.createElement("img");
	img.style.position = "absolute";
	img.style.top = "3px";
	img.style.right = "3px";
	img.style.cursor = "pointer";
	img.src = "<%= rootPath %>images/icons/close.gif";
	img.onclick = function(){
		try {new parent.Control.Modal.close();}
		catch(e) { Control.Modal.close();}
	}
	
	divControls.appendChild(divTitle);
	divControls.appendChild(img);
	
	var divFrame = doc.createElement("div");
	divFrame.className = "modal_frame_principal";
	
	var divContent = doc.createElement("div");
	divContent.className = "modal_frame_content";
	
	var sHTML = $(id).value;
	
	divContent.innerHTML = sHTML;
	divFrame.appendChild(divContent);

	
	var divOptions = doc.createElement("div");
	divOptions.className = "modal_options";
		
	modal_princ.appendChild(divFrame);
	modal_princ.appendChild(divOptions);
	
	return modal_princ;
}
function removeBlock(id){
	location.href = "<%= response.encodeURL("modifyDeskWelcomePageForm.jsp?") %>"+
			"sAction=remove&sId="+id;
}
function addBlock(){
	location.href = "<%= response.encodeURL("modifyDeskWelcomePageForm.jsp?") %>"+
					"sAction=create";
}
function reinitialize(){
	location.href = "<%= response.encodeURL("modifyDeskWelcomePageForm.jsp?") %>"+
					"sAction=reinitialize";
}
function displayAllNews(){
	var sUrl = "<%= response.encodeURL(
			rootPath + "desk/parametrage/configuration/news/displayAllNews.jsp") %>";


	parent.addParentTabForced("News",sUrl);
}
//-->
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyDeskWelcomePageForm.jsp") %>" method="post" name="formulaire">
<input type="hidden" name="sAction" value="store" />
<div id="fiche">
<button type="button" onclick="displayAllNews()">Afficher les news</button>
<table class="formLayout" cellspacing="3">
<% 
int iIdx = 1;
for(Configuration block : vBlocks){ 
%>
<tr>
	<td class="pave_cellule_gauche">Code :</td>
	<td class="pave_cellule_droite"><%= block.getIdString()%></td>
</tr>
<tr>
	<td class="pave_cellule_gauche">Body :</td>
	<td class="pave_cellule_droite">
		<textarea rows="30" cols="100" name="<%= block.getIdString()%>" id="<%= block.getIdString()%>" ><%= block.getDescription() %></textarea>
	</td>
</tr>
<tr>
	<td class="pave_cellule_gauche">&nbsp;</td>
	<td class="pave_cellule_droite">
	<% if(iIdx > 2){ %>
	<button type="button" onclick="javascript:removeBlock('<%= block.getIdString()%>')" >Supprimer ce bloc</button>
	<%} %>
	</td>
</tr>
<%iIdx++;} %>
</table>
</div>
<div id="fiche_footer">
	<button type="button" onclick="javascript:addBlock()" >Ajouter un bloc</button>
	<button type="submit" >Valider</button>
	<button type="button" onclick="javascript:reinitialize ()"><%=locButton.getValue (21, "Voir le message pour tous les utilisateurs")%></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.HttpUtil"%>
</html>
