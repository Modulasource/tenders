<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%@ page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.Language"%>
<%

	String sTitle = "Localisation du site";

	JSONArray languages = new JSONArray();
	Vector<Language> vLanguage = Language.getAllStatic();
	for (Language l:vLanguage) {
		JSONObject obj = new JSONObject();
		obj.put("value",l.getLabel());
		obj.put("data",l.getId());
		languages.put(obj);
	}
	
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CaptionCategory.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CaptionLabel.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CaptionValue.js"></script>
<style>
.caption_cat {
	padding:2px 2px 2px 5px;
	color:#36C;
	font-weight:bold;
	background-color:#EFF5FF;
	border-right:1px solid #DDD;
	border-bottom:1px solid #DDD;
	margin-bottom:1px;
}
.caption_label {
	padding:2px 2px 2px 5px;
	color:#333;
	background-color:#EEE;
	border-right:1px solid #DDD;
	border-bottom:1px solid #DDD;
	margin-bottom:1px;
}
.cell_lang {
	background-color:#EFFFF5;
	border-right:1px solid #DDFFEA;
	border-bottom:1px solid #DDFFEA;
	padding:2px;
}
.cell_value {
	background-color:lightyellow;
	padding:2px;
	cursor:pointer;
}
</style>
<script>

var languages = <%=languages%>;

function displayModifyLabelModal(item, node) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de label :</td>'+
					'<td class="frame"><input type="text" value="'+item.label+'"/></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Modification d'un label", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	input.focus();
	input.onkeyup = function() {
		this.value = this.value.cleanString();
	}
	modal.onValidate = function() {
		if (input.value!="") {
			item.label = input.value;
			node.innerHTML = item.label;
			CaptionLabel.updateFromId(item.id, item.label);
		}
	}
}

function displayModifyCatModal(item, node) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de catégorie :</td>'+
					'<td class="frame"><input type="text" value="'+item.name+'"/></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Modification d'une catégorie", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	input.focus();
	input.onkeyup = function() {
		this.value = this.value.cleanString();
	}
	modal.onValidate = function() {
		if (input.value!="") {
			item.name = input.value;
			node.innerHTML = item.name;
			CaptionCategory.updateFromId(item.id, item.name);
		}
	}	
}

function addTranslationModal(node, item, catLabel) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Label :</td>'+
					'<td class="frame">'+catLabel+"."+item.label+'</td>'+
				'</tr>'+
				'<tr>'+
					'<td class="label">Langue :</td>'+
					'<td class="frame"><select><option>Chargement...</option></select></td>'+
				'</tr>'+			
				'<tr>'+
					'<td class="label">Contenu :</td>'+
					'<td class="frame"><textarea style="width:200px"></textarea></td>'+
				'</tr>'+
				'</table>';
	var modal = new Modal("Ajout d'une traduction", sHTML);
	var textarea = modal.content.getElementsByTagName("textarea")[0];
	textarea.focus();
	
	var buttons = modal.divModal.getElementsByTagName("button");
	
	var select = modal.content.getElementsByTagName("select")[0];
	mt.html.setSuperCombo(select);
	select.disabled = true;
	buttons[0].disabled = true;
	buttons[1].disabled = true;
	
	CaptionValue.getDataSetFromLabel(item.id, function(r){
		if (r.length==languages.length) {
			modal.remove();
			alert("Chaque langue disponible à déjà une traduction");
		} else {
			var filteredLanguages = [];	
			languages.each(function(item){
				var isExist = false;
				r.each(function(item2){
					if (item.data==item2.idLanguage) isExist = true;
				});
				if (!isExist) filteredLanguages.push({value:item.value, data:item.data});
			});
			select.populate(filteredLanguages);
			select.disabled = false;
			buttons[0].disabled = false;
			buttons[1].disabled = false;
		}
	});
		
	modal.onValidate = function() {
		var newObj = {};
		CaptionValue.addNewValue(item.id, select.value, textarea.value, function(id) {
			newObj.id = id;
		});
		newObj.idLanguage = select.value;
		newObj.language = select.getSelectedText();
		newObj.value = textarea.value;
		addTranslation(node, newObj, catLabel, item.label);
	}
}

function displayTranslationModal(node, item, label) {

	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Label :</td>'+
					'<td class="frame">'+label+'</td>'+
				'</tr>'+
				'<tr>'+
					'<td class="label">Langue :</td>'+
					'<td class="frame"><strong>'+item.language+'</strong></td>'+
				'</tr>'+
				'<tr>'+
					'<td class="label">Contenu :</td>'+
					'<td class="frame"><textarea style="width:200px">'+item.value+'</textarea></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Traduction", sHTML);
	var textarea = modal.content.getElementsByTagName("textarea")[0];
	textarea.focus();
	modal.onValidate = function() {
		item.value = textarea.value;
		node.innerHTML = item.value;
		CaptionValue.updateValueFromId(item.id, item.value);
	}

}

function addTranslation(node, item, catLabel, itemLabel) {
	var div = document.createElement("div");
	var table = document.createElement("TABLE");
	table.className = "fullWidth";
	var grid = document.createElement("TBODY");
	
	var line = document.createElement("tr");
	var cellLang = document.createElement("td");
	cellLang.style.width = "80px";
	var divLang = document.createElement("div");
	divLang.className = "cell_lang";
	divLang.innerHTML = item.language;
	cellLang.appendChild(divLang);
	var cellValue = document.createElement("td");			
	cellValue.className = "cell_value";
	cellValue.innerHTML = item.value;
	cellValue.onmouseover = function() {
		this.style.backgroundColor = "#FFFFB6";
	}
	cellValue.onmouseout = function() {
		this.style.backgroundColor = "lightyellow";
		this.style.border = "none";
	}
	
	cellValue.onclick = function() {
		displayTranslationModal(this, item, catLabel+"."+itemLabel.label);
	}
	
	var cellDelete = document.createElement("td");
	cellDelete.style.textAlign = "right";
	cellDelete.style.width = "16px";
	var imgDelete = document.createElement("img");
	imgDelete.className = "pointer";
	imgDelete.onclick = function() {
		if (confirm("Etes-vous sûr de vouloir effacer cette traduction \""+item.language+"\" ? c'est votre dernier mot ?")) {
			CaptionValue.removeFromId(item.id);
			Element.remove(line);
		}
	}
	imgDelete.src = "<%=rootPath%>images/icons/delete.gif";
	cellDelete.appendChild(imgDelete);
	
	line.appendChild(cellLang);
	line.appendChild(cellValue);
	line.appendChild(cellDelete);
	grid.appendChild(line);
	
	table.appendChild(grid);
	node.appendChild(table);
}

function loadTranslations(itemLabel, node, catLabel) {
	node.innerHTML = "chargement en cours";
	CaptionValue.getDataSetFromLabel(itemLabel.id, function(r){
		node.innerHTML = "";
		r.each(function(item){
			addTranslation(node, item, catLabel, itemLabel);
		});
	});
}

function addLabel(node, item, catLabel) {
	var div = document.createElement("div");
				
	var itemTable = document.createElement("TABLE");
	itemTable.className = "caption_label fullWidth";
	var grid = document.createElement("TBODY");
	var line = document.createElement("tr");
	
	var cell1 = document.createElement("td");
	var link = document.createElement("a");
	link.innerHTML = item.label;
	link.href = "javascript:void(0)";
	cell1.appendChild(link);
	
	var cell2 = document.createElement("td");
	cell2.style.textAlign = "right";
	
	var imgAdd = document.createElement("img");
	imgAdd.style.paddingRight = "4px";
	imgAdd.title = "Ajouter une traduction";
	imgAdd.className = "pointer";
	imgAdd.onclick = function() {
		openBranch(true);
		addTranslationModal(divChilds, item, catLabel);
	}
	imgAdd.src = "<%=rootPath%>images/icons/plus_purple.gif";
	
	var imgModify = document.createElement("img");
	imgModify.style.paddingRight = "2px";
	imgModify.className = "pointer";
	imgModify.onclick = function() {
		displayModifyLabelModal(item, link);
	}
	imgModify.src = "<%=rootPath%>images/icons/application_edit.gif";
	
	var imgDelete = document.createElement("img");
	imgDelete.className = "pointer";
	imgDelete.onclick = function() {
		if (confirm("Etes-vous sûr de vouloir effacer ce label \""+item.label+"\" ? les traductions associées seront supprimées, c'est votre dernier mot ?")) {
			CaptionLabel.removeFromId(item.id);
			Element.remove(div);
		}
	}
	imgDelete.src = "<%=rootPath%>images/icons/delete.gif";
	cell2.appendChild(imgAdd);
	cell2.appendChild(imgModify);
	cell2.appendChild(imgDelete);
	
	line.appendChild(cell1);
	line.appendChild(cell2);
	grid.appendChild(line);
	itemTable.appendChild(grid);
	
	var divChilds = document.createElement("div");
	divChilds.style.paddingLeft = "15px";

	function openBranch(open) {
		if (!divChilds.hasChildNodes()){
			loadTranslations(item, divChilds, catLabel);
		} else {
			if (divChilds.style.display == "none" || open) {
				divChilds.style.display = "block";
			} else {
				divChilds.style.display = "none";
			}
		}
	}
	
	link.onclick = function() {
		openBranch();
	}
	
	div.appendChild(itemTable);
	div.appendChild(divChilds);
	
	node.appendChild(div);
}

function displayAddLabelModal(node, catId, catName) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de label :</td>'+
					'<td class="frame"><input type="text" /></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Ajout d'un label", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	input.focus();
	input.onkeyup = function() {
		this.value = this.value.cleanString();
	}
	modal.onValidate = function() {
		if (input.value!="") {
			var item = {};
			item.label = input.value;
			CaptionLabel.addNew(catId, item.label, function(id){
				item.id = id;
			});
			addLabel(node, item, catName);
		}
	}
}

function displayAddCatModal(node, parentId, catName) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de catégorie :</td>'+
					'<td class="frame"><input type="text" /></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Ajout d'une catégorie", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	input.focus();
	input.onkeyup = function() {
		this.value = this.value.cleanString();
	}
	modal.onValidate = function() {
		if (input.value!="") {
			var item = {};
			item.name = input.value;
			CaptionCategory.addNew(parentId, item.name, function(id){
				item.id = id;
			});
			addCategory(node, item, catName+"."+item.name);
		}
	}
}


function addCategory(node, item, catName) {
	var cn = (catName=="") ? item.name : catName+"."+item.name;

	var div = document.createElement("div");
	var itemTable = document.createElement("TABLE");
	itemTable.className = "caption_cat fullWidth";
	var grid = document.createElement("TBODY");
	var line = document.createElement("tr");
	
	var cell1 = document.createElement("td");
	var link = document.createElement("a");
	link.innerHTML = item.name;
	link.href = "javascript:void(0)";
	cell1.appendChild(link);
	
	var cell2 = document.createElement("td");
	cell2.style.textAlign = "right";
	
	var imgAddCat = document.createElement("img");
	imgAddCat.style.paddingRight = "2px";
	imgAddCat.title = "Ajouter une catégorie";
	imgAddCat.className = "pointer";
	imgAddCat.onclick = function() {
		displayAddCatModal(divChilds, item.id, cn);
	}
	imgAddCat.src = "<%=rootPath%>images/icons/plus_blue.gif";
	
	var imgAddLabel = document.createElement("img");
	imgAddLabel.style.paddingRight = "3px";
	imgAddLabel.title = "Ajouter un label";
	imgAddLabel.className = "pointer";
	imgAddLabel.onclick = function() {
		displayAddLabelModal(divChilds, item.id, catName);
	}
	imgAddLabel.src = "<%=rootPath%>images/icons/plus.gif";
	
	var imgModify = document.createElement("img");
	imgModify.style.paddingRight = "2px";
	imgModify.className = "pointer";
	imgModify.onclick = function() {
		displayModifyCatModal(item, link);
	}
	imgModify.src = "<%=rootPath%>images/icons/application_edit.gif";
	var imgDelete = document.createElement("img");
	imgDelete.className = "pointer";
	imgDelete.onclick = function() {
		if (confirm("Etes-vous sûr de vouloir effacer cette catégorie \""+item.name+"\" ? les sous catégories, les labels et les traductions associés seront supprimés, c'est votre dernier mot ?")) {
			CaptionCategory.removeFromId(item.id);
			Element.remove(div);
		}
	}
	imgDelete.src = "<%=rootPath%>images/icons/delete.gif";
	
	cell2.appendChild(imgAddCat);
	cell2.appendChild(imgAddLabel);
	cell2.appendChild(imgModify);
	cell2.appendChild(imgDelete);

	line.appendChild(cell1);
	line.appendChild(cell2);
	grid.appendChild(line);
	itemTable.appendChild(grid);

	var divChilds = document.createElement("div");
	divChilds.style.paddingLeft = "15px";
	
	link.onclick = function() {
		if (!divChilds.hasChildNodes()){
			loadCategory(item.id, divChilds, cn);
		} else {
			if (divChilds.style.display == "none") {
				divChilds.style.display = "block";
			} else {
				divChilds.style.display = "none";
			}
		}
	}
	
	div.appendChild(itemTable);
	div.appendChild(divChilds);
	node.appendChild(div);	
}

function loadCategory(idCat, node, catName) {
	node.innerHTML = "chargement en cours";
	CaptionCategory.getDataSetFromParent(idCat, function(r){
		node.innerHTML = "";
		r.each(function(item) {
			switch(item.type) {		
				case 'cat':
					addCategory(node, item, catName);
					break;
				case 'label':
					addLabel(node, item, catName);
					break;
			}
		});
	});
}

onPageLoad = function() {
	loadCategory(0, $('cat_tree'), "");
}

</script>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
	
	<div id="cat_tree"></div>
	
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>

</html>