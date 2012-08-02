// ex de folder layout
mt.component.layout.FolderLayout = function(domId){
	var self = this;
	this.domId = domId;
	this.selectionEnabled = false;
	this.selectionItems = [];

	this.setItemDisplay = function(item) {
		var div = document.createElement("div");
		div.style.backgroundColor = "lightyellow";
		div.style.border = "1px solid #CCC";
		div.style.margin = "10px";
		div.style.paddding = "10px";
		div.innerHTML = item.name;
		return div;
	}
	
	this.init = function(){
		this.selectionItems = [];
	}
	
	this.setDisplay = function(result) {
		
		var mainDiv = document.createElement("div");
		result.dataset.each(function(item,index){
			
			
			var div = document.createElement("div");
			div.className = "FloatLeft";
			
			var userDiv = self.setItemDisplay(item);
			
			/**
			 * Add selection possibility
			 */
			
			if (self.selectionEnabled) {

				var chk = document.createElement("input");
				chk.type = "checkbox";
				self.selectionItems.push(chk);
				chk.setSelection = function() {
					divClear.style.backgroundColor = (this.checked)?"lightyellow":color;
				}
				chk.onclick = chk.setSelection;				
				chk.item = item;
				
				div.appendChild(chk);
				//userDiv.innerHTML = chk + userDiv.innerHTML ;
			}		
			
			div.appendChild(userDiv);
			mainDiv.appendChild(div);
		});
		
		var divClear = document.createElement("div");
		divClear.style.clear = "left";
		
		
		
		mainDiv.appendChild(divClear);

		
		
		
		var domElm = $(this.domId);
		domElm.innerHTML = '';
		domElm.appendChild(mainDiv);
	}
	
	this.enableSelections = function(enable, selectionItem){
		this.selectionEnabled = enable;
		this.selectionItem = selectionItem;
	}
	
	this.getSelections = function(){
		var selections = [];
		this.selectionItems.each(function(item){
			if (item.checked) selections.push(item.item);
		});
		return selections;
	}
}

