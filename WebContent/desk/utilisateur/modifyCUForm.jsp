<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*, org.coin.bean.html.*,java.util.*" %>
<% 
	String sTitle = "Cas d'utilisation : "; 
	
	Vector<UseCase> vCU = UseCase.getAllUseCase();
	
	JSONArray json_cu = new JSONArray();
	for (UseCase cu : vCU) {
		JSONObject obj = new JSONObject();
		obj.put("value",cu.getName());
		obj.put("data",cu.getIdString());
		json_cu.put(obj);
	}
	
	UseCase item = null;
	
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-4";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new UseCase();
		sTitle += "<span class=\"altColor\">Nouveau Cas d'utilisation</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = UseCase.getUseCase(request.getParameter("sId"));
		sTitle += "<span class=\"altColor\">"+item.getIdString()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;

	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

%>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/css/calendar.css" media="screen" />
<script>
var cu = <%=json_cu%>;
function isCodeExist(code) {
	if ($('sOldId').value!=code) {
		for (var z=0; z<cu.length; z++) {
			if (cu[z].data==code) return true;
		}
	}
	return false;
}
function onPageLoad() {
	$('form').onsubmit = function() {
		var code = $('sId').value;
		if(code != ""){
			if (isCodeExist(code)) {
				$('divError').innerHTML = "Ce code est déjà utilisé";
				return false;
			} 
			else {
				return true;
			}
		}
		else {
				$('divError').innerHTML = "Vous devez saisir un code";
				return false;
			}
	}
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

<form id="form" action="<%= response.encodeURL("modifyCU.jsp") %>" >
<div id="fiche">
<div class="rouge" style="text-align:left" id="divError"></div>
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<input id="sOldId" type="hidden" name="sOldId" value="<%= item.getIdString()%>" />
		<table class="formLayout" cellspacing="3">
			<%= pave.getHtmlTrInput("Code :", "sId", item.getIdString(),"size=\"100\"") %>
			<%= pave.getHtmlTrInput("Libelle :", "sName", item.getName(),"size=\"100\"") %>
		</table>
</div>
<div id="fiche_footer">
	<button type="submit" ><%= localizeButton.getValueSubmit() %></button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath+"desk/utilisateur/modifyCU.jsp?sAction=remove&sId=" + item.getIdString() ) 
			%>');" ><%= localizeButton.getValueDelete() %></button>
	<%} %>
<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath+"desk/utilisateur/afficherTousCasUtilisation.jsp") %>');" ><%= localizeButton.getValueCancel() %></button>
</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
</html>
