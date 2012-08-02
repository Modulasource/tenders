var SimpleTree = function(placeHolder) {
	
	var self = this;
	this.selections = [];
	this.dataTypes = [];
	this.combo = false;
	this.remoteMethod = null;
	this.rendered = false;
	
	this.addDataType = function(obj){
		this.dataTypes.push(obj);
	}
	
	this.updateSelection = function() {
		this.divSelection.innerHTML = '';
		this.divSelection.style.display = (this.selections.length>0) ? "block" : "none";
		this.selections.each(function(item){
			var table = document.createElement("table");
			table.style.padding = "0";
			table.setAttribute("cellspacing", 0);
			table.style.width = "100%";
			table.style.borderBottom = "1px solid #cbd2e7";
			table.style.borderRight = "1px solid #cbd2e7";
			table.style.backgroundColor = "#EFF5FF";
			var tbody = document.createElement("tbody");
			var tr = document.createElement("tr");
			
			var td1 = document.createElement("td");
			td1.style.padding = "4px 3px 4px 6px";
			
			if (item.lIdJobPositionParent==0) {
				td1.innerHTML = "<b>"+item.label+"</b>";
			} else {
				td1.innerHTML = "<b>"+item.labelJobPositionParent+"</b> / "+item.label;
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
				
				if (item.lIdJobPositionParent==0) {
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
	
	function onSelect(item) {
		if (item.treeItem.checkbox.checked) {
			self.selections.push(item);
			self.onSelect(self.selections);
		} else {
			self.removeItemSelection(item);
		}
	}
	
	this.removeItemSelection = function(item) {
		item.treeItem.checkbox.checked = false;
		self.selections.each(function(sel, index){
			if (sel[self.dataTypes[item.level].idField]==item[self.dataTypes[item.level].idField]) {
				self.selections.splice(index, 1);
				throw $break;
			}
		});
		self.onSelect(self.selections);
	}
	
	function loadChilds(itemJC) {
		self.dataTypes[itemJC.level].loadChildRemoteMethod(itemJC[self.dataTypes[itemJC.level].idField], function(sJSON){
			itemJC.subItems = sJSON.evalJSON();
			itemJC.treeItem.subDom.innerHTML = (itemJC.subItems==0) ? 'vide' : '';
			itemJC.subItems.each(function(item){
				item.type = "childJC";
				item.parent = itemJC;
				item.level = itemJC.level+1;
				item.treeItem = new TreeItem(item);
				/*
				if (isItemOnSelection(item)) {
					item.treeItem.checkbox.checked = true;
				} else {
					item.treeItem.checkbox.checked = itemJC.treeItem.checkbox.checked;
				}
				*/
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
		this.checkbox.style.margin = 0;
		this.checkbox.style.padding = 0;
		this.checkbox.onclick = function() {
			var chk = this;
			
			$$("#"+placeHolder+" input").each(function(input){
				if (input!=chk){
					input.checked = false;
				}
			});
			
			self.selections = [];
			onSelect(item);
		}
		this.checkbox.className = "middle";
		
		var label;
		if (item.type=="mainJC") {
			label = document.createElement("a");
			label.href = "javascript:void(0)";
			label.onclick = function() {
				if (selfItem.subDom.style.display=="none") {
					imgIco.src = rootPath+"images/treeview/icons/openTreeItem.gif";
					selfItem.subDom.style.display="block";
					if (!selfItem.subDom.hasChildNodes()) {
						selfItem.subDom.innerHTML = "chargement...";
						loadChilds(item);
					}
				} else {
					imgIco.src = rootPath+"images/treeview/icons/closeTreeItem.gif";
					selfItem.subDom.style.display="none";
				}
			}
		} else {
			label = document.createElement("span");
		}
		label.className = "middle";
		label.innerHTML = item[self.dataTypes[item.level].labelField];
		
		this.subDom = document.createElement("div");
		this.subDom.style.display = "none";

		this.subDom.style.marginLeft = "30px";
		
		if (self.dataTypes[item.level].enableSelection) divLabel.appendChild(this.checkbox);
		
		if (item.type=="mainJC") divLabel.appendChild(imgIco);
		label.style.paddingLeft = "3px";
		
		divLabel.appendChild(label);
		
		this.domNode.appendChild(divLabel);
		this.domNode.appendChild(this.subDom);
	}
	
	this.build = function(placeHolder) {
		var div = placeHolder;
		div.style.backgroundColor = "#FFF";
		div.style.padding = "4px";
		div.style.overflow = "auto";
		
		this.dataTypes[0].dataSet.each(function(item){
			item.type = "mainJC";
			item.level = 0;
			item.treeItem = new TreeItem(item);
			div.appendChild(item.treeItem.domNode);
		});
	}
	
	this.getSelections = function() {
		return this.selections;
	}
	
	this.populate = function(dataSet) {
		this.selections = dataSet;
		this.updateSelection();
	}
	
	this.render = function(){
		this.build($(placeHolder));
		this.rendered = true;
	}

}
