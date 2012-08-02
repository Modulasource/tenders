<%@ include file="/include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Type d'attribut";
%>

<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentAttributeType.js"></script>
<script type="text/javascript">

var categories = <%=GedDocumentAttributeType.getJSONArray()%>;

function addNew(node, item) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de label :</td>'+
					'<td class="frame"><input type="text" /></td>'+
				'</tr>'+
				'<tr>'+
					'<td class="label">Descriptif :</td>'+
					'<td class="frame"><textarea></textarea></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Nouveau type", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	var textarea = modal.content.getElementsByTagName("textarea")[0];
	input.focus();
	
	modal.onValidate = function() {
		if (input.value.trim()!="") {
			var newItem = {};
			newItem.sName = input.value.trim();
			newItem.sDescription = textarea.value.trim();
			addItemNode(newItem, $('placeHolder'));
			
			GedDocumentAttributeType.storeFromJSONString(Object.toJSON(newItem), function(newId) {
				newItem.lId = newId;
			});		
		}
	}
}

function edit(node, item) {

	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de label :</td>'+
					'<td class="frame"><input type="text" value="'+item.sName+'"/></td>'+
				'</tr>'+
				'<tr>'+
					'<td class="label">Descriptif :</td>'+
					'<td class="frame"><textarea>'+item.sDescription+'</textarea></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Modification d'un label", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	var textarea = modal.content.getElementsByTagName("textarea")[0];
	input.focus();
	
	modal.onValidate = function() {
		if (input.value.trim()!="") {
			item.sName = input.value.trim();
			node.innerHTML = item.sName;
			item.sDescription = textarea.value.trim();
			GedDocumentAttributeType.storeFromJSONString(Object.toJSON(item));
		}
	}

}

function removeAllFromParentId(id) {
	$$('.admin_list_item').each(function(item){
		if (item.data.lIdGedDocumentAttributeTypeParent==id) Element.remove(item);
	});
}

function addItemNode(item, placeHolder) {
	var div = document.createElement("div");
	div.className = "admin_list_item";
	div.style.marginLeft = (item.lIdGedDocumentAttributeTypeParent!=0) ? "20px" : 0;
	div.data = item;
	
	var span = document.createElement("span");
	span.style.fontWeight = (item.lIdGedDocumentAttributeTypeParent==0) ? "bold" : "normal";
	span.innerHTML = item.sName;

	var divOptions = document.createElement("div");
	divOptions.className = "admin_list_item_options";

	var imgDelete = document.createElement("img");
	imgDelete.className = "admin_list_item_options_img";
	imgDelete.src = "<%=rootPath%>images/icons/delete.gif";
	imgDelete.onclick = function() {
		var sMessage = "Etes-vous sûr de vouloir supprimer le type "+item.sName+" ?";
		sMessage += "\n\nAttention, les attributs associés à ce type seront aussi supprimées";
		if (confirm(sMessage)) {
			GedDocumentAttributeType.removeFromId(item.lId);
			//removeAllFromParentId(item.lId);
			Element.remove(div);
		}
	}
	
	var imgEdit = document.createElement("img");
	imgEdit.className = "admin_list_item_options_img";
	imgEdit.src = "<%=rootPath%>images/icons/application_edit.gif";
	imgEdit.onclick = function() {
		edit(span, item);
	}
	
	var imgAddSubCategory = document.createElement("img");
	imgAddSubCategory.className = "admin_list_item_options_img";
	imgAddSubCategory.src = "<%=rootPath%>images/icons/plus.gif";
	imgAddSubCategory.onclick = function() {
		addNew(div, item);
	}
	
	//if (item.lIdGedDocumentAttributeTypeParent==0) divOptions.appendChild(imgAddSubCategory);
	divOptions.appendChild(imgEdit);
	divOptions.appendChild(imgDelete);
	
	div.appendChild(span);
	div.appendChild(divOptions);
	
	placeHolder.appendChild(div);
}

function populate() {

	var placeHolder = $('placeHolder');

	categories.each(function(item){
		addItemNode(item, placeHolder);
	});
	//alert("populate");
}

onPageLoad = populate;

</script>
</head>
<body>
<% long lIdPersonnePhysique = sessionUser.getIdIndividual(); %>

<div class="ficheTablePadding">
<table id="ficheTable" cellspacing="0" cellpadding="0" class="fullWidth">
	<tr>
		<td></td>
		<td class="imgTop"></td>
		<td></td>
	</tr>
	<tr>
		<td class="imgCenterLeft"></td>
		<td>
			<div class="ficheFrame">
				<style>
					.sb-inner {background-color:#EAEDF3}
					.sb-border {background-color:#A4BCD2}
				</style>
				<table cellspacing="0" cellpadding="0" id="pageTitleWrapper" style="margin:0 auto"><tr><td>
					<div class="roundCorners" style="padding:4px 10px 4px 10px"><span id="pageTitle"><%=sTitle%><span></div>
				</td></tr></table>
<div id="fiche">

<div class="center">
	<img class="middleAlign" src="<%=rootPath %>images/icons/plus_blue.gif" />&nbsp;<a href="javascript:addNew()" class="middleAlign">Ajouter un type</a>
</div>
<div id="placeHolder" class="admin_list"></div>

</div> <!-- end fiche -->
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ged.GedDocumentAttributeType"%>
</html>