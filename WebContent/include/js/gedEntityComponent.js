/**
 * Librairies needed :
 * Inputs :
 * - arrDataSet is an array of ged_folder_entity elements : {lId:..., sLabel:...}  
 * - lIdGedDocumentEntityType (ex : TYPE_WRITER or TYPE_READER)
 * - arrSelection : is an array of {lIdReferenceObject:..., lIdTypeObject:...}
 * 
 * Output :
 * return an array arrSelection (an array of {lIdReferenceObject:..., lIdTypeObject:...})
 * 
 * example : new gedEntityComponent("myDiv", arrDataSet, arrSelection, lIdGedDocumentEntityType);
 * or : new gedEntityComponent("myDiv", arrDataSet, arrSelection, lIdGedDocumentEntityType, "List of elements", "List of selected elements");
 */
function gedEntityComponent(placeHolder, arrDataSet, arrSelection, lIdGedDocumentEntityType, sLabelNotSelected, sLabelSelected) {
	var self = this;
	this.arrDataSet = arrDataSet;
	this.arrList = [];
	this.arrSelection = arrSelection;
	this.lIdGedDocumentEntityType = lIdGedDocumentEntityType;
	this.id = placeHolder;
	this.iHeight = 325;
	this.sLabelNotSelected = sLabelNotSelected || captionScriptGEC.title.notSelectedItems;
	this.sLabelSelected = sLabelSelected || captionScriptGEC.title.selectedItems;
	
	
	this.emptyMsg = "<div style=\"text-align:center;color:#BBB;font-size:20px;margin-top:70px\">" +
		captionScriptGEC.message.noSelectedItem + "</div>"; 
	this.emptyMsgList = "<div style=\"text-align:center;color:#BBB;font-size:20px;margin-top:70px\">" +
		captionScriptGEC.title.noItem + "</div>";
	
	this.updateSelection = function() {
		this.divSelection.innerHTML = (this.arrSelection.length==0) ? this.emptyMsg : '';
		this.divList.innerHTML = (this.arrList.length==0) ? this.emptyMsgList : '';
		var iIndex = 0;
		this.arrSelection.each(function(item){
			var iCurIndex = iIndex;
			var table = document.createElement("table");
			table.style.padding = "0";
			table.setAttribute("cellspacing", 0);
			table.style.width = "100%";
			table.style.marginBottom = "1px";
			table.style.borderBottom = "1px solid #ADB8D8";
			table.style.borderRight = "1px solid #ADB8D8";
			table.style.backgroundColor = "#EEEEEE";
			var tbody = document.createElement("tbody");
			var tr = document.createElement("tr");
			
			var td1 = document.createElement("td");
			td1.style.padding = "4px 3px 4px 6px";
			td1.style.verticalAlign = "top";
			
			var sTitle = ((item.sLabel.length>0)?item.sLabel: captionScriptGEC.title.noTitle);
			
			td1.innerHTML = "<b>- </b>"+sTitle;//["+item+"]";			
			tr.appendChild(td1);
			
			var td2 = document.createElement("td");
			td2.style.width = "48px";
			td2.style.padding = "2px 2px 0 0";
			td2.style.textAlign = "right";
					
			var imgDelete = document.createElement("img");
			imgDelete.src = rootPath+"images/icons/delete.gif";	
			
			td2.appendChild(imgDelete);
			tr.appendChild(td2);
			
			tr.onclick = function() {
				self.removeItemFromIndex(iCurIndex);
				self.updateSelection();
			};
			tr.style.cursor = "pointer";
			tbody.appendChild(tr);
			table.appendChild(tbody);
			self.divSelection.appendChild(table);
			iIndex++;

		});
		iIndex = 0;
		this.arrList.each(function (item){
			var iCurIndex = iIndex;
			var table = document.createElement("table");
			table.style.padding = "0";
			table.setAttribute("cellspacing", 0);
			table.style.width = "100%";
			table.style.marginBottom = "1px";
			//table.style.borderBottom = "1px solid #ADB8D8";
			//table.style.borderRight = "1px solid #ADB8D8";
			table.style.backgroundColor = "#EEEEEE";
			var tbody = document.createElement("tbody");
			var tr = document.createElement("tr");
			
			var td1 = document.createElement("td");
			td1.style.padding = "4px 3px 4px 6px";

			var sTitle = ((item.sLabel.length>0)?item.sLabel : captionScriptGEC.title.noItem);
			td1.innerHTML = sTitle+"["+item.lIdTypeObject+"/"+item.lIdReferenceObject+"]";
			tr.appendChild(td1);
			
			var td2 = document.createElement("td");
			td2.style.width = "48px";
			td2.style.padding = "2px 2px 0 0";
			td2.style.textAlign = "right";
			
			var imgAdd = document.createElement("img");
			imgAdd.src = rootPath+"images/icons/icon-add.png";	
			imgAdd.title = imgAdd.alt = MESSAGE_BUTTON [5];
			
			td2.appendChild(imgAdd);
			tr.appendChild(td2);
			tr.style.cursor = "pointer";
			tr.onclick = function() {
				self.addItemFromIndex(iCurIndex);
				self.updateSelection();
			};

			tbody.appendChild(tr);
			table.appendChild(tbody);
			self.divList.appendChild(table);
			iIndex++;
		});
	}
	
	this.switchIndex = function(iOldIndex, iNewIndex) {
		var lId = this.arrSelection[iOldIndex];
		this.arrSelection[iOldIndex] = this.arrSelection[iNewIndex];
		this.arrSelection[iNewIndex] = lId;
	}
	this.removeItemFromIndex = function(iIndex){
		var lId = this.arrSelection[iIndex];
		this.arrSelection.splice(iIndex, 1);
		this.arrList = [lId].concat(this.arrList);
	}
	this.addItemFromIndex = function(iIndex){
		var lId = this.arrList[iIndex];
		this.arrList.splice(iIndex, 1);
		this.arrSelection =  [lId].concat(this.arrSelection);
	}
	this.build = function() {
		var div = document.createElement("div");
		div.style.backgroundColor = "#FFF";
		div.style.border = "1px solid #FFF";
		div.style.padding = "4px";
		div.style.width = "550px";
	
		var table = document.createElement("table");
		table.style.padding = "0";
		table.setAttribute("cellspacing", 2);
		table.style.width = "100%";
		var tbody = document.createElement("tbody");
		var tr = document.createElement("tr");
		
		var td1 = document.createElement("td");
		td1.style.width = "50%";
		
		var divTreeLeft = document.createElement("div");
		divTreeLeft.className = "location_frame";
		divTreeLeft.id = this.id+"_divTreeLeft";
		divTreeLeft.style.padding = "4px";
		divTreeLeft.style.height = "15px";
		divTreeLeft.style.overflow = "auto";
		divTreeLeft.style.backgroundColor = "#8A6D7C";
		divTreeLeft.style.color = "#FFF";
				
		var labelLeft = document.createElement("label");
		labelLeft.style.textAlign = "left";
		labelLeft.innerHTML = this.sLabelNotSelected;	
		
		this.divList = document.createElement("div");
		this.divList.id = this.id+"_list";
		this.divList.style.padding = "4px 4px 4px 8px";
		this.divList.style.height = this.iHeight+"px";
		this.divList.style.overflow = "auto";
		this.divList.style.backgroundColor = "#FFF";
		this.divList.innerHTML = this.emptyMsgList;
		
		divTreeLeft.appendChild(labelLeft);
		td1.appendChild(divTreeLeft);
		td1.appendChild(this.divList);
		
		///////////////////////////////////////
		var td2 = document.createElement("td");
		td2.style.width = "50%";
		
		var divTreeRight = document.createElement("div");
		divTreeRight.className = "location_frame";
		divTreeRight.id = this.id+"_divTreeRight";
		divTreeRight.style.padding = "4px";
		divTreeRight.style.height = "15px";
		divTreeRight.style.overflow = "auto";
		divTreeRight.style.backgroundColor = "#8A6D7C";
		divTreeRight.style.textAlign = "right";
		divTreeRight.style.color = "#FFF";
				
		var labelRight = document.createElement("label");
		labelRight.style.textAlign = "right";
		labelRight.innerHTML = this.sLabelSelected;
		
		this.divSelection = document.createElement("div");
		this.divSelection.id = this.id+"_selection";
		this.divSelection.style.padding = "4px 4px 4px 8px";
		this.divSelection.style.height = this.iHeight+"px";
		this.divSelection.style.overflow = "auto";
		this.divSelection.style.backgroundColor = "#FFF";
		this.divSelection.innerHTML = this.emptyMsg;
		
		divTreeRight.appendChild(labelRight);
		td2.appendChild(divTreeRight);
		td2.appendChild(this.divSelection);
		
		tr.appendChild(td1);
		tr.appendChild(td2);
		tbody.appendChild(tr);
		table.appendChild(tbody);
		div.appendChild(table);
		
		$(placeHolder).appendChild(div);
	}

	
	this.getSelectedItems = function() {
		return this.arrSelection;
	}
	
	this.getUnselectedItems = function() {
		return this.arrList;
	}
	
	this.getSelectionToString = function() {
		return this.arrSelection.join(",");
	}
	this.populate = function() {
		self.arrDataSet.each(function (item){
			if (!isInArray(self.arrSelection, item.lIdRefenceObject, item.lIdTypeObject)){
				 self.arrList.push(item);
			}
		});
	}
	function isInArray(arr, lIdRefenceObject, lIdTypeObject){
		for (var i=0;i<arr.length;i++){
			if (arr[i].lIdRefenceObject==lIdRefenceObject 
				&& arr[i].lIdTypeObject==lIdTypeObject) return true;
		}
		return false;
	}
	this.getLabel = function(iValue){
		for (var i=0;i<self.arrDataSet.length;i++){
			if (self.arrDataSet[i].lId==iValue){
				var s = self.arrDataSet[i].sLabel;
				if (s.innerHTML){
					var div = document.createElement("div");
					div.appendChild(s);
					return div.innerHTML;
				}
				return s;
			}
		}
		return "";
	}

	this.build();
	this.populate();
	this.updateSelection();
}
