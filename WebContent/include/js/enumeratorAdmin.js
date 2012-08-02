var placeHolder;

function addNew(node, item) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de label :</td>'+
					'<td class="frame"><input type="text" /></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Nouvel élément", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	input.focus();
	
	modal.onValidate = function() {
		if (input.value.trim()!="") {
			var newItem = {};
			newItem.sLabel = input.value.trim();
			addItemNode(newItem, placeHolder);
			window[className].storeFromJSONString(Object.toJSON(newItem), function(newId) {
				newItem.lId = newId;
			});
		}
	}
}

function edit(node, item) {
	var sHTML = '<table class="formLayout" cellspacing="3">'+
				'<tr>'+
					'<td class="label">Nom de label :</td>'+
					'<td class="frame"><input type="text" value="'+item.sLabel+'"/></td>'+
				'</tr>'+
				'</table>';
	
	var modal = new Modal("Modification d'un label", sHTML);
	var input = modal.content.getElementsByTagName("input")[0];
	input.focus();
	
	modal.onValidate = function() {
		if (input.value.trim()!="") {
			item.sLabel = input.value.trim();
			node.innerHTML = item.sLabel;
			window[className].storeFromJSONString(Object.toJSON(item));
		}
	}
}

function addItemNode(item, placeHolder) {
	var div = document.createElement("div");
	div.className = "admin_list_item";
	div.data = item;
	
	var span = document.createElement("span");
	span.innerHTML = item.sLabel;

	var divOptions = document.createElement("div");
	divOptions.className = "admin_list_item_options";

	var imgDelete = document.createElement("img");
	imgDelete.className = "admin_list_item_options_img";
	imgDelete.src = rootPath+"images/icons/delete.gif";
	imgDelete.onclick = function() {
		if (confirm("Etes-vous sûr de vouloir supprimer "+item.sLabel+" ?")) {
			window[className].removeFromId(item.lId);
			Element.remove(div);
		}
	}
	
	var imgEdit = document.createElement("img");
	imgEdit.className = "admin_list_item_options_img";
	imgEdit.src = rootPath+"images/icons/application_edit.gif";
	imgEdit.onclick = function() {
		edit(span, item);
	}
	
	divOptions.appendChild(imgEdit);
	divOptions.appendChild(imgDelete);
	
	div.appendChild(span);
	div.appendChild(divOptions);
	
	placeHolder.appendChild(div);
}

function populate() {
	placeHolder = $('placeHolder');
	placeHolder.className = "admin_list";
	
	var divAdd = document.createElement("div");
	divAdd.className = "center";
	
	var img = document.createElement("img");
	img.src = rootPath+"images/icons/plus_blue.gif";
	img.className = "middleAlign";
	
	var link = document.createElement("a");
	link.href = "javascript:addNew()";
	link.className = "middleAlign";
	link.innerHTML = "Ajouter un élément";
	link.style.marginLeft = "5px";
	
	divAdd.appendChild(img);
	divAdd.appendChild(link);
	
	placeHolder.parentNode.insertBefore(divAdd, placeHolder);
	
	items.each(function(item){
		addItemNode(item, placeHolder);
	});
}

Event.observe(window, 'load', populate);