var org = 
{
	coin:
	{
		ui:
		{
			findPosX: function(obj)
			{
				var curleft = 0;
				if(obj.offsetParent)
				    while(1) 
				    {
				      curleft += obj.offsetLeft;
				      if(!obj.offsetParent)
				        break;
				      obj = obj.offsetParent;
				    }
				else if(obj.x)
				    curleft += obj.x;
				return curleft;
			},


			findPosY: function(obj)
			{
			  var curtop = 0;
			  if(obj.offsetParent)
			      while(1)
			      {
			        curtop += obj.offsetTop;
			        if(!obj.offsetParent)
			          break;
			        obj = obj.offsetParent;
			      }
			  else if(obj.y)
			      curtop += obj.y;
			  return curtop;
			},
						

			setLinkElement: function (
			        eltA,
			        eltB, 
			        sIdPrefix,
			        sName)
			{
			    var sHookFace = this.getHookFace(eltA, eltB);
			    this.setLinkElementHookFace(
				        eltA,
				        eltB, 
				        sIdPrefix,
				        sName,
				        sHookFace,
				        0,
				        0);
				
			},
			
			setLinkElementHookFace: function (
			        eltA,
			        eltB, 
			        sIdPrefix,
			        sName,
			        sHookFace,
			        iDeltaPositionA,
			        iDeltaPositionB)
			{
			    var xPosA;
			    var yPosA;
			    var xPosB;
			    var yPosB;
			
			    var sDirection;
			    
			    switch(sHookFace)
			    {
			    case "left":
			        xPosA = this.findPosX(eltA);
			        yPosA = this.findPosY(eltA) + eltA.getHeight() / 2 + iDeltaPositionA;
			        xPosB = this.findPosX(eltB) + eltB.getWidth();
			        yPosB = this.findPosY(eltB) + eltB.getHeight() / 2 + iDeltaPositionB;
			        sDirection = "horizontal";
			        break;
			    case "right":
			        xPosA = this.findPosX(eltA) + eltA.getWidth();
			        yPosA = this.findPosY(eltA) + eltA.getHeight() / 2 + iDeltaPositionA;
			        xPosB = this.findPosX(eltB);
			        yPosB = this.findPosY(eltB) + eltB.getHeight() / 2 + iDeltaPositionB;
			        sDirection = "horizontal";
			        break;
			    case "top":
			        xPosA = this.findPosX(eltA) + eltA.getWidth() / 2 + iDeltaPositionA;
			        yPosA = this.findPosY(eltA);
			        xPosB = this.findPosX(eltB) + eltB.getWidth() / 2 + iDeltaPositionB;
			        yPosB = this.findPosY(eltB) + eltB.getHeight() ;
			        sDirection = "vertical";
			        break;
			    case "bottom":
			        xPosA = this.findPosX(eltA) + eltA.getWidth() / 2 + iDeltaPositionA;
			        yPosA = this.findPosY(eltA) + eltA.getHeight() ;
			        xPosB = this.findPosX(eltB) + eltB.getWidth() / 2 + iDeltaPositionB;
			        yPosB = this.findPosY(eltB);
			        sDirection = "vertical";
			        break;
			    }
    
			    this.setLink(
			            sIdPrefix,
			            sName,
			            xPosA,
			            yPosA,
			            xPosB,
			            yPosB,
			            sDirection);
			},
			
			getHookFace: function(
		            eltA ,
		            eltB)
		    {
		        var sHookFace = null;

		        /**
		         * is left sided ?
		         * 
		         *  - -|
		         *     |            
		         *  B  |<=delta left =>
		         *     |               |-
		         *  - -|               |
		         *                     |   A
		         *                     |
		         *                     |-
		         *
		         */

		        var iDeltaLeft 
		            = this.findPosX(eltA) 
		            - (this.findPosX(eltB) + eltB.getWidth());

		        /**
		         * is right sided ?
		         * 
		         *  - -|
		         *     |            
		         *  A  |<=delta right =>
		         *     |               |-
		         *  - -|               |
		         *                     |   B
		         *                     |
		         *                     |-
		         *
		         */
		        var iDeltaRight 
		            = this.findPosX(eltB) 
		            - (this.findPosX(eltA) + eltA.getWidth() );

		        /**
		          * is top sided ?
		          * 
		          *  - -|
		          *     |            
		          *  B  |
		          *     |               
		          *  - -|               
		          *         ^
		          *         |   delta top
		          *         |
		          *         v
		          *                     |-----
		          *                     |
		          *                     |   A
		          *                     |
		          *                     |-
		          *
		          */
		        var iDeltaTop 
		         = this.findPosY(eltA) 
		         - (this.findPosY(eltB) + eltB.getHeight() );

		        /**
		         * is bottom sided ?
		         * 
		         *  - -|
		         *     |            
		         *  A  |
		         *     |               
		         *  - -|               
		         *         ^
		         *         |   delta top
		         *         |
		         *         v
		         *                     |-----
		         *                     |
		         *                     |   B
		         *                     |
		         *                     |-
		         *
		         */
		        var iDeltaBottom 
		         = this.findPosY(eltB) 
		         - (this.findPosY(eltA) + eltA.getHeight() );
		      
		        if(iDeltaLeft > 0)
		        {
		            sHookFace = "left";
		        }
		        if(iDeltaRight > 0)
		        {
		            sHookFace = "right";
		        }
		        if(iDeltaTop > 0)
		        {
		            if(sHookFace == "" 
		            || (iDeltaTop > iDeltaLeft && iDeltaTop > iDeltaRight))
		            {
		                sHookFace = "top";
		            }
		        }
		        if(iDeltaBottom > 0)
		        {
		            if(sHookFace == "" 
		            || (iDeltaBottom > iDeltaLeft && iDeltaBottom > iDeltaRight))
		            {
		                sHookFace = "bottom";
		            }
		        }
		         
		        return sHookFace;    
		    },

		    setElementDimension: function(
		            sElementName,
		            iPosX,
		            iPosY,
		            iWidth,
		            iHeight
		    )
		    {
		        var elt = $(sElementName);
		        elt.style.left = iPosX + "px";
		        elt.style.top = iPosY + "px";
		        elt.style.width = iWidth + "px";
		        elt.style.height = iHeight + "px";
		    },

		    moveElement: function(
		            sElementName,
		            iPosX,
		            iPosY
		    )
		    {
		        var elt = $(sElementName);
		        elt.style.left = iPosX + "px";
		        elt.style.top = iPosY + "px";
		    },


		    /**
		    
		    ____a_____________
		                    |
		                    |
		                    |
		                    |b
		                    |
		                    |
		                    |
		                    ________c_________
		    
		    */
		    createLink: function(
		           sIdPrefix)
		    {
		       var cellA = document.createElement('div');
		       var cellB = document.createElement('div');
		       var cellC = document.createElement('div');
		       var cellD = document.createElement('div');

		       cellA.id = sIdPrefix + "_a";
		       cellA.innerHTML = "&nbsp;";
		       cellA.style.backgroundColor = "#ddd";
		       cellA.style.position = "absolute";

		       cellB.id = sIdPrefix + "_b";
		       cellB.style.backgroundColor = "#ddd";
		       cellB.style.position = "absolute";
		       cellB.style.width = "1px";

		       cellC.id = sIdPrefix + "_c";
		       cellC.style.backgroundColor = "#ddd";
		       cellC.style.position = "absolute";
		       cellC.style.height = "1px";

		       cellD.id = sIdPrefix + "_d";
		       cellD.style.position = "absolute";
		       cellD.style.cursor = "move";
		       cellD.style.width = "80px";
		       cellD.style.height = "16px";


		       document.body.appendChild(cellA); 
		       document.body.appendChild(cellB); 
		       document.body.appendChild(cellC); 
		       document.body.appendChild(cellD); 
		   },

		   setLink: function(
		            sIdPrefix,
		            sName,
		            xPosA1,
		            yPosA1,
		            xPosA2,
		            yPosA2,
		            sDirection)
			{
			    var bCreateElement = false;
			    var cellA = $(sIdPrefix + "_a");
			    if(cellA == null) 
			    {
			        this.createLink(sIdPrefix);
			        bCreateElement = true;
			    }
			   
			    switch(sDirection)
			    {
			    case "horizontal":
			        this.setLinkHorizontal(
			                sIdPrefix,
			                sName,
			                xPosA1,
			                yPosA1,
			                xPosA2,
			                yPosA2);
			        break;
			    case "vertical":
			    	this.setLinkVertical(
			                sIdPrefix,
			                sName,
			                xPosA1,
			                yPosA1,
			                xPosA2,
			                yPosA2);
			        break;
			    }
	
			    /**
			     * invariant cell
			     */
			    var cellD = $(sIdPrefix + "_d");
			    cellD.innerHTML = sName ;
			    cellD.style.left = ((xPosA1 + xPosA2) / 2) + "px";
			    cellD.style.top = ((yPosA1 + yPosA2) / 2 ) + "px";
			    
			    if(bCreateElement )
			    {
			        new Draggable(cellD, { revert:false });
			    }
			},
				   
		   		    
		   setLinkVertical: function(
		            sIdPrefix,
		            sName,
		            xPosA1,
		            yPosA1,
		            xPosA2,
		            yPosA2)
			{
				var cellA = $(sIdPrefix + "_a");
			    var cellB = $(sIdPrefix + "_b");
			    var cellC = $(sIdPrefix + "_c");
			    var cellD = $(sIdPrefix + "_d");
	
			    var xTmp;
			    var yTmp;
			    if(yPosA1 > yPosA2)
			    {
			        /**
			         * inversion A1 <=> A2
			         */
			        xTmp = xPosA1;
			        yTmp = yPosA1;
			        xPosA1 = xPosA2;
			        yPosA1 = yPosA2;
			        xPosA2 = xTmp;
			        yPosA2 = yTmp;
			    }
			    		    
			    var iHalfPos = Math.abs(yPosA2 - yPosA1) / 2 ;
			    cellA.style.left = xPosA1 + "px";
			    cellA.style.top = yPosA1 + "px";
			    cellA.style.width = "1px";
			    cellA.style.height = iHalfPos  + "px";
	
			    if(xPosA1 < xPosA2 )
			    {
			        cellB.style.left = xPosA1 + "px";
			    } else {
			        cellB.style.left = xPosA2 + "px";
			    }
			    cellB.style.top = Math.abs(yPosA2 - iHalfPos) + "px";
			    cellB.style.width = Math.abs(xPosA2 - xPosA1) + "px";
			    cellB.style.height = "1px";
			    
			    cellC.style.left = xPosA2 + "px";
			    cellC.style.top = Math.abs(yPosA2 - iHalfPos)  + "px";
			    cellC.style.width = "1px";
			    cellC.style.height = iHalfPos  + "px";
			},
		 
			setLinkHorizontal: function (
		        sIdPrefix,
		        sName,
		        xPosA1,
		        yPosA1,
		        xPosA2,
		        yPosA2)
			{
				var cellA = $(sIdPrefix + "_a");
			    var cellB = $(sIdPrefix + "_b");
			    var cellC = $(sIdPrefix + "_c");
			    var cellD = $(sIdPrefix + "_d");
	
			    var xTmp;
			    var yTmp;
			    if(xPosA1 > xPosA2)
			    {
			        /**
			         * inversion A1 <=> A2
			         */
			        xTmp = xPosA1;
			        yTmp = yPosA1;
			        xPosA1 = xPosA2;
			        yPosA1 = yPosA2;
			        xPosA2 = xTmp;
			        yPosA2 = yTmp;
			    }

			    var iHalfPos = Math.abs(xPosA2 - xPosA1) / 2 ;
			    cellA.style.left = xPosA1 + "px";
			    cellA.style.top = yPosA1 + "px";
			    cellA.style.width = iHalfPos  + "px";
			    cellA.style.height = "1px";
			    
			    cellB.innerHTML = "&nbsp;";
			    cellB.style.left = (xPosA1 + iHalfPos) + "px";
			    cellB.style.top = ((yPosA1 > yPosA2)?yPosA2:yPosA1) + "px";
			    cellB.style.height = Math.abs(yPosA2 - yPosA1) + "px";
			    cellB.style.width = "1px";
	
			    cellC.innerHTML = "&nbsp;";
			    cellC.style.left = Math.abs(xPosA2 - iHalfPos) + "px";
			    cellC.style.top = yPosA2  + "px";
			    cellC.style.width = iHalfPos  + "px";
			    cellC.style.height = "1px";
	
			},

			removeLink:	function(
		            sIdPrefix)
			{
			    Element.remove(sIdPrefix + "_a");
			    Element.remove(sIdPrefix + "_b");
			    Element.remove(sIdPrefix + "_c");
			    Element.remove(sIdPrefix + "_d");
			},


			drawLinkFromRelation: function(
		            item)
			{
	            var eltA = $(item.entityA);
	            var eltB = $(item.entityB);

	            org.coin.ui.setLinkElementHookFace(
				        eltA,
				        eltB, 
				        item.id,
				        item.name,
				        item.sHookFace,
				        item.iDeltaPositionA,
				        item.iDeltaPositionB);
			},

			setSizeFromDiv: function(
		            divIn,
		            divOut,
		            fRatio)
			{
				var s = divOut.style;
	            s.left = (this.findPosX(divIn) * fRatio) + "px";
	            s.top = (this.findPosY(divIn) * fRatio) + "px";
	            s.width = (divIn.getWidth() * fRatio) + "px";
	            s.height = (divIn.getHeight() * fRatio) + "px";
			},


			displayHookFace: function(
			        eltA,
			        eltB,
			        sHookFace)
			{
			    /**
			     * init 
			     */
			    eltA.style.borderColor = "#ddd";
			    eltB.style.borderColor = "#ddd";
	
			    switch(sHookFace)
			    {
			    case "left":
			        eltA.style.borderLeftColor = "red";
			        eltB.style.borderRightColor = "red";
			        break;
			    case "right":
			        eltA.style.borderRightColor = "red";
			        eltB.style.borderLeftColor = "red";
			        break;
			    case "top":
			        eltA.style.borderTopColor = "red";
			        eltB.style.borderBottomColor = "red";
			        break;
			    case "bottom":
			        eltA.style.borderBottomColor = "red";
			        eltB.style.borderTopColor = "red";
			        break;
			    }
			}
		    		    
					               
	    } /* END org.coin.ui */
	} /* END org.coin*/
}; /* END org */


org.coin.ui.EntityRelationDiagram  = Class.create();
org.coin.ui.EntityRelationDiagram.prototype = 
{
	initialize: function(placeHolder) {
		/** space between 2 relations on a face */
		this.iRelationOnHookFaceOffset = 5;
	    this.tables = [];
	    this.regions = [];
	    this.relations = [];
	    this.tablesDraggable = [];
	    this.divNavigator = "divNavigator";
	    this._divNavigator = null;
	    this.fRatioNavigator = 0.05;
    },
    activateTableDragAndDrop: function() {
        var _this = this;
    	this.tables.each(function(item){
            
            var div = $(item.id);
            div.style.cursor = "move";
            div.onmouseup = function(){
            	var timeStart = new Date();
            	_this.drawTableRelation(item);
            	_this.displayNavigatorTable(item);
            	var timeEnd = new Date();
            	
            	try{
            		$("spanTimeDuration").innerHTML = "time elapsed : " + (timeEnd.getTime() - timeStart.getTime() )  + " ms";
            	} catch (e) {}
            }; 
            div.onclick = function(){
            };

            var d = new Draggable(item.id, { revert:false });
            _this.tablesDraggable.push(d);
    	});
    },
    deactivateTableDragAndDrop: function() {
        this.tablesDraggable.each(function(item){
           	item.destroy();
        });
    	this.tables.each(function(item){
            var div = $(item.id);
            div.style.cursor = "pointer";
            div.onmouseup = function(){
            	/** empty */
            };
            div.onclick = function(){
            	alert("my callback on click "
            			 + " left=" + item.hookFaces.left.length 
            			 + " right=" + item.hookFaces.right.length 
            			 + " top=" + item.hookFaces.top.length 
            			 + " bottom=" + item.hookFaces.bottom.length 
            			 );
            };
        });
    },
    addRelation: function(id, name, entityA, entityB) {
    	this.relations.push({"id": id, "name": name, "entityA": entityA, "entityB": entityB});
    },
    addTable: function(id, name, posX, posY) {
    	var hookFaces = {"left": [], "right": [], "top": [], "bottom": []};
    	this.tables.push({"id": id, "name": name, "hookFaces": hookFaces, "div": $(id)});
    	org.coin.ui.moveElement(id, posX, posY);
    },
    addRegion: function(id, name, posX, posY, width, height) {
    	this.regions.push({"id": id, "name": name});
        org.coin.ui.setElementDimension(id, posX, posY, width, height);
    	
    },
    displayNavigator: function() {
        var _this = this;
        //var pa = $(_this.divNavigator);
        //while(pa.lastChild)pa.removeChild(pa.lastChild);

        this._divNavigator = $("navigator_main_div"); 
        if(this._divNavigator == null)
        {
        	/**
        	 * create it
        	 */
            var divAbs = document.createElement("div");
            divAbs.style.position = "relative";
            divAbs.id = "navigator_main_div";
            $(_this.divNavigator).appendChild(divAbs);
            this._divNavigator = divAbs;
        }
        Element.hide(this._divNavigator );

        this.regions.each(function(item){
            var div = $(item.id);
            var divMap = $("nav_" +  item.id);
            if(divMap == null) {
            	/*
            	divMap = document.createElement("div");
                divMap.id = "nav_" +  item.id;
                divMap.style.border = "#ddd 1px solid";
                divMap.style.backgroundColor = "#DFF";
                divMap.style.position = "absolute";
            	*/
            	
                divMap = new Element("div", 
                		{ "id": "nav_" +  item.id, 
    	        		"title" : item.name,
    	        		"style" : "border: #ddd 1px solid;"
    	        			+ "position: absolute;"
    	        			+ "cursor: pointer;"
    	        			+ "background-color: " + div.getStyle("background-color")
                		});

            	_this._divNavigator.appendChild(divMap);
            }
            
            org.coin.ui.setSizeFromDiv(
		            div,
		            divMap,
		            _this.fRatioNavigator);

    	});    	

        
        this.tables.each(function(item){
        	_this.displayNavigatorTable(item);
    	});    	
        
        Element.show(this._divNavigator );

    },

    displayNavigatorTable: function(item) {
        var divNavigator = this._divNavigator ; 
        //var div = $(item.id);
        var div = item.div;
        //var divMap = $("nav_" +  item.id);
        var divMap = item.divMap;
        if(divMap == null)
        {
        	/*
        	divMap = document.createElement("div");
            divMap.id = "nav_" +  item.id;
            divMap.style.border = "#ddd 1px solid";
            divMap.style.backgroundColor = div.style.backgroundColor ;
            divMap.style.position = "absolute";
            divMap.style.cursor = "pointer";
            divMap.title = item.name;
            */
        	
            divMap = new Element("div", 
            		{ "id": "nav_" +  item.id, 
	        		"title" : item.name,
	        		"style" : "border: #ddd 1px solid;"
	        			+ "position: absolute;"
	        			+ "cursor: pointer;"
	        			+ "background-color: " + div.getStyle("background-color")
            		});
            
            item.divMap = divMap;
            
            
            divMap.onclick = function(){
            	window.scrollTo(
            			Math.abs( org.coin.ui.findPosX(div) - window.screen.width/2) ,
            			Math.abs( org.coin.ui.findPosY(div) - window.screen.height/2) );
            }
            
            divNavigator.appendChild(divMap);
        }
        
        
        org.coin.ui.setSizeFromDiv(
	            div,
	            divMap,
	            this.fRatioNavigator);
	            
    },
    
    displayAllHookFace: function() {

        this.relations.each(function(item){
            var eltA = $(item.entityA);
            var eltB = $(item.entityB);

	    	var sHookFace = org.coin.ui.getHookFace(eltA, eltB);
	        org.coin.ui.displayHookFace(
	                eltA,
	                eltB,
	                sHookFace );
        });
        
    },

    getTableById: function(idTable) {
    	return this.getObjectById(idTable, this.tables);
    },

    getRelationById: function(idRelation) {
    	return this.getObjectById(idRelation, this.relations);
    },


    getObjectById: function(idObject, objects) {
    	var obj = null;
        objects.each(function(item){
        	if(item.id == idObject) {
        		obj = item;
        	}
        });
        return obj;
    },

    reorderTableRelation: function(table) {
    	var hf = table.hookFaces;
    	hf.left = this.reorderTableRelationHookFace(table, hf.left, "left");
    	hf.right = this.reorderTableRelationHookFace(table, hf.right, "right");
    	hf.top = this.reorderTableRelationHookFace(table, hf.top, "top");
    	hf.bottom = this.reorderTableRelationHookFace(table, hf.bottom, "bottom");
    },

    /**
     * To sort the array, we need to tell JavaScript how to sort. This comes from a 
     * function that returns -1, 0, or +1 as a value. -1 will put the first value 
     * before the second in the sorted array, +1 will put the second value before the first, 
     * and 0 means the values are equal
     */
    sortByDeltaPosition: function(a, b) {
    	var x = a.iDeltaPosition; 
    	var y = b.iDeltaPosition;
    	return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    },

    
    reorderTableRelationHookFace: function(table, relations, sHookFace) {
    	var _this = this;
    	var relationsReordered = [];
    	
    	/**
    	 * 0 or 1 relation : nothing to reorder
    	 */
    	if(relations.length <= 1) return relations;
    	
    	/**
    	 * get first relation
    	 * 
    	 *           [B2]
    	 * [A]
    	 * 
    	 * 		[B1]
    	 * 			[B3]
    	 * 
    	 * 
    	 * => reordered : B2, B1, B3
    	 */
		var iDeltaCurrent = 0;
		var relationDelta = [];
		
    	relations.each(function(item, index){
	   		var tableTemp1 = _this.getTableById(item.entityA);
			var tableTemp2 = _this.getTableById(item.entityB);
			var tableA = table;
			var tableB ;
			if(table.id == tableTemp1.id) 
			{
				tableB = tableTemp2;
			} else {
				tableB = tableTemp1;
			}

            var eltA = $(tableA.id);
            var eltB = $(tableB.id);
            
         	switch(sHookFace)
    	    {
    	    case "left":
    	    case "right":
    	    	iDeltaCurrent = org.coin.ui.findPosY(eltB) - org.coin.ui.findPosY(eltA);
    	    	break;
    	    case "top":
    	    case "bottom":
    	    	iDeltaCurrent = org.coin.ui.findPosX(eltB) - org.coin.ui.findPosX(eltA);
    	        break;
    	    }
         	
			relationDelta.push({relation: item, iDeltaPosition:iDeltaCurrent});
    	});

    	
    	relationDelta.sort(this.sortByDeltaPosition);
    	relationDelta.each(function(item){
			relationsReordered.push(item.relation);
        });
    	
        return relationsReordered;
    },

    getAllRelationForHookFace: function(table, sHookFace) {
        var relations;
    	switch(sHookFace)
	    {
	    case "left":
	    	relations = table.hookFaces.left;
	    	break;
	    case "right":
	    	relations = table.hookFaces.right;
	        break;
	    case "top":
	    	relations = table.hookFaces.top;
	        break;
	    case "bottom":
	    	relations = table.hookFaces.bottom;
	        break;
	    case "_all":
	    	relations 
	    		= [].concat(
	    			table.hookFaces.left,
	    			table.hookFaces.right,
	    			table.hookFaces.top,
	    			table.hookFaces.bottom);
	    	break;
	    }
        
        return relations;
    },

    getOppositeHookFace: function(sHookFace) {
        var sHookFaceOpposite;
    	switch(sHookFace)
	    {
	    case "left":
	    	sHookFaceOpposite = "right";
	    	break;
	    case "right":
	    	sHookFaceOpposite = "left";
	        break;
	    case "top":
	    	sHookFaceOpposite = "bottom";
	        break;
	    case "bottom":
	    	sHookFaceOpposite = "top";
	        break;
	    }
        
        return sHookFaceOpposite;
    },

    initTableHookFace: function(table, sHookFace) {
        var sHookFaceOpposite;
    	switch(sHookFace)
	    {
	    case "left":
        	table.hookFaces.left = [];
	    	break;
	    case "right":
        	table.hookFaces.right = [];
	        break;
	    case "top":
        	table.hookFaces.top  = [];
	        break;
	    case "bottom":
        	table.hookFaces.bottom = [];
	        break;
	    case "_all":
        	table.hookFaces.left = [];
        	table.hookFaces.right = [];
        	table.hookFaces.top = [];
        	table.hookFaces.bottom = [];
	        break;
	    }
    },

    
    drawTableRelation: function(table) {
    	var _this = this;
    	var tables = [];
    	var relationsImpacted = [];
    	tables.push(table);




    	/**
    	 * set relations on hookface
    	 */
    	var idTable = table.id;
        this.relations.each(function(item){
        	
        	try {
        		$( item.id + "_a").style.backgroundColor = "#ddd";
        		$( item.id + "_b").style.backgroundColor = "#ddd";
        		$( item.id + "_c").style.backgroundColor = "#ddd";
        		$( item.id + "_c").style.color = "#ddd";
        	} catch (e) {
			}
        	
        	/**
        	 * we have 3 level of interaction
        	 * 
        	 * A (all faces) <=> B (all faces)  <=> C (hook faces) 
        	 */
        	if(item.entityA == idTable || item.entityB == idTable)
        	{
        		relationsImpacted.push(item);
                var tableB;
                var sHookFace;
            	if(item.entityA == idTable )
            	{
                    tableB = _this.getTableById(item.entityB);
            	} else {
                    tableB = _this.getTableById(item.entityA);
            	}
            	
            	
            	/**
            	 * re init hookface
            	 */
                var hookB = _this.getAllRelationForHookFace(tableB, "_all");
                hookB.each(function(hook){
                	
                	var tableC;
                	if(hook.entityA == tableB.id )
                	{
                        tableC = _this.getTableById(hook.entityB);
                        sHookFace = _this.getOppositeHookFace( hook.sHookFace);
                	} else {
                        tableC = _this.getTableById(hook.entityA);
                        sHookFace = hook.sHookFace;
                	}

                	/**
                	 * to prevent loop on main table
                	 */
                	if(tableC.id == table.id) return;
                	
            		
                	_this.initTableHookFace(tableC, sHookFace);
                	
                	relationsImpacted.push(hook); 
                    hook.iDeltaPosition=0;
                });


            	_this.initTableHookFace(tableB, "_all");
                tables.push(tableB);
        	}
        });
        

    	/**
    	 * re init hookface
    	 */
        this.initTableHookFace(table, "_all");

        
        relationsImpacted.each(function(item){
        	try {
        		$( item.id + "_a").style.backgroundColor = "#f99";
        		$( item.id + "_b").style.backgroundColor = "#f99";
        		$( item.id + "_c").style.backgroundColor = "#f99";
        		$( item.id + "_c").style.color = "#f99";
        	} catch (e) {
    		}
        });



        
    	this.drawAllTableRelation(
        		tables,
        		relationsImpacted); 

    },
    
    displayAllRelation: function() {
    	var _this = this;

    	/**
    	 * re init hookface
    	 */
        this.tables.each(function(item){
        	_this.initTableHookFace(item, "_all");
        });

    	this.drawAllTableRelation(
        		this.tables,
        		this.relations); 
    },

    
    hideRelation: function(item)
    {
    	Element.hide(item.id + "_a");
    	Element.hide(item.id + "_b");
    	Element.hide(item.id + "_c");
    	Element.hide(item.id + "_d");
    },

    showRelation: function(item)
    {
    	Element.show(item.id + "_a");
    	Element.show(item.id + "_b");
    	Element.show(item.id + "_c");
    	Element.show(item.id + "_d");
    },

    showAllRelation: function()
    {
        this.relations.each(function(item){
            try{
               _this.showRelation(item);
            } catch(e) {}
        });
    },
    
    drawAllTableRelation: function(
    		tables,
    		relations) 
    {
    	var _this = this;
    	

    	/**
    	 * set relations on hookface
    	 */
        relations.each(function(item){

		    var eltA = $(item.entityA);
            var eltB = $(item.entityB);
            var sHookFace = org.coin.ui.getHookFace(eltA, eltB);
		    
	    	item.sHookFace = sHookFace;
            if(sHookFace != null)
            {
                var tableA = _this.getTableById(item.entityA);
                var tableB = _this.getTableById(item.entityB);
                var hookA = _this.getAllRelationForHookFace(tableA, sHookFace);
                var hookB = _this.getAllRelationForHookFace(tableB, _this.getOppositeHookFace( sHookFace));
              
    	    	hookA.push(item);
    	    	hookB.push(item);
            }
        });


        
    	/**
    	 * reorder relations 
    	 */
        tables.each(function(item){
        	_this.reorderTableRelation(item);
        });

        
        
    	/**
    	 * compute shift factor
    	 */
        relations.each(function(item){
            var eltA = $(item.entityA);
            var eltB = $(item.entityB);
		    
            var tableA = _this.getTableById(item.entityA);
            var tableB = _this.getTableById(item.entityB);
            
            if(item.sHookFace != null)
        	{
                var hookA = _this.getAllRelationForHookFace(tableA, item.sHookFace);
                var hookB = _this.getAllRelationForHookFace(tableB, _this.getOppositeHookFace( item.sHookFace));
                
    	    	/**
    	    	 * compute shift factor by index placing
    	    	 */
    	    	hookA.each(function(relation, index){
    	    		if(relation.id == item.id)
    	    		{
    			    	item.iDeltaPositionA = index * _this.iRelationOnHookFaceOffset;
    	    		}
    	        });

    	    	hookB.each(function(relation, index){
    	    		if(relation.id == item.id)
    	    		{
    			    	item.iDeltaPositionB = index * _this.iRelationOnHookFaceOffset;
    	    		}
    	        });
        	}

        });

        
        relations.each(function(item){
            if(item.sHookFace != null)
        	{
        		org.coin.ui.drawLinkFromRelation(item);
        	}
        });
    }       
}
