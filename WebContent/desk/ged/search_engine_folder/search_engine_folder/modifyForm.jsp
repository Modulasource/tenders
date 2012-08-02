<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page language="java" %>
<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.json.JSONObject"%>
<% 
	String sTitle = "Dossier de recherche";
	String sWebsitePublicationWord = "fiche";
	boolean bKindFemaleElement = true;

	SearchEngineFolder item = null;
	JSONObject jsonData = null;
	String sPageUseCaseId = "XXX";
	
	long lId = HttpUtil.parseLong("lId", request, 0);
	
	long lIdSearchEngineCriteriaType = HttpUtil.parseLong("lIdSearchEngineCriteriaType", request, SearchEngineCriteriaType.TYPE_PARAPHEUR_GED);
	
	String sAction = HttpUtil.parseString("sAction", request, "create");
	if (lId>0){
		try{item = SearchEngineFolder.getSearchEngineFolder(lId);
			jsonData = item.toJSONObject();
		}catch(Exception e){e.printStackTrace();}
	}
	if (item==null){
		item = new SearchEngineFolder();
		jsonData = new JSONObject();
	}
	

%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/SearchEngineFolder.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/orderingComponent.js"></script>
</head>
<body>
<script type="text/javascript">
var jsonData = <%= jsonData %>;
var jsonAllElements = <%= SearchEngineCriteria.getJSONArrayFromType(lIdSearchEngineCriteriaType).toString() %>;
var jsonSelectedElements = <%= SearchEngineFolderCriteria.getJSONArrayFromIdSearchEngineFolder(lId).toString() %>; 
var order_selection;

function removeItem(){
	if (confirm("Supprimer cette fiche ?")){
		$('submit_btn').disabled = true;	
		$('submit_btn').innerHTML = "Chargement en cours...";
		$('remove_btn').disabled = true;
		var obj = {};
		obj.lId = $("lId").value;
		SearchEngineFolder.removeFromIdJSON($("lId").value, function(bSuccess){
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
	$('sTitle').value = jsonData.sTitle || "";
	$('sCode').value = jsonData.sCode || "";
	$('sCodeBody').value = jsonData.sCodeBody || "";

	var arrAllElement = [];
	jsonAllElements.each(function(item){
	    var divImg = document.createElement("div");
	    //divImg.style.maxHeight = "64px";
	    //divImg.style.border = "solid blue 1px";
	    //divImg.style.marginRight = "auto";
	    //divImg.style.marginLeft = "auto";
	    
	    var img = document.createElement("img");
	    if (item.sIconPath.length>0){
		    img.src = "<%= rootPath %>"+item.sIconPath;
	    }else{
	    	img.src = "<%= rootPath+"images/icons/64x64/document.png" %>";
	    }
	    img.alt = img.title = item.sName;
	    divImg.appendChild(img);

		var label = document.createElement("label");
		label.innerHTML = item.sName;
		label.style.marginLeft = "2px";
		divImg.appendChild(label);
	    
		arrAllElement.push({"lId":item.lId,"sLabel":divImg});
	});
	var arrSelection = [];
	jsonSelectedElements.each(function(item){
		arrSelection.push(item.lIdSearchEngineCriteria);
	});
	if (jsonData.lId){
		order_selection = new orderingComponent("orderingCpt", arrAllElement, arrSelection, "Liste des critères disponibles", "Liste des critères sélectionnés");
	}
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
		obj.sTitle = $("sTitle").value;
		obj.sCode = $("sCode").value;
		obj.sCodeBody = $("sCodeBody").value;
		if (jsonData.lId){
			try{obj.sOrderList = order_selection.getSelectionToString();}catch(e){}
		}else{
			obj.sOrderList = "";
		}
		SearchEngineFolder.storeFromJSONString(Object.toJSON(obj), function(lId){
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
				<td class="label">Titre * :</td>
				<td class="value"><input id="sTitle" name="sTitle" maxlength="250" class="dataType-notNull" style="width:250px;" /></td>
			</tr>
			<%if (lId>0){ %>
			<tr>
				<td class="label">Critères de recherche :</td>
				<td class="value" style="width:550px;">
					<div id="orderingCpt"></div>
				</td>
			</tr>
			<%} %>
			<tr>
				<td class="label">Code (Javascript) :</td>
				<td class="value" style="width:550px;">
					<textarea id="sCode" name="sCode" style="width: 100%;height: 350px;"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label">Code (Body) :</td>
				<td class="value" style="width:550px;">
					<textarea id="sCodeBody" name="sCodeBody" style="width: 100%;height: 350px;"></textarea>
				</td>
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

<%@page import="mt.searchenginefolder.SearchEngineFolder"%>

<%@page import="mt.searchenginefolder.SearchEngineCriteria"%>
<%@page import="mt.searchenginefolder.SearchEngineCriteriaType"%>
<%@page import="mt.searchenginefolder.SearchEngineFolderCriteria"%></html>