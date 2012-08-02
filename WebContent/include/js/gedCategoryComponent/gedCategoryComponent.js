function gedCategoryComponent(placeHolder, dataSet, lIdLanguage) {
	var self = this;
	this.selections = [];
	this.lIdLanguage = lIdLanguage ? lIdLanguage : 1;
	
	this.emptyMsg = '<div style="text-align:center;color:#BBB;font-size:20px;margin-top:70px">' +
		captionScriptGEC.message.selectItems + '</div>';
	
	this.updateSelection = function() {
		this.divSelection.innerHTML = (this.selections.length==0) ? this.emptyMsg : '';
		this.selections.each(function(item){
			var table = document.createElement("table");
			table.style.padding = "0";
			table.setAttribute("cellspacing", 0);
			table.style.width = "100%";
			table.style.marginBottom = "1px";
			table.style.borderBottom = "1px solid #ADB8D8";
			table.style.borderRight = "1px solid #ADB8D8";
			table.style.backgroundColor = "#EDEFF2";
			var tbody = document.createElement("tbody");
			var tr = document.createElement("tr");
			
			var td1 = document.createElement("td");
			td1.style.padding = "4px 3px 4px 6px";
			
			if (item.lIdGedCategoryParent==0) {
				td1.innerHTML = "<b>"+item.sLabel+"</b>";
			} else {
				td1.innerHTML = "<b>"+item.sLabelGedCategoryParent+"</b> / "+item.sLabel;
			}
				
			tr.appendChild(td1);
			
			var td2 = document.createElement("td");
			td2.style.width = "16px";
			td2.style.padding = "2px 2px 0 0";
			var imgDelete = document.createElement("img");
			imgDelete.src = rootPath+"images/icons/delete.gif";	
			imgDelete.style.cursor = "pointer";
			imgDelete.onclick = function() {
			
				dataSet.each(function(itemMain){
					try {
						itemMain.subItems.each(function(itemChild){
							if (item.lId==itemChild.lId) {
								itemChild.treeItem.checkbox.checked = false;
								throw $break;
							}
						});
					} catch(e){}
				});
				
				try {item.treeItem.checkbox.checked = false;} catch(e){}
				
				if (item.lIdGedCategoryParent==0) {
					if (item.treeItem) {
						onSelectMainJC(item);
					} else {
						removeItemSelection(item);
					}
				} else {
					if (item.treeItem) {
						onSelectChildJC(item);
					} else {
						removeItemSelection(item);
					}
				}
				
				self.updateSelection();
			}
			td2.appendChild(imgDelete);
			tr.appendChild(td2);
			
			tbody.appendChild(tr);
			table.appendChild(tbody);
			self.divSelection.appendChild(table);
		});
	}
	
	
	function onSelectMainJC(item) {
		if (item.treeItem.subDom.hasChildNodes()) {
			item.subItems.each(function(subItem){
				subItem.treeItem.checkbox.checked = item.treeItem.checkbox.checked;
			});
		}
		
		if (item.treeItem.checkbox.checked) {
			try {
				item.subItems.each(function(subItem){removeItemSelection(subItem);});
			} catch(e){}
			self.selections.push(item);
		} else {
			removeItemSelection(item);
		}
	}
	
	function onSelectChildJC(item) {
		if (item.treeItem.checkbox.checked) {
			if (isFullSelection(item.parent)) {
				item.parent.treeItem.checkbox.checked = true;
				item.parent.subItems.each(function(subItem){removeItemSelection(subItem);});
				self.selections.push(item.parent);
			} else {
				self.selections.push(item);
			}
		} else {
			item.parent.subItems.each(function(subItem){
				removeItemSelection(subItem);
				if (subItem.treeItem.checkbox.checked) {
					self.selections.push(subItem);
				}
			});
			removeItemSelection(item.parent);
			item.parent.treeItem.checkbox.checked = false;
		}
	}
	
	function isFullSelection(item) {	
		var b = true;
		item.subItems.each(function(item){
			if (!item.treeItem.checkbox.checked) {
				b = false;throw $break;
			}
		});
		return b;
	}
	
	function removeItemSelection(item) {
		self.selections.each(function(sel, index){
			if (sel.type==item.type && sel.lId==item.lId) {
				self.selections.splice(index, 1);
				throw $break;
			}
		});
	}
	
	
	function isItemOnSelection(item) {
		var b = false;
		self.selections.each(function(sel){
			if (sel.type==item.type && sel.lId==item.lId) {
				b = true;
				throw $break;
			}
		});
		return b;
	}
	
	function loadChilds(itemJC) {
		GedCategory.getJSONArrayFromParentLocalized(itemJC.lId, self.lIdLanguage, function(sJSON){
			itemJC.subItems = sJSON.evalJSON();
			itemJC.treeItem.subDom.innerHTML = (itemJC.subItems==0) ?
					captionScriptGEC.title.empty : '';
			itemJC.subItems.each(function(item){
				item.type = "childJC";
				item.parent = itemJC;
				item.treeItem = new TreeItem(item);
				if (isItemOnSelection(item)) {
					item.treeItem.checkbox.checked = true;
				} else {
					item.treeItem.checkbox.checked = itemJC.treeItem.checkbox.checked;					
				}
				itemJC.treeItem.subDom.appendChild(item.treeItem.domNode);
			});
		})
	}
	
	function TreeItem(item) {
		var selfItem = this;
	
		this.domNode = document.createElement("div");
		mt.dom.disableSelection(this.domNode);
		this.domNode.className = "item";
		
		var divLabel = document.createElement("div");
		
		var imgIco = document.createElement("img");
		imgIco.src = rootPath+"images/treeview/icons/closeTreeItem.gif";
		imgIco.className = "middle";

		this.checkbox = document.createElement("input");
		this.checkbox.type = "checkbox";
		this.checkbox.id = "cb_"+item.lId;
		this.checkbox.style.overflow = "hidden";
		this.checkbox.style.width = "13px";
		this.checkbox.style.height = "13px";
		this.checkbox.onclick = function() {
			if (item.type=="mainJC") {
				onSelectMainJC(item);
			} else if (item.type=="childJC") {
				onSelectChildJC(item);
			}
			self.updateSelection();
		}
		this.checkbox.className = "middle";
		
		var label;
		if (item.type=="mainJC") {
			label = document.createElement("a");
			label.href = "javascript:void(0)";
			label.onclick = function() {
				if (selfItem.subDom.style.display=="none") {
					if (!selfItem.subDom.hasChildNodes()) {
						selfItem.subDom.innerHTML = captionScriptGEC.title.loading;
						loadChilds(item);
					}
					imgIco.src = rootPath+"images/treeview/icons/openTreeItem.gif";
					selfItem.subDom.style.display="block";
				} else {
					imgIco.src = rootPath+"images/treeview/icons/closeTreeItem.gif";
					selfItem.subDom.style.display="none";
				}
			}
		} else {
			label = document.createElement("label");
			label.setAttribute("for", "cb_"+item.lId);
		}
		label.className = "middle";
		label.innerHTML = item.sLabel;
		
		this.subDom = document.createElement("div");
		this.subDom.style.display = "none";

		this.subDom.style.marginLeft = "30px";
		
		if (item.type=="mainJC") divLabel.appendChild(imgIco);
		label.style.paddingLeft = "3px";
		divLabel.appendChild(this.checkbox);
		divLabel.appendChild(label);
		
		this.domNode.appendChild(divLabel);
		this.domNode.appendChild(this.subDom);
	}
	
	this.build = function() {
		var div = document.createElement("div");
		div.style.backgroundColor = "#FFF";
		div.style.border = "1px solid #7888A0";
		div.style.padding = "4px";
		div.style.width = "420px";
		
		var table = document.createElement("table");
		table.style.padding = "0";
		table.setAttribute("cellspacing", 0);
		table.style.width = "100%";

		var tbody = document.createElement("tbody");
		var tr = document.createElement("tr");
		
		var td1 = document.createElement("td");
		td1.style.verticalAlign = "top";
		td1.style.width = "200px";
		
		var divTree = document.createElement("div");
		divTree.className = "location_frame";
		divTree.style.padding = "4px";
		divTree.style.height = "200px";
		divTree.style.overflow = "auto";
		divTree.style.backgroundColor = "#EFF5FF";
		
		td1.appendChild(divTree);
		tr.appendChild(td1);
		
		var td2 = document.createElement("td");
		td2.style.verticalAlign = "top";
		
		this.divSelection = document.createElement("div");
		this.divSelection.style.padding = "4px 4px 4px 8px";
		this.divSelection.style.height = "200px";
		this.divSelection.style.overflow = "auto";
		this.divSelection.style.backgroundColor = "#FFF";
		this.divSelection.innerHTML = this.emptyMsg;
		
		td2.appendChild(this.divSelection);
		tr.appendChild(td2);
		
		tbody.appendChild(tr);
		table.appendChild(tbody);
		
		div.appendChild(table);
		
		$(placeHolder).appendChild(div);
		
		dataSet.each(function(item){
			item.type = "mainJC";
			item.treeItem = new TreeItem(item);
			divTree.appendChild(item.treeItem.domNode);
		});
	}
	
	this.getSelections = function() {
		var dataset = [];
		this.selections.each(function(item){dataset.push({lId:item.lId});});
		return dataset;
	}
	// Retourne la sélection en String séparée par des virgules
	this.getSelectionsToString = function() {
		var dataset = [];
		this.selections.each(function(item){dataset.push(item.lId);});
		return dataset.join(",");
	}
	this.populate = function(dataSet) {
		this.selections = dataSet;
		this.updateSelection();
	}
	
	this.build();

}


function gedCategoryComponentExplorer(placeHolder, dataSet, engine, lIdLanguage) {
	var self = this;
	this.selections = [];
	this.lIdLanguage = lIdLanguage ? lIdLanguage : 1;
	this.value = 0;
	this.iIndex = 0;
	this.iCurrentIndex = 0;
	
	this.emptyMsg = '<div style="text-align:center;color:#BBB;font-size:20px;margin-top:70px">' +
		captionScriptGEC.message.selectCategories + '</div>';
	
	this.updateSelection = function() {
		this.selections.each(function(item){
			var table = document.createElement("table");
			table.style.padding = "0";
			table.setAttribute("cellspacing", 0);
			table.style.width = "100%";
			table.style.marginBottom = "1px";
			table.style.borderBottom = "1px solid #ADB8D8";
			table.style.borderRight = "1px solid #ADB8D8";
			table.style.backgroundColor = "#EDEFF2";
			var tbody = document.createElement("tbody");
			var tr = document.createElement("tr");
			
			var td1 = document.createElement("td");
			td1.style.padding = "4px 3px 4px 6px";
			
			if (item.lIdGedCategoryParent==0) {
				td1.innerHTML = "<b>"+item.sLabel+"</b>";
			} else {
				td1.innerHTML = "<b>"+item.sLabelGedCategoryParent+"</b> / "+item.sLabel;
			}
				
			tr.appendChild(td1);
			
			var td2 = document.createElement("td");
			td2.style.width = "16px";
			td2.style.padding = "2px 2px 0 0";
			var imgDelete = document.createElement("img");
			imgDelete.src = rootPath+"images/icons/delete.gif";	
			imgDelete.style.cursor = "pointer";
			imgDelete.onclick = function() {
			
				dataSet.each(function(itemMain){
					try {
						itemMain.subItems.each(function(itemChild){
							if (item.lId==itemChild.lId) {
								//itemChild.treeItem.checkbox.checked = false;
								throw $break;
							}
						});
					} catch(e){}
				});
				
				//try {item.treeItem.checkbox.checked = false;} catch(e){}
				
				if (item.lIdGedCategoryParent==0) {
					if (item.treeItem) {
						onSelectMainJC(item);
					} else {
						removeItemSelection(item);
					}
				} else {
					if (item.treeItem) {
						onSelectChildJC(item);
					} else {
						removeItemSelection(item);
					}
				}
				
				self.updateSelection();
			}
			td2.appendChild(imgDelete);
			tr.appendChild(td2);
			
			tbody.appendChild(tr);
			table.appendChild(tbody);
			//self.divSelection.appendChild(table);
		});
	}
	
	
	function onSelectMainJC(item) {
		if (item.treeItem.subDom.hasChildNodes()) {
			item.subItems.each(function(subItem){
				//subItem.treeItem.checkbox.checked = item.treeItem.checkbox.checked;
			});
		}

	}
	
	function onSelectChildJC(item) {

			item.parent.subItems.each(function(subItem){
				removeItemSelection(subItem);
				/*
				if (subItem.treeItem.checkbox.checked) {
					self.selections.push(subItem);
				}*/
			});
			removeItemSelection(item.parent);
			//item.parent.treeItem.checkbox.checked = false;
		//}
	}
	
	function isFullSelection(item) {	
		var b = true;
		item.subItems.each(function(item){

		});
		return b;
	}
	
	function removeItemSelection(item) {
		self.selections.each(function(sel, index){
			if (sel.type==item.type && sel.lId==item.lId) {
				self.selections.splice(index, 1);
				throw $break;
			}
		});
	}
	
	
	function isItemOnSelection(item) {
		var b = false;
		self.selections.each(function(sel){
			if (sel.type==item.type && sel.lId==item.lId) {
				b = true;
				throw $break;
			}
		});
		return b;
	}
	
	function loadChilds(itemJC) {
		GedCategory.getJSONArrayFromParentLocalized(itemJC.lId, self.lIdLanguage, function(sJSON){
			itemJC.subItems = sJSON.evalJSON();
			itemJC.treeItem.subDom.innerHTML = (itemJC.subItems==0) ? captionScriptGEC.title.empty : '';
			itemJC.subItems.each(function(item){
				item.type = "childJC";
				item.parent = itemJC;
				item.treeItem = new TreeItem(item);

				itemJC.treeItem.subDom.appendChild(item.treeItem.domNode);
			});
		})
	}
	function setActiveItem(sId){
		$(sId).style.backgroundColor = "#EEE";
	}
	function setInactiveItem(sId){
		$(sId).style.backgroundColor = "transparent";
	}
	function selectItem(lId, iLabelIndex){
		setInactiveItem("lab"+self.iCurrentIndex);
		self.iCurrentIndex = iLabelIndex;
		setActiveItem("lab"+iLabelIndex);
		self.value = lId;
		engine.run(true);
	}
	function TreeItem(item) {
		var selfItem = this;
	
		this.domNode = document.createElement("div");
		mt.dom.disableSelection(this.domNode);
		this.domNode.className = "item";
		
		var divLabel = document.createElement("div");
		divLabel.id = "lab"+self.iIndex;
		selfItem.iIndex = self.iIndex;
		
		var imgIco = document.createElement("img");
		imgIco.src = rootPath+"images/treeview/icons/closeTreeItem.gif";
		imgIco.className = "middle";
		
		var label;
		if (item.type=="mainJC") {
			label = document.createElement("a");
			label.href = "javascript:void(0)";
			label.onclick = function() {
				if (selfItem.subDom.style.display=="none") {
					if (!selfItem.subDom.hasChildNodes()) {
						selfItem.subDom.innerHTML = "loading...";
						loadChilds(item);
					}
					imgIco.src = rootPath+"images/treeview/icons/openTreeItem.gif";
					selfItem.subDom.style.display="block";
				} else {
					imgIco.src = rootPath+"images/treeview/icons/closeTreeItem.gif";
					selfItem.subDom.style.display="none";
				}
				selectItem(item.lId, selfItem.iIndex);
			}
		} else {
			label = document.createElement("a");
			label.href = "javascript:void(0)";
			label.onclick = function() {
				selectItem(item.lId, selfItem.iIndex);
			}
			//label.setAttribute("for", "cb_"+item.lId);
		}
		label.className = "middle";
		label.innerHTML = item.sLabel;
		
		this.subDom = document.createElement("div");
		this.subDom.style.display = "none";

		this.subDom.style.marginLeft = "30px";
		
		if (item.type=="mainJC") divLabel.appendChild(imgIco);
		label.style.paddingLeft = "3px";
		divLabel.appendChild(label);
		
		this.domNode.appendChild(divLabel);
		this.domNode.appendChild(this.subDom);
		self.iIndex++;
	}
	
	this.build = function() {
		var div = document.createElement("div");
		div.style.backgroundColor = "#FFF";
		div.style.border = "1px dotted #7888A0";
		div.style.padding = "4px";
		div.style.width = "210px";
		div.style.height = "100%";
		
		var table = document.createElement("table");
		table.style.padding = "0";
		table.setAttribute("cellspacing", 0);
		table.style.width = "100%";

		var tbody = document.createElement("tbody");
		
		var divAll = document.createElement("div");
		divAll.id = "lab"+self.iIndex++;
		var a0 = document.createElement("a");
		a0.href = "javascript:void(0)";
		a0.onclick = function(){selectItem(0, 0);}
		a0.innerHTML = captionScriptGEC.title.allCategories;
		divAll.appendChild(a0);
		
		
		var tr = document.createElement("tr");
		
		var td1 = document.createElement("td");
		td1.style.verticalAlign = "top";
		td1.style.width = "210px";
		
		var divTree = document.createElement("div");
		divTree.className = "location_frame";
		divTree.style.padding = "4px";
		divTree.style.height = "100%";
		divTree.style.overflow = "auto";
		divTree.style.backgroundColor = "#D8C9D5";
		
		divTree.appendChild(divAll);
		td1.appendChild(divTree);
		tr.appendChild(td1);
		
		//////////////
		/*
		var td2 = document.createElement("td");
		td2.style.verticalAlign = "top";
		
		this.divSelection = document.createElement("div");
		this.divSelection.style.padding = "4px 4px 4px 8px";
		this.divSelection.style.height = "200px";
		this.divSelection.style.overflow = "auto";
		this.divSelection.style.backgroundColor = "#FFF";
		this.divSelection.innerHTML = this.emptyMsg;
		
		td2.appendChild(this.divSelection);
		tr.appendChild(td2);
		*/
		///////////////////
		
		tbody.appendChild(tr);
		table.appendChild(tbody);

		div.appendChild(table);
		
		$(placeHolder).appendChild(div);
		
		dataSet.each(function(item){
			item.type = "mainJC";
			item.treeItem = new TreeItem(item);
			divTree.appendChild(item.treeItem.domNode);
		});
	}
	this.getValue = function(){
		return this.value;
	}
	this.getSelections = function() {
		var dataset = [];
		this.selections.each(function(item){dataset.push({lId:item.lId});});
		return dataset;
	}
	// Retourne la sélection en String séparée par des virgules
	this.getSelectionsToString = function() {
		var dataset = [];
		this.selections.each(function(item){dataset.push(item.lId);});
		return dataset.join(",");
	}
	this.populate = function(dataSet) {
		this.selections = dataSet;
		this.updateSelection();
	}
	
	this.build();
	setActiveItem("lab0");

}
