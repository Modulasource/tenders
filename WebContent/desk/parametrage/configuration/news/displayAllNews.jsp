<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.bean.User"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.HttpUtil"%>
<%

	String sTitle = "news admin";
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	Connection conn = ConnectionManager.getConnection();
	
	if(sAction.equals("create"))
	{
		Theme.addNews();
		sTitle += "<span class=\"altColor\"> Nouveau bloc ajouté</span>"; 
	}

	if(sAction.equals("remove"))
	{
		String sId = HttpUtil.parseStringBlank("sId",request);
		Theme.removeNews(sId);
		sTitle += "<span class=\"altColor\"> Bloc supprimé</span>"; 
	}

	if(sAction.equals("store"))
	{
		Theme.updateAllNews(request);
		sTitle += "<span class=\"altColor\"> Modifications enregistrées</span>"; 
	} 

	
	if(sAction.equals("sendToAllUser"))
	{
		String sId = HttpUtil.parseStringBlank("sId",request);
		String sLogin = HttpUtil.parseStringBlank("sLogin",request);
		sTitle += "<span class=\"altColor\"> News envoyée</span>"; 

		Vector<User> vUser = null;
		if("".equals(sLogin ) )
		{
			vUser = User.getAllStatic();
		} else {
			vUser = User.getAllUserFromLoginLike(sLogin);
		}
		for(User user : vUser )
		{
			boolean bAlreadyAdded = false;
			Vector<PersonnePhysiqueParametre> vParam 
				= PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(
						user.getIdIndividual(),
						false, 
						conn);
			
			for(PersonnePhysiqueParametre param : vParam )
			{
				if(param.getName().equals("system.page.html.news")
				&& param.getValue().equals(sId))
				{
					bAlreadyAdded = true;
					break;
				}
			}
		
			if(!bAlreadyAdded)
			{
				System.out.println("user : " + user.getLogin());
				PersonnePhysiqueParametre param = new PersonnePhysiqueParametre();
				param.setIdPersonnePhysique(user.getIdIndividual());
				param.setName("system.page.html.news");
				param.setValue(sId);
				param.create();
			}
		}
	}


	if(sAction.equals("removeToAllUser"))
	{
		String sId = HttpUtil.parseStringBlank("sId",request);
		sTitle += "<span class=\"altColor\"> News retirée</span>"; 
		String sLogin = HttpUtil.parseStringBlank("sLogin",request);

		Vector<User> vUser = null;
		if("".equals(sLogin ) )
		{
			vUser = User.getAllStatic();
		} else {
			vUser = User.getAllUserFromLoginLike(sLogin);
		}
		for(User user : vUser )
		{
			Vector<PersonnePhysiqueParametre> vParam 
				= PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(
						user.getIdIndividual(),
						false, 
						conn);
			
			for(PersonnePhysiqueParametre param : vParam )
			{
				if(param.getName().equals("system.page.html.news")
				&& param.getValue().equals(sId))
				{
					param.remove();
					break;
				}
			}
		}
	}

	
	/**
	 * at the end due to pre modification
	 */
	Vector<Configuration> vNews = Theme.getAllNews();
	int iIdxContent=0;
	String sContentIds = "";
	for(Configuration block : vNews){
		sContentIds += block.getIdString()+((iIdxContent<vNews.size()-1)?",":"") ;
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


function removeNews(id)
{
	if(confirm("Etes-vous sûr de vouloir supprimer la news ?"))
	{
		location.href = "<%= response.encodeURL("displayAllNews.jsp?") %>"
				+ "sAction=remove&sId="+id;
	}
}

function createNews(){
	location.href = "<%= response.encodeURL("displayAllNews.jsp?") %>"+
					"sAction=create";
}

function sendNewsToAllUser(sId){
	var sLoginParam = "";
	if($("sendto_" + sId + "_login").checked)
	{
		sLoginParam = "&sLogin=" + $("sendto_login_" + sId).value;
	}
	location.href = "<%= response.encodeURL("displayAllNews.jsp?") %>"+
					"sAction=sendToAllUser"
					+ "&sId=" + sId
					+ sLoginParam;
}

function removeNewsToAllUser(sId){
	location.href = "<%= response.encodeURL("displayAllNews.jsp?") %>"+
					"sAction=removeToAllUser"
					+ "&sId=" + sId;
}

function displayNewsToAllUser(sId){
	var url = "<%= response.encodeURL("displayAllUserNews.jsp?") %>"
			+ "&sId=" + sId;

	mt.utils.displayModal({
		type:"iframe",
		url:url,
		title:("News " + sId),
		width:600,
		height:400
	});
	
}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("displayAllNews.jsp") %>" method="post" name="formulaire">
<input type="hidden" name="sAction" value="store" />
<div id="fiche">
<table class="formLayout" cellspacing="3">
<% 
int iIdx = 1;
for(Configuration news : vNews){ 
%>
<!-- 
<tr>
	<td class="pave_cellule_gauche">Code :</td>
	<td class="pave_cellule_droite"><%= news.getIdString()%></td>
</tr>
 -->
<tr>
	<td class="pave_cellule_gauche">News :</td>
	<td class="pave_cellule_droite">
		<div
			style="text-align: right;cursor: pointer;" 
			onclick="javascript:removeNews('<%= news.getIdString()%>')" >
			Supprimer cette news
			<img alt="" src="<%= rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE %>" />
		</div>

		<textarea rows="30" cols="100" 
			name="<%= news.getIdString()%>" 
			id="<%= news.getIdString()%>" ><%= news.getDescription() %></textarea>
	</td>
</tr>
<tr>
	<td class="pave_cellule_gauche">&nbsp;</td>
	<td class="pave_cellule_droite">


	<input type="radio" 
		checked="checked"
		name="sendto_<%= news.getIdString() %>" 
		id="sendto_<%= news.getIdString() %>_all" 
		value="all" />A tout le monde <br/>
	<input type="radio" 
		name="sendto_<%= news.getIdString() %>" 
		id="sendto_<%= news.getIdString() %>_login" 
		value="login" />
		Uniquement à (identifiant)
		<input type="text"
			id="sendto_login_<%= news.getIdString() %>" 
			name="sendto_login_<%= news.getIdString() %>" />
		<br/>
	<button type="button" onclick="javascript:sendNewsToAllUser('<%= news.getIdString() %>')" >Envoyer</button>
	<button type="button" onclick="javascript:removeNewsToAllUser('<%= news.getIdString() %>')" >Retirer</button>
	<button type="button" onclick="javascript:displayNewsToAllUser('<%= news.getIdString() %>')" >Voir les utilisateurs sélectionnés</button>
	</td>
</tr>
<%
	iIdx++;
} 
%>
</table>
</div>
<div id="fiche_footer">
	<button type="button" onclick="javascript:createNews()" >Ajouter une news</button>
	<button type="submit" >Valider</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
<%
	ConnectionManager.closeConnection(conn);
%>