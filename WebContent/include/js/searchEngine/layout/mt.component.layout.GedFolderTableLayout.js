mt.component.layout.GedFolderTableLayout = function(domId){
	var self = this;
	
	this.domId = domId;
	this.headers = [];
	this.selectionEnabled = false;
	this.selectionItems = [];
	this.sURL = "";
	this.selectionItem = "";
	this.arrOpenedItem = [];
	
	var TableHeader = function(h){
		this.getHeaderContent = function() {return h;}
		this.getCellContent = function() {};
	}
	
	this.init = function(){
		this.selectionItems = [];
	}

	this.setDisplay = function(result) {
		
		var table = document.createElement("table");
		table.className = "SE_TableLayout";
		table.style.borderCollapse = "collapse";
		table.style.width = "100%";
		
		var tbody = document.createElement("tbody");
		table.appendChild(tbody);
		
		var trHeader = document.createElement("tr");
		tbody.appendChild(trHeader);
		/*
		if (this.selectionEnabled) {
			var th1 = document.createElement("th");
			th1.style.padding = "5px 0 5px 6px";
			var chkMain = document.createElement("input");
			chkMain.type = "checkbox";
			chkMain.onclick = function() {
				var selfChk = this;
				self.selectionItems.each(function(item){
					item.checked = selfChk.checked;
					item.setSelection();
				});
			}
			th1.appendChild(chkMain);
			trHeader.appendChild(th1);
		}
		
		this.headers.each(function(item){
			var th = document.createElement("th");
			item.domElm = th;
			th.style.textTransform = "uppercase";
			th.style.verticalAlign = "top";
			th.style.textAlign = "left";
			th.style.padding = "5px 0 5px 6px";
			th.innerHTML = item.getHeaderContent();
			trHeader.appendChild(th);
		});
		*/
		result.dataset.each(function(item,index){
			//var color = (index%2==0)?"#FFF":"#EFF5FF";
			var colorLine = (index%2==0)?"#EEE":"#C3D9FF";
			
			var tr1 = document.createElement("tr");
			//tr1.style.backgroundColor = color;
			//tr1.className = "color"+index%2;
			tr1.className = "GedFolderLine";
			tr1.style.cursor = "pointer";
			tr1.id = "lineFolder_"+item.id_ged_folder;
			if (self.isOpenedItem(item.id_ged_folder)){
				tr1.style.backgroundColor = "#cdc0c7";
			}else{
				tr1.style.backgroundColor = "#FFFFFF";
			}
			tr1.onmouseover = function(){
				self.onlineMouseOver(item, tr1);
				/*
				if (self.isOpenedItem(item.id_ged_folder)){
					tr1.style.backgroundColor = "#cdc0c7";
				}else{
					tr1.style.backgroundColor = "#EEEEEE";
				}*/
			}
			tr1.onmouseout = function(){
				self.onlineMouseOut(item, tr1);
				/*
				if (self.isOpenedItem(item.id_ged_folder)){
					tr1.style.backgroundColor = "#cdc0c7";
				}else{
					tr1.style.backgroundColor = "#FFFFFF";
				}*/
			}
			tr1.onclick = function(){
				self.onlineClick(item, tr1);
			}
			
			if (self.selectionEnabled) {
				var td1 = document.createElement("td");
				td1.style.width = "16px";
				td1.style.verticalAlign = "top";
				//td1.style.borderTop = "1px solid #C3D9FF";
				td1.style.padding = "5px 5px 2px 6px";
				td1.style.backgroundColor = "#FAFAFA";
				td1.style.borderRight = "1px solid #DDD";
				var chk = document.createElement("input");
				chk.type = "checkbox";
				self.selectionItems.push(chk);
				chk.setSelection = function() {
					//tr1.style.backgroundColor = (this.checked)?"lightyellow":color;
					tr1.className = (this.checked)?"color_selected":"color"+index%2;
				}
				chk.onclick = chk.setSelection;				
				chk.item = item;
				
				td1.appendChild(chk);
				tr1.appendChild(td1);
			}
			self.headers.each(function(item2){
				var td = document.createElement("td");
				td.style.verticalAlign = "top";
				//td.style.borderTop = "1px solid #C3D9FF";
				td.style.padding = "1px";
				var content = item2.getCellContent(item, td);
				if (typeof(content)=='object') {
					td.appendChild(content);
				} else {
					td.innerHTML = content;
				}
				tr1.appendChild(td);
			});
			
			tbody.appendChild(tr1);
	
		});
		
		var domElm = $(this.domId);
		domElm.innerHTML = '';
		domElm.appendChild(table);
	}
	
	this.enableSelections = function(enable, selectionItem){
		this.selectionEnabled = enable;
		this.selectionItem = selectionItem;
	}
	
	this.getSelections = function(){
		var selections = [];
		this.selectionItems.each(function(chk){
			if (chk.checked) selections.push(chk.item);
		});
		return selections;
	}
	
	this.getSelectionsId = function(){
		var selections = [];
		this.selectionItems.each(function(chk){
			if (chk.checked) selections.push(chk.item[self.selectionItem]);
		});
		return selections;
	}	
	this.addHeader = function(h){
		var header = new TableHeader(h);
		this.headers.push(header);
		return header;
	}
	this.setURL = function(u){
		this.sURL = u;
		return this.sURL;
	}
	this.onlineClick = function(){}
	this.onlineMouseOver = function(){}
	this.onlineMouseOut = function(){}
	this.addOpenedItem = function(lId){
		this.arrOpenedItem.push(lId);
	}
	this.removeOpenedItem = function(lId){
		for (var i=0;i<this.arrOpenedItem.length;i++){
			if (lId==this.arrOpenedItem[i]){
				this.arrOpenedItem.splice(i,1);
				return;
			}
		}
	}
	this.getOpenedItem = function(){
		return this.arrOpenedItem;
	}
	this.isOpenedItem = function(lId){
		for (var i=0;i<this.arrOpenedItem.length;i++){
			if (lId==this.arrOpenedItem[i]) return true;
		}
		return false;	
	}
}