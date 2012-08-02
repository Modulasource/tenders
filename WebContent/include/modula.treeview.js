var modula = {
	treeview:{
		tvOpen:true,
		displayMenuNode:function(node, parentDiv,idTreeview) {
			var menus = mt.dom.getChildrenByTagName(node,"menu");
			var str='';
			var TV_FORCE_NEW_TAB_ENABLED = 
				(typeof(tvForceNewTabEnabled) == "undefined" || tvForceNewTabEnabled == null) ? false : tvForceNewTabEnabled;			
			var TV_ID_FORCE_NEW_TAB_ONCLICK = 
				(typeof(tvIdForceNewTabOnClick) == "undefined" || tvIdForceNewTabOnClick == null) ? "" : tvIdForceNewTabOnClick;			

			var divClose = document.createElement("div");
			divClose.className = "treeviewClose";
			divClose.style.display = "none";
			document.body.appendChild(divClose);
			var divOpen = document.createElement("div");
            divOpen.className = "treeviewOpen";
            divOpen.style.display = "none";
            document.body.appendChild(divOpen);
           
            var contextMenus = new Array();
 			
			for (var z=0; z<menus.length; z++) {
				var m = menus[z];
				var hasChilds = (m.getElementsByTagName("menu").length>0);
				var weight = (hasChilds) ? "bold" : "normal";
				var colorClass = (hasChilds) ? "parentItem" : "childItem";

				var attrIdNode = m.getAttribute("num");
				var lIdNode = parseInt (attrIdNode);
				
				var sDivName = idTreeview+"_tv_node_div_" + lIdNode ;
				var div1 = document.createElement("div");

				div1.id = sDivName;
				div1.className="menuItem";
				div1.hasChilds = hasChilds;
				div1.setAttribute("page", m.getAttribute("lien"));
				div1.setAttribute("index", z);

				if(!hasChilds){
				    var icon = "default";
	                var customIcon = m.getAttribute("icone");
	                if(customIcon=="defaut" || customIcon=="null")
	                    customIcon = "default";
	                if (customIcon && customIcon!="" && !hasChilds) {
	                    icon = customIcon;
	                }
	                /** rootPath must be endded by a slash */
	                div1.style.backgroundImage = "url('"+this.rootPath+"images/treeview/icons/"+icon+".gif')";
				}else{
				    div1.style.backgroundImage = Element.getStyle(divClose,'background-image');
				}

				div1.style.fontWeight = weight;
				div1.innerHTML = "<span id='"+idTreeview+"_tv_node_label_" +lIdNode + "'>"
					+ m.getAttribute("libelle")
					+ "<span id='"+idTreeview+"_tv_node_label_extra_" + lIdNode + "'>"
					//+ m.getAttribute("num")
					+ '</span>'
					+ '</span>';
				div1.firstChild.className = colorClass;
				div1.firstChild.onmouseover = function() {
					this.className = "hoverItem";
				}
				div1.firstChild.onmouseout = function() {
					this.className = colorClass;
				}
				mt.dom.disableSelection(div1.firstChild);
		
				function onMenuClick() {					
					if (!this.nextSibling.hasChildNodes()) {
						this.nextSibling.style.display = "block";
						modula.treeview.displayMenuNode(menus[this.getAttribute("index")], this.nextSibling,idTreeview);						
						this.style.backgroundImage = Element.getStyle(divOpen,'background-image');
					} else {
						if (this.nextSibling.style.display == "none") {
							this.nextSibling.style.display = "block";
							this.style.backgroundImage = Element.getStyle(divOpen,'background-image');
						} else {
							this.nextSibling.style.display = "none";
							this.style.backgroundImage = Element.getStyle(divClose,'background-image');
						}						
					}
				}
				
				function onItemClick() {
					var url = this.getAttribute("page");
					var indexHttp = url.indexOf("http");
					var indexComa = url.indexOf(";");
					var arrTv = idTreeview.split('_');
					var menuTreeview = (arrTv[1]==null)?"":arrTv[1];
					if (indexHttp!=-1) {
						url = url.substr(indexHttp, indexComa-indexHttp);
						location = url;
					} else {
                        if(menuTreeview != TV_ID_FORCE_NEW_TAB_ONCLICK || !TV_FORCE_NEW_TAB_ENABLED) {
                            mt.html.addTab(this.menuData.getAttribute("libelle"),this.getAttribute("page"));
                        } else {
                        	if(TV_FORCE_NEW_TAB_ENABLED) {
                        		mt.html.addTabForced(this.menuData.getAttribute("libelle"),this.getAttribute("page"),false,div1.id,div1.id);
                        	}
                        }
                        //main.location = this.getAttribute("page");
					}
					//modula.treeview.toggle();
				}
				div1.onclick = (hasChilds) ? onMenuClick : onItemClick;
				div1.menuData = menus[z];
				
				if(enableDeskContextMenu && !hasChilds){
                    contextMenus.push(div1);
                }
				
				var div2 = document.createElement("div");
				div2.style.paddingLeft = "22px";
				
				parentDiv.appendChild(div1);
				parentDiv.appendChild(div2);
			}
            
			contextMenus.each(function(div,indexDiv){
		      var tvTab = [{
		          name: ((enableDeskTabs)?MESSAGE_TV[2]:MESSAGE_TV[1]), 
                  callback: function(){
                     mt.html.addTab(div.menuData.getAttribute("libelle"),div.getAttribute("page"),true);
                 }
              }];
              div.id = "TVContextMenu_"+indexDiv+"_"+div.menuData.getAttribute("num");
	          div.ctxmenu = new Proto.Menu({selector: '#'+div.id,className: 'menu firefox', menuItems: tvTab });
	        });
	        
		},
		expandAllBranches:function(node,idTreeview) {
			var nodes = Element.select(node,".menuItem");
			for (var z=0; z<nodes.length; z++) {
				modula.treeview.displayMenuNode(nodes[z].menuData, nodes[z].nextSibling,idTreeview);
			}
		},
		toggle:function(){
			Effect.toggle('nav','slide',{scaleX:true,scaleY:false,duration:0.5, 
				afterFinish: function(){
				try{
					if($("nav").style.display == "none"){
					    Element.show($("navToggleHidden"));
					}else{
					   Element.hide($("navToggleHidden"));
					}
				}catch(e){}
				},
				beforeStart: function(){
                try{
                    if($("nav").style.display == "none"){
                        Element.hide($("navToggleHidden"));
                    }
                }catch(e){}
                }
			} );
			
			if(modula.treeview.tvOpen)
				modula.treeview.tvOpen = false;
			else
				modula.treeview.tvOpen = true;
		},
		loadTreeview:function(url, idTreeview,rootPath) {
			function onLoad(r) {
				modula.treeview.tv = $(idTreeview);
				modula.treeview.tv.innerHTML = '';
				modula.treeview.xmlData = r.responseXML.documentElement;
				modula.treeview.rootPath = rootPath;
				var firstchild = mt.dom.getChildrenByTagName(modula.treeview.xmlData,"menu")[0];
				
				var table = document.createElement("table");
				var tbody = document.createElement("tbody");
				var tr = document.createElement("tr");
				var td = document.createElement("td");
				td.style.padding = "8px 5px 5px 8px";
				tr.appendChild(td);
				tbody.appendChild(tr);
				table.appendChild(tbody);
				modula.treeview.tv.appendChild(table);
				try{modula.treeview.displayMenuNode(firstchild, td,idTreeview);}
				catch(e){alert("Probleme de chargement de la treeview : "+e);}
				if(modula.treeview.expandAll) modula.treeview.expandAllBranches(modula.treeview.tv,idTreeview);
				modula.treeview.onLoadTreeview(idTreeview);
			}
			new Ajax.Request(url, {method:'get', onComplete:onLoad});
		},
		onLoadTreeview:function(idTreeview){}
	}
}