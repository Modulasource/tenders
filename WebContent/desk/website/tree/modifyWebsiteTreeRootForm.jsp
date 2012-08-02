<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.InputStreamDownloader"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.coin.util.Outils"%>
<% 
String sTitle = "Page : "; 
Connection conn = ConnectionManager.getConnection();


WebsiteTreeRoot item = null;
JSONObject jsonData =  null;
long lId = HttpUtil.parseLong("lIdWebsiteTreeRoot", request, 0);
boolean bButtonAdd = HttpUtil.parseBoolean("bButtonAdd", request, false);

if (lId>0){
	try{item = WebsiteTreeRoot.getWebsiteTreeRoot(lId);
	jsonData = item.toJSONObject();
	}catch(Exception e){e.printStackTrace();}
}
if (item==null){
	item = new WebsiteTreeRoot();
	jsonData = new JSONObject();
}
HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
pave.bIsForm = true;

String sPageUseCaseId = "IHM-DESK-WEBSITE-TREEROOT"; //"IHM-DESK-FONDATION-LECLERC-GERER-DOCUMENTS";

sTitle += "<span class=\"altColor\">Modifier une arborescence</span>"; 
sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

String sURLForm = response.encodeURL(rootPath+"desk/website/tree/displayAllWebsiteTree.jsp");
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/WebsiteTreeRoot.js"></script>
</head>
<body>
<script type="text/javascript">
var jsonData = <%= jsonData %>;

mt.config.enableAutoLoading = false;

function populate(){
//name, url, meta_tags, google_analytics
	$("sName").value=jsonData.sName || "";
	$("sUrl").value=jsonData.sUrl || "";
	$("sMetaTags").value=jsonData.sMetaTags || "";
	$("sGoogleAnalytics").value=jsonData.sGoogleAnalytics || "";
	$("sRobotsTxt").value=jsonData.sRobotsTxt || "";
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
        try{obj.sUrl = $("sUrl").value;}catch(e){}
        try{obj.sMetaTags = $("sMetaTags").value;}catch(e){}
        try{obj.sGoogleAnalytics = $("sGoogleAnalytics").value;}catch(e){}
        try{obj.sRobotsTxt = $("sRobotsTxt").value;}catch(e){}
        
        WebsiteTreeRoot.storeFromJSONString(Object.toJSON(obj), function(lId){
            if (lId>0) {
	        	location.href="<%=response.encodeURL("displayAllWebsiteTree.jsp") %>";
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
						<div style="font-weight: bold;">Nom de l'arborescence : </div>
						<input type="text" id="sName" name="sName" class="dataType-notNull" style="width: 350px;"/>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">URL de l'arborescence : </div>
						<input type="text" id="sUrl" name="sUrl" style="width: 350px;" />
					</td>
				</tr>
			</table>
			</td>
			<td style="vertical-align: top;">
			<table class="formLayout" >
				<tr>
					<td>
						<div style="font-weight: bold;">Balises metas : </div>
						<textarea id="sMetaTags" name="sMetaTags" style="width: 350px;height: 150px;"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Balises Google Analytics : </div>
						<textarea id="sGoogleAnalytics" name="sGoogleAnalytics" style="width: 350px;height: 150px;"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<div style="font-weight: bold;">Robots.txt : </div>
						<textarea id="sRobotsTxt" name="sRobotsTxt" style="width: 350px;height: 50px;"></textarea>
						<br />Exemple : Sitemap: http://www.nom-du-site.com/sitemap.xml
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
		response.encodeURL("displayAllWebsiteTree.jsp") %>');" >
			Annuler</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="mt.website.WebsiteTreeRoot"%>
</html>
<%

	ConnectionManager.closeConnection(conn);

%>