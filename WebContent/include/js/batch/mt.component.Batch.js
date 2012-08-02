mt.component.batch.initBatch = function(jsonBatches,jsonConnection,se){
    var batchManager = new Object();
	var batches = new Array();
    
    jsonBatches.each(function(item){
        var batch = eval("new "+item._JS_CONTEXT+"(item)");
        batch.getValue = function(id,defaultValue){
            var value = defaultValue;
            try{value = eval("this.batchItem."+id);}
            catch(e){value = defaultValue;}
            if(!isNotNull(value)){
                value = defaultValue;
            }
            return value;
        }
        batch.load();
        batches.push(batch);
    });
    jsonBatches.splice(0, 0, {_ID:0, _NAME:MESSAGE_BATCH[2]});
    $('selectBatch').populate(jsonBatches,null,"_ID","_NAME");
    
    $('selectBatch').onchange = function(){
    	if(this.selectedIndex>0){
	        var batch = batches[this.selectedIndex-1];
	        $$(".divBatch").each(function(item){
	            if(batch && batch.batchItem && item.id == "div"+batch.batchItem._ID){
	                Element.show(item);
	            }else{
	                Element.hide(item);
	            }
	        });
	        $("descBatch").innerHTML = "";
	        $("descBatch").innerHTML = batch.batchItem._DESC;
	        batchManager.onChangeBatch(this,batch);
    	}
    }
    
    $('runBatch').onclick = function(){
        var batch = batches[$('selectBatch').selectedIndex-1];
        if(batch && batch.run){
        	batchManager.onBeforeRunBatch(batch);
            if((batch.onBeforeRun && batch.onBeforeRun(se)) || !batch.onBeforeRun){
            	batch.run(se);
            }
        }
            
    }
    
    if($("selectConn")){
        jsonConnection.splice(0, 0, {data:"local", value:"Local Connection"});
        $('selectConn').populate(jsonConnection);
    }
    
    batchManager.batches = batches;
    batchManager.onChangeBatch = function(select,batch){}
    batchManager.onBeforeRunBatch = function(batch){}
    
    batchManager.retrieveBatch = function(name){
    	batches.each(function(batch){
    		
    		if(batch.batchItem._ID == name) b = batch; 
    	});
    	return b;
    }
    
    return batchManager;
}

mt.component.batch.AttachContractBatch = function(batch){
	var self = this;
	this.batchItem = null;
	
	this.init = function(){
	   this.batchItem = batch;
    }
    
    this.load = function(){
        var div = document.createElement("div");
        div.innerHTML = '<form id="form'+this.batchItem._ID+'" class="validate-fields"><button type="button" id="AJCL_but_lIdContract"'+
         ' class="obligatory" >'+this.getValue("locChooseContract","Link to a contract")+'</button>'+
         '<input class="dataType-notNull dataType-id dataType-id dataType-integer" type="hidden" id="lIdContract"'+ 
         'name="lIdContract" value="" />'+
         '<img style="cursor:pointer;display:none" src="'+rootPath+'images/icons/application_edit.gif" id="contractLink" />'+
		 '<br/>'+'<br/>'+
		 '<span style="margin-top:5px;font-style:italic;" id="contractDates"></span>'+
		 '<br/>'+'<br/>'+
		 '<table id="tableContractParams" name="tableContractParams" style="display:none">'+
         '<tr><td>'+this.getValue("getDateStartLabel","Start date")+'</td><td><input class="dataType-notNull dataType-date" name="tsDateStart" id="tsDateStart" value=""/></td></tr>'+
         '<tr><td>'+this.getValue("getDateEndLabel","End date")+'</td><td><input class="dataType-notNull dataType-date" name="tsDateEnd" id="tsDateEnd" value=""/></td></tr>'+
         '<tr><td>'+this.getValue("getIdContractVehicleTypeLabel","Type")+'</td><td><select name="lIdContractVehicleType" id="lIdContractVehicleType"></select></td></tr>'+
         '</table>'+
		 '</form>';
         div.id = "div"+this.batchItem._ID;
         div.className = "divBatch";
         div.style.display = "none";
         $("contentBatch").appendChild(div);
         
         var acContract = new AjaxComboList("lIdContract", "getContract","right","batchManager.retrieveBatch('AttachContractBatch').onSelectContract();");
         
         try{requireHead(rootPath+"dwr/interface/AttachContractBatch.js");}
         catch(e){}
         
         mt.html.setSuperCombo($("lIdContractVehicleType"));
         $("lIdContractVehicleType").populate(this.getValue("cvTypes"),0,"lId","sName");
         
         enableFormFieldsValidation();
         
         $('form'+this.batchItem._ID).isValid = function(){
             var compare = self.onSelectContract();
             if(compare == false){
         		mt.utils.displayFormFieldMsg($("tsDateStart"),self.getValue("locMessageContractDates") );
         		mt.utils.displayFormFieldMsg($("tsDateEnd"),self.getValue("locMessageContractDates"));
             }
         	return compare;
         }
    }
    
    this.onSelectContract = function(){
    	var select = $("AJCL_sel_lIdContract");
    	if(select.options.selectedIndex >= 0){
    	    var optionSelected = select.options[select.options.selectedIndex];
    	    var optionSelectedObj = optionSelected.obj;
    	    var dateStartContract = optionSelectedObj.tsDateStart;
    	    var dateEndContract = optionSelectedObj.tsDateEnd;
    	
    	    if($("lIdContract").value > 0){
    		    Element.show($("contractLink"));
    		    Element.show($("tableContractParams"));
    		    
    		    $("contractLink").onclick = function(){
    		    	parent.addParentTabForced('contract',self.getValue("sURLContract")+optionSelectedObj.lId);
    		    }
    		    
    		    if(!isNotNull($('tsDateStart').value)){
    		    	$('tsDateStart').value = dateStartContract;
    		    	self.batchItem.startdateobject = Date.parseShortDate($('tsDateStart').value);
    		    }
    		    if(!isNotNull($('tsDateEnd').value)) {
    		    	$('tsDateEnd').value = dateEndContract;
    		    	self.batchItem.enddateobject = Date.parseShortDate($('tsDateEnd').value);
    		    }
    		    enableDateField($('tsDateEnd'));
    		    enableDateField($('tsDateStart'));
    		    
    	         $('tsDateStart').onSelect = function(date) {
    	        	 self.batchItem.startdateobject = date;
    	         }
    	         $('tsDateEnd').onSelect = function(date) {
    	        	 self.batchItem.enddateobject = date;
    	         }
    		    
    		    var compareStart = Date.compareStringDate($('tsDateStart').value,dateStartContract);
    		    var compareEnd = Date.compareStringDate($('tsDateEnd').value,dateEndContract);
    		    var compareCV = Date.compareStringDate($('tsDateStart').value,$('tsDateEnd').value);
    		    var compareStartEnd = Date.compareStringDate($('tsDateStart').value,dateEndContract);
    		    var compareEndStart = Date.compareStringDate($('tsDateEnd').value,dateStartContract);
    		
    		    $("contractDates").innerHTML = self.getValue("getIdContractLabel")+" "+MESSAGE_BUTTON[7]+" "+dateStartContract+" "+MESSAGE_BUTTON[8]+" "+dateEndContract;

    			var compareEndNow = Date.compareStringDate(dateEndContract,new Date().dateFormat("d/m/Y"));
    			if(compareEndNow >= 0){
    				var dateStartBecomingAv = Date.parseShortDate(dateEndContract);
    				dateStartBecomingAv.addMonth(-self.getValue("iNbMonthBefore"));
    			    $("contractDates").innerHTML += "<br/>"+self.getValue("getFlagBecomingAvailableLabel") +" "+MESSAGE_BUTTON[7]+" "+dateStartBecomingAv.dateFormat("d/m/Y")+" "+MESSAGE_BUTTON[8]+" "+dateEndContract;
    			}
    			
    		    if(compareStart >= 0/*start >= contractStart*/
    		   	&& compareStartEnd <= 0/*start <= contractEnd*/
    		   	&& compareEndStart >= 0/*end >= contractStart*/
    		   	&& compareEnd <= 0/*end <= contractEnd*/
    		   	&& compareCV <= 0 /*start <= end*/){
    				return true;
    		    }else{
    		    	return false;
    		    }
    	    }else{
    			Element.hide($("contractLink"));
    			Element.hide($("tableContractParams"));
    			$("contractDates").innerHTML = "";
    		}
    	}else{
    		Element.hide($("contractLink"));
    		Element.hide($("tableContractParams"));
    		$("contractDates").innerHTML = "";
    	}
    }
    
    this.onBeforeRun = function(se){
        var formValid = $('form'+this.batchItem._ID).onsubmit();
        var params = se.generateSelectedItems();
        for (i in params){
            eval("this.batchItem."+i+"=params[i];");
        }
        var startdateformat = isNotNull(self.batchItem.startdateobject)?(self.batchItem.startdateobject.dateFormat("Y-m-d")+" 00:00:00"):"";
        var enddateformat =  isNotNull(self.batchItem.enddateobject)?(self.batchItem.enddateobject.dateFormat("Y-m-d")+" 23:59:59"):"";
        this.batchItem.lIdContract = $("lIdContract").value;
        this.batchItem.tsDateStart = startdateformat;
        this.batchItem.tsDateEnd = enddateformat;
        this.batchItem.lIdContractVehicleType = $("lIdContractVehicleType").value;
        
        if(!isNotNull(this.batchItem.selected)){
            openGlobalException(this.getValue("locMessageSelectVehicle","You have to select at least one vehicle"), null, MESSAGE_BATCH[3]);
            formValid = false;
        }
        if(formValid)
            return confirm(MESSAGE_BATCH[1]);
        else
            return false;
    }   
    
    this.run = function(se){
        AttachContractBatch.doAjaxStatic(Object.toJSON(this.batchItem),function(result){
        	result = result.parseJSON();
        	acceptCallback = function(){
        		closeGlobalConfirm();
        		se.useCurrentBatch = true;
        		se.search();
            }
            if(isNotNull(result.report)) openGlobalConfirm(MESSAGE_BATCH[4], result.report, MESSAGE_BUTTON[1], acceptCallback);  
            else acceptCallback();
        });
    }
    
    this.init();
	
}

mt.component.batch.AttachTrainContractBatch = function(batch){
	var self = this;
	this.batchItem = null;
	
	this.init = function(){
	   this.batchItem = batch;
    }
    
    this.load = function(){
        var div = document.createElement("div");
        div.innerHTML = '<form id="form'+this.batchItem._ID+'" class="validate-fields"><button type="button" id="AJCL_but_lIdContract"'+
         ' class="obligatory" >'+this.getValue("locChooseContract","Link to a contract")+'</button>'+
         '<input class="dataType-notNull dataType-id dataType-id dataType-integer" type="hidden" id="lIdContract"'+ 
         'name="lIdContract" value="" />'+
         '<img style="cursor:pointer;display:none" src="'+rootPath+'images/icons/application_edit.gif" id="contractLink" />'+
		 '<br/>'+'<br/>'+
		 '<span style="margin-top:5px;font-style:italic;" id="contractDates"></span>'+
		 '<br/>'+'<br/>'+
		 '<table id="typeLeasing" name="typeLeasing" style="display:none">'+
		 '<tr><td>'+this.getValue("getDeliveryDateLabel","Delivery date")+'</td><td><input class="dataType-date" name="tsDeliveryDate" id="tsDeliveryDate" value=""/></td></tr>'+
		 '<tr><td>'+this.getValue("getMileageAtDeliveryLabel","Mileage at delivery")+'</td><td><input name="sMileageAtDelivery" id="sMileageAtDelivery" value=""/></td></tr>'+
		 '<tr><td>'+this.getValue("getRedeliveryDateLabel","Redelivery date")+'</td><td><input class="dataType-date" name="tsRedeliveryDate" id="tsRedeliveryDate" value=""/></td></tr>'+
		 '<tr><td>'+this.getValue("getNoticeDateLabel", "Notice date")+'</td><td><input class="dataType-date" name="tsNoticeDate" id="tsNoticeDate" value=""</td></tr>'+
		 '</table>'+
		 '<table id="typePurchase" name="typePurchase" style="display:none">'+
		 '<tr><td>'+this.getValue("getDeliveryDateLabel","Delivery date")+'</td><td><input class="dataType-date" name="tsDeliveryDatePurchase" id="tsDeliveryDatePurchase" value=""</td></tr>'+
		 '<tr><td>'+this.getValue("getEndOfWarrantyLabel", "End of warranty")+'</td><td><input class="dataType-date" name="tsEndOfWarranty" id="tsEndOfWarranty" value=""</td></tr>'+
		 '<tr><td>'+this.getValue("getActualPriceLabel", "Actual price")+'</td><td><input name="lActualPrice" id="lActualPrice" value="" </td></tr>'+
		 '<tr><td>'+this.getValue("getNoticeDateLabel", "Notice date")+'</td><td><input class="dataType-date" name="tsNoticeDatePurchase" id="tsNoticeDatePurchase" value="" </td></tr>'+
		 '</table>'+
		 '<table id="typeOther" name="typeOther" style="display:none">'+
         '<tr><td>'+this.getValue("getDateStartLabel","Start date")+'</td><td><input class="dataType-date" name="tsDateStart" id="tsDateStart" value=""/></td></tr>'+
         '<tr><td>'+this.getValue("getDateEndLabel","End date")+'</td><td><input class="dataType-date" name="tsDateEnd" id="tsDateEnd" value=""/></td></tr>'+
         '</table>'+
		 '</form>';
         div.id = "div"+this.batchItem._ID;
         div.className = "divBatch";
         div.style.display = "none";
         $("contentBatch").appendChild(div);
         
         
         var acContract = new AjaxComboList("lIdContract", "getContractFromType_11_12_14_15_16","right","batchManager.retrieveBatch('AttachTrainContractBatch').onSelectContract();");
         
         try{requireHead(rootPath+"dwr/interface/AttachTrainContractBatch.js");}
         catch(e){}
         
         
         enableFormFieldsValidation();
    }
    
    this.onSelectContract = function(){
    	var select = $("AJCL_sel_lIdContract");
        if(select.options.selectedIndex >= 0){
            var optionSelected = select.options[select.options.selectedIndex];
            var optionSelectedObj = optionSelected.obj;
            var dateStartContract = optionSelectedObj.tsDateStart;
            var dateEndContract = optionSelectedObj.tsDateEnd;
            var contractTypeSelected = optionSelectedObj.lIdContractType;
            var compareStart = null;
            var compareEnd = null;
            var compareCV = null;
            var compareStartEnd = null;
            var compareEndStart = null;
            self.batchItem.optionSelectedObj = optionSelectedObj;
            
    	    if($("lIdContract").value > 0){
    		    Element.show($("contractLink"));
    		    
    		    $("contractLink").onclick = function(){
    		    	parent.addParentTabForced('contract',self.getValue("sURLContract")+optionSelectedObj.lId);
    		    }
    		    
    		    Element.hide("typeOther");
    		    Element.hide("typeLeasing");
    		    Element.hide("typePurchase");
    		    
    		    if(contractTypeSelected!=14 && contractTypeSelected!=12 && contractTypeSelected !=15){
    		    	Element.show("typeOther");
    		    	compareStart = Date.compareStringDate($('tsDateStart').value,dateStartContract);
    	            compareEnd = Date.compareStringDate($('tsDateEnd').value,dateEndContract);
    	            compareCV = Date.compareStringDate($('tsDateStart').value,$('tsDateEnd').value);
    	            compareStartEnd = Date.compareStringDate($('tsDateStart').value,dateEndContract);
    	            compareEndStart = Date.compareStringDate($('tsDateEnd').value,dateStartContract);
    	
    	        }
                else if(contractTypeSelected==14 || contractTypeSelected==12){
                	Element.show("typeLeasing");
                	compareStart = Date.compareStringDate($('tsDeliveryDate').value,dateStartContract);
                    compareEnd = Date.compareStringDate($('tsRedeliveryDate').value,dateEndContract);
                    compareCV = Date.compareStringDate($('tsDeliveryDate').value,$('tsRedeliveryDate').value);
                    compareStartEnd = Date.compareStringDate($('tsDeliveryDate').value,dateEndContract);
                    compareEndStart = Date.compareStringDate($('tsDeliveryDate').value,dateStartContract);

                }
                else if(contractTypeSelected==15){
                	Element.show("typePurchase");
                }
    		    
    		    enableDateField($('tsDateEnd'));
    		    enableDateField($('tsDateStart'));
    		    enableDateField($('tsDeliveryDate'));
    		    enableDateField($('tsRedeliveryDate'));
    		    enableDateField($('tsNoticeDate'));
    		    enableDateField($('tsDeliveryDatePurchase'));
    		    enableDateField($('tsNoticeDatePurchase'));
    		    enableDateField($('tsEndOfWarranty'));
    		    
    	         $('tsDateStart').onSelect = function(date) {
    	        	 self.batchItem.startdateobject = date;
    	         }
    	         $('tsDateEnd').onSelect = function(date) {
    	        	 self.batchItem.enddateobject = date;
    	         }
    	         $('tsDeliveryDate').onSelect = function(date) {
    	        	 self.batchItem.startdateobject = date;
    	         }
    	         $('tsRedeliveryDate').onSelect = function(date) {
    	        	 self.batchItem.enddateobject = date;
    	         }

    		    $("contractDates").innerHTML = self.getValue("getIdContractLabel")+" "+MESSAGE_BUTTON[7]+" "+dateStartContract+" "+MESSAGE_BUTTON[8]+" "+dateEndContract;
    			
    		    if(compareStart >= 0/*start >= contractStart*/
    		   	&& compareStartEnd <= 0/*start <= contractEnd*/
    		   	&& compareEndStart >= 0/*end >= contractStart*/
    		   	&& compareEnd <= 0/*end <= contractEnd*/
    		   	&& compareCV <= 0 /*start <= end*/){
    				return true;
    		    }else{
    		    	return false;
    		    }
    	    }else{
    			Element.hide($("contractLink"));
    			Element.hide($("typeLeasing"));
    			Element.hide($("typeOther"));
    			Element.hide($("typePurchase"));
    			$("contractDates").innerHTML = "";
    		}
    	}else{
    		Element.hide($("contractLink"));
    		Element.hide($("typeLeasing"));
			Element.hide($("typeOther"));
			Element.hide($("typePurchase"));
    		$("contractDates").innerHTML = "";
    	}
    }
    
    this.onBeforeRun = function(se){
        var formValid = $('form'+this.batchItem._ID).onsubmit();
        var params = se.generateSelectedItems();
        for (i in params){
            eval("this.batchItem."+i+"=params[i];");
        }
        
        var startdateformat = isNotNull(self.batchItem.startdateobject)?(self.batchItem.startdateobject.dateFormat("Y-m-d")+" 00:00:00"):"";
        var enddateformat =  isNotNull(self.batchItem.enddateobject)?(self.batchItem.enddateobject.dateFormat("Y-m-d")+" 23:59:59"):"";
        
        this.batchItem.lIdContract = this.batchItem.optionSelectedObj.lId;
        this.batchItem.lIdContractType = this.batchItem.optionSelectedObj.lIdContractType;
        
        if(this.batchItem.lIdContractType!=14 && this.batchItem.lIdContractType!=12 && this.batchItem.lIdContractType !=15){
            this.batchItem.tsDateStart = startdateformat;
            this.batchItem.tsDateEnd = enddateformat;
        }
        else if(this.batchItem.lIdContractType==14 || this.batchItem.lIdContractType==12){
        	this.batchItem.tsDeliveryDate = $("tsDeliveryDate").value;
        	this.batchItem.sMileageAtDelivery = $("sMileageAtDelivery").value;
        	this.batchItem.tsRedeliveryDate = $("tsRedeliveryDate").value;
        	this.batchItem.tsNoticeDate = $("tsNoticeDate").value;
        }
        else if(this.batchItem.lIdContractType==15){
        	this.batchItem.tsDeliveryDate = $("tsDeliveryDatePurchase").value;
        	this.batchItem.tsEndOfWarranty = $("tsEndOfWarranty").value;
        	this.batchItem.lActualPrice = $("lActualPrice").value;
        	this.batchItem.tsNoticeDate = $("tsNoticeDatePurchase").value;
        }
        
        if(!isNotNull(this.batchItem.selected)){
            openGlobalException(this.getValue("locMessageSelectVehicle","You have to select at least one vehicle"), null, MESSAGE_BATCH[3]);
            formValid = false;
        }
        if(formValid)
            return confirm(MESSAGE_BATCH[1]);
        else
            return false;
    }   
    
    this.run = function(se){
        AttachTrainContractBatch.doAjaxStatic(Object.toJSON(this.batchItem),function(result){
        	result = result.parseJSON();
        	acceptCallback = function(){
        		closeGlobalConfirm();
        		se.useCurrentBatch = true;
        		se.search();
            }
            if(isNotNull(result.report)) openGlobalConfirm(MESSAGE_BATCH[4], result.report, MESSAGE_BUTTON[1], acceptCallback);  
            else acceptCallback();
        });
    }
    
    this.init();
	
}

mt.component.batch.AttachTrainPicturesBatch = function(batch){
	var self = this;
	this.batchItem = null;
	
	this.init = function(){
	   this.batchItem = batch;
    }
    
    this.load = function(){
    	var div = document.createElement("div");
        var content = '<form id="form'+this.batchItem._ID+'" class="validate-fields">'+
		 '<table class="formLayout" cellspacing="3">'+
		 '<tr><td>'+this.getValue("getMediaTypeLabel","Media type")+'</td><td><select id="lIdMediaType" name="lIdMediaType">';
	        this.batchItem.mediaType.each(function(mediaType){
	            content += '<option value="'+mediaType.data+'">'+mediaType.value+'</option>';
	        });
	     content += '</select></td></tr>'+
	     '<tr><td>'+this.getValue("getNameLabel", "Name")+'</td><td><input name="sName" id="sName" value="" type="text" class="dataType-notNull"/> </td></tr>'+
	     '<tr><td>'+this.getValue("getFileLabel", "File")+'</td><td><input name="sFilePath" id="sFilePath" value="" type="file" class="dataType-notNull"/></td></tr>'+
		 '</table>'+
		 '</form>'+
		 '<form id="form_upload'+this.batchItem._ID+'" enctype="multipart/form-data" method="post" target="upload_target" action="'+this.batchItem.url+'">'+
		 '</form>'+
		 '<iframe id="upload_target" name="upload_target" src="" style="width:1px;height:1px;border:0;visibility:hidden"></iframe>';
         div.innerHTML = content;
         div.id = "div"+this.batchItem._ID;
         div.className = "divBatch";
         div.style.display = "none";
         $("contentBatch").appendChild(div);
         
         try{requireHead(rootPath+"dwr/interface/AttachTrainPicturesBatch.js");}
         catch(e){}
         
         enableFormFieldsValidation();
    }
    
    
    this.onBeforeRun = function(se){
        var formValid = $('form'+this.batchItem._ID).onsubmit();
        var params = se.generateSelectedItems();
        for (i in params){
            eval("this.batchItem."+i+"=params[i];");
        }
        
        this.batchItem.sName = $("sName").value;
        this.batchItem.lIdMediaType = $("lIdMediaType").value;
        this.batchItem.sFilePath = $("sFilePath").value;
        
        if(!isNotNull(this.batchItem.selected)){
            openGlobalException(this.getValue("locMessageSelectVehicle","You have to select at least one vehicle"), null, MESSAGE_BATCH[3]);
            formValid = false;
        }
        if(formValid)
            return confirm(MESSAGE_BATCH[1]);
        else
            return false;
    }   
    
    this.run = function(se){
    	AttachTrainPicturesBatch.doAjaxStatic(Object.toJSON(this.batchItem),function(result){
    		openGlobalLoader();
    		result = result.parseJSON();
    		acceptCallback = function(){
        		closeGlobalConfirm();
        		se.useCurrentBatch = true;
        		se.search();
            }
    		if(isNotNull(result.report)) openGlobalConfirm(MESSAGE_BATCH[4], result.report, MESSAGE_BUTTON[1], acceptCallback);  
            else {
            	$('form_upload'+self.batchItem._ID).appendChild($("sFilePath"));
            	$('form_upload'+self.batchItem._ID).submit();
            }
         });
    }
    
    this.init();
}

mt.component.batch.ModifyVehicleStatusBatch = function(batch){
    var self = this;
    this.batchItem = null;
    
    this.init = function(){
       this.batchItem = batch;
    }
    
    this.load = function(){
        
        var div = document.createElement("div");
        div.id = "div"+this.batchItem._ID;
        div.className = "divBatch";
        div.style.display = "none";
        $("contentBatch").appendChild(div);
        
        var form = document.createElement("form");
        form.id = 'form'+this.batchItem._ID;
        form.className = "validate-fields";
        div.appendChild(form);
       
        var button = document.createElement("button");
        button.id = button.name = 'buttonActionStatut';
        button.innerHTML =  this.getValue("locVehicleButtonStatus","Change vehicle status");
        button.onclick = function(){
            self.changeVehicleStatus();
            return false;
        }
        form.appendChild(button);
        
        var input = document.createElement("input");
        input.id = input.name = 'sActionStatut';
        input.className = "dataType-notNull";
        input.type = "hidden";
        input.fieldReference = button;
        form.appendChild(input);
         
        try{requireHead(rootPath+"dwr/interface/ModifyVehicleStatusBatch.js");}
        catch(e){}
         
        enableFormFieldsValidation();
    }
    
    this.onBeforeRun = function(se){
        var formValid = $('form'+this.batchItem._ID).onsubmit();
        var params = se.generateSelectedItems();
        for (i in params){
            eval("this.batchItem."+i+"=params[i];");
        }
        this.batchItem.sActionStatut = $("sActionStatut").value;

        if(!isNotNull(this.batchItem.selected)){
            openGlobalException(this.getValue("locMessageSelectVehicle","You have to select at least one vehicle"), null, MESSAGE_BATCH[3]);
            formValid = false;
        }
        if(formValid)
            return confirm(MESSAGE_BATCH[1]);
        else
            return false;
    }   
    
    this.run = function(se){
        ModifyVehicleStatusBatch.doAjaxStatic(Object.toJSON(this.batchItem),function(result){
        	result = result.parseJSON();
        	acceptCallback = function(){
        		closeGlobalConfirm();
        		se.useCurrentBatch = true;
        		se.search();
            }
            if(isNotNull(result.report)) openGlobalConfirm(MESSAGE_BATCH[4], result.report, MESSAGE_BUTTON[1], acceptCallback);  
            else acceptCallback();
        });
    }
    
    this.changeVehicleStatus = function(){
	    var title = this.getValue("locVehicleButtonStatus","Change vehicle status");
	    var content = this.getValue("locMessageSelectVehicleStatus","Select action you want to do")+"<br/><br/>";
	    content += '<table class="formLayout" cellspacing="3">'+
	                '<tr>'+
	                    '<td class="label">Status:</td>'+
	                    '<td class="value"><select id="modal_vehicle_action">';
	   this.batchItem.status.each(function(statut){
	        content += '<option value="'+statut.data+'">'+statut.value+'</option>';
	   });

	    content += '</select></td>'+
	                '</tr>'+
	                '</table>';

	    var acceptTitle = MESSAGE_BUTTON[6];
	    acceptCallback = function(){     
	        $("sActionStatut").value = "";
	        var select;
	        try{select = parent.document.getElementById("modal_vehicle_action");}
	        catch(e){select = document.getElementById("modal_vehicle_action");}
	        mt.html.setSuperCombo(select);
	        $("sActionStatut").value = select.value;
	        $("buttonActionStatut").innerHTML = select.getSelectedText();
	        closeGlobalConfirm();
	    }

	    var refuseTitle = MESSAGE_BUTTON[2];
	    refuseCallback = function(){
	        closeGlobalConfirm();
	    }

	    openGlobalConfirm(title, content, acceptTitle, acceptCallback, refuseTitle, refuseCallback);
	    return false;
	}
    
    this.init();
}

mt.component.batch.ModifyContractBatch = function(batch){
    var self = this;
    this.batchItem = null;
    
    this.startdateobject;
    this.enddateobject;
    this.optionaldateobject;
    
    this.init = function(){
       this.batchItem = batch;
    }
    
    this.load = function(){
        var div = document.createElement("div");
        div.innerHTML = '<form id="form'+this.batchItem._ID+'" class="validate-fields">'+
        '<table>'+
         '<tr><td>'+this.getValue("locContractDateStart","Start date")+'</td><td><input class="dataType-date" name="tsDateStart" id="tsDateStart"  value="" /></td></tr>'+
         '<tr><td>'+this.getValue("locContractDateEnd","End date")+'</td><td><input class="dataType-date" name="tsDateEnd" id="tsDateEnd"  value="" /></td></tr>'+
         '<tr><td>'+this.getValue("locContractDateOptionalExtension","optional extension date")+'</td><td><input class="dataType-date" name="tsDateOptionalExtension" id="tsDateOptionalExtension"  value="" /></td></tr>'+
         '</table>'+
         '</form>';
         div.id = "div"+this.batchItem._ID;
         div.className = "divBatch";
         div.style.display = "none";
         $("contentBatch").appendChild(div);
         
         try{requireHead(rootPath+"dwr/interface/ModifyContractBatch.js");}
         catch(e){}
         try{requireHead(rootPath+"include/component/calendar/calendar.js");}
         catch(e){}
         try{requireHeadCSS(rootPath+"include/component/calendar/calendar.css");}
         catch(e){}
         
         enableFormFieldsValidation();
         enableDateFields();
         
         $('tsDateStart').onSelect = function(date) {
            self.startdateobject = date;
         }
         $('tsDateEnd').onSelect = function(date) {
            self.enddateobject = date;
         }
         $('tsDateOptionalExtension').onSelect = function(date) {
            self.optionaldateobject = date;
         }
    }
    
    this.onBeforeRun = function(se){
        var formValid = $('form'+this.batchItem._ID).onsubmit();
        var params = se.generateSelectedItems();
        for (i in params){
            eval("this.batchItem."+i+"=params[i];");
        }
        
        this.batchItem.tsDateStart = isNotNull($("tsDateStart").value.trim())?this.startdateobject.dateFormat("Y-m-d")+" 00:00:00":"";
        this.batchItem.tsDateEnd = isNotNull($("tsDateEnd").value.trim())?this.enddateobject.dateFormat("Y-m-d")+" 23:59:59":"";
        this.batchItem.tsDateOptionalExtension = isNotNull($("tsDateOptionalExtension").value.trim())?this.optionaldateobject.dateFormat("Y-m-d")+" 23:59:59":"";
        
        if(!isNotNull(this.batchItem.selected)){
            openGlobalException(this.getValue("locMessageSelectContract","You have to select at least one contract"), null, MESSAGE_BATCH[3]);
            formValid = false;
        }
        if(formValid)
            return confirm(MESSAGE_BATCH[1]);
        else
            return false;
    }   
    
    this.run = function(se){
        ModifyContractBatch.doAjaxStatic(Object.toJSON(this.batchItem),function(result){
        	se.useCurrentBatch = true;
        	se.search();
        });
    }
    
    this.init();
    
}

mt.component.batch.ModifyVehicleBUBatch = function(batch){
    var self = this;
    this.batchItem = null;
    
    this.init = function(){
       this.batchItem = batch;
    }
    
    this.load = function(){
        var div = document.createElement("div");
        div.innerHTML = '<form id="form'+this.batchItem._ID+'" class="validate-fields"><button type="button" id="AJCL_but_lIdOrganisationBU"'+
         'class="obligatory" >'+this.getValue("locChooseBU","Choose business unit")+'</button>'+
         '<input class="dataType-notNull dataType-id dataType-id dataType-integer" type="hidden" id="lIdOrganisationBU"'+ 
         'name="lIdOrganisationBU" value="" />&nbsp;<select id="lIdOrganisationBUDepot" name="lIdOrganisationBUDepot"></select></form>';
         div.id = "div"+this.batchItem._ID;
         div.className = "divBatch";
         div.style.display = "none";
         $("contentBatch").appendChild(div);
         
         var acBU = new AjaxComboList("lIdOrganisationBU", "getRaisonSocialeVeolia");
         acBU.defineSelectSpecificAction = function(){
            $(acBU.sIdSelect).onchange = function(){
	            var optionSelected = this.options[this.options.selectedIndex];
	            var optionSelectedObj = optionSelected.obj;
	            mt.html.setSuperCombo($("lIdOrganisationBUDepot"));
	            $("lIdOrganisationBUDepot").populate(optionSelectedObj.depots);
	            
	            AJCL_getItemFromSelect(acBU.sIdChamp,
                                  acBU.sIdSelect,
                                  acBU.sIdButton,
                                  acBU.sIdDiv,
                                  acBU.bShowId,
                                  acBU.sActionOnChange);
            }
            
         }
         
         try{requireHead(rootPath+"dwr/interface/ModifyVehicleBUBatch.js");}
         catch(e){}
         
         enableFormFieldsValidation();
    }
    
    this.onBeforeRun = function(se){
        var formValid = $('form'+this.batchItem._ID).onsubmit();
        var params = se.generateSelectedItems();
        for (i in params){
            eval("this.batchItem."+i+"=params[i];");
        }
        this.batchItem.lIdOrganisationBU = $("AJCL_sel_lIdOrganisationBU").value;
        this.batchItem.lIdOrganisationBUDepot = $("lIdOrganisationBUDepot").value;

        if(!isNotNull(this.batchItem.selected)){
            openGlobalException(this.getValue("locMessageSelectVehicle","You have to select at least one vehicle"), null, MESSAGE_BATCH[3]);
            formValid = false;
        }
        if(formValid)
            return confirm(MESSAGE_BATCH[1]);
        else
            return false;
    }   
    
    this.run = function(se){
        ModifyVehicleBUBatch.doAjaxStatic(Object.toJSON(this.batchItem),function(result){
        	se.useCurrentBatch = true;
        	se.search();
        });
    }
    
    this.init();
}