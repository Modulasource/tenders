//TODO: security (chiffrement)

//TODO: like clauses (type_varchar, type_text) à mettre en place si on enregistre les données en bdd avec le prevent
mt.component.SearchEngine = function(name,dg_name,page_name,infos_count,infos_limit,advanced) {
	var self = this;
	var disableOnClick = false;
	
	//var TYPE_VARCHAR = 1;
	//var TYPE_TEXT = 2;
	this.bUseHttpPrevent = true;
	this.bUseBeanGeneratorConnection = false;
	
	this.bUseContextLineMenu = false;
	this.bUseContextLineMenuAll = false;
	this.bUseContextLinkMenu = false;
	this.bUseContextLinkMenuAll = false;
	this.contextLineMenuLink = "";
	this.contextLineMenuLinkParams = "";
	this.sTabPrefix = "";
	
	this.sLabelElement = "";
	this.sLabelPlurialElement = "";
	this.bFemaleKindElement = false;
    
    this.bAddChexbox = false;
    this.sPrefixChexbox = "";
    this.sClassChexbox = "";
    this.headerSelect;
    this.unselectedItems = new Array();
	
	this.vHeaders = [];

	/** SQL */
	this.sSelectPart;
	this.sMainTable;
	this.sMainAliasTable;
	this.vOtherTables = [];
	this.vOtherTablesWithLeftJoin = [];
	this.vFilter = [];
	this.sGeneratedRequest = "";
	this.sGeneratedRequestSecure = "";
	this.sGroupByClause;
	this.bSelectWithDistinct;//unused
	this.sIdInTable;

	/** OPTIONS */
	this.iCurrentPage = 0;
	this.useCurrentPageFromPagination = false;
	this.useCurrentPageOrder = false;
	this.useCurrentBatch = false;
	this.iMaxElementsPerPage = 20;
	this.iGroupPerPage = 10;
	this.vResults;
	this.iTotalCountCriterias = 0;
	this.bMaxElementsCountUsed = true;
	this.bMaxElementsCountReach = false;
	this.iMaxElementsCount = 1000;
	this.iCurrentPageCount = 0;
	this.activeKeypressSearch = true;
	this.useMaxElementSelectPaginate = true;
	this.useMaxElementSelectCount = true;
	this.disableSearch = false;
	
	/** STYLE */
	this.paginationLinkClassName = "se_pagination";
	this.paginationIconPrefix = "blue_";
	this.headerIconPrefix = "blue_";
	this.headerLinkClassName = "se_header";
	this.lineBackground = "";
	this.lineBackgroundBis = "";
	this.lineBackgroundHover = "";
	this.lineColorHover = "";
	this.addLineCursor = false;
	
	this.initDataGrid = function(){
		this.dg = new mt.component.DataGrid(dg_name);
		this.dg.addStyle("width", "100%");
		this.onLoadDataGrid();
	}
	this.onLoadDataGrid = function() {};
	
	this.addOtherTable = function(tableName,jointure,leftjoin){
		var table = new mt.component.SearchEngineTable(tableName,jointure,leftjoin);
		this.vOtherTables.push(table);
	}
	this.addOtherTableWithLeftJoin = function(tableName,jointure){
		var table = new mt.component.SearchEngineTable(tableName,jointure);
		this.vOtherTablesWithLeftJoin.push(table);
	}
	
	Event.observe (document,'keypress',
        function(evt){
            if(evt.keyCode==Event.KEY_RETURN && self.activeKeypressSearch) 
            {            
                Event.stop(evt);
                self.search();
            }
        }
    );
	/**
	* fields = Array
	* liste des champ de la recherche
	* si plusieurs champ alors ils sont séparé par un OR
	
	* values = Array
	* liste de valeurs recherchees
	* si plusieurs valeurs alors utilisation d'un IN
	
	* optLike = Boolean
	* si optLike = true alors utilisation de LIKE %% sinon =
	*
	* compareFilter = String
	* valeurs : =, >=, <>, <= etc
	*/

	this.addFilter = function(fields,values,optLike,compareFilter){
		if(!isNotNull(compareFilter))
			compareFilter = "=";
		var filter = new mt.component.SearchEngineFilter(fields,values,optLike,compareFilter);
		this.vFilter.push(filter);
		return filter;
	}
	this.setGroupByClause = function(group){
		this.sGroupByClause = group;
	}
	this.addCheckbox = function(sPrefix,sClass,header,mode){
        this.bAddChexbox = true;
        this.sPrefixChexbox = sPrefix;
        this.sClassChexbox = isNotNull(sClass)?sClass:"";
        
        var headerCB = "";
        if(isNotNull(sClass) && (!header || !isNotNull(header)) ){
            if(mode=="simple" || !mode){
	            headerCB = document.createElement("input");
	            headerCB.type = "checkbox";
	            headerCB.onclick = function(){
	                $$("."+self.sClassChexbox).each(
	                    function(item){
	                        item.checked=headerCB.checked;
	                    }
	                );
	            }
	        }else if(mode=="advanced"){
	           var headerCB = document.createElement("div");
	           headerCB.style.width = "32px";
	           
	           var span = document.createElement("span");
	           span.innerHTML = "<img style=\"vertical-align : middle;\" src=\"" + rootPath + "images/icons/cart.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[14]+"\" title=\""+MESSAGE_AJAX_SEARCH[14]+"\" />" +
	           		"<img style=\"vertical-align : middle;\" src=\"" + rootPath + "images/icones/fleches/" + self.headerIconPrefix+"next.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[14]+"\" title=\""+MESSAGE_AJAX_SEARCH[14]+"\" />";
                
	           span.style.cursor = "pointer";
	           headerCB.appendChild(span);
	           span.onclick = function(){
	               Element.toggle(div);
	               if(div.style.display=="none"){
	               span.innerHTML = "<img style=\"vertical-align : middle;\" src=\"" + rootPath + "images/icons/cart.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[14]+"\" title=\""+MESSAGE_AJAX_SEARCH[14]+"\" />" +
	            	   "<img style=\"vertical-align : middle;\" src=\"" 
                                    + rootPath + "images/icones/fleches/" + self.headerIconPrefix+"next.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[14]+"\" title=\""+MESSAGE_AJAX_SEARCH[14]+"\" />";
                
	               }else{
	               span.innerHTML = "<img style=\"vertical-align : middle;\" src=\"" + rootPath + "images/icons/cart.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[14]+"\" title=\""+MESSAGE_AJAX_SEARCH[14]+"\" />" +
	            	   "<img style=\"vertical-align : middle;\" src=\"" 
                                    + rootPath + "images/icones/fleches/" + self.headerIconPrefix+"desc.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[14]+"\" title=\""+MESSAGE_AJAX_SEARCH[14]+"\" />";
                    }
	           }
	           
	           var div = document.createElement("div");
	           div.style.width = "100px";
	           div.style.padding = "2px";
	           div.style.display = "none";
	           div.style.position = "absolute";
	           div.style.border = "1px solid #C2CCE0";
	           div.style.backgroundColor = "#FFFFFF";
               
               var divNone = document.createElement("div");
               divNone.setAttribute("mode","none");
               divNone.innerHTML = "<img style=\"margin-right:5px;vertical-align : middle;\" src=\"" 
                                    + rootPath + "images/icons/application_delete.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[11]+"\" title=\""+MESSAGE_AJAX_SEARCH[11]+"\" /> "+MESSAGE_AJAX_SEARCH[11];
               
               var divPage = document.createElement("div");
               divPage.setAttribute("mode","page");
               divPage.innerHTML = "<img style=\"margin-right:5px;vertical-align : middle;\" src=\"" 
                                    + rootPath + "images/icons/application.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[12]+"\" title=\""+MESSAGE_AJAX_SEARCH[12]+"\" /> "+MESSAGE_AJAX_SEARCH[12];
              
               var divAll = document.createElement("div");
               divAll.setAttribute("mode","all");
               divAll.innerHTML = "<img style=\"margin-right:5px;vertical-align : middle;\" src=\"" 
                                    + rootPath + "images/icons/application_cascade.gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[13]+"\" title=\""+MESSAGE_AJAX_SEARCH[13]+"\" /> "+MESSAGE_AJAX_SEARCH[13];
               
               div.appendChild(divPage);
               div.appendChild(divAll);
               div.appendChild(divNone);
               
               divNone.style.padding = divPage.style.padding = divAll.style.padding = "2px";
               divNone.style.cursor = divPage.style.cursor = divAll.style.cursor = "pointer";
               divNone.onclick = divPage.onclick = divAll.onclick = function(){
                    var mode = this.getAttribute('mode');
                    headerCB.setAttribute("mode",mode);
                    divNone.setAttribute("bg","");divPage.setAttribute("bg","");divAll.setAttribute("bg","");
                    divNone.style.backgroundColor = divPage.style.backgroundColor = divAll.style.backgroundColor = "";
                    this.style.backgroundColor = "#8FD783";
                    this.setAttribute("bg",this.style.backgroundColor);
 
                    $$("."+self.sClassChexbox).each(
                        function(item){
                        	var id = item.name.split("_")[1]; 
                            item.checked=(mode=="page" || mode=="all");
                            if(item.checked){
                        		self.unselectedItems = self.unselectedItems.without(id);
                	        }else{
                	        	if(self.unselectedItems.indexOf(id)<0) self.unselectedItems.push(id);
                	        }
                        }
                    );
                    span.onclick();
               }
               divNone.onmouseover = divPage.onmouseover = divAll.onmouseover = function(){
                    this.setAttribute("bg",this.style.backgroundColor);
                    this.style.backgroundColor = "#AADDFF";
               }
               divNone.onmouseout = divPage.onmouseout = divAll.onmouseout = function(){
                    this.style.backgroundColor = this.getAttribute('bg');
               }
               
               headerCB.appendChild(div);
            }
            
        }else if(header) headerCB = header;
        
        this.addHeader(headerCB,[""],"").onPopulate = function(values,mainId, itemIdx){
            var id = mainId;
            var cb = document.createElement("input");
            cb.type = "checkbox";
            cb.className = self.sClassChexbox;
            cb.name = cb.id = self.sPrefixChexbox+id;
            cb.onclick = function(){
            	disableOnClick = true;
            	if(this.checked){
            		self.unselectedItems = self.unselectedItems.without(id);
    	        }else{
    	        	if(self.unselectedItems.indexOf(id)<0) self.unselectedItems.push(id);
    	        }
            }
            try{
                var mode = headerCB.getAttribute('mode');
                cb.checked=(mode=="page" || mode=="all");
                if(self.unselectedItems.indexOf(id)>=0){
                	cb.checked = false;
                }
            }catch(e){}
            self.onAddCheckbox(cb);
            return cb;
        };
        this.headerSelect = headerCB;
    }
	
	this.onAddCheckbox = function(cb){};
    
    this.generateSelectedItems = function(forceMode){
	    var params = new Object();
	    var bFirstItem = true;
        
        var mode = "";
        if(isNotNull(forceMode)) mode = forceMode;
        else mode = this.headerSelect.getAttribute('mode');
        
	    if(mode=="all"){
	    	var idus = "";
	    	this.unselectedItems.each(function(item){
	    		if(bFirstItem){
                    bFirstItem=false;
                }else{
                	idus += ",";
                }
	    		idus += item;
	    	});
	    	
            params = {selected:this.sGeneratedRequestSecure,
            mode:"all",
            sMainAliasTable:this.sMainAliasTable,
            sMainTable:this.sMainTable,
            unselected:idus};
	    }else{
	        var ids = "";
		    $$("."+this.sClassChexbox).each(function(item){
	            if(item.checked)
	            {
	                if(bFirstItem){
	                    bFirstItem=false;
	                }else{
	                    ids += ",";
	                }
	                var id = item.name.split("_")[1]; 
	                ids += id;
	            }
	        });
	        params = {selected:ids};
	    }
	    return params;
	}

	this.addHeader = function(title,select,order,direction){
		var header = new mt.component.SearchEngineHeader(title,select,order);
		header.direction = direction;
		this.vHeaders.push(header);
		return header;
	}

	this.render = function() {
		if(isNotNull(dg_name)){
			this.dg = new mt.component.DataGrid(dg_name);
			this.dg.addStyle("width", "100%");
			this.onLoadDataGrid();
		}
		if(isNotNull(name))
			this.domNode = $(name);
		if(isNotNull(page_name))
			this.domPage = $(page_name);
		if(isNotNull(infos_count))
			this.domCount = $(infos_count);
		if(isNotNull(infos_limit))
			this.domLimit = $(infos_limit);
			//Element.hide(this.domLimit);
		if(isNotNull(advanced)){
			this.domAdvanced = $(advanced);	
			Element.show(this.domAdvanced);
		}
	
		var headers = new Array();
		this.initDataGrid();
		this.initAdvancedFunction();
		
		this.vHeaders.each(function(header,index){
			
			var direction = "";
			var headerElement = document.createElement("div");
			var headerRemove = document.createElement("a");
			headerRemove.className = self.headerLinkClassName;
			var headerAdd = document.createElement("a");
			headerAdd.className = self.headerLinkClassName;
			
			if(isNotNull(header.direction)){
				direction = "";

				headerRemove.href = "javascript:void(0);";
				headerRemove.onclick = function() {
				      self.removeOrderBy(header);
				}
				headerRemove.innerHTML = "&nbsp;<img style=\"vertical-align : middle;\" src=\"" 
									+ rootPath + "images/icones/fleches/" + self.headerIconPrefix+header.direction+".gif" + "\" alt=\""+MESSAGE_AJAX_SEARCH[15]+"\" title=\""+MESSAGE_AJAX_SEARCH[15]+"\" />";
				
				if( header.direction == "desc"){
					direction = "asc";
				}else{
					direction = "desc";
				}
			}else{
				direction = "desc";
			}
			if(!isNotNull(header.order)){
				headerAdd = document.createElement("label");
			}else{
				headerAdd.href = "javascript:void(0);";
				headerAdd.onclick = function() {
					self.addOrderBy(header,direction);
				}
			}
			if(typeof(header.title) == "string")
              headerAdd.innerHTML = header.title;
            else
              headerAdd.appendChild(header.title);

			headerElement.appendChild(headerAdd);
			headerElement.appendChild(headerRemove);
			headers.push(headerElement);
		});
		this.dg.setHeader(headers);
	}
	
	this.onSelect = function() {};
	this.onSelectDoubleClick = function() {};
	this.onBeforeAddItem = function(item, itemPrev, index) {};
	this.onAfterAddItem = function(item, itemPrev, index, lineData) {};
	this.onAfterAddLastItem = function(item) {};
	this.onMouseOver = function(line) {};
	this.onMouseOut = function(line) {};
	
	this.addContextMenu = function(){
	   var sTab = this.sTabPrefix;
       if(this.bUseContextLinkMenu){
           $$(".contextmenu").each(function(item, index){
                item.addClassName("contextmenu"+index);
                var myLinks = [
                {name: MESSAGE_AJAX_SEARCH[1], callback: function(){
                    parent.addParentTabForced(item.innerHTML,item.href);
                }}
                ];
                if(self.bUseContextLinkMenuAll){
                	myLinks = [
                               {name: MESSAGE_AJAX_SEARCH[1], callback: function(){
                                   parent.addParentTabForced(item.innerHTML,item.href);
                               }},
                               {name: MESSAGE_AJAX_SEARCH[18], callback: function(){
                            	   $$(".contextmenu").each(function(itemAll, indexAll){
                            		   parent.addParentTabForced(itemAll.innerHTML,indexAll.href);
                            	   });
                               }}
                               ];
                }
                new Proto.Menu({selector: '.contextmenu'+index,className: 'menu firefox', menuItems: myLinks});
           });
       }
       if(this.bUseContextLineMenu && isNotNull(this.contextLineMenuLink)){
           $$(".contextlinemenu").each(function(item, index){
               item.addClassName("contextmenu"+index);
               var myLinks = [
               {name: MESSAGE_AJAX_SEARCH[1], callback: function(){	   
            	   if(isNotNull(sTab)) parent.addParentTabForced(MESSAGE_AJCL[5],self.contextLineMenuLink+item.data+self.getMenuLinkParam(item),false, sTab+item.data,sTab+item.data );
            	   else parent.addParentTabForced(MESSAGE_AJCL[5],self.contextLineMenuLink+item.data+self.getMenuLinkParam(item) );
               }}
               ];
               if(self.bUseContextLineMenuAll){
            	   myLinks = [
            	              {name: MESSAGE_AJAX_SEARCH[1], callback: function(){            	 
            	            	  if(isNotNull(sTab)) parent.addParentTabForced(MESSAGE_AJCL[5],self.contextLineMenuLink+item.data+self.getMenuLinkParam(item),false, sTab+item.data,sTab+item.data );
            	            	  else parent.addParentTabForced(MESSAGE_AJCL[5],self.contextLineMenuLink+item.data+self.getMenuLinkParam(item) );
            	              }},
            	              {name: MESSAGE_AJAX_SEARCH[18], callback: function(){
            	            	  self.openAllTab();
            	              }}
            	              ];
               }
               new Proto.Menu({selector: '.contextmenu'+index,className: 'menu firefox', menuItems: myLinks});
          });
        }
    }
	
	this.getMenuLinkParam = function(line){
		return (isNotNull(this.contextLineMenuLinkParam)?self.contextLineMenuLinkParam:"");
	}
	
	this.openAllTab = function(){
		var sTab = this.sTabPrefix;
		$$(".contextlinemenu").each(function(itemAll, indexAll){
   		  if(isNotNull(sTab)) parent.addParentTabForced(MESSAGE_AJCL[5],self.contextLineMenuLink+itemAll.data+self.getMenuLinkParam(itemAll),false, sTab+itemAll.data,sTab+itemAll.data );
   		  else parent.addParentTabForced(MESSAGE_AJCL[5],self.contextLineMenuLink+itemAll.data+self.getMenuLinkParam(itemAll) );
   	  });
	}
    
	this.populate = function() {
		//$(dg_name).style.display = "block";
		this.dg.removeAll();
		var itemPrev = null;

		this.vResults.each(function(item,index) {
			if(item.iCurrentPageCount >= 0){
				self.iCurrentPageCount = item.iCurrentPageCount;
			}else if(item.bMaxElementsCountReach == true || item.bMaxElementsCountReach == false){
				self.bMaxElementsCountReach = item.bMaxElementsCountReach;
			}
			else if(isNotNull(item.sPagination)){
				self.paginate(item.sPagination.evalJSON());
			}else if(item.iTotalCountCriterias >= 0){
				self.iTotalCountCriterias = item.iTotalCountCriterias;
			}else if(isNotNull(item.sGeneratedRequest)){
				self.sGeneratedRequest = item.sGeneratedRequest;
				if(debugMode) {
					spanRequest.innerHTML 
						= self.sGeneratedRequest.replace(/[\r\n]+/g, "<br>\n");
				}
			}
			else if(isNotNull(item.sGeneratedRequestSecure)){
                self.sGeneratedRequestSecure = item.sGeneratedRequestSecure;
            }
			else{
				var values = [];
				self.vHeaders.each(function(header){
					var selectValues = [];
					if (header.selection) {
						header.selection.each(function(value){
							selectValues.push(item[value]);
						});
						values.push(header.onPopulate(selectValues,item[self.sIdInTable],index));
					} else {
						values.push(header.onPopulate(item,"",index));
					}
				});
	
				self.onBeforeAddItem(item, itemPrev, index);
				var lineData = self.dg.addItem(values);
				self.onAfterAddItem(item, itemPrev, index, lineData);
				itemPrev = item;
				
				var line = lineData.node;
				line.data = item[self.sIdInTable];
				line.item = item;
				
				if(self.bUseContextLineMenu){
					Element.addClassName(line,"contextlinemenu");
				}
				
				var modulo = index%2;
				if(modulo==0 && isNotNull(self.lineBackground)){
					line.style.backgroundColor = self.lineBackground;			
				}
				if(modulo==1 && isNotNull(self.lineBackgroundBis)){
					line.style.backgroundColor = self.lineBackgroundBis;			
				}
				
				var lineBg = line.style.backgroundColor;
				var lineColor = line.style.color;
				if(self.addLineCursor){
				    line.style.cursor = "pointer";
				    
				    line.onmouseover = function() {
	                    this.style.backgroundColor = self.lineBackgroundHover; 
	                    if(self.lineColorHover != ""){
	                       this.style.color = self.lineColorHover; 
	                    }      
	                    
	                    self.onMouseOver(this);          
	                }
	                line.onmouseout = function() {
	                    this.style.backgroundColor = lineBg;
	                    if(self.lineColorHover != ""){
                           this.style.color = lineColor; 
                        } 
                        
                        self.onMouseOut(this);
	                }
				}
				/*
				line.onmouseover = function() {
					this.style.backgroundColor = "#FFF6C1";					
				}
				line.onmouseout = function() {
					this.style.backgroundColor = "#FAFAFA";
				}
				*/
				
				line.ondblclick = function() {
					if(!disableOnClick){
					   self.onSelectDoubleClick(item);
					}
					disableOnClick = false;
				}
				
				line.onclick = function() {
					if(!disableOnClick){
					   self.onSelect(item);
					}
					disableOnClick = false;
				}
			}
		});
		
		try{this.onAfterAddLastItem(itemPrev);}catch(e){}
		if (!this.dg.bRendered) this.dg.render();
		try{this.addContextMenu();}catch(e){alert("SearchEngine addContextMenu : "+e);}
	}
	
	/** PAGINATION */
	this.onPaginate = function(){};
	this.onPaginateElement = function(item){
		var link = document.createElement("a");
		link.className = self.paginationLinkClassName;
		link.href = "javascript:void(0);";
		var bActiveLink = true;
		if(item.name == "current"){
			link.innerHTML = "["+(item.value+1)+"]";
			bActiveLink = false;
		}else if(item.name == "page"){
			link.innerHTML = item.value+1;
		}else{
			link.innerHTML = "&nbsp;<img style=\"vertical-align : middle;\" src=\"" + rootPath + "images/icones/fleches/"+self.paginationIconPrefix+item.name+".gif" + "\" alt=\""+item.label+"\" title=\""+item.label+"\" />";
		}
		
		if(bActiveLink){
			link.onclick = function() {
				self.iCurrentPage = item.value;
				self.useCurrentPageFromPagination = true;
				self.render();
				self.search(true);
			}
		}
		self.domPage.appendChild(link);
	}
	this.paginate = function(pagination){
		
		while (self.domPage.firstChild) {
		  self.domPage.removeChild(self.domPage.firstChild);
		}
		pagination.each(function(item,index) {
			if(isNotNull(item)){
				self.onPaginateElement(item);
			}
		});
		
		this.onPaginate();
		
		if(self.useMaxElementSelectPaginate) {
			self.useMaxElementSelect(self.domPage,false);
		}
	}
	this.useMaxElementSelect = function(divContent, attach){
		/** MaxElementsPerPage */
		var divCountElement = document.createElement((attach)?"span":"div");
		if(!attach){
			divCountElement.style.cssFloat = 'right'; 
			divCountElement.style.styleFloat = 'right'; 
		}
		divCountElement.style.marginBottom = "5px";
		divCountElement.style.marginLeft = "5px";
		
		var selectCountElement = document.createElement("select");
		mt.html.setSuperCombo(selectCountElement);
		selectCountElement.populate([{data:"20",value:"20"},{data:"50",value:"50"},
		                             {data:"100",value:"100"},{data:"200",value:"200"},
		                             {data:"500",value:"500"},{data:"1000",value:"1000"}]);
		selectCountElement.onchange = function(){
			self.useCurrentPageFromPagination = true;
			self.setMaxElementsPerPage(this.value);
			self.search(true);
		}
		selectCountElement.setSelectedValue(self.iMaxElementsPerPage);
		divCountElement.appendChild(selectCountElement);
		divContent.appendChild(divCountElement);
		/** end MaxElementsPerPage */
	}
	
	/** COUNT */
	this.infoCount = function(){
		var sPlurial = "";//on n'accorde pas en fait//((this.iTotalCountCriterias>1)?"s":"");
		var sKind = "";//on n'accorde pas en fait//((this.bKindFemaleElement)?"e":"");
		var sLabel = this.sLabelElement;
		if(isNotNull(this.sLabelPlurialElement) && this.iTotalCountCriterias>1)
			sLabel = this.sLabelPlurialElement;
		
		this.domCount.innerHTML = "";
		var msgNoResult = ((this.bKindFemaleElement)?MESSAGE_AJAX_SEARCH[16]:MESSAGE_AJAX_SEARCH[17]);//MESSAGE_AJAX_SEARCH[9].replace("%1",sKind);
		var msgResult = MESSAGE_AJAX_SEARCH[10].replace("%1",sLabel);
		msgResult = msgResult.replace("%2",sKind);
		
		this.domCount.innerHTML = (this.iTotalCountCriterias>0?this.iTotalCountCriterias:msgNoResult) + " "+msgResult;
		
		while (self.domLimit.firstChild) {
		  self.domLimit.removeChild(self.domLimit.firstChild);
		}
		
		if(this.bMaxElementsCountUsed && this.bMaxElementsCountReach){
			if(this.iCurrentPageCount>0){
				var link = document.createElement("a");
				link.className = self.paginationLinkClassName;
				link.href = "javascript:void(0);";
				link.innerHTML = MESSAGE_AJAX_SEARCH[2];
				
				link.onclick = function() {
					self.iCurrentPageCount--;
					self.useCurrentPageFromPagination = true;
					self.render();
					self.search(true);
				}
				self.domLimit.appendChild(link);
			}
			var span = document.createElement("span");
			span.innerHTML = " "+MESSAGE_AJAX_SEARCH[4]+" : "+(this.iCurrentPageCount*this.iMaxElementsCount)+" > "+((this.iCurrentPageCount+1)*this.iMaxElementsCount);
			self.domLimit.appendChild(span);
			
			var link = document.createElement("a");
			link.className = self.paginationLinkClassName;
			link.href = "javascript:void(0);";
			link.innerHTML = MESSAGE_AJAX_SEARCH[3];
			
			link.onclick = function() {
				self.iCurrentPageCount++;
				self.useCurrentPageFromPagination = true;
				self.render();
				self.search(true);
			}
			self.domLimit.appendChild(link);
		}
		
		if(self.useMaxElementSelectCount) {
			self.useMaxElementSelect(self.domLimit,true);
		}
	}
	
	/** ADVANCED FUNCTION */
	var inputCutCount;
	var chkLimit;
	var inputNbResults;
	var divAdvancedFunction;
	var spanRequest;
	this.hideAdvancedFunction = function(){
		try{Element.hide(divAdvancedFunction);}catch(e){}
	}
	this.showAdvancedFunction = function(){
		try{Element.toggle(divAdvancedFunction);}catch(e){}
	}
	this.applyAdvancedFunction = function(){
		try{
			this.bMaxElementsCountUsed = chkLimit.checked;
			this.iMaxElementsCount = inputCutCount.value;
			this.iMaxElementsPerPage = inputNbResults.value;
		}catch(e){alert(e);}
	}
	this.setMaxElementsPerPage = function(i){
		try{
			this.iMaxElementsPerPage = i;
			inputNbResults.value = i;
		}catch(e){alert(e);}
	}
	this.initAdvancedFunction = function(){
		
		
		if(isNotNull(this.domAdvanced)){
			while (self.domAdvanced.firstChild) {
			  self.domAdvanced.removeChild(self.domAdvanced.firstChild);
			}
			
			divAdvancedFunction = document.createElement("div");
			divAdvancedFunction.style.paddingTop = "5px";
			
			var divLimit = document.createElement("div");
			chkLimit = document.createElement("input");
			chkLimit.type = "checkbox";

			var span = document.createElement("span");
			span.style.paddingLeft = "5px";
			span.innerHTML = MESSAGE_AJAX_SEARCH[5];
			divLimit.appendChild(chkLimit);
			divLimit.appendChild(span);
			divAdvancedFunction.appendChild(divLimit);
			
			chkLimit.checked = this.bMaxElementsCountUsed;
			
			var divCutCount = document.createElement("div");
			divCutCount.style.marginTop = "5px";
			inputCutCount = document.createElement("input");
			inputCutCount.type = "text";
			inputCutCount.value = this.iMaxElementsCount;
			inputCutCount.maxLength = 4;
			inputCutCount.size = 4;
			inputCutCount.style.marginLeft = "5px";
			var spanCutCount = document.createElement("span");
			spanCutCount.innerHTML = MESSAGE_AJAX_SEARCH[6];
			divCutCount.appendChild(spanCutCount);
			divCutCount.appendChild(inputCutCount);
			divAdvancedFunction.appendChild(divCutCount);
			
			var divNbResults = document.createElement("div");
			divNbResults.style.marginTop = "5px";
			inputNbResults = document.createElement("input");
			inputNbResults.type = "text";
			inputNbResults.value = this.iMaxElementsPerPage;
			inputNbResults.maxLength = 4;
			inputNbResults.size = 4;
			inputNbResults.style.marginLeft = "5px";
			var spanNbResults = document.createElement("span");
			spanNbResults.innerHTML = MESSAGE_AJAX_SEARCH[7];
			divNbResults.appendChild(spanNbResults);
			divNbResults.appendChild(inputNbResults);
			divAdvancedFunction.appendChild(divNbResults);
			
			spanRequest = document.createElement("span");
			if (debugMode) {
				spanRequest.innerHTML 
				 	= self.sGeneratedRequest.replace(/[\r\n]+/g, "<br>\n");
			}
			divAdvancedFunction.appendChild(spanRequest);
			
			var link = document.createElement("a");
			link.href = "javascript:void(0);";
			link.innerHTML = MESSAGE_AJAX_SEARCH[8];
			
			link.onclick = function() {
				self.showAdvancedFunction();
			}
			
			this.domAdvanced.appendChild(link);
			this.domAdvanced.appendChild(divAdvancedFunction);
			
			Element.hide(divAdvancedFunction);
			
		}
	}
	
			
	this.onLoad = function() {};
	this.onBeforeSearch = function() {};
	this.onAfterSearch = function() {this.afterSearch();};
	this.onSearch = function(searchData) {};
	this.search = function(keepUnselected) {
		try{
		if(!keepUnselected) this.unselectedItems = new Array();
		if (!this.disableSearch && !this.domNode ) this.render();
		
		this.onBeforeSearch();
		
		if(isNotNull(this.domCount)) this.domCount.innerHTML = "";

		var searchData = new Object();
		searchData.bUseHttpPrevent = this.bUseHttpPrevent;
		searchData.bUseBeanGeneratorConnection = this.bUseBeanGeneratorConnection;
		
		searchData.sGroupByClause = this.sGroupByClause;
		searchData.vHeaders = this.vHeaders;
		searchData.sSelectPart = this.sSelectPart;
		searchData.sMainTable = this.sMainTable;
		searchData.sMainAliasTable = this.sMainAliasTable;
		searchData.vOtherTables = this.vOtherTables;
		searchData.vOtherTablesWithLeftJoin = this.vOtherTablesWithLeftJoin;
		searchData.vFilter = this.vFilter;
		this.vFilter = [];
		searchData.sIdInTable = this.sIdInTable;
		searchData.iGroupPerPage = this.iGroupPerPage;	
		
		searchData.loadPaginated = (this.loadPaginated) ? true : false;
		
		if(isNotNull(this.domAdvanced)){
			this.applyAdvancedFunction();
		}
		searchData.bMaxElementsCountUsed = this.bMaxElementsCountUsed;
		searchData.iMaxElementsPerPage = this.iMaxElementsPerPage;
		searchData.iMaxElementsCount = this.iMaxElementsCount;
		
		if(this.useCurrentPageFromPagination)
			searchData.iCurrentPageCount = this.iCurrentPageCount;
		else
			searchData.iCurrentPageCount = 0;
		if(this.useCurrentPageFromPagination)
			searchData.iCurrentPage = this.iCurrentPage;
		else
			searchData.iCurrentPage = 0;
		
		this.useCurrentPageOrder = false;
		this.useCurrentPageFromPagination = false;
		this.useCurrentBatch = false;
		
		this.onSearch(searchData);
		
		function callback(results) {
			self.vResults = results.evalJSON();
			self.onAfterSearch();
		}

		if(!this.disableSearch){
			if (this.iIdEngine!=null) {
				AutoFormSearchEngine.getJSONArrayResultFromEngine(this.iIdEngine, Object.toJSON(searchData), callback);
			} else {
				AutoFormSearchEngine.getJSONArrayResult(Object.toJSON(searchData), callback);
			}
		}
		
		
		}catch(e){alert(e);}

	}
	
	this.afterSearch = function(){
		this.populate();
		this.infoCount();
		this.hideAdvancedFunction();
		this.onLoad();
	}
	
	this.addOrderBy = function(header, direction){
		if (this.uniqueSort) {
			this.vHeaders.each(function(h){h.direction = ""});
		}
		header.direction = direction;
		this.useCurrentPageOrder = true;
		this.render();
		this.search(true);
	}
	
	this.removeOrderBy = function(header){
		header.direction = "";
		this.useCurrentPageOrder = true;
		this.render();
		this.search(true);
	}
}

mt.component.SearchEngineTable = function(tableName,jointure,leftJoin) {
	this.tableName = tableName;
	this.jointure = jointure;
	this.leftJoin = leftJoin;
}

/**
* title : string
* selection : Array<String>
* order : string
*/
mt.component.SearchEngineHeader = function(title,selection,order) {
	this.title = title;
	this.order = order;
	this.selection = selection;
	this.direction = "";
	this.separationValue = "<br/>";
	/**
	* values : Array : select values from selection array
	*/
	this.onPopulate = function(values,mainId, itemIdx) {
		var data = "";
		var separationValue = this.separationValue;
		values.each(function(value,index){
			data += value;
			if(index != (values.length-1))
				data += separationValue;
		});
		return data;
	};
}
mt.component.SearchEngineFilter = function(fields,values,optLike,compareFilter) {
	this.fields = fields;
	this.values = values;
	this.optLike = optLike;
	this.compareFilter = compareFilter;
}

mt.component.DataGrid = Class.create();
mt.component.DataGrid.prototype = {
	initialize:function(placeHolder) {
		this.bRendered = false;
		this.domNode = $(placeHolder);
		this.dataSet = [];
		this.columnStyles = [];
		this.createTable();
	},
	createTable:function() {
		this.table = document.createElement("TABLE");
		this.table.className = "dataGrid";
		this.table.cellSpacing = 1;
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
				cell.editor = new mt.component.InPlaceEditor(cell, false);
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
        var self = this;
        /*
        try{
        Sortable.create(this.grid,
        {dropOnEmpty:false,
        constraint:"",
        ghosting:true,
        tag:"tr",
        onUpdate:this.render,
        onChange:this.render,
        containment:[this.grid]});
		}catch(e){alert("Sortable:"+e);}
		
		try{
        var drag = new Draggable(line.node, 
        {ghosting:true});
        }catch(e){alert("Draggable:"+e);}
		*/
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
			var drag = new Draggable(this, {revert:true});
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
		this.bRendered = true;
		this.domNode.innerHTML = "";
		this.domNode.appendChild(this.table);
	}
};

function isNotNull(item) {
	if (item==null || item=="" || item=="undefined" || item=="null") return false;
	return true;
}

mt.component.Envelope = function(name, divList, isNumbered, items, rootPath) {
	var self = this;
	
	this.sortableEventActive = true;
	
	this.rootPath = rootPath;
	this.name = name;
	this.container = $(name);
	this.table;
	this.divList = divList;
	this.items = items;
	
	this.isNumbered = isNumbered;
	
	this.suffixId = "_ids";
	this.prefix = "";
	this.prefixOrder = this.prefix+"order_";
	this.prefixDesc = this.prefix+"desc_";
	this.prefixAction = this.prefix+"actions_";
	this.prefixButton = this.prefix+"button_";
	this.icon = "";
	this.title = "";
	this.cssClass = "";
	
	this.dropOnEmpty=true;
	this.containment = [];
	
	this.setContainment = function(items){
		this.containment = items;
	}
	this.addContainment = function(item){
		this.containment.push(item);
	}
	
	this.setStyle = function(icon, title, cssClass, prefix){
		this.icon = icon;
		this.title = title;
		this.cssClass = cssClass;
		this.prefix = prefix;
		this.prefixOrder = this.prefix+"order_";
		this.prefixDesc = this.prefix+"desc_";
		this.prefixAction = this.prefix+"actions_";
		this.prefixButton = this.prefix+"button_";
	}
	
	this.checkSortable = function()	{
	    if (!this.sortableEventActive) {
	         Event.stopObserving(this.container, "click");
	         this.sortableEventActive = true;
	    }
	}
	
	this.updateList = function(){
		try{self.onUpdateList();}catch(e){}
		
		try{
			var items = Sortable.serialize(self.container.id).split("&");
			$(self.container.id+self.suffixId).value = "";
			for(var i=0;i<items.length;i++){
				var item = items[i];
				var id = item.substr((self.container.id+"[]=").length,item.length);
				$(self.container.id+self.suffixId).value += id+"|";
			}
		}catch(e){/*alert("serialize:"+self.container.id+":"+e);*/}
		
		try{self.updateListNumbers();}catch(e){}
		
		try{
			//$("print").innerHTML += "updateList<br/>";
			//$("print").innerHTML += "container id:"+self.container.id+"<br/>";
			//$("print").innerHTML += "serialize:"+Sortable.serialize(self.container.id)+"<br/>";
		}catch(e){}
	}
	this.onUpdateList = function(){};
	

	this.updateListNumbers = function(){
		var lis = this.container.getElementsByTagName("li");
		for(var i=0;i<lis.length;i++){
			var li = lis[i];
			var id = li.id.substr(this.prefix.length,li.id.length);

			if(this.isNumbered)
				$(this.prefixOrder+id).innerHTML = (i+1)+". ";
			else
				$(this.prefixOrder+id).innerHTML = "";
		}
	}
	
	this.changeList = function(element)	{
	    $("print").innerHTML += "changeList<br/>";
	    $("print").innerHTML += "element:"+element+"<br/>";
		$("print").innerHTML += "element id:"+element.id+"<br/>";
	}
	
	this.createSortable = function(options){
		if(!options){
			Sortable.create(this.name,
			{dropOnEmpty:this.dropOnEmpty,containment:this.containment,constraint:"vertical",
			onUpdate:this.updateList/*,onChange:changeList*/});
		}else{
			Sortable.create(this.name,options);
		}
		this.updateList();
	}
	
	this.render = function(){
		this.createTable();
		this.divList.appendChild(this.table);
		
		this.container = $(this.name);
		this.items.each(function(item, index){
			item.buttons.each(function(button, indexButton){
				new Control.ToolTip($(self.prefixButton+indexButton+"_"+item.id),button.title,{
					className:'infobulle_tooltip',
					position: 'mouse',
					offsetTop: 30,
					offsetLeft: -15
				});
			});
		});
		
		Event.observe(this.container, 'click', function(event) { self.checkSortable(event); });
	}
	
	this.createTable = function(){
		this.table = document.createElement("TABLE");
		var grid = document.createElement("TBODY");
		var tr = document.createElement("TR");
		
		var tdIcon = document.createElement("TD");
		var img = document.createElement("img");
		img.src = this.icon;
		img.alt = this.title;
		img.title = this.title;
		img.style.verticalAlign = "middle";
		tdIcon.appendChild(img);
		tr.appendChild(tdIcon);
		
		var tdContent = document.createElement("TD");
		tdContent.style.paddingLeft = "20px";
		tdContent.style.width = "100%";
		var div = document.createElement("div");
		
		var h3 = document.createElement("h3");
		h3.innerHTML = this.title;
		div.appendChild(h3);
		
		var divList = document.createElement("div");
		divList.className = this.cssClass;
		
		var ul = document.createElement("ul");
		ul.className = "sortablelist";
		ul.id = this.name;
		
		/**
		items:id, firsttext, lasttext, buttons:[url,title,icon]
		*/
		this.items.each(function(item, index){
			var li = document.createElement("li");
			li.className = "list_item";
			li.id = self.prefix+item.id;
			
			var divLeft = document.createElement("div");
			divLeft.style.cssFloat = "left";
			divLeft.style.styleFloat = "left";
			divLeft.style.paddingTop = "3px";
			divLeft.id = self.prefixDesc+item.id;
			
			var span = document.createElement("span");
			span.style.color = "#124D85";
			span.style.fontWeight = "bold";
			var spanOrder = document.createElement("span");
			spanOrder.id = self.prefixOrder+item.id;
			spanOrder.innerHTML = (index+1)+". ";
			span.appendChild(spanOrder);
			var spanContent = document.createElement("span");
			spanContent.innerHTML = item.firsttext;
			span.appendChild(spanContent);
			divLeft.appendChild(span);
			
			var spanContentDiv = document.createElement("span");
			spanContentDiv.innerHTML = item.lasttext;
			divLeft.appendChild(spanContentDiv);
			
			li.appendChild(divLeft);
			
			var divRight = document.createElement("div");
			divRight.style.cssFloat = "right";
			divRight.style.styleFloat = "right";
			divRight.id = self.prefixAction+item.id;
			
			item.buttons.each(function(button, indexButton){
				var spanButton = document.createElement("span");
				spanButton.id=self.prefixButton+indexButton+"_"+item.id;
				spanButton.onclick = function(){
					self.sortableEventActive = false;
					openModal(button.url, button.title);
				}
				
				var imgButton = document.createElement("img");
				imgButton.src = button.icon;
				imgButton.style.verticalAlign = "middle";
				imgButton.style.cursor = "pointer";
				spanButton.appendChild(imgButton);
				
				divRight.appendChild(spanButton);
				new Control.ToolTip($(spanButton.id),button.title,{
					className:'infobulle_tooltip',
					position: 'mouse',
					offsetTop: 30,
					offsetLeft: -15
				});
			});
			
			li.appendChild(divRight);
			
			var divClear = document.createElement("div");
			divClear.style.clear = "both";
			li.appendChild(divClear);
			
			ul.appendChild(li);
		});
		
		divList.appendChild(ul);
		
		div.appendChild(divList);
		
		tdContent.appendChild(div);
		tr.appendChild(tdContent);
		
		grid.appendChild(tr);
		this.table.appendChild(grid);
	}
}

//TODO: chargement des carac 1/112
mt.component.Layer = function(layers,objectId,layerVar) {
    var indexTabSyst = 0;
	var tabState = new Array();
	
	var allInOne = false;
	var allInOneBlock = false;
	var allInOneDispatch = false;
	var formEnabled = true;
	var lIdLayer;
	
	var componentSyst = new Object();
	var componentAdm = new Object();
	var componentTech = new Object();
	var indexCurrentTab = 0;
	var indexCurrentMatrixTab = 0;
	var show = false;
	var layers = layers;
	var objectId = objectId;
	var layerVar = layerVar;
	var self = this;
	
	var componentAdmTitle = "Administrative Data";
	var componentTechTitle = "Technical Data";
	
	var tdStyleLeft = "pave_cellule_gauche_free";
	var tdStyleRight = "pave_cellule_droite_free";
	var tableClass = "";
	
	var defaultCurrency;
	
	this.setDefaultCurrency = function(curr){
	   defaultCurrency = curr;
	}
	
	this.isFormEnabled = function(){
       return formEnabled;
    }

    function initLayer(layer){
	    allInOne = isNotNull(layer.allInOne)?layer.allInOne:false;
	    allInOneBlock = isNotNull(layer.allInOneBlock)?layer.allInOneBlock:false;
	    allInOneDispatch = isNotNull(layer.allInOneDispatch)?layer.allInOneDispatch:false;
	    tableClass = isNotNull(layer.tableClass)?layer.tableClass:"";
	    
	    try{formEnabled = layer.formEnabled;}
	    catch(e){formEnabled = true;}
	    if(formEnabled != true && formEnabled != false && !isNotNull(formEnabled))
	       formEnabled = true;

	    lIdLayer = layer.id;
	}
	
	this.render = function(){
	   openGlobalLoader();
	   this.getLayer(layers[0]);
	}
	
	this.setComponentTitle = function(titleAdm, titleTech){
	   componentAdmTitle = titleAdm;
	   componentTechTitle = titleTech;
	}
	
	this.setStyles = function(styleLeft, styleRight){
		tdStyleLeft = styleLeft;
		tdStyleRight = styleRight;
	}
	
	this.serverCall = function(objectId,lId,callback){};
	
	this.getLayer = function (layer){
	    initLayer(layer);
	    if(allInOne){
	        componentSyst.sName = layer.name;
	        componentSyst.characteristics = new Array();
	        self.renderComponentTypeTab(componentSyst,true);
	        
	        componentAdm.sName = componentAdmTitle;
	        componentAdm.id = "layer_adm_"+layer.id;
	        componentAdm.characteristics = new Array();
	        self.renderComponentTypeBlock(componentAdm,indexTabSyst);
	        if(!allInOneBlock){
			    componentTech.sName = componentTechTitle;
			    componentTech.id = "layer_tech_"+layer.id;
			    componentTech.characteristics = new Array();
			    self.renderComponentTypeBlock(componentTech,indexTabSyst);
	        }
	    }
	    self.serverCall(objectId,lIdLayer,
	    function (results){
	       results = htmlEntities(results,"json");
	       self.getLayerResults(results);
	    });
	}
	
	this.getLayerResultsList = function(results){
        var components = results;
        try{components = results.evalJSON();}catch(e){}
        components.each(function(component, indexComponent){
            self.getLayerResults(component);
        });
        
        this.applyEvents();
    }
    this.getLayerResults = function(results){
        var components = results;
        try{components = results.evalJSON();}catch(e){alert(e);}
        indexCurrentMatrixTab = 0;
        
        var blocksAdm = new Array();
        var blocksTech = new Array();
        components.each(function(component, indexComponent){
            if(component.iDepth > 0){
                if(component.iDepth == 1){
                    indexCurrentMatrixTab++;
                    self.renderComponentTypeTab(component);
                }else{
                	var indexTab = allInOne?indexTabSyst:indexCurrentTab-1;
                	var block = allInOne?((indexCurrentMatrixTab==1)?componentAdm:componentTech):null;
                	if(allInOneBlock) block = componentAdm;

                	if(allInOneDispatch){
	                	var objBlock = new Object();
	                	objBlock.component = component;
	                	objBlock.indexTab = indexTab;
	                	objBlock.block = block;
	                	
	                	if(allInOneBlock) blocksAdm.push(objBlock);
	                	else if(allInOne && indexCurrentMatrixTab==1) blocksAdm.push(objBlock);
	                	else blocksTech.push(objBlock);
	                	
                	}else{
                		self.renderComponentTypeBlock(component, 
                    							indexTab,
                    							block);
                	}
                }
             }
        });
        if(allInOneDispatch){
        	function sortChar(a, b){
        		if(a.iIndexY != b.iIndexY)
        			return compareInt(a.iIndexY,b.iIndexY);
        		else if(a.iIndexX != b.iIndexX)
        			return compareInt(a.iIndexX,b.iIndexX);
        		else
        			return compareInt(a.lColumnIndexFile,b.lColumnIndexFile);
        	}
        	/** ADMIN BLOCK */
        	if(blocksAdm.length>0){
	        	var charAdm = new Array();
	        	blocksAdm.each(function(b){
	        		b.component.characteristics.each(function(charItem){
	        			charAdm.push(charItem);
	        		});
		        });
	        	charAdm.sort(sortChar);
	        	blocksAdm[0].component.characteristics = charAdm;
	        	self.renderComponentTypeBlock(blocksAdm[0].component, 
	        			blocksAdm[0].indexTab,
	        			blocksAdm[0].block);
        	}
        	
        	/** TECH BLOCK */
        	if(blocksTech.length>0){
	        	var charTech = new Array();
	        	blocksTech.each(function(b){
	        		b.component.characteristics.each(function(charItem){
	        			charTech.push(charItem);
	        		});
		        });
	        	charTech.sort(sortChar);
	        	blocksTech[0].component.characteristics = charTech;
	        	self.renderComponentTypeBlock(blocksTech[0].component, 
	        			blocksTech[0].indexTab,
	        			blocksTech[0].block);
        	}
        }

        if(!show && isNotNull(layers[1]) && layers[1].id != layers[0].id){
           show = true;
           self.getLayer(layers[1]);
           return;
        }
        
        var onTabChangeOld = onTabChange;
        onTabChange = function(index, id){
            onTabChangeOld(index, id);
            if(isNotNull(tabState[index])){
	            var postTreatment = tabState[index].postTreatment;
	            if(!postTreatment){
	                tabState[index].postTreatment = true;
	                var postTreatmentItems = tabState[index].postTreatmentItems;
	                self.postTreatmentItems(postTreatmentItems);
	            }
	        }
        }
        
        this.applyEvents();
    }
    
    this.clearTabs = function(){
        var tabsTitle = $$(".tabs")[0].addClassName("tabClear");
        $$(".tabs div").each(function(item){
            Element.remove(item);
        });
        var tabsContent = $$(".tabContent")[0].addClassName("tabClear");;
        var tabFrame = $$(".tabFrame")[0].addClassName("tabClear");;   
    }
    
	this.applyEvents = function(){
	    var iTabsTitle = $$(".tabs div").length;
	    mt.html.applyTabEvents();
	    try{mt.html.jumpToTabIndex("tabsTitle",0 );}
        catch(e){}
	    if(iTabsTitle<=1){
	        this.clearTabs();
	    }
	    
	    enableDateFields();
	    this.onAfterApplyEvents();
	    closeGlobalLoader();
	}
	
	this.onAfterApplyEvents = function(){}
	
	this.renderComponentTypeTab = function (item,forceCreate){
	    
		 var tabsTitle = $$(".tabs")[0];
		 var tabsContent = $$(".tabContent")[0];
		 
		 if(!allInOne || (allInOne && forceCreate && !isNotNull(tabsTitle.childElements()[indexTabSyst]))){
		    var divTitle = document.createElement("div");
		    divTitle.innerHTML = item.sName;
		    tabsTitle.appendChild(divTitle);
		    
		    var divContent = document.createElement("div");
		    tabsContent.appendChild(divContent);
        }
	    
	    var index = (tabsContent.childElements().length-1);
	    if(!isNotNull(tabState[(allInOne?indexTabSyst:index)])){
	       tabState[(allInOne?indexTabSyst:index)] = {"index":(allInOne?indexTabSyst:index),"block":false,"postTreatment":false,"postTreatmentItems":new Array() };
	     }else{
	       tabState[(allInOne?indexTabSyst:index)].block = false;
	     }
	    indexCurrentTab++;
	    
	    if(item.characteristics.length > 0){
	    	var indexTab = allInOne?indexTabSyst:index;
        	var block = allInOne?((indexCurrentMatrixTab==1)?componentAdm:componentTech):null;
        	if(allInOneBlock) block = componentAdm;
        	
	        self.renderComponentTypeBlock(item,
	        		indexTab,
	        		block);
	    }
	}
	
	this.renderComponentTypeBlock = function (item, indexTab, block){
	    //alert("indexTab:"+indexTab+">"+item.sName+">"+item.lId);
	    var gridBlock;
	    var table;
	    var titleBlock;

	    if(!isNotNull(block)){
	        var tabs = $$(".tabContent")[0];
	        var divComponent = tabs.childElements()[indexTab];
	    
	        var div = document.createElement("div");
	        if(item.id) {
	        	div.id = item.id;
	        }
	        div.style.marginTop = "10px";
	        table = document.createElement("TABLE");
	        table.className = "paveUnrounded "+tableClass;
	        //var col = document.createElement("COL");
	        //col.width = "150";
	        //table.appendChild(col);
	        var grid = document.createElement("TBODY");
	        item.grid = grid;
	        gridBlock = grid;
	        
	        /*
	        var title = document.createElement("tr");
	        var td = document.createElement("td");
	        td.className = "pave_titre_gauche";
	        td.innerHTML = item.sName;
	        title.appendChild(td);
	        grid.appendChild(title);
	        */
	        var title = document.createElement("div");
	        Element.addClassName(title,"blockPaveBorder");
            var spanLeft = document.createElement("span");
		    spanLeft.style.cssFloat = 'left'; 
		    spanLeft.style.styleFloat = 'left';
            spanLeft.innerHTML = item.sName;
            title.appendChild(spanLeft);
	        titleBlock = title;
	    }else{
	       gridBlock = block.grid;
	    }

	    if(!isNotNull(block)){
	        table.appendChild(grid);
	        
	        div.appendChild(titleBlock);
	        div.appendChild(table);
	        
	        divComponent.appendChild(div);
            /*
	        try{roundPave(table);}
            catch(e){}
            */
	    }

        tabState[indexTab].index = indexTab;
        tabState[indexTab].block = true;
        tabState[indexTab].postTreatment = false;
	    self.orderCharacteristicType(item.characteristics, gridBlock, titleBlock,indexTab);
	}
	
	this.orderCharacteristicType = function (characteristics, grid, title,indexTab){

	    var yIndex = 0;
	    var line = document.createElement("tr");
	    line.items = new Array();  
	    var lines = new Array();
	    var maxLineElements = 0;
        var hasOptions = false;
        
	    characteristics.each(function(charItem, indexItem){
	       if(charItem.iIndexY != yIndex){
	            yIndex = charItem.iIndexY;
	            if(line.items.length > maxLineElements)
	                maxLineElements =  line.items.length;
	            lines.push(line);
	            line = document.createElement("tr");
	            line.items = new Array();  
	       }
	       if(charItem.bOptional == true){
	           hasOptions = true;
	       }
	       line.items.push(charItem);
	       tabState[indexTab].postTreatmentItems.push(charItem);
	    });
	    
	    var cb;
	    if(isNotNull(title)){
	        /*
	        var td = document.createElement("td");
            td.className = "pave_titre_droite";
            */
            var spanRight = document.createElement("span");
		    spanRight.style.cssFloat = 'right'; 
		    spanRight.style.styleFloat = 'right'; 
            
	        if(hasOptions){
	            spanRight.innerHTML = MESSAGE_LAYER[2]+" ";
	            cb = document.createElement("input");
	            cb.type = "checkbox";
	            cb.onclick = function(){
	                var options = Element.select(grid,".option-hidden");
	                var clicked = this.checked;
	                options.each(function(option){
	                    if(clicked){
	                        Element.show(option);
	                    }else{
	                        Element.hide(option);
	                    }
	                });
		        }
		        spanRight.appendChild(cb);
            }else{
                spanRight.innerHTML = "&nbsp;";
            }
            title.appendChild(spanRight);
            var divClear = document.createElement("div");
            divClear.style.clear="both";
            title.appendChild(divClear);
	    }

	    if(line.items.length > maxLineElements)
	        maxLineElements =  line.items.length;
	    lines.push(line);
	    
	    
	    
	    lines.each(function(lineItem){
	        self.renderCharacteristicType(lineItem.items, grid, lineItem, maxLineElements,characteristics,indexTab);
	    });
	}
	this.applyCharacteristicElementId = function(char){
		char.prefix = "layer_"+lIdLayer+"_";
		var id = "";
		if(char.lIdObjectTypeData == 0){
		    id = "char_"+char.lId;
		}else{
		    id = char.sObjectTypeTableData+"_"+char.sReference;
		}
		char.id = char.prefix+id;
	}
	this.applyCharacteristicElementValue = function(char){
	   //isNotNullAcceptBlank > il faut accepter les char dont la valeur enregistrée = ""
	   char.bddValue = ""+char.bddValue;
       var bddValue = isNotNullAcceptBlank(char.bddValue)?char.bddValue:(isNotNull(char.sDefaultValue)?char.sDefaultValue:"");
       char.bddValue = bddValue;
       char.displayValue = isNotNull(char.bddValue)?char.bddValue:"";
	}
	this.applyCharacteristicElementName = function(char){
		if(char.bMandatory) {
	    	return "<strong>"+char.sName+" *</strong>";//"<font color='#FF0000'>" + item.sName + "</font>";
	    } else if(char.bOptional){
	    	return "<i>"+char.sName+"</i>";
	    }else {
	    	return char.sName;
	    }
	}
	
	this.renderCharacteristicType = function (items, grid, line, max,characteristics,indexTab){
	    /*
	    var td = document.createElement("td");
	    var table = document.createElement("TABLE");
	    var tbody = document.createElement("TBODY");
	    var tr = document.createElement("tr");
	    */
	    items.each(function(item){
	        item.childItems = new Array();
	        characteristics.each(function(itemDepend){
	           if(isNotNull(itemDepend.lIdVehicleCharacteristicTypeParent)
	           && itemDepend.lIdVehicleCharacteristicTypeParent > 0
	           && itemDepend.lIdVehicleCharacteristicTypeParent == item.lId){
	               self.applyCharacteristicElementId(itemDepend);
	               self.applyCharacteristicElementValue(itemDepend);
	               item.childItems.push(itemDepend);
	           }
	        });

	        var title = document.createElement("td");
	        title.className = tdStyleLeft;
	        //title.style.width = 100/(items.length*2)+"%";
	        var spanTitle = document.createElement("span");
	        spanTitle.innerHTML = self.applyCharacteristicElementName(item);
            title.appendChild(spanTitle);
	        line.appendChild(title);
	    
	        var data = document.createElement("td");
	        data.className = tdStyleRight;
	        //data.style.width = 100/(items.length*2)+"%";
	        var spanData = document.createElement("span");
	        
	        var elt = new Object();
	        self.applyCharacteristicElementId(item);
	        item.formEnabled = formEnabled;
            self.applyCharacteristicElementValue(item);
            
	        switch(item.lIdVehicleCharacteristicDesignType){
	            case 1://VehicleCharacteristicDesignType.DESIGN_SELECT
	                elt = document.createElement("select");
	                mt.html.setSuperCombo(elt);

	                //si la combo n'a pas de liste /defaut
	                //on suppose qu'elle est chargée dynamiquement via un autre item(combo list)
	                //on la charge alors par defaut avec sa valeur en bdd
	                if( isNotNull(item.bddValue) 
	                && (item.values.length==0 || (item.values.length==1 && !isNotNull(item.values[0].value)))
	                && ( (item.bddValue.isNumber() && item.bddValue > 0) || !item.bddValue.isNumber()) ){
	                   elt.addItemValue(item.bddValue, item.displayValue);
	                   elt.setSelectedIndex(elt.options.length-1);
	                }else{
	                   //sinon on charge la liste avec le populate
	                   elt.populate(item.values,item.bddValue);
	                }
	                item.displayValue = elt.getSelectedText();
	                if(item.bddValue.isNumber() && item.bddValue == 0)
	                	item.displayValue = "";
	                break;
	            case 2://VehicleCharacteristicDesignType.DESIGN_INPUT
	                elt = document.createElement("input");
	                elt.type = "text";
	                elt.value = item.bddValue;
	                break;
	            case 3://VehicleCharacteristicDesignType.DESIGN_TEXTAREA
	                elt = document.createElement("textarea");
	                elt.rows = 4;
	                elt.cols = 30;
	                elt.value = item.bddValue;
	                break;
	            case 4://VehicleCharacteristicDesignType.DESIGN_CHECKBOX
	                elt = document.createElement("input");
	                elt.type = "checkbox";
	                break;
	            case 5://VehicleCharacteristicDesignType.DESIGN_RADIO
	                elt = document.createElement("input");
	                elt.type = "radio";
	                break;
	            case 8://VehicleCharacteristicDesignType.DESIGN_LABEL
	                elt = document.createElement("label");
	                elt.innerHTML = item.bddValue;
	                break;
	            case 7://VehicleCharacteristicDesignType.DESIGN_AJAX_COMBO_LIST
	                elt = document.createElement("input");
	                elt.type = "hidden";
	                var button = document.createElement("button");
	                try{button.type = "button";}
	                catch(e){}
	                button.id = "AJCL_but_"+item.id;
	                button.innerHTML = MESSAGE_LAYER[1];
	                spanData.appendChild(button);
	                elt.fieldReference = button;
	                elt.value = item.bddValue;
	                break;
	        }
		    if(!item.formEnabled){
		       elt = document.createElement("label");
               elt.innerHTML = item.displayValue;
               spanTitle.innerHTML += ":";
		    }
		    
	        switch(item.lIdVehicleCharacteristicValueType){
	            case 4://VehicleCharacteristicValueType.VALUE_BOOLEAN
	                break;
	            case 3://VehicleCharacteristicValueType.VALUE_DATETIME
	                Element.addClassName(elt, "dataType-date");
	                break;
	            case 5://VehicleCharacteristicValueType.VALUE_FLOAT
	                Element.addClassName(elt, "dataType-float");
	                break;
	            case 2://VehicleCharacteristicValueType.VALUE_INTEGER
	                Element.addClassName(elt, "dataType-integer");
	                break;
	            case 9://VehicleCharacteristicValueType.VALUE_PRICE
                    Element.addClassName(elt, "dataType-price-negative");
                    break;
	            case 1://VehicleCharacteristicValueType.VALUE_STRING
	                break;
	        }
	        
	        //to manage field event and controls on tab event
	        Element.addClassName(elt, "tab_field_index_"+indexTab);

	        if(isNotNull(elt)){
	            elt.id = item.id;
	            elt.name = item.id;
	            elt.title = item.sName;
	            spanData.appendChild(elt);
	        }
	        
	        if(item.bOptional && !item.bCharStore){
	           //les span permettent de ne pas faire de decalage
	           //voir dans les pave entiers d'options si ca n'affiche pas un grand pave vide
	           //dans ce cas il faudra mieux passer pas les elt "data" et "title" au lieu des span
	           Element.hide(title);
	           Element.addClassName(title, "option-hidden");
	           Element.hide(data);
	           Element.addClassName(data, "option-hidden");
	        }
	        if(item.bMandatory) {
               Element.addClassName(elt, "dataType-notNull");
            }
            if( (isNotNull(item.sObjectTypeColumnData) && item.sObjectTypeColumnData.startsWith("id_")) ){
               Element.addClassName(elt, "dataType-id");
            }
            
            elt.charItem = item;
            
            item.setMandatory = function(b){
            	item.bMandatory = b;
            	spanTitle.innerHTML = self.applyCharacteristicElementName(item);
            	if(b){
            		Element.addClassName(elt, "dataType-notNull");
            	}else{
            		Element.removeClassName(elt, "dataType-notNull");
            	}
            }
            
            data.appendChild(spanData);
	        line.appendChild(data);
	    });
	    /*
	    tbody.appendChild(tr);
	    table.appendChild(tbody);
	    td.appendChild(table);
	    line.appendChild(td);
	    */
	    grid.appendChild(line);   
	    
	    //self.postTreatmentItems(items);
	}
	
	this.postTreatmentItems = function(items)
    {
        items.each(function(item)
        {
            if(item.lIdVehicleCharacteristicDesignType == 7)//VehicleCharacteristicDesignType.DESIGN_AJAX_COMBO_LIST
            {
                item.itemValue = item.bddValue;
                var action = item.sObjectJSMethod;
                self.postTreatmentItem(item);
                var ac = new AjaxComboList(item.id, action);
                ac.addActionOnChange(layerVar+".onItemChange("+Object.toJSON(item)+");");
                ac.onAfterInit = function(){
                    item.displayValue = this.selectedText;
                    if(!item.formEnabled){
                        if(isNotNull(item.linkURL)){
	                        var select = $("AJCL_sel_"+item.id);
	                        if(select.options.selectedIndex>=0){
	                            var optionSelected = select.options[select.options.selectedIndex];
	                            $(item.id).innerHTML = "<a href=\""+item.linkURL+optionSelected.obj.lId+"\">"+item.displayValue+"</a>";
	                        }else{
	                            $(item.id).innerHTML = item.displayValue;
	                        }
	                    }else{
	                        $(item.id).innerHTML = item.displayValue;
	                    }
	                    Element.hide("AJCL_but_"+item.id);
                    }
                }
                ac.init(item.itemValue);
            }
            else if(item.lIdVehicleCharacteristicValueType == 9)//VehicleCharacteristicValueType.VALUE_INTEGER_PRICE
            {
                //alert("VALUE_INTEGER_PRICE");
                var htmlItem = $(item.id);
                htmlItem.onkeyup = function(){
                    clearTimeout(htmlItem.lastKeyUpTimeId);
	                htmlItem.lastKeyUpTimeId = setTimeout(function() {
	                    if(htmlItem.value.length>=1){
	                        //alert("onkeyup item "+htmlItem.id);
		                    if (htmlItem.value.isPriceAllowNegative() && !htmlItem.value.isNull()) {
		                        //alert("isPrice");
		                        item.childItems.each(function(childItem){
		                             var childItemElt = $(childItem.id);
		                             if(childItem.lIdObjectTypeValue == 800){//ObjectType.CURRENCY
		                                //alert("childItem currency : "+childItemElt.value);
		                                if(childItemElt.value.isNull() || childItemElt.value == "" || childItemElt.value == "0"){
		                                  //alert("set default currency");
		                                  if(childItem.lIdVehicleCharacteristicDesignType == 1){//VehicleCharacteristicDesignType.DESIGN_SELECT
		                                      childItemElt.setSelectedValue(defaultCurrency);
		                                  }else{
		                                      childItemElt.value = defaultCurrency;
		                                  } 
		                                }
		                             }
		                        });
		                    }
	                    }
	                }, 500);
                }
            }else{
            	self.postTreatmentItem(item);
            }
            
        });
    }
    this.postTreatmentItem = function(item){}
    
    this.onItemChange = function(itemChange){
	    var select = $("AJCL_sel_"+itemChange.id);
	    var optionSelected = select.options[select.options.selectedIndex];
	    var optionSelectedObj = optionSelected.obj;
        //alert("onItemChange "+itemChange.id);
	    itemChange.childItems.each(function(childItem){
	        //alert("onItemChange item "+childItem.id);
	        var childItemElt = $(childItem.id);
	        var path = childItem.sObjectJSPath.split(".");
	        //alert("onItemChange path "+path+" type>"+typeof(path)+" length>"+path.length);
	        var object = optionSelectedObj;
	        //alert("onItemChange object "+Object.toJSON(object));
	        
	        if(path.length>0){
		        object = object[path[0]];
		        for(var ipath=1;ipath<path.length;ipath++){
		            object = object[path[ipath]];
		        }
	        }
            //alert("onItemChange obj "+object);
	        switch(childItem.lIdVehicleCharacteristicDesignType){
	            case 1://VehicleCharacteristicDesignType.DESIGN_SELECT
	            	if(isNotNull(path)) {
		            	if(itemChange.formEnabled){
		                    childItemElt.populate(object,childItem.bddValue);
		                }else {
		                   object.each(function(obj){
		                       if(obj.data == childItem.bddValue){
		                           childItemElt.innerHTML = obj.value;
		                       }  
		                   });
		                }
	            	}
	                break;
	            case 8://VehicleCharacteristicDesignType.DESIGN_LABEL
	                childItemElt.innerHTML = object;
	                break;
	            default://VehicleCharacteristicDesignType.DESIGN_INPUT
	                childItemElt.value = object;
	                break;
	        }
	    });
	}
}