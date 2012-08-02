<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.algorithm.condition.*,org.coin.bean.algorithm.*,java.util.*, org.coin.util.*" %>
<%
	String sId = request.getParameter("id");
	Procedure proc = null;
	JSONObject jsonProc = new JSONObject();
	if(sId != null)
	{
		try{
			proc = Procedure.getProcedureMemory(Long.parseLong(sId));
			jsonProc = proc.toJSONObject(true);
		}
		catch(Exception e){e.printStackTrace();}
	}
	else{
		proc = new Procedure();
		jsonProc = proc.toJSONObject(false);
		JSONArray jsonPhases = new JSONArray();
		jsonProc.put("phases",jsonPhases);
	}
	
	String sTitle = "Process : <span class=\"altColor\">"+proc.getName()+"</span>";
	
	JSONArray jsonPhases = Phase.getJSONArray(true);
	JSONArray jsonConditions = Condition.getJSONArray();
%>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/Procedure.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/Condition.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/Phase.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/Etape.js" ></script>
<script type="text/javascript">
var phase_dg;
var phase_list = <%= jsonPhases %>;
function populatePhaseDG() {		
    var imgAddPhase = document.createElement("img");
    imgAddPhase.className = "pointer";
    imgAddPhase.src = rootPath+"images/icons/plus.gif";
    imgAddPhase.title = "Add Phase";
    imgAddPhase.onclick = function() {
        displayPhase("new phase");
    }
    phase_dg.addRemoveOption(imgAddPhase);
    phase_dg.addStyle("width", "100%");
    phase_dg.setColumnStyle(2, {width:"32px"});
	phase_dg.setHeader(['Id', 'Nom','']);
	phase_list.each(function(item){
		var divImg = document.createElement("div");
		var img = document.createElement("img");
	    img.className = "pointer";
	    img.src = rootPath+"images/icons/application_edit.gif";
	    img.title = "Edit";
	    img.onclick = function(){
	        displayPhase(item.sLibelle,item,lineData);
	    }
	    var imgEtape = document.createElement("img");
        imgEtape.className = "pointer";
        imgEtape.src = rootPath+"images/icons/plus_purple.gif";
        imgEtape.title = "Add Step";
        imgEtape.onclick = function(){
            displayStep("new step",null,item,lineData);
        }
        divImg.appendChild(img);
        divImg.appendChild(imgEtape);
		var lineData = phase_dg.addItem([item.lId, "", divImg]);
		lineData.node.id = item.lId;
		storePhase(item,lineData);
	});
	phase_dg.render();
}
function displayPhase(title, item, node) {
    var isNew = false;
    if(!isNotNull(item)){
        isNew = true;
        item = new Object();
        item.sLibelle = "";
    }
    var sHTML = '<table class="formLayout" cellspacing="3">'+
                '<tr>'+
                    '<td class="label">Name :</td>'+
                    '<td class="frame"><input type="text" value="'+item.sLibelle+'"/></td>'+
                '</tr>'+
                '</table>';
    
    var modal = new Modal(title, sHTML);
    var inputs = modal.content.getElementsByTagName("input");
    
    modal.onValidate = function() {
        var itemStore = item;
        itemStore.sLibelle = inputs[0].value;
        if(!isNotNull(itemStore.etapes))
            itemStore.etapes = new Array();
        
        Phase.storeFromJSONString(Object.toJSON(itemStore),function(result){
            itemStore.lId = result;
            if(!isNew && isNotNull(node))
               storePhase(itemStore,node);
            else
               addPhase(itemStore);
        });
    }
}
function renderPhase(item,node){
    var div = document.createElement("div");
    var divPhase = document.createElement("div");
    divPhase.innerHTML = item.sLibelle;
    divPhase.style.marginBottom = "2px";
    div.appendChild(divPhase);
    
    var table = document.createElement("table");
    table.style.width="100%";
    var grid = document.createElement("tbody");
    item.etapes.each(function(itemEtape,indexEtape){
        var color = "lightyellow";
        if(indexEtape%2!=0) color = "#FFEFC0";
        
        var tr = document.createElement("tr");
        var tdStep = document.createElement("td");
        tdStep.style.backgroundColor = color;
        tdStep.style.padding = "2px";
        tdStep.innerHTML = itemEtape.lId + ' - '+itemEtape.sLibelle +'<br/>'+itemEtape.sCommentaire;
        tr.appendChild(tdStep);
        
        var tdStepAction = document.createElement("td");
        tdStepAction.style.width = "32px";
        tdStepAction.style.backgroundColor = color;
        var img = document.createElement("img");
        img.className = "pointer";
        img.src = rootPath+"images/icons/application_edit.gif";
        img.title = "Edit";
        img.style.verticalAlign = "bottom";
        img.onclick = function(){
            displayStep(itemEtape.sLibelle,itemEtape,item,node);
        }
        var imgDelete = document.createElement("img");
        imgDelete.className = "pointer";
        imgDelete.src = rootPath+"images/icons/cross.gif";
        imgDelete.title = "Delete";
        imgDelete.style.verticalAlign = "bottom";
        imgDelete.onclick = function(){
            if(confirm("Do you want to delete this step ?" )){
	            Etape.removeFromId(itemEtape.lId, function() { 
	               deleteStep(itemEtape,item,node);
	            });
            }
        }
        tdStepAction.appendChild(img);
        tdStepAction.appendChild(imgDelete);
        tr.appendChild(tdStepAction);
        grid.appendChild(tr);
    });
    table.appendChild(grid);
    div.appendChild(table);
    return div;
}
function storePhase(item,node){ 
    node.cells[1].innerHTML = "";
    var div = renderPhase(item,node)
    node.cells[1].appendChild(div);
}
function addPhase(item){
    var divImg = document.createElement("div");
    var img = document.createElement("img");
    img.className = "pointer";
    img.src = rootPath+"images/icons/application_edit.gif";
    img.title = "Edit";
    img.onclick = function(){
        displayPhase(item.sLibelle,item,lineData);
    }
    var imgEtape = document.createElement("img");
    imgEtape.className = "pointer";
    imgEtape.src = rootPath+"images/icons/plus_purple.gif";
    imgEtape.title = "Add Step";
    imgEtape.onclick = function(){
        displayStep("new step",null,item,lineData);
    }
    divImg.appendChild(img);
    divImg.appendChild(imgEtape);
    var lineData = phase_dg.addItem([item.lId,item.sLibelle, divImg]);
    lineData.node.id = item.lId;
    phase_list.push(item);
}

function displayStep(title, item,itemPhase, node) {
    var isNew = false;
    if(!isNotNull(item)){
        isNew = true;
        item = new Object();
	    item.sIdUseCase="";
	    item.sLibelle="";
	    item.sUrlFormulaire="";
	    item.sUrlTraitement="";
	    item.sCommentaire="";
    }
    item.lIdAlgoPhase=itemPhase.lId;
    
    var sHTML = '<table class="formLayout" cellspacing="3">'+
                '<tr>'+
                    '<td class="label">Phase :</td>'+
                    '<td class="frame"><strong>'+itemPhase.sLibelle+'</strong></td>'+
                '</tr>'+
                '<tr>'+
                    '<td class="label">Name :</td>'+
                    '<td class="frame"><input type="text" value="'+item.sLibelle+'"/></td>'+
                '</tr>'+
                '<tr>'+
                    '<td class="label">Use Case :</td>'+
                    '<td class="frame"><input type="text" value="'+item.sIdUseCase+'"/></td>'+
                '</tr>'+
                '<tr>'+
                    '<td class="label">URL Form :</td>'+
                    '<td class="frame"><input type="text" value="'+item.sUrlFormulaire+'"/></td>'+
                '</tr>'+
                '<tr>'+
                    '<td class="label">URL Form treatment :</td>'+
                    '<td class="frame"><input type="text" value="'+item.sUrlTraitement+'"/></td>'+
                '</tr>'+
                '<tr>'+
                    '<td class="label">Description :</td>'+
                    '<td class="frame"><textarea style="width:200px">'+item.sCommentaire+'</textarea></td>'+
                '</tr>'+
                '</table>';
    
    var modal = new Modal(title, sHTML);
    var inputs = modal.content.getElementsByTagName("input");
    var texts = modal.content.getElementsByTagName("textarea");
    
    modal.onValidate = function() {
        var itemStore = item;
        itemStore.sLibelle = inputs[0].value;
        itemStore.sIdUseCase = inputs[1].value;
        itemStore.sUrlFormulaire = inputs[2].value;
        itemStore.sUrlTraitement = inputs[3].value;
        itemStore.sCommentaire = texts[0].value;
        
        Etape.storeFromJSONString(Object.toJSON(itemStore),function(result){
            itemStore.lId = result;
            if(!isNew)
               storeStep(itemStore,itemPhase,node);
            else
               addStep(itemStore,itemPhase,node);
        });
    }
}
function storeStep(item,itemPhase,node){ 
    storePhase(itemPhase,node);
}
function addStep(item,itemPhase,node){
    itemPhase.etapes.push(item);
    storePhase(itemPhase,node);
}
function deleteStep(itemEtape,itemPhase,node){
    var indexEtape = itemPhase.etapes.find(function(item, indexE){
        item.indexE = indexE;
        return (item.lId==itemEtape.lId);
    }).indexE;
    itemPhase.etapes.splice(indexEtape,1);
    storePhase(itemPhase,node);
}

var condition_dg;
var condition_list = <%= jsonConditions %>;
function populateConditionDG() {		
    var imgAddCond = document.createElement("img");
    imgAddCond.className = "pointer";
    imgAddCond.src = rootPath+"images/icons/plus.gif";
    imgAddCond.title = "Add condition";
    imgAddCond.onclick = function() {
        displayCondition("new condition");
    }

    condition_dg.addRemoveOption(imgAddCond);
    condition_dg.addStyle("width", "100%");
    condition_dg.setColumnStyle(2, {width:"16px"});
	condition_dg.setHeader(['Id', 'Name','Class','']);
	condition_list.each(function(item){
	    var img = document.createElement("img");
	    img.className = "pointer";
	    img.src = rootPath+"images/icons/application_edit.gif";
	    img.title = "Edit";
	    img.onclick = function(){
	        displayCondition(item.sLibelle,item,lineData);
	    }
		var lineData = condition_dg.addItem([item.lId, item.sLibelle,item.sConditionClass, img]);
		lineData.node.id = item.lId;
	});
	condition_dg.render();
	
}
function displayCondition(title, item, node) {
    var isNew = false;
    if(!isNotNull(item)){
        isNew = true;
        item = new Object();
        item.sLibelle = "";
        item.sConditionClass = "";
    }
    var sHTML = '<table class="formLayout" cellspacing="3">'+
                '<tr>'+
                    '<td class="label">Name :</td>'+
                    '<td class="frame"><input type="text" value="'+item.sLibelle+'"/></td>'+
                '</tr>'+
                '<tr>'+
                    '<td class="label">Class :</td>'+
                    '<td class="frame"><input type="text" value="'+item.sConditionClass+'"/></td>'+
                '</tr>'+
                '</table>';
    
    var modal = new Modal(title, sHTML);
    var inputs = modal.content.getElementsByTagName("input");
    
    modal.onValidate = function() {
        var itemStore = item;
        itemStore.sLibelle = inputs[0].value;
        itemStore.sConditionClass = inputs[1].value;
        
        Condition.storeFromJSONString(Object.toJSON(itemStore),function(result){
            itemStore.lId = result;
            if(!isNew && isNotNull(node))
               storeCondition(itemStore,node);
            else
               addCondition(itemStore);
        });
    }
}
function storeCondition(item,node){ 
    node.cells[1].innerHTML = item.sLibelle;
    node.cells[2].innerHTML = item.sConditionClass;
}
function addCondition(item){
    var img = document.createElement("img");
    img.className = "pointer";
    img.src = rootPath+"images/icons/application_edit.gif";
    img.title = "Edit";
    img.onclick = function(){
        displayCondition(item.sLibelle,item,lineData);
    }
    var lineData = condition_dg.addItem([item.lId,item.sLibelle,item.sConditionClass, img]);
    lineData.node.id = item.lId;
    condition_list.push(item);
}

var jsonProc = <%= jsonProc %>;
function displayProcess(){
    var div = $("process");
    div.innerHTML = "";
    var table = document.createElement("table");
    table.className ="formLayout";
    table.cellSpacing = "3";
    var grid = document.createElement("tbody");
    
    var trName = document.createElement("tr");
    var tdName = document.createElement("td");
    tdName.className = "label";
    tdName.innerHTML = "Name :";
    trName.appendChild(tdName);
    var tdNameValue = document.createElement("td");
    tdNameValue.className = "frame";
    var inputName = document.createElement("input");
    inputName.type = "text";
    inputName.id = "process_name";
    inputName.value = jsonProc.sLibelle;
    inputName.size = "70";
    tdNameValue.appendChild(inputName);
    trName.appendChild(tdNameValue);
    grid.appendChild(trName);
    
    var trCom = document.createElement("tr");
    var tdCom = document.createElement("td");
    tdCom.className = "label";
    tdCom.innerHTML = "Description :";
    trCom.appendChild(tdCom);
    var tdComValue = document.createElement("td");
    tdComValue.className = "frame";
    var inputCom = document.createElement("input");
    inputCom.id = "process_com";
    inputCom.type = "text";
    inputCom.value = jsonProc.sCommentaire;
    inputCom.size = "70";
    tdComValue.appendChild(inputCom);
    trCom.appendChild(tdComValue);
    grid.appendChild(trCom);
    
    jsonProc.phases.each(function(phase,indexPhase){
        var trPhase = document.createElement("tr");
	    var tdPhase = document.createElement("td");
	    tdPhase.className = "label";
	    tdPhase.innerHTML = "Phase : "+phase.sLibelle;
	    var img = document.createElement("img");
	    img.className = "pointer";
	    img.style.marginLeft = "5px";
	    img.style.verticalAlign = "bottom";
	    img.src = rootPath+"images/icons/application_edit.gif";
	    img.title = "Select Step";
	    img.onclick = function(){
	        addProcessStep(phase);
	    }
	    var imgDeletePhase = document.createElement("img");
        imgDeletePhase.className = "pointer";
        imgDeletePhase.src = rootPath+"images/icons/cross.gif";
        imgDeletePhase.title = "Delete";
        imgDeletePhase.style.verticalAlign = "bottom";
        imgDeletePhase.style.marginLeft = "5px";
        imgDeletePhase.onclick = function(){
            if(confirm("Do you want to delete this phase ?" )){
               removeProcessPhase(phase);
            }
        }
	    tdPhase.appendChild(img);
	    tdPhase.appendChild(imgDeletePhase);
	    trPhase.appendChild(tdPhase);
	    var tdStep = document.createElement("td");
	    tdStep.className = "frame";
	    if(phase.etapes){
	        phase.etapes.each(function(step){
	            tdStep.innerHTML += "Step : "+step.sLibelle+"<br/>";
	        });
	    }
	    trPhase.appendChild(tdStep);
	    grid.appendChild(trPhase);
	    
	    if(indexPhase < jsonProc.phases.length-1){
		    var trCond = document.createElement("tr");
	        var tdCond = document.createElement("td");
	        tdCond.className = "label";
	        tdCond.innerHTML = "Transition's condition : ";
	        var imgAddCond = document.createElement("img");
		    imgAddCond.className = "pointer";
		    imgAddCond.src = rootPath+"images/icons/plus.gif";
		    imgAddCond.style.verticalAlign = "bottom";
		    imgAddCond.title = "Add condition";
		    imgAddCond.onclick = function() {
		        addProcessCondition(phase);
		    }
		    tdCond.appendChild(imgAddCond);
	        trCond.appendChild(tdCond);
	        var tdCondValue = document.createElement("td");
	        tdCondValue.className = "frame";
	        if(phase.conditions){
		        phase.conditions.each(function(condition){
		            var div = document.createElement("div");
		            var imgDelete = document.createElement("img");
			        imgDelete.className = "pointer";
			        imgDelete.src = rootPath+"images/icons/cross.gif";
			        imgDelete.title = "Delete";
			        imgDelete.style.verticalAlign = "bottom";
			        imgDelete.style.marginLeft = "5px";
			        imgDelete.onclick = function(){
			            if(confirm("Do you want to delete this condition ?" )){
			               removeProcessCondition(phase,condition);
			            }
			        }
			        var span = document.createElement("span");
		            span.innerHTML = condition.sLibelle;
		            div.appendChild(span);
		            div.appendChild(imgDelete);
		            tdCondValue.appendChild(div);
		        });
		    }
	        trCond.appendChild(tdCondValue);
	        grid.appendChild(trCond);
        }
    });
    
    table.appendChild(grid);
    div.appendChild(table);
}
function addProcessPhase(){
    if(jsonProc.lId > 0){
	    var sHTML = '<table class="formLayout" cellspacing="3">'+
	                '<tr>'+
	                    '<td class="label">Phase :</td>'+
	                     '<td class="frame"><select><option>Chargement...</option></select></td>'+
	                '</tr>'+
	                '<tr>'+
	                    '<td class="label">Position :</td>'+
	                     '<td class="frame"><select><option>Chargement...</option></select></td>'+
	                '</tr>'+
	                '</table>';
	    
	    var modal = new Modal("Add Process Phase", sHTML);
	    var selects = modal.content.getElementsByTagName("select");
	    
	    var selectPhase = selects[0];
	    mt.html.setSuperCombo(selectPhase);
	    selectPhase.populate(phase_list,0,"lId","sLibelle");
	    
	    var selectPhasePosition = selects[1];
	    mt.html.setSuperCombo(selectPhasePosition);
	    var first = new Object();
	    first.lIdPhaseTransitionBefore = 0;
	    first.sLibelleSelect = "In First";
	    var phases = new Array();
	    phases.push(first);
	    jsonProc.phases.each(function(item){
	        item.sLibelleSelect = "After "+item.sLibelle;
	        phases.push(item);
	    });
	    selectPhasePosition.populate(phases,0,"lIdPhaseTransitionBefore","sLibelleSelect");
	    
	    modal.onValidate = function() {
	        var lIdPhaseTransitionBefore = selectPhasePosition.value;
	        var indexPhase = selectPhasePosition.selectedIndex;
	        var lIdPhase = selectPhase.value;
	        var selectPhaseItem = phase_list.find(function(item){return item.lId == lIdPhase;});
	
	        var addPhase = new Object();
	        addPhase.lId = selectPhaseItem.lId;
	        addPhase.sLibelle = selectPhaseItem.sLibelle;
	        addPhase.etapes = selectPhaseItem.etapes;
	
	        Procedure.addPhase(jsonProc.lId, addPhase.lId, lIdPhaseTransitionBefore,function(result){
	            jsonProc = result.evalJSON();
	            /*
	            var resultPhase = result.evalJSON();
	            addPhase.lIdPhaseTransitionAfter = resultPhase.lIdPhaseTransitionAfter;
	            addPhase.lIdPhaseTransitionBefore = resultPhase.lIdPhaseTransitionBefore;
	            addPhase.lIdPhaseProcedure = resultPhase.lIdPhaseProcedure;
	            jsonProc.phases.splice(indexPhase,0,addPhase);
	            
	            if(indexPhase-1 >= 0){
	                var phaseBefore = jsonProc.phases[indexPhase-1];
	                phaseBefore.lIdPhaseTransitionAfter = addPhase.lIdPhaseTransitionBefore;
	            }
	            if(indexPhase+1 < jsonProc.phases.length){
	                var phaseAfter = jsonProc.phases[indexPhase+1];
	                phaseBefore.lIdPhaseTransitionBefore = addPhase.lIdPhaseTransitionAfter;
	            }
	            */
	            displayProcess();
	        });
	        
	    }
    }else{
        openGlobalException("You have to store the process before adding phase",null);
    }
}

function removeProcessPhase(phase){
    var indexPhase;
    jsonProc.phases.each(function(item,index){
        if(item.lId == phase.lId){
            indexPhase = index;
        }
    });
    Procedure.removePhase(jsonProc.lId, phase.lIdPhaseProcedure, function(result){
        jsonProc.phases.splice(indexPhase,1);
        displayProcess();
    });
}

function addProcessCondition(phase){
    var sHTML = '<table class="formLayout" cellspacing="3">'+
                '<tr>'+
                    '<td class="label">Condition :</td>'+
                     '<td class="frame"><select><option>Chargement...</option></select></td>'+
                '</tr>'+
                '</table>';
    
    var modal = new Modal("Add Process Condition", sHTML);
    var selects = modal.content.getElementsByTagName("select");
    
    var selectCond = selects[0];
    mt.html.setSuperCombo(selectCond);
    selectCond.populate(condition_list,0,"lId","sLibelle");
    
    modal.onValidate = function() {
        var lIdCond = selectCond.value;
        var selectCondItem = condition_list.find(function(item){return item.lId == lIdCond;});
 
        jsonProc.phases.each(function(item){
            if(item.lId == phase.lId){
                if(!item.conditions)
                    item.conditions = new Array();
                    
                var addCond = new Object();
		        addCond.lId = selectCondItem.lId;
		        addCond.sLibelle = selectCondItem.sLibelle;
		        
		        Procedure.addCondition(addCond.lId,item.lIdPhaseTransitionAfter, function(result){
                    item.conditions.splice(item.conditions.length,0,addCond);
                    displayProcess();
                });
            }
        });
    }
}

function removeProcessCondition(phase,condition){
    jsonProc.phases.each(function(item){
        if(item.lId == phase.lId){
            var indexCond;
		    item.conditions.each(function(cond,index){
		       if(cond.lId == condition.lId){
		           indexCond = index;
		       }
		    });
		    Procedure.removeCondition(condition.lId,phase.lIdPhaseTransitionAfter, function(result){
                 item.conditions.splice(indexCond,1);
                 displayProcess();
            });
		}
    });
}

function addProcessStep(phase){
    var div = document.createElement("div");
    var ul = document.createElement("ul");
    ul.id = "ul_step";
    ul.className = "sortablelist";
    phase.etapes.each(function(step,index){
        var li = document.createElement("li");
        li.style.width = "200px";
        li.className = "list_neutral";
        li.id = step.lId;
        var cbSelect = document.createElement("input");
        cbSelect.type = "checkbox";
        cbSelect.checked = true;
        cbSelect.style.marginRight = "5px";
        li.appendChild(cbSelect); 
        var span = document.createElement("span");
        span.innerHTML = step.sLibelle;
        li.appendChild(span);
        ul.appendChild(li);
    });
    
    var completePhase =  phase_list.find(function(item){return item.lId == phase.lId;});
    completePhase.etapes.each(function(step,index){
        var selectStep =  phase.etapes.find(function(item){return item.lId == step.lId;});
        if(!isNotNull(selectStep)){
	        var li = document.createElement("li");
	        li.style.width = "200px";
	        li.className = "list_neutral";
	        li.id = step.lId;
	        var cbSelect = document.createElement("input");
	        cbSelect.type = "checkbox";
            cbSelect.checked = false;
	        cbSelect.style.marginRight = "5px";
	        li.appendChild(cbSelect); 
	        var span = document.createElement("span");
	        span.innerHTML = step.sLibelle;
	        li.appendChild(span);
	        ul.appendChild(li);
	    }
    });
    div.appendChild(ul);
    
    var modal = new Modal("Select Process Step", div);
    var sortable = Sortable.create("ul_step", {dropOnEmpty:true});
    
    modal.onValidate = function() {
        jsonProc.phases.each(function(item){
            if(item.lId == phase.lId){
                item.etapes = new Array();
                var lis = $A($("ul_step").getElementsByTagName("li"));
		        lis.each(function(li){
		            var stepChecked = li.getElementsByTagName("input")[0].checked;
		            if(stepChecked){
		              var step =  completePhase.etapes.find(function(etape){return etape.lId == li.id;});
		              item.etapes.push(step);
		            }
		        });
		        
		        Procedure.storePhase(jsonProc.lId, item.lIdPhaseProcedure,Object.toJSON(item.etapes),function(result){
		            displayProcess();
		        });
            }
        });
    }
}

function synchroProcess(){
    jsonProc.sLibelle = $("process_name").value;
    jsonProc.sCommentaire = $("process_com").value;
    var div = $("process");
    div.innerHTML = "Enregistrement en cours...";
    Procedure.storeFromJSONString(Object.toJSON(jsonProc),function(result){
        jsonProc = result.evalJSON();
        displayProcess();
    });
}

onPageLoad = function() {

	phase_dg = new mt.component.DataGrid('phase_dg');
	populatePhaseDG();
	phase_dg.onBeforeRemove = function(index) 
    {
        if(confirm("Do you want to delete this phase ?" )){
            var id = phase_dg.dataSet[index].node.id;
            Phase.removeFromId(id, function() { 
                   var indexPhase = phase_list.find(function(item, indexP){
                       item.indexP = indexP;
                       return (item.lId==id);
                   }).indexP;
                   phase_list.splice(indexPhase,1);
                   phase_dg.removeItem(index);
               });
        }
        return false;
    }
	
	condition_dg = new mt.component.DataGrid('condition_dg');
	populateConditionDG();
	condition_dg.onBeforeRemove = function(index) 
    {
        if(confirm("Do you want to delete this condition ?" )){
            var id = condition_dg.dataSet[index].node.id;
            Condition.removeFromId(id, function() { 
                   var indexCond = condition_list.find(function(item, indexC){
                       item.indexC = indexC;
                       return (item.lId==id);
                   }).indexC;
                   condition_list.splice(indexCond,1);
                   condition_dg.removeItem(index);
               });
        }
        return false;
    }
    
    displayProcess();
	
	$('saveData_btn').onclick = function() {
		synchroProcess();
	}
	
}
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">	
	
	<table class="fullWidth" cellpadding="0" ><tr>
		<td class="top">
			<div class="sectionTitle" style="margin-top:0">
			 <div>Procédure&nbsp;&nbsp;
			 <img src="<%=rootPath+"images/icons/plus.gif" %>"
			 title="Add Process Phase"
			 class="pointer"
			 style="vertical-align:bottom"
			 onclick="addProcessPhase()" /></div>
			</div>
			<div class="sectionFrame" id="process">Chargement...</div>
		</td>
		<td style="width:25px"></td>
		<td class="top" style="width:40%">
			<div class="sectionTitle" style="margin-top:0"><div>Phases disponibles</div></div>
			<div class="sectionFrame">
				<div id="phase_dg">Chargement...</div>
			</div>
			<div class="sectionTitle" style="margin-top:0"><div>Conditions disponibles</div></div>
			<div class="sectionFrame">
				<div id="condition_dg">Chargement...</div>
			</div>
		</td>
	</tr></table>

</div> <!-- end fiche -->
<div id="fiche_footer">
	<button id="saveData_btn">Enregistrer</button>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
</html>