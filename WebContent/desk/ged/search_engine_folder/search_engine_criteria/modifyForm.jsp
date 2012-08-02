<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page language="java" %>
<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.json.JSONObject"%>
<% 
	String sTitle = "Critère de recherche";
	String sWebsitePublicationWord = "fiche";
	boolean bKindFemaleElement = true;

	SearchEngineCriteria item = null;
	JSONObject jsonData = null;
	String sPageUseCaseId = "XXX";
	
	long lId = HttpUtil.parseLong("lId", request, 0);
	
	String sAction = HttpUtil.parseString("sAction", request, "create");
	if (lId>0){
		try{item = SearchEngineCriteria.getSearchEngineCriteria(lId);
			jsonData = item.toJSONObject();
		}catch(Exception e){e.printStackTrace();}
	}
	if (item==null){
		item = new SearchEngineCriteria();
		jsonData = new JSONObject();
	}
	

%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SearchEngineCriteria.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/dragdrop.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/livepipe.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/window.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentSelection.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/component/calendar/calendar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath %>include/js/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
</head>
<body>
<script type="text/javascript">
var jsonData = <%= jsonData %>;
var jsonSearchEngineCriteriaType = <%= SearchEngineCriteriaType.getJSONArray() %>

function removeItem(){
	if (confirm("Supprimer cette fiche ?")){
		$('submit_btn').disabled = true;	
		$('submit_btn').innerHTML = "Chargement en cours...";
		$('remove_btn').disabled = true;
		var obj = {};
		obj.lId = $("lId").value;
		SearchEngineCriteria.removeFromIdJSON($("lId").value, function(bSuccess){
			if (bSuccess) {
				location.href = "<%=response.encodeRedirectURL("displayAll.jsp")%>";
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
	}
	$('lId').value = jsonData.lId || "";
	$('sName').value = jsonData.sName || "";
	$('lIdSearchEngineCriteriaType').populate(jsonSearchEngineCriteriaType, jsonData.lIdSearchEngineCriteriaType, "lId", "sLabel");

	$('sDescription').value = jsonData.sDescription || "";
	$('sIconPath').value = jsonData.sIconPath || "";
}
onPageLoad = function() {
	populate();
	$("formDocument").isValid = function(){
		var bValid = true;
		return bValid;
	}
	$("formDocument").onValidSubmit = function() {
		$('submit_btn').disabled = true;	
		$('submit_btn').innerHTML = "Chargement en cours...";
		$('remove_btn').disabled = true;
		
		var obj = {};
		obj.lId = $("lId").value;
		obj.sName = $("sName").value;
		obj.lIdSearchEngineCriteriaType = $("lIdSearchEngineCriteriaType").value;
		obj.sDescription = $("sDescription").value;
		obj.sIconPath = $("sIconPath").value;

		SearchEngineCriteria.storeFromJSONString(Object.toJSON(obj), function(lId){
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
				Composition de la fiche
				</td>
			</tr>
			<tr>
				<td class="label">Nom * :</td>
				<td class="value"><input id="sName" name="sName" maxlength="250" class="dataType-notNull" style="width:250px;" /></td>
			</tr>
			<tr>
				<td class="label">Type :</td>
				<td class="value"><select id="lIdSearchEngineCriteriaType"></select></td>
			</tr>
			<tr>
				<td class="label">Description :</td>
				<td class="value" style="width:550px;">
					<textarea id="sDescription" name="sDescription" style="width: 75%;height: 100px;"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label">Icone (chemin) :</td>
				<td class="value"><input id="sIconPath" name="sIconPath" maxlength="250" class="" style="width:350px;" /></td>
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

<%@page import="mt.searchenginefolder.SearchEngineCriteria"%>
<%@page import="mt.searchenginefolder.SearchEngineCriteriaType"%></html>