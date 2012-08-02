AjaxDataGrid = Class.create();
AjaxDataGrid.prototype = {
	initialize:function(placeHolder,pagination) {
		this.domNode = $(placeHolder);
		this.paginationNode = $(pagination);
		this.dataSet = [];
		this.columnStyles = [];
		this.createTable();
		this.se;
	},
	createTable:function() {
		this.table = document.createElement("TABLE");
		//this.table.style.width = "100%";
		this.table.className = "dataGrid";
		this.table.jsObj = this;
		this.grid = document.createElement("TBODY");
		this.table.appendChild(this.grid);
	},	
	addStyle:function(name, value) {
		this.table.style[name] = value;
	},
	setHeader:function(values) {
		var self = this;
		var line = document.createElement("tr");
		line.className = "header";
		values.each(function(item, index){
			var cell = document.createElement("td");
			cell.className = "cell";
			for (i in self.columnStyles[index]) {
				if (i=="width" || i=="textAlign")
				cell.style[i] = self.columnStyles[index][i];
			}
			if(typeof(item)=='object') {
				cell.appendChild(item);
			} else {
				cell.innerHTML = item;
			}
			line.appendChild(cell);
		});
		if (this.moveOptionEnabled) {
			var cell = document.createElement("td");
			cell.className = "cell";
			line.appendChild(cell);
		}
		if (this.removeOptionEnabled) {
			var cell = document.createElement("td");
			cell.className = "cell";
			cell.style.width = "16px";
			if (this.removeOptionHeader)
				cell.appendChild(this.removeOptionHeader);
			line.appendChild(cell);
		}
		this.grid.insertBefore(line, this.grid.firstChild);
	},
	/*setGridHeight:function(h) {
		this.grid.style.overflow = "auto";
		this.grid.style.height = h+"px";
	},*/
	_addItem:function(index, values, options) {
		var self = this;
		var line = document.createElement("tr");
		line.className = "line";
		for (i in this.linesStyle) line.style[i] = this.linesStyle[i];
		line.index = index;
		var lineData = {node:line, cells:[]};
		if (options)
			lineData.removeOption = options.removeOption;
		values.each(function(item, index){
			if (item==null) item="";
		
			var cell = document.createElement("td");
			cell.className = "cell";
			for (i in self.columnStyles[index]) cell.style[i] = self.columnStyles[index][i];
			cell.getIndex = function() {
				return this.parentNode.index;
			}
			var content;
			
			if (item.editable) {
				cell.innerHTML = item.value;
				cell.data = item.data;
				cell.editor = new koffee.component.InPlaceEditor(cell, false);
				cell.editor.onChange = function(value) {
					cell.data = value;
				}
			} else {
			
				if (item.nodeType==1) {
					cell.data = "";
					content = item;
					cell.appendChild(content);
				} else {
					if (!item.value) {
						cell.data = "";
						content = item;
					} else {
						cell.data = item.data;
						content = item.value;
					}
					if (content.nodeType==1) {
						cell.appendChild(content);
					} else {
						cell.innerHTML = content;
					}
				}
			
			}
			
			line.appendChild(cell);
			lineData.cells.push(cell);
		});
		
		if (this.moveOptionEnabled) {
			var imgUp = document.createElement("img");
			imgUp.src = rootPath+"images/icons/up.gif";
			imgUp.className = "pointer";
			imgUp.onclick = function() {
				self.moveItem(-1, this.parentNode.parentNode.index);
			}
			var imgDown = document.createElement("img");
			imgDown.src = rootPath+"images/icons/down.gif";
			imgDown.style.marginLeft = "2px";
			imgDown.className = "pointer";
			imgDown.style.marginLeft = "4px";
			imgDown.onclick = function() {
				self.moveItem(1, this.parentNode.parentNode.index);
			}
			var cell = document.createElement("td");
			cell.className = "cell";
			cell.getIndex = function() {
				return this.parentNode.index;
			}
			cell.appendChild(imgUp);
			cell.appendChild(imgDown);
			line.appendChild(cell);
			lineData.cells.push(cell);
		}
		
		if ((this.removeOptionEnabled && lineData.removeOption) || (this.removeOptionEnabled && lineData.removeOption==null)) {
			var imgDelete = document.createElement("img");
			imgDelete.src = rootPath+"images/delete.gif";
			imgDelete.className = "pointer";
			imgDelete.onclick = function() {
				var result = self.onBeforeRemove(this.parentNode.parentNode.index);
				if (result || result==null) {
					self.removeItem(this.parentNode.parentNode.index);
				}
			}
			var cell = document.createElement("td");
			cell.style.width = "16px";
			cell.className = "cell";
			cell.getIndex = function() {
				return this.parentNode.index;
			}
			cell.appendChild(imgDelete);
			line.appendChild(cell);
			lineData.cells.push(cell);
		}		
		
		if (index==this.dataSet.length) {
			this.grid.appendChild(line);
			this.dataSet.push(lineData);
		} else {
			this.grid.insertBefore(line, this.grid.childNodes[index]);
			this.dataSet.splice(index, 0, lineData);
		}
		
		return lineData;
	},
	addItem:function(values, options) {
		return this._addItem(this.dataSet.length, values, options);
	},
	insertItem:function(index, values, options) {
		var lineData = this._addItem(index, values, options);
		this._updateIndexes();
		return lineData;
	},
	_updateIndexes:function() {
		this.dataSet.each(function(line, index){
			line.node.index = index;
		});
	},	
	setColumnStyle:function(index, styles) {
		this.columnStyles[index] = styles;
		this.dataSet.each(function(line){
			for (i in styles) {
				line.cells[index].style[i] = styles[i];
			}
		});
	},
	addRemoveOption:function(headerContent) {
		this.removeOptionHeader = headerContent;
		this.removeOptionEnabled = true;
		this.dataSet.each(function(line){
			line.removeOption = true;
		});
	},
	addMoveOption:function() {
		this.moveOptionEnabled = true;
	},
	removeItem:function(index, callEvent) {
		Element.remove(this.dataSet[index].node);
		this.dataSet.splice(index,1);
		this._updateIndexes();
		if (callEvent || callEvent==null) this.onRemove(index);
	},
	removeAll:function() {
		while(this.dataSet.length>0)
			this.removeItem(this.dataSet.length-1);
	},
	clear:function() {
		while(this.dataSet.length>0) {
			var index = this.dataSet.length-1;
			Element.remove(this.dataSet[index].node);
			this.dataSet.splice(index,1);
		}
		this._updateIndexes();
	},
	moveItem:function(direction, index) {
		if (direction==-1) {
			if (index>0) {
				var node = this.dataSet[index].node;
				var previousNode = this.dataSet[index-1].node;
				node.parentNode.insertBefore(node, previousNode);
				var previousSet = this.dataSet[index-1];
				this.dataSet[index-1] = this.dataSet[index];
				this.dataSet[index] = previousSet;
				this._updateIndexes();
				this.onMove(direction, index);
			}
		} else if (direction==1) {
			if (index<(this.dataSet.length-1)) {
				var node = this.dataSet[index].node;
				var nextNode = this.dataSet[index+1].node;
				node.parentNode.insertBefore(nextNode, node);
				var nextSet = this.dataSet[index+1];
				this.dataSet[index+1] = this.dataSet[index];
				this.dataSet[index] = nextSet;
				this._updateIndexes();
				this.onMove(direction, index);
			}
		}
	},
	onRemove:function() {},
	onBeforeRemove:function() {},
	onMove:function() {},
	_setItemDragEvents:function(line) {
		line.node.style.cursor = "move";
		var originalBackground = Element.getStyle(line.node, 'background-color');
		line.node.onmouseover = function() {
			this.style.backgroundColor = "lightyellow";
		}
		line.node.onmouseout = function() {
			this.style.backgroundColor = originalBackground;
		}
		line.node.onmousedown = function(e) {
			var e = e || window.event;
			var div = this.cloneNode(true);	
			div.style.position = "absolute";
			div.className = "dgDragItem";
			div.style.backgroundColor = "#FFF";
			div.style.border = "1px solid #C5D5FC";
			div.lineData = line;
			document.body.appendChild(div);
			Position.clone(this, div);
			var drag = new Draggable(div, {revert:true, endRevertEffect:function() {
				try{Element.remove(div);}catch(e){};
			}});
			drag.initDrag(e);
			drag.startDrag(e);
		}
	},
	enableItemDrag:function(enable) {
		var self = this;
		this.dataSet.each(function(line){
			if (enable) {
				self._setItemDragEvents(line);
			}			
		});
	},
	enableItemDrop:function(enable) {
		var self = this;
		this.dataSet.each(function(item, index){
			Droppables.add(item.node, {accept:'dgDragItem', onDrop:function(node){
				self.onItemDrop(node.onBoardData, {datagrid:self,itemIndex:index});
				Element.remove(node);
			},hoverclass:'dgItemOnDragOver', noPositionChange:true});
		});
	},	
	render:function() {
		this.domNode.innerHTML = "";
		this.domNode.appendChild(this.table);
	},
	load:function(){
	//	this.removeAll();
		
		alert("koffee.component.AjaxDataGrid.load should be implemented");
	},
	
	updatePagination:function(totalCount) {
	
		var numPages = Math.ceil(totalCount/this.se.offset);
		var currentPageNum = (this.se.index/this.se.offset)+1;
		this.paginationNode.innerHTML = "";
		if (numPages>1) {
			for (var z=1; z<=numPages; z++) {
				var div = document.createElement("div");
				div.innerHTML = z;
				var self = this;
				div.onclick = function() {
					self.se.index = (parseInt(this.innerHTML)-1)*self.se.offset;
					self.load();
				}
				if (z==currentPageNum) {
					div.className = "page_selected"; 
				} else {
					div.className = "page";
				}
				this.paginationNode.appendChild(div);
			}
		}
	}
	
};

