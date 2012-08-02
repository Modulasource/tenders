
mt.component.SearchEngine = function() {

	var self = this;

	this.queryData = {};
	this.result = {};
	
	this.queryData.isPaginated = true;

	this.init = function(){
		this.queryData.tablesWithLeftJoin = [];
		this.queryData.tablesWithInnerJoin = [];
		this.queryData.whereClauses = [];
	}
	
	this.getQueryData = function(){
		return this.queryData;
	}

	this.run = function(init){
		if (init) this.queryData.pageIndex = 1;
		this.init();
		try {this.layoutProvider.init();}catch(e){};
		if (this.queryData.isPaginated) Element.hide(this.domPaginationId);
		
		this.queryBeforeSearch(this.runSearch);
		
	}
	
	this.runSearch = function(obj){
		
		if (self.onBeforeSearch(obj)) {
			self.setLoading();
			self.load();
		}
	}
	
	
	this.queryBeforeSearch = function(runSearch){		
		runSearch({});
	}
	
	
	this.setLoading = function() {
		$(this.layoutProvider.domId).innerHTML = '<div class="center"><img src="'+rootPath+'images/loading/ajax-loader.gif" /></div>';
		this.onLoading();
	}
	this.load = function(){
		SearchEngine.getResults(Object.toJSON(this.queryData), function(results){
			self.result = results.evalJSON();
			
			try {
				self.layoutProvider.setDisplay(self);
			} catch(e){self.layoutProvider.setDisplay(self.result);}
			
			if (self.queryData.isPaginated && (self.result.totalCount>self.result.pageOffset)){
				self.setPagination();
			}
			self.onAfterSearch(self.result);
		});
		
	}
	
	this.setLayoutProvider = function(provider) {
		this.layoutProvider = provider;
	}
	
	this.enablePagination = function(enable){
		this.queryData.isPaginated = enable;
	}
	
	this.setCountLimit = function(num){
		this.queryData.countLimit = num;
	}
	
	this.setPagination = function(){
		
		var numPages = Math.ceil(this.result.totalCount/this.result.pageOffset);
		
		var container = document.createElement("div");
		
		if (this.queryData.pageIndex>1) {
			var link = document.createElement("a");
			link.style.paddingRight = "5px";
			link.onclick = function(){
				self.setPageIndex(self.queryData.pageIndex-1);
				self.run(false);
			}
			link.href = "javascript:void(0)";
			link.innerHTML = "&lt; " + MESSAGE_BUTTON[9];
			container.appendChild(link);
		}
		
		
		/*
		(numPages).times(function(num){
			if (self.queryData.pageIndex==(num+1)) {
				container.appendChild(document.createTextNode(num+1));
			} else {
				var link = document.createElement("a");
				link.style.padding = "0 3px 0 3px";
				link.onclick = function(){
					self.setPageIndex(num+1);
					self.run(false);
				}
				link.href = "javascript:void(0)";
				link.innerHTML = num+1;
				container.appendChild(link);
			}
		});
		*/
		
		if (this.queryData.pageIndex<numPages) {
			var link = document.createElement("a");
			link.style.padding = "0 3px 0 3px";
			link.onclick = function(){
				self.setPageIndex(self.queryData.pageIndex+1);
				self.run(false);
			}
			link.href = "javascript:void(0)";
			link.innerHTML = MESSAGE_BUTTON[10] + " &gt;";
			container.appendChild(link);
		}
		
		Element.show(this.domPaginationId);
		$(this.domPaginationContentId).innerHTML = "";
		
		$(this.domPaginationContentId).appendChild(container);
		
	}
	
	this.setPaginationElements = function(id, id2){
		this.domPaginationId = id;
		this.domPaginationContentId = id2;
	}
	
	this.onBeforeSearch = function(){return true};
	this.onAfterSearch = function(){};
	this.onLoading = function(){};
	
	this.setMainTable = function(tableName, tableAlias, tableId){
		this.queryData.tableName = tableName;
		this.queryData.tableAlias = tableAlias;
		this.queryData.tableId = tableId;
	}
	
	this.setSelectPart = function(select){
		this.queryData.select = select;
	}
	
	this.setGroupByClause = function(clause){
		this.queryData.groupByClause = clause;
	}
	
	this.setOrderBy = function(clause, direction){
		this.queryData.orderByClause = (direction) ? clause+" "+direction : clause;
	}

	this.addTable = function(tableName, jointure, values){
		this.queryData.tablesWithInnerJoin.push({jointure:tableName+" ON ("+jointure+")", values:values || []});
	}
	
	this.addTableWithLeftJoin = function(tableName, jointure, values){
		this.queryData.tablesWithLeftJoin.push({jointure:tableName+" ON ("+jointure+")", values:values || []});
	}
	
	this.addWhereClause = function(clause, values){
		this.queryData.whereClauses.push({clause:clause, values:values || []});
	}
	
	this.getWhereClauses = function() {
		return this.queryData.whereClauses;
	}
	
	this.setPageIndex = function(index){
		this.queryData.pageIndex = index;
	}
	
	this.init();
	
}


mt.component.layout.CustomLayout = function(domId){
	this.domId = domId;
	this.setDisplay = function(engineInstance) {};
}


mt.component.layout.TableLayout = function(domId){
	var self = this;
	
	this.domId = domId;
	this.headers = [];
	this.selectionEnabled = false;
	this.selectionItems = [];
	this.selections = [];
	this.tableWidth = "auto";
	this.displayHeader = true;
	this.lineSelection = false;
	
	var TableHeader = function(h, n){
		this.sortingEnabled = false;
		this.sortingClause = "";
		this.sortingDirectionDefault = "desc";
		this.sortingDirection = "";
		
		this.getHeaderContent = function() {return h;}
		this.getCellContent = function(obj,cell) {
			if (n) return obj[n];
		};
		this.enableSorting = function(enable, clause, direction){
			this.sortingEnabled = enable;
			this.sortingClause = clause;
			if (direction) {
				this.sortingDirectionDefault = direction;
				this.sortingDirection = direction;
			}
		}
		
		this.isSortingEnabled = function(){
			return this.sortingEnabled;
		}
		
		this.getSortingClause = function(){
			return this.sortingClause;
		}
		
		this.setSortingDirection = function(direction){
			this.sortingDirection = direction;
		}
		
		this.getSortingDirection = function(){
			return this.sortingDirection;
		}
		
		this.getSortingDirectionDefault = function(){
			return this.sortingDirectionDefault;
		}
		
		
	}
	
	this.init = function(){
		this.selectionItems = [];
	}
	
	this.setTableWidth = function(w){
		this.tableWidth = w;
	}
	
	this.setDisplayHeader = function(enable){
		this.displayHeader = enable;
	}

	this.setCountElement = function(id){
		this.countElement = id;
	}
	
	this.setLineSelection = function(b){
		this.lineSelection = b;
	}
	
	this.onSelect = function(){}
	
	this.setDisplay = function(engineInstance) {
		var result = engineInstance.result;
		
		var divHeader = document.createElement("div");
		var phrase = (result.totalCount<500)?'<span style="color:#F60">{num}</span> results':'more than <span style="color:#F60">{num}</span> results';
		if (this.countElement) $(this.countElement).innerHTML = phrase.replace("{num}", result.totalCount);
		divHeader.innerHTML = phrase.replace("{num}", result.totalCount);
		divHeader.style.fontSize = "13px";
		divHeader.style.fontWeight = "bold";
		divHeader.style.padding = "4px 8px 4px 0";
		divHeader.style.backgroundColor = "#FAFAFA";
		divHeader.style.marginBottom = "6px";
		divHeader.style.textAlign = "right";
		
		var table = document.createElement("table");
		table.className = "SE_TableLayout";
		table.style.borderCollapse = "collapse";
		table.style.width = this.tableWidth;
		
		var tbody = document.createElement("tbody");
		table.appendChild(tbody);
		
		var trHeader = document.createElement("tr");
		mt.dom.disableSelection(trHeader);
		trHeader.style.cursor = "default";
		trHeader.className = "header";
		tbody.appendChild(trHeader);
		
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
			/*
			var th = document.createElement("th");
			item.domElm = th;
			//th.style.textTransform = "uppercase";
			th.style.verticalAlign = "top";
			th.style.textAlign = "left";
			th.style.padding = "5px 0 5px 6px";
			th.innerHTML = item.getHeaderContent();
			trHeader.appendChild(th);
			*/
			var th = document.createElement("th");
			item.domElm = th;
			
			var table = document.createElement("table");
			table.style.width = "100%";
			table.style.borderCollapse = "collapse";
			var tbody = document.createElement("tbody");
			var tr = document.createElement("tr");			
			var td1 = document.createElement("td");
			td1.innerHTML = item.getHeaderContent();
			tr.appendChild(td1);			
			if (item.isSortingEnabled()){
				var td2 = document.createElement("td");
				
				tr.appendChild(td2);
			}			
			tbody.appendChild(tr);
			table.appendChild(tbody);
			
			th.appendChild(table);				
			
			trHeader.appendChild(th);
			
			if (item.isSortingEnabled()){
				
				if (engineInstance.getQueryData().orderByClause.indexOf(item.getSortingClause())!=-1) {
					th.style.backgroundPosition = "0 -25px";
					td2.style.width = "15px";
					var direction = (item.getSortingDirectionDefault()==item.getSortingDirection())?"desc":"asc";
					td2.style.background = 'url('+rootPath+'/images/icons/table_sort_'+direction+'.png) no-repeat 0 4px';
				}
				
				th.style.cursor = "pointer";
				th.onmouseover = function(){
					th.style.backgroundPosition = "0 -25px";
				}
				th.onmouseout = function(){
					if (engineInstance.getQueryData().orderByClause.indexOf(item.getSortingClause())==-1) {
						th.style.backgroundPosition = "top left";
					}
				}
				th.onmousedown = function(){
					if (engineInstance.getQueryData().orderByClause.indexOf(item.getSortingClause())!=-1) {
						if (item.getSortingDirection()=="asc"){
							item.setSortingDirection("desc");
						} else {
							item.setSortingDirection("asc");
						}
					} else {
						item.setSortingDirection(item.getSortingDirectionDefault());						
					}
					engineInstance.setOrderBy(item.getSortingClause(), item.getSortingDirection());
					engineInstance.run(true);
				}
			}
		});

		result.dataset.each(function(item,index){
			var colorLine = (index%2==0)?"#EEE":"#C3D9FF";
			var tr1 = document.createElement("tr");
			//tr1.style.backgroundColor = color;
			tr1.className = "color"+index%2;

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
				td.style.padding = "5px 5px 2px 6px";
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
	
	this.setSelections = function(dataset){
		self.selectionItems.each(function(chk){
			dataset.each(function(id){
				if (id==chk.item[self.selectionItem]) {
					chk.checked = true;
					var elm = chk;
					while(elm.nodeName!="TR") {elm = elm.parentNode};
					elm.className = "color_selected";
				}	
			});
		});
	}
	
	this.getSelectionsId = function(){
		var selections = [];
		this.selectionItems.each(function(chk){
			if (chk.checked) selections.push(chk.item[self.selectionItem]);
		});
		return selections;
	}
	
	this.addHeader = function(h, n){
		var header = new TableHeader(h, n);
		this.headers.push(header);
		return header;
	}	
		
	
}


