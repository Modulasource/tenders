<%@ include file="/include/new_style/headerDesk.jspf" %>

<% 
	String sTitle = "Configuration : "; 
	sTitle += "<span class=\"altColor\">Message d'information BOAMP</span>"; 
	
	Configuration item = null;
	String sPageUseCaseId = "IHM-DESK-PARAM-HOME-1";
    
	String sId = "design.desk.message.information.boamp.page.html";
	
	try{
		item = Configuration.getConfigurationMemory(sId);
	} catch(CoinDatabaseLoadException e) {
		item = new Configuration(sId);
		item.setDescription("à définir !");
		item.create();
	}

	String sAction = request.getParameter("sAction");
	if(sAction != null && sAction.equals("store"))
	{
		item.setDescription(request.getParameter("sDescription"));
		item.store();
		sTitle += "<span class=\"altColor\">Message d'information BOAMP enregistré</span>"; 
	} 
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>


<script type="text/javascript" src="<%=rootPath%>include/js/tinymce/jscripts/tiny_mce/tiny_mce_gzip.jsp"></script>

<script type="text/javascript">

tinyMCE_GZ.init({//extraction des plugins du fichier  tiny_mce_gzip
    plugins : 'paste,preview',
    themes : 'advanced',
    languages : 'en',
    disk_cache : true,
    debug : false
});


tinyMCE.init({
    theme : "advanced",
    mode : "exact",
    elements : "sDescription",//contenu à traiter///////////////////////////////////////////////////////////////////
    skin : "o2k7",
    plugins:"paste,preview",//plugins à utiliser//////////////////////////////////////////////////////////////////////
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_path_location : "bottom",
    theme_advanced_buttons1 : "bold,italic,underline,|,bullist,numlist,|,link,unlink,|,preview",
    theme_advanced_buttons2 : "fontselect,fontsizeselect,styleselect",
    theme_advanced_buttons3 : "",
    //theme_advanced_buttons1 : "separator,insertdate,inserttime,preview,zoom,separator,forecolor,backcolor",
    //theme_advanced_buttons2 : "bullist,numlist,separator,outdent,indent,separator,undo,redo,separator",
    //theme_advanced_buttons3 : "hr,removeformat,visualaid,separator,sub,sup,separator,charmap",
    plugin_preview_pageurl:"<%=rootPath%>include/js/tinymce/jscripts/tiny_mce/plugins/preview/preview.jsp",//page qui sert à afficher la preview
    content_css : "<%=rootPath%>include/css/tinymce.css",

    theme_advanced_width : "600",
    theme_advanced_height : "600",
    
    theme_advanced_resizing : true,
    theme_advanced_resize_horizontal : true,
    plugin_preview_width : "600",
    plugin_preview_height : "600"
});

</script>


<script type="text/javascript">
<!--




function displayHtmlModal(){
	openModal(null);
}

function openModal(obj){
	var modal, div ;
	
	try{div = createModal(obj,parent.document);}
	catch(e){div = createModal(obj,document);}
	
	try {modal = new parent.Control.Modal(false,{contents: div});}
	catch(e) {modal = new Control.Modal(false,{contents: div});}

    modal.container.insert(div);
	modal.open();
}

function createModal(obj, doc){
	
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
	
	var sHTML = $('sDescription').value;
	
	divContent.innerHTML = sHTML;
	divFrame.appendChild(divContent);

	
	var divOptions = doc.createElement("div");
	divOptions.className = "modal_options";
		
	modal_princ.appendChild(divFrame);
	modal_princ.appendChild(divOptions);
	
	return modal_princ;
}

//-->
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyInformationMessageBoampForm.jsp") %>" method="post" name="formulaire">
<div id="fiche">
<table class="formLayout" cellspacing="3">
<tr>
<input type="hidden" name="sAction" value="store" />
	<td class="pave_cellule_gauche">Code :</td>
	<td class="pave_cellule_droite"><%= item.getIdString()  %></td>
</tr>
<tr>
	<td class="pave_cellule_gauche">Body :</td>
	<td class="pave_cellule_droite">
		<textarea rows="30" cols="100" name="sDescription" id="sDescription" ><%= item.getDescription() %></textarea>
	</td>
</tr>
</table>
</div>
<div id="fiche_footer">
<!-- 
	<button type="button" onclick="javascript:displayHtmlModal()" >Afficher HTML</button>
 -->
	<button type="submit" >Valider</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
</html>
