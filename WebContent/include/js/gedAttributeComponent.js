
function gedAttributeComponent(placeHolder, dataSet) {
	var self = this;
	this.arrDataSet = dataSet;
	this.selections = [];
	this.id = placeHolder;
	
	this.emptyMsg = '<div style="text-align:center;color:#BBB;font-size:20px;margin-top:70px">Sélectionnez les attributs dans la liste ci-dessus</div>';
	
	this.updateSelectionValues = function(){
		for(var i=0;i<this.divSelection.getElementsByTagName("textarea").length;i++){
			var sValue = this.divSelection.getElementsByTagName("textarea")[i].value;
			this.selections[i].sValue = sValue;
		}
	}
	
	this.updateSelection = function() {
		if  (this.select.length<=1){
			$(this.id+"_divTree").style.visibility = "hidden";
		}else{
			$(this.id+"_divTree").style.visibility = "visible";
		}
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
			
			td1.innerHTML = "<b>"+item.sName+"</b><br />";
			
			var textarea = document.createElement("textarea");
			textarea.style.width = "350px";
			textarea.style.height = "50px";
			textarea.value = item.sValue;
			textarea.name = "value";
			var hidden = document.createElement("input");
			hidden.type = "hidden";
			hidden.name = "lIdGedDocumentAttributeType";
			hidden.value = item.lIdGedDocumentAttributeType;
			td1.appendChild(hidden);
			td1.appendChild(textarea);
			
			tr.appendChild(td1);
			
			var td2 = document.createElement("td");
			td2.style.width = "16px";
			td2.style.padding = "2px 2px 0 0";
			var imgDelete = document.createElement("img");
			imgDelete.src = rootPath+"images/icons/delete.gif";	
			imgDelete.style.cursor = "pointer";
			imgDelete.onclick = function() {				
				removeItemSelection(item);
				self.updateSelection();
			}
			td2.appendChild(imgDelete);
			tr.appendChild(td2);
			
			tbody.appendChild(tr);
			table.appendChild(tbody);
			self.divSelection.appendChild(table);
		});
	}
	
	function removeItemSelection(item) {
		self.updateSelectionValues();
		self.selections.each(function(sel, index){
			if (sel.lIdGedDocumentAttributeType==item.lIdGedDocumentAttributeType) {
				self.select.options[self.select.options.length] = new Option(item.sName, item.lIdGedDocumentAttributeType);
				self.selections.splice(index, 1);
				throw $break;
			}
		});
	}
	
	this.build = function() {
		var div = document.createElement("div");
		div.style.backgroundColor = "#FFF";
		div.style.border = "1px solid #7888A0";
		div.style.padding = "4px";
		div.style.width = "420px";
		
		var divTree = document.createElement("div");
		divTree.className = "location_frame";
		divTree.id = this.id+"_divTree";
		divTree.style.padding = "4px";
		divTree.style.height = "15px";
		divTree.style.overflow = "auto";
		divTree.style.backgroundColor = "#EFF5FF";
		
		var label = document.createElement("label");
		label.innerHTML = "Ajouter un attribut : ";
		
		this.select = document.createElement("select");
		this.select.id = this.select.name = placeHolder+"_select";
		this.select.onchange = function(){
			if (self.select.value>0){
				self.updateSelectionValues();
				self.selections.push({"lIdGedDocumentAttributeType":self.select.options[self.select.selectedIndex].value,"sName":self.select.options[self.select.selectedIndex].text,"sValue":""});
				self.select.options[self.select.selectedIndex] = null;
				self.updateSelection();
			}
		}
		divTree.appendChild(label);
		divTree.appendChild(this.select);
		
		div.appendChild(divTree);
		
		this.divSelection = document.createElement("div");
		this.divSelection.style.padding = "4px 4px 4px 8px";
		this.divSelection.style.minHeight = "185px";
		//this.divSelection.style.overflow = "auto";
		this.divSelection.style.backgroundColor = "#FFF";
		this.divSelection.innerHTML = this.emptyMsg;
		
		div.appendChild(this.divSelection);
		
		$(placeHolder).appendChild(div);

		this.select.options[this.select.options.length] = new Option("-", 0);
		dataSet.each(function(item){
			self.select.options[self.select.options.length] = new Option(item.sName, item.lId);
		});
	}
	this.removeSelectItemFromValue = function(iValue){
		for(var i=0;i<this.select.length;i++){
			if (this.select.options[i].value==iValue){
				this.select.options[i] = null;
			}
		}
	}
	
	this.getSelections = function() {
		this.updateSelectionValues();
		var dataset = [];
		this.selections.each(function(item){
			if (item.sValue.length>0) dataset.push(item);
		});
		return dataset;
	}

	this.populate = function(ds) {
		var sName = "";
		ds.each(function (item){
			// on recherche le libellé du type
			self.arrDataSet.each(function (it){
				if(it.lId==item.lIdGedDocumentAttributeType) sName = it.sName;
			});
			self.selections.push({"lIdGedDocumentAttributeType":item.lIdGedDocumentAttributeType,"sName":sName,"sValue":item.sValue});
			self.removeSelectItemFromValue(item.lIdGedDocumentAttributeType);
		});
		this.updateSelectionValues();
		this.updateSelection();
	}
	
	this.build();

}