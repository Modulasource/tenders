/**
 * Libraries needed :
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/dragdrop.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/livepipe.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/livepipe/window.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/GedDocumentSelection.js"></script>
 */
function gedSelectionComponent(placeHolder, lIdTypeObject, lIdReferenceObject, sURLItem, sURLAdd, sURLSelect) {
	var self = this;
	this.arrDataSet = [];
	this.selections = [];
	this.id = placeHolder;
	this.lIdTypeObject = lIdTypeObject;
	this.lIdReferenceObject = lIdReferenceObject;
	this.sURLItem = sURLItem;
	this.sURLAdd = sURLAdd;
	this.sURLSelect = sURLSelect;
	
	this.emptyMsg = '<div style="text-align:center;color:#BBB;font-size:20px;margin-top:70px">Aucun document associé</div>';
	
	this.updateSelection = function() {
		this.divSelection.innerHTML = (this.selections.length==0) ? this.emptyMsg : '';
		var iIndex = 0;
		this.selections.each(function(item){
			item.iCurIndex = iIndex;
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

			td1.innerHTML = "<b>"+(iIndex+1)+") "+item.sName+"</b><br />";
			
			var sTitle = ((item.sName.length>0)?item.sName:"Sans titre");
			var sURL = self.sURLItem+item.lId;
		    
		    var div = document.createElement("div");
		    div.style.margin = "2px";
		    div.style.padding = "5px";
		    div.style.width = "100px";
		    div.style.textAlign = "center";
		    div.style.styleFloat = "left";
		    div.style.cssFloat = "left";
		    
		    var br = document.createElement("br");
		    
		    var divImg = document.createElement("div");
		    divImg.style.width = divImg.style.height = "64px";
		    //divImg.style.border = "solid blue 1px";
		    divImg.style.marginRight = "auto";
		    divImg.style.marginLeft = "auto";
		    
		    var img = document.createElement("img");
		    img.src = sURL+"&tn=true";
		    img.alt = img.title = sTitle;

		    //img.style.display = "block";
		    img.style.marginRight = "auto";
		    img.style.marginLeft = "auto";
		    img.style.cursor = "pointer";
		    img.style.marginTop = "0";
		    img.style.height = "64px";
		    //img.style.position = "relative";
		    img.onclick = function(){
		    	window.open(sURL, "Document", "menubar=no, resizable=yes,scrollbars=yes, width=500, height=300");
		    }
		    divImg.appendChild(img);
		    
		    var linkDoc = document.createElement("a");
		    linkDoc.href = sURL;
		    linkDoc.target = "_blank";
		    linkDoc.innerHTML = linkDoc.title = sTitle;
		    
		    
		    var label = document.createElement("div");
		    label.style.width = "90px";
		    //label.style.height = "110px";
		    label.style.padding = "2px";
		    label.style.textAlign = "center";
		    label.style.overflow = "hidden";
		    label.style.cursor = "pointer";
		    label.title = sTitle;
		    label.onclick = function(){
		    	//document.location.href = sURL;
		    }
		    
		    var divType = document.createElement("div");
			divType.style.position = "absolute";
			divType.style.zIndex = "2";
			divType.style.fontSize = "10px";
			divType.style.color = "#EEE";
			divType.style.backgroundColor = "#990000";
			divType.style.width = "40px";
			divType.style.height = "12px";
			divType.style.textAlign = "center";
			divType.style.marginTop = "0px";
			divType.style.marginLeft = "0px";
		    divType.innerHTML = item.sDocumentContentType;
		    
		    label.appendChild(divImg);
		    label.appendChild(linkDoc);
		    div.appendChild(divType);
		    div.appendChild(label);
			
			var hidden = document.createElement("input");
			hidden.type = "hidden";
			hidden.name = "lIdGedDocument";
			hidden.value = item.lId;
			td1.appendChild(hidden);
			td1.appendChild(div);
			
			tr.appendChild(td1);
			
			var td2 = document.createElement("td");
			td2.style.width = "48px";
			td2.style.padding = "2px 2px 0 0";
			td2.style.textAlign = "right";
			
			var imgUp = document.createElement("img");
			imgUp.src = rootPath+"images/icons/up.gif";	
			imgUp.style.cursor = "pointer";
			imgUp.title = imgUp.alt = "Monter";
			imgUp.onclick = function() {
				switchIndex(item.iCurIndex, item.iCurIndex-1);
			}
			var imgDown = document.createElement("img");
			imgDown.src = rootPath+"images/icons/down.gif";	
			imgDown.style.cursor = "pointer";
			imgDown.title = imgDown.alt = "Descendre";
			imgDown.onclick = function() {
				switchIndex(item.iCurIndex, item.iCurIndex+1);
			}
			
			var imgDelete = document.createElement("img");
			imgDelete.src = rootPath+"images/icons/delete.gif";	
			imgDelete.style.cursor = "pointer";
			imgDelete.onclick = function() {
				if (confirm("Retirer ce document ?")){
					removeItemSelection(item);
					self.updateSelection();
				}
			}
			if (iIndex>0) td2.appendChild(imgUp);
			if (iIndex<(self.selections.length-1)) td2.appendChild(imgDown);
			td2.appendChild(imgDelete);
			tr.appendChild(td2);

			tbody.appendChild(tr);
			table.appendChild(tbody);
			self.divSelection.appendChild(table);
			iIndex++;
		});
	}
	
	function switchIndex(iOldIndex, iNewIndex) {
		self.divSelection.innerHTML = "Chargement...";
		GedDocumentSelection.switchIdGedDocumentSelection(self.selections[iOldIndex].lIdGedDocumentSelection, self.selections[iNewIndex].lIdGedDocumentSelection, function(bSuccess){
			if (bSuccess) {
				self.load();
			}else{
				alert("Une erreur est survenue lors de l'échange.");
			}
		});
			
	}
	
	function removeItemSelection(item) {
	 	var oElt = {};
		oElt.lIdGedDocument = item.lId;
		oElt.lIdTypeObject = self.lIdTypeObject;
		oElt.lIdReferenceObject = self.lIdReferenceObject;
		GedDocumentSelection.removeFromJSONString(Object.toJSON(oElt), function(bSuccess){
			if (bSuccess) {
				try{
					self.selections.each(function(itm, index){
						if (itm.lId==item.lId) {
							self.selections.splice(index, 1);
							self.updateSelection();
						}
					});
				}catch(e){};
			}else{
				alert("un problème est survenu lors de la suppression");
			}
		});

	}
	function getPopup(sURL){
		    var docPopup;
/*		                            
		    if(parent.document == document){
		      docPopup = document;
		    } else {
		       try{
		           docPopup.createElement("div");
		           docPopup = parent.document;
		       } catch (e) {}
		       docPopup = document;
		    }
*/		  
			docPopup = document;
		    var popDiv = docPopup.createElement("div");
		    popDiv.style.position = "relative";
		    popDiv.style.backgroundColor = "#EFF5FF";
		    popDiv.style.padding = "0 7px 0 7px";
		    popDiv.style.border = "1px solid #CCCCCC";
		
		    var imgClose = docPopup.createElement("img");
		    imgClose.style.position = "absolute";
		    imgClose.style.top = "3px";
		    imgClose.style.right = "3px";
		    imgClose.style.cursor = "pointer";
		    imgClose.src = rootPath+"images/icons/close.gif";
		    imgClose.id=imgClose.className = "imgClose";
		    //imgClose.onclick = function(){closeModal();};
		
		    popDiv.appendChild(imgClose);
		    
		    
		    var divHeader = docPopup.createElement("div");
		    divHeader.style.textAlign = "right";
		    popDiv.style.paddingRight = "30px";
		    divHeader.style.lineHeight = "28px";
		    divHeader.innerHTML = 'Fermer';
		    divHeader.style.height = "28px";
		    
		    var divIframe = docPopup.createElement("div");
		    divIframe.style.border = "1px solid #888";
		    divIframe.style.backgroundColor = "#AAA";
		    
		    var iframe = docPopup.createElement("iframe");
		    iframe.name = "offerPopup";
		    iframe.id = "offerPopup";
		    iframe.src = sURL;
		    iframe.style.width = "100%";
		    iframe.style.height = "450px";
		    iframe.style.border = 0;
		    iframe.style.margin = 0;
		    iframe.align = "top";
		    iframe.frameBorder = "0";
		    iframe.border = "1";
		    divIframe.appendChild(iframe);
		                                
		    var divFooter = docPopup.createElement("div");
		    divFooter.style.textAlign = "center";
		    divFooter.style.lineHeight = "6px";
		    divFooter.style.height = "6px";
		    
		    popDiv.appendChild(divHeader);
		    popDiv.appendChild(divIframe);
		    popDiv.appendChild(divFooter);
		
		   
		   
		   var popup ;
		   try{ 
            	popup = new parent.Control.Modal(false,
	            	{width: 740, contents: popDiv, closeOnClick:true, afterClose: function(){self.afterCloseAction();}});
		   } catch(e) {
		       popup = new Control.Modal(false,{width: 740, contents: popDiv, afterClose: self.afterCloseAction(), closeOnClick:true});
		   }
		   popup.container.insert(popDiv);
		   return popup;		
	}
	
	this.afterCloseAction = function(){
		this.divSelection.innerHTML = 'Loading...';
		self.load();
	}
	this.load = function(){
		GedDocumentSelection.getJSONAllGedDocumentFromTypeAndReferenceObject(self.lIdTypeObject, self.lIdReferenceObject, function(sJSON){
			if (sJSON) {
				self.flush();
        		self.populate(sJSON.evalJSON() || []);
			}
		});
	}
	this.flush = function(){
		self.arrDataSet = self.selections = [];
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
		label.style.textAlign = "center";
		
		var aAdd = document.createElement("a");
		aAdd.style.marginRight = "5px";
		aAdd.style.cursor = "pointer";
		var labAdd = document.createElement("label");
		labAdd.style.cursor = "pointer";
		var imgAdd = document.createElement("img");
		imgAdd.src = rootPath+"images/icons/add.gif";
		imgAdd.alt = aAdd.title = labAdd.innerHTML = "Ajouter";
		aAdd.appendChild(imgAdd);
		aAdd.appendChild(labAdd);
		aAdd.onclick = function(){
		   var popup = getPopup(self.sURLAdd+"?lIdTypeObject="+self.lIdTypeObject+"&lIdReferenceObject="+self.lIdReferenceObject);
		   popup.open();
		}
		
		var aPick = document.createElement("a");
		aPick.style.marginRight = "5px";
		aPick.style.cursor = "pointer";
		var labPick = document.createElement("label");
		labPick.style.cursor = "pointer";
		var imgPick = document.createElement("img");
		imgPick.src = rootPath+"images/icons/zoom.gif";
		imgPick.alt = aPick.title = labPick.innerHTML = "Sélectionner des documents dans la liste";
		aPick.appendChild(imgPick);
		aPick.appendChild(labPick);
		aPick.onclick = function(){
		   var popup = getPopup(self.sURLSelect+"?lIdTypeObject="+self.lIdTypeObject+"&lIdReferenceObject="+self.lIdReferenceObject);
		   popup.open();
		}
		
		label.appendChild(aAdd);
		label.appendChild(aPick);		
		divTree.appendChild(label);
		
		div.appendChild(divTree);
		
		this.divSelection = document.createElement("div");
		this.divSelection.style.padding = "4px 4px 4px 8px";
		this.divSelection.style.minHeight = "185px";
		//this.divSelection.style.overflow = "auto";
		this.divSelection.style.backgroundColor = "#FFF";
		this.divSelection.innerHTML = this.emptyMsg;
		
		div.appendChild(this.divSelection);
		
		$(placeHolder).appendChild(div);
	}

	
	this.getSelections = function() {
		return this.selections;
	}

	this.populate = function(ds) {
		self.arrDataSet = ds;
		ds.each(function (item){
			self.selections.push(item);
		});
		this.updateSelection();
	}
	
	this.build();

}