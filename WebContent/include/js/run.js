

/**
 *  
 * TO_REMOVE : var $C = document.getElementsByClassName;
 * 
 *  BAD:  var tabFrames = $C("tabFrame", document.body);
	GOOD: var tabFrames =  document.body.getElementsByClassName('tabFrame');
	NEW ONE ALSO GOOD var tabFrames =  mt_getElementsByClassName('tabFrame', document.body.);
	
	http://www.prototypejs.org/api/element/getElementsByClassName => deprecated 
*/

/** global variable */
var g_globalModalContentDivOpened = null;

function mt_getElementsByClassName(classname, node)  {
    if(!node) node = document.getElementsByTagName("body")[0];
    var a = [];
    var re = new RegExp('\\b' + classname + '\\b');
    var els = node.getElementsByTagName("*");
    for(var i=0,j=els.length; i<j; i++)
        if(re.test(els[i].className))a.push(els[i]);
    return a;
}

/** MODAL */
function Modal(title, mainContent) {
	var self = this;
	
	this.display = function() {
		try{Element.remove($('modal'))} catch(e){}
		this.divModal = document.createElement("form");
		this.divModal.action = "";
		this.divModal.style.zIndex = 10;
		this.divModal.id = "modal";
		var frame = document.createElement("div");
		frame.className = "modalFrame";
		var frame2 = document.createElement("div");
		frame2.className = "modalFrame2";
		var header = document.createElement("div");
		header.className = "header";
		header.innerHTML = title;
		this.content = document.createElement("div");
		this.content.className = "content";
		if(typeof(mainContent) == "string")
		  this.content.innerHTML = mainContent;
		else
		  this.content.appendChild(mainContent);

		var divButtons = document.createElement("div");
		divButtons.className = "buttons";

		var btnCancel = document.createElement("button");
		btnCancel.setAttribute("type", "button"); // for IE
		btnCancel.innerHTML = "Annuler";
		btnCancel.onclick = function() {
			self.remove();
		}

		var btnValidate = document.createElement("button");
		btnValidate.setAttribute("type", "submit"); // for IE
		btnValidate.innerHTML = "Valider";
		
		function submit() {
			self.onValidate();
			self.remove();
			return false;
		}
		
		this.divModal.onsubmit = btnValidate.onclick = submit;

		divButtons.appendChild(btnValidate);
		divButtons.appendChild(btnCancel);
	
		frame2.appendChild(header);
		frame2.appendChild(this.content);
		frame2.appendChild(divButtons);
		frame.appendChild(frame2);
		this.divModal.appendChild(frame);
		this.divModal.style.top = document.documentElement.scrollTop+150+"px";
		document.body.appendChild(this.divModal);
		this.divModal.style.left = ((document.documentElement.offsetWidth/2)-(this.divModal.offsetWidth/2))+"px";
	}
	
	this.onValidate = function(){};
	
	this.remove = function() {
		Element.remove(this.divModal);
	}
	
	this.display();
}

function openModal(link,title,width,height){
    var modal, div;
    
    if(g_globalModalContentDivOpened != null) {
    	g_globalModalContentDivOpened.innerHTML = "";
    }
    try{
    	if(parent.g_globalModalContentDivOpened != null) {
        	parent.g_globalModalContentDivOpened.innerHTML = "";
        }
    }catch(e){}

    try{div = this.createModal(link,title,width,height,parent.document);}
    catch(e){div = this.createModal(link,title,width,height,document);}
    g_globalModalContentDivOpened = div;
    try{parent.g_globalModalContentDivOpened = div;}catch(e){}
    
    try {modal = new parent.Control.Modal(false,{contents: div});}
    catch(e) {modal = new Control.Modal(false,{contents: div});}

    modal.container.insert(div);
    modal.open();
}

function createModal(link,title,width,height,doc){
    
    var modal_princ = doc.createElement("div");
    modal_princ.className = "modal_principal";
    
    var divControls = doc.createElement("div");
    divControls.className = "modal_controls";
    
    var divTitle = doc.createElement("div");
    divTitle.className = "modal_title";
    divTitle.innerHTML = title;
    
    var img = doc.createElement("img");
    img.style.position = "absolute";
    img.style.top = "3px";
    img.style.right = "3px";
    img.style.cursor = "pointer";
    img.src = this.rootPath+"images/icons/close.gif";
    img.onclick = function(){
        closeModal();
    }
    
    divControls.appendChild(divTitle);
    divControls.appendChild(img);
    
    var divFrame = doc.createElement("div");
    divFrame.className = "modal_frame_principal";
    
    var divContent = doc.createElement("div");
    divContent.className = "modal_frame_content";
    
    var iframe = doc.createElement("iframe");
    iframe.name = "modalPopup";
    iframe.id = "modalPopup";
    iframe.src = link;
    iframe.style.width = (width)?width:"700px";
    iframe.style.height = (height)?height:"500px";
    iframe.style.border = 0;
    iframe.style.margin = 0;
    iframe.align = "top";
    iframe.frameborder = "0";
    iframe.border = "0";
    
    divContent.appendChild(iframe);
    divFrame.appendChild(divContent);
    
    modal_princ.appendChild(divControls);
    modal_princ.appendChild(divFrame);
    
    return modal_princ;
}
function closeModal(){
    try {new parent.Control.Modal.close();}
    catch(e) { Control.Modal.close();}
}

function openGlobalLoader(){
    var modal, div ;
    
    if(g_globalModalContentDivOpened != null) {
    	g_globalModalContentDivOpened.innerHTML = "";
    }
    try{
    	if(parent.g_globalModalContentDivOpened != null) {
        	parent.g_globalModalContentDivOpened.innerHTML = "";
        }
    }catch(e){}

    try{div = createLoaderModal(parent.document);}
    catch(e){div = createLoaderModal(document);}
    g_globalModalContentDivOpened = div;
    try{parent.g_globalModalContentDivOpened = div;}catch(e){}
    
    try {modal = new parent.Control.Modal(false,{contents: div, overlayCloseOnClick:true});}
    catch(e) {modal = new Control.Modal(false,{contents: div, overlayCloseOnClick:true});}
    
    modal.container.insert(div);
    modal.open();
}
function closeGlobalLoader(){
    closeModal();
}

function createLoaderModal(doc){
    
    var modal_princ = doc.createElement("div");
    modal_princ.className = "modal_principal";
    
    var sHTML = '<table class="formLayout" cellspacing="3">'+
                '<tr>'+
                    '<td class="label">loading</td>'+
                    '<td class="value"><div class="loader">&nbsp;</div></td>'+
                '</tr>'+
                '</table>';
    modal_princ.innerHTML = sHTML;
    
    return modal_princ;
}


function openGlobalException(errorString, exception, title){
    var modal, div ;
    
    if(g_globalModalContentDivOpened != null) {
    	g_globalModalContentDivOpened.innerHTML = "";
    }
    try{
    	if(parent.g_globalModalContentDivOpened != null) {
        	parent.g_globalModalContentDivOpened.innerHTML = "";
        }
    }catch(e){}
    
    try{div = createExceptionModal(parent.document,errorString, exception, title);}
    catch(e){div = createExceptionModal(document,errorString, exception, title);}
    g_globalModalContentDivOpened = div;
    try{parent.g_globalModalContentDivOpened = div;}catch(e){}
    
    try {modal = new parent.Control.Modal(false,{contents: div});}
    catch(e) {modal = new Control.Modal(false,{contents: div});}
    
    modal.container.insert(div);
    modal.open();
}

function createExceptionModal(doc, errorString, exception, title){
    
    var modal_princ = doc.createElement("div");
    modal_princ.className = "modal_principal";

    var exceptionClassName = "";
    var msjTitle = title;
    try{exceptionClassName = exception.javaClassName;}
    catch(e){}
    
    if(exceptionClassName == "org.coin.security.SessionException"){
        window.location.reload();
    }
    
    msjTitle = MESSAGE_TITLE[1];
    if(exceptionClassName == "org.coin.db.CoinDatabaseRemoveException"){
    	msjTitle = MESSAGE_TITLE[2];
    }
    
    var errorTitle = isNotNull(title)?title:msjTitle;
    var sHTML = '<table class="formLayout"><tr><td>'+
                 '<div class="box" >'+
                     '<div class="boxTitle"><div>'+errorTitle+'</div></div>'+
                     '<div class="boxContent">'+
                         errorString
                     '</div>'+
                 '</div>'+
                '</td></tr></table>';
    modal_princ.innerHTML = sHTML;
    modal_princ.onclick = function(){
    	closeGlobalException();
    }
    return modal_princ;
}

function closeGlobalException(){
    closeModal();
}

function openGlobalConfirm(
		title, 
		content, 
		acceptTitle, 
		acceptCallback, 
		refuseTitle, 
		refuseCallback, 
		addTitle, 
		addCallback)
{
    var modal, div ;
    
    if(g_globalModalContentDivOpened != null) {
    	g_globalModalContentDivOpened.innerHTML = "";
    }
    try{
    	if(parent.g_globalModalContentDivOpened != null) {
        	parent.g_globalModalContentDivOpened.innerHTML = "";
        }
    }catch(e){}
    	
    try{div = createConfirmModal(parent.document,title, content, acceptTitle, acceptCallback, refuseTitle, refuseCallback, addTitle, addCallback);}
    catch(e){div = createConfirmModal(document,title, content, acceptTitle, acceptCallback, refuseTitle, refuseCallback, addTitle, addCallback);}
    g_globalModalContentDivOpened = div;
    try{parent.g_globalModalContentDivOpened = div;}catch(e){}
    
    try {modal = new parent.Control.Modal(false,{contents: div});}
    catch(e) {modal = new Control.Modal(false,{contents: div});}
    
    /*
    var scripts = div.getElementsByTagName("script");
    $A(scripts).each(function(item){alert(item.innerHTML);eval(item.innerHTML);});
    */    
    modal.container.insert(div);
    modal.open();
    
}
function createConfirmModal(
		doc, 
		title, 
		content, 
		acceptTitle, 
		acceptCallback, 
		refuseTitle, 
		refuseCallback, 
		addTitle, 
		addCallback)
{
    var modal_princ = doc.createElement("div");
    modal_princ.className = "modal_principal";
    
    var table = doc.createElement("TABLE");
    table.className = "formLayout";
    var tbody = doc.createElement("TBODY");
    var tr = doc.createElement("tr");
    var td = doc.createElement("td");
    var divBox = doc.createElement("div");
    divBox.className = "box";
    
    var divBoxTitle = doc.createElement("div");
    divBoxTitle.className = "boxTitle";
    var divBoxTitle2 = doc.createElement("div");
    divBoxTitle2.innerHTML = title;
    divBoxTitle.appendChild(divBoxTitle2);
    
    var divBoxContent = doc.createElement("div");
    divBoxContent.className = "boxContent";
    divBoxContent.innerHTML = content;
    
    var divBoxButton = doc.createElement("div");
    divBoxButton.className = "center";
    divBoxButton.style.marginTop = "10px";
    if(isNotNull(acceptTitle)){
	    var buttonAccept = doc.createElement("button");
	    buttonAccept.setAttribute("type", "button");
	    buttonAccept.innerHTML = acceptTitle;
	    buttonAccept.onclick = acceptCallback;
	    divBoxButton.appendChild(buttonAccept);
	}
	if(isNotNull(addTitle)){
	    var buttonAdd = doc.createElement("button");
	    buttonAdd.setAttribute("type", "button");
	    buttonAdd.innerHTML = addTitle;
	    buttonAdd.onclick = addCallback;
	    divBoxButton.appendChild(buttonAdd);
	}
	if(isNotNull(refuseTitle)){
	    var buttonRefuse = doc.createElement("button");
	    buttonRefuse.setAttribute("type", "button");
	    buttonRefuse.innerHTML = refuseTitle;
	    buttonRefuse.onclick = refuseCallback;
	    divBoxButton.appendChild(buttonRefuse);
	}
    divBoxContent.appendChild(divBoxButton);
    
    divBox.appendChild(divBoxTitle);
    divBox.appendChild(divBoxContent);
    
    td.appendChild(divBox);
    tr.appendChild(td);
    tbody.appendChild(tr);
    table.appendChild(tbody);
    modal_princ.appendChild(table);

    /**
     * hum what is this ... alone ?
     */
    //divBoxContent
    
    return modal_princ;
}

function closeGlobalConfirm(){
    closeModal();
}
/** /MODAL */

function trace(str, sideNum) {
	if (debugMode=="enabled")
		traceType("text", str, sideNum);
}
function traceXML(xmlStr, sideNum) {
	if (debugMode=="enabled")
		traceType("xml", xmlStr, sideNum);
}

function traceType(type, xmlStr, sideNum) {
	var traceStr = (type=="xml") ? getXmlTraceString(xmlStr) : xmlStr.escapeHTML();
	var debugTable = $('debug_trace_table');
	if (debugTable) {
		var tds = debugTable.getElementsByTagName("td");
		if (sideNum==1 || !sideNum) {
			tds[0].innerHTML = traceStr;
		} else {
			tds[1].innerHTML = traceStr;
		}
	} else {
		var table = document.createElement("TABLE");
		table.id = "debug_trace_table";
		table.className = "fullWidth";
		table.style.marginTop = "20px";
		table.style.color = "#262675";
		var tbody = document.createElement("TBODY");
		var tr = document.createElement("tr");
		var td1 = document.createElement("td");
		td1.className = "top";
		td1.style.width = "50%";
		var td2 = document.createElement("td");
		td2.className = "top";
		td2.style.width = "50%";
		if (sideNum==1 || !sideNum) {
			td1.innerHTML = traceStr;
		} else {
			td2.innerHTML = traceStr;
		}
		tr.appendChild(td1);
		tr.appendChild(td2);
		tbody.appendChild(tr);
		table.appendChild(tbody);
		document.body.appendChild(table);
	}
}

function getXmlTraceString(sXml) {
	var xmlDoc = getXMLFromString(sXml);
	var root = xmlDoc.documentElement;
	if (root.nodeName == "parsererror") return sXml.escapeHTML();
	
	function traceNode(node, strOffset) {
		var atts = [];
		for (z=0; z<node.attributes.length; z++) {
			atts.push(node.attributes[z].name+'="'+node.attributes[z].value+'"');
		}
		strAtts = (atts.length>0) ? " "+atts.join(" ") : "";
		var ret = (strOffset.length==0) ? "" : "<br/>";
		var str = ret+strOffset+('<'+node.nodeName+strAtts+'>').escapeHTML();
		var hasChilds = false;
		for (var z=0; z<node.childNodes.length; z++) {
			var n = node.childNodes[z];
			if (n.nodeType==1) {
				hasChilds = true;
				str += traceNode(n, strOffset+"....");
			} else if (n.nodeType==3) {
				if (n.nodeValue!="\n")
					str += n.nodeValue;
			}
		}
		if (hasChilds) str += "<br/>"+strOffset;
		str += ('</'+node.nodeName+'>').escapeHTML();
		return str;
	}
	
	return traceNode(root, "");
}

function getXMLFromString(str) {
	try {
		var xmlParser = new DOMParser();
		var xmlDocument = xmlParser.parseFromString(str, 'text/xml');
	}
	catch(err) {
		var xmlDocument = new ActiveXObject('Microsoft.XMLDOM');
		xmlDocument.async = false;
		xmlDocument.loadXML(str);
	}
	return xmlDocument;
}

function getStringFromXML(node) {
	try {
		var str = new XMLSerializer().serializeToString(node);
	}
	catch(err) {
		var str = node.xml;
	}
	return str;
}

	


Function.prototype.method = function (name, func) {
    this.prototype[name] = func;
    return this;
};
Function.method('inherits', function (parent) {
    var d = 0, p = (this.prototype = new parent());
    /* check http://www.crockford.com/javascript/inheritance.html */
    /*this.method('uber', function uber(name) {
        var f, r, t = d, v = parent.prototype;
        if (t) {
            while (t) {
                v = v.constructor.prototype;
                t -= 1;
            }
            f = v[name];
        } else {
            f = p[name];
            if (f == this[name]) {
                f = v[name];
            }
        }
        d += 1;
        r = f.apply(this, Array.prototype.slice.apply(arguments, [1]));
        d -= 1;
        return r;
    });*/
    return this;
});

var modulaBaseClass = function() {

	this.buildXml = function(nodeName, xmlStr) {
		var sXml = '<'+nodeName+((this.bRemove)?' action="remove"':'')+'>'+'<id>'+this.lId+'</id>';
		if (!this.bRemove) sXml += xmlStr;
		sXml += '</'+nodeName+'>';
		return sXml;
	}

	this.getClassArraySerialization = function(nodeName, array) {
		var sXml = '<'+nodeName+'>';
		array.each(function(item){sXml += item.serialize();});
		return sXml+'</'+nodeName+'>';
	}
	
	this.getClassArrayDeserialization = function(parentNode, nodeName, className) {
		var items = [];
		if (parentNode) {
			var nodes = parentNode.getElementsByTagName(nodeName);
			for (var z=0; z<nodes.length; z++) {
				var item = new className();
				item.deserialize(nodes[z]);
				items.push(item);
			}
		}
		return items;
	}
   
}

function RegisterNamespaces(){
    for (var i=0;i<arguments.length;i++){
        var astrParts = arguments[i].split(".")
        var root = window;
        for (var j=0; j < astrParts.length; j++){
            if (!root[astrParts[j]]){
                root[astrParts[j]] = new Object();
            }
            root = root[astrParts[j]];
        }
    }
}

String.prototype.parseJSON = function () {
    try {
        return !(/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(
                this.replace(/"(\\.|[^"\\])*"/g, ''))) &&
            eval('(' + this + ')');
    } catch (e) {
        return false;
    }
};

function requireClass() {
	var classURL = rootPath + "include/class/";
	function loadScript(className) {
		var splits = className.split(".");
		var name = (splits.length==1) ? (className+".js") : ("/"+splits[splits.length-1]+".js");
		splits.pop();
		var path = splits.join(".");
		RegisterNamespaces(path);
		require(classURL+path+name);		
	}
	for (var i=0; i<arguments.length; i++) {
		try {
			if (!eval(arguments[i])) loadScript(arguments[i]);
		}
		catch(e) {
			loadScript(arguments[i]);
		}
	}
}

function require() {
	for (var i=0; i<arguments.length; i++) {
		try {
			document.write("<scr"+"ipt type='text/javascript' src='"+arguments[i]+"'></scr"+"ipt>");
		} catch (e) {
			var script = document.createElement("script");
			script.src = arguments[i];
			document.getElementsByTagName("head")[0].appendChild(script);
		}
	}
}

function requireHead() {
    for (var i=0; i<arguments.length; i++) {
        var script = document.createElement("script");
        script.src = arguments[i];
        document.getElementsByTagName("head")[0].appendChild(script);
    }
}
function requireHeadCSS() {
    for (var i=0; i<arguments.length; i++) {
        var link = document.createElement("link");
        link.rel = "stylesheet";
        link.type = "text/css";
        link.href = arguments[i];
        link.media="screen";
        document.getElementsByTagName("head")[0].appendChild(link);
    }
}
function onTabDoubleClick(index, id) {}
function onTabChange(index, id) {
    if(mt.config.enableTabsContextButton){
        onTabChangeContextButton(index);
    }
    if(mt.config.enableTabsContextDiv){
        onTabChangeContextDiv(index);
    }
    onTabChangeAddAction(index,id);
}
function onTabChangeAddAction(index, id) {};

function onTabChangeContextButton(index) {
    $$("#fiche_footer button ").each(function(item){
        if(Element.hasClassName(item,'tab_button_index_'+index)){
            item.removeClassName("hide");
        }else{
            item.addClassName("hide");
        }
    });
}
function onTabChangeContextDiv(index) {
    $$("#fiche_footer div ").each(function(item){
        if(Element.hasClassName(item,'tab_div_index_'+index)){
            item.removeClassName("hide");
        }else{
            item.addClassName("hide");
        }
    });
}

var mt = {
	config:{
		enableTabs:false,
		limitTabsTitle:false,
		limitTabsTitleLength:20,
		enableTabsContextButton:false,
		enableTabsContextDiv:false,
		enableSuperCombos:false,
		enableAutoRoundPave:true,
		enableAutoLoading:true,
		enableDateFieldAuto:true,
		enableTabTitle:true,
		
		disableAutoLoading:function(){
		  dwr.engine.setPreHook(function() {
		    
		  });
		  dwr.engine.setPostHook(function() {
		    
		  });
		}
	},
	localization:{
        localizeObject:function(iIdLanguage,iIdCaptionCategory) {
            this.iIdLanguage = iIdLanguage;
            this.iIdCaptionCategory = iIdCaptionCategory;
            
	        this.getValue = function(id,defaultValue) {
                var value = defaultValue;
                try{value = parent.localizeMatrix[this.iIdLanguage][this.iIdCaptionCategory][id];}
                catch(e){value = defaultValue;}
                if(!isNotNull(value)) value = defaultValue;
                alert(value);
                return value;
	        }
        }
	},
	security:{
        ratePassword:function(password,user){
		    // Set Variables
		    var string = password;
		    var lower = /[a-z]/;
		    var upper = /[A-Z]/;
		    var num = /[0-9]/;
		    var char = /\W/
		    var ReqNum = /^.{8}/;
		    var ReqNum2 = /^.{16}/;
		    var rating = 0;
		
		    // Add Rading for each simple option
		    if (lower.test(string))
		       rating++;
		    if (upper.test(string))
		       rating++;
		    if (num.test(string))
		       rating++;
		    if (char.test(string))
		       rating++;
		    if (ReqNum.test(string))
		       rating++;
		    if (ReqNum2.test(string))
		       rating++;
		
		    //Check for username input box and remove a point if password container username
		    if (isNotNull(user)){
		        var grabusername = user;
		        var username = new RegExp(grabusername);
		        if (grabusername != '' && username.test(string)){
		            rating--;   
		        }
		    }
		    
		    // Display a comment related to result
		    var returnObject = new Object();
		    returnObject.rating = rating;
		    switch(rating){
		      case 0:
	           returnObject.returnString = 'Invalide';//Invalid
	           returnObject.returnColor = '#E0E0E0';
	           break;
		    case 1:
		       returnObject.returnString = 'Faible';//Weak
		       returnObject.returnColor = '#AA0033';
		       break;
		    case 2:
		       returnObject.returnString = 'Correct';//Fair
		       returnObject.returnColor = '#F5AC00';
		       break;
		    case 3:
		        returnObject.returnString = 'Bon';//Good
		        returnObject.returnColor = '#FF7F00';
		        break;
		        
		    case 4:
		        returnObject.returnString = "Elev&eacute;";//Strong
		        returnObject.returnColor = '#008000';
		        break;
		    case 5:
		        returnObject.returnString = "Tr&eagrave;s Elev&eacute;";//Very Strong
		        returnObject.returnColor = '#4B30FF';
		        break;
		    case 6:
		        returnObject.returnString = 'Incassable';//Unbreakable
		        returnObject.returnColor = '#8A6D7C';
		        break;
		    }
		    
		    return returnObject;
		}
	},
	dom:{
		getChildrenByTagName:function(node, tagName) {
			var ln = node.childNodes.length;

			var arr = [];
			for (var z=0; z<ln; z++) {
				if (node.childNodes[z].nodeType==1 && node.childNodes[z].nodeName.toUpperCase()==tagName.toUpperCase()) arr.push(node.childNodes[z]);
			}
			return arr;
		},
		disableSelection:function(n) {
			try{
				n.style.MozUserSelect = "none";
				n.unselectable = "on";
				n.style.KhtmlUserSelect = "none";
			}catch(e){};
		},
		getValueByTagName:function(node, nodeName, defaultValue) {
			var defaultValue = (defaultValue) ? defaultValue : "";
			var n = node.getElementsByTagName(nodeName)[0];
			try{n.normalize();}catch(e) {}
	   		return (n && n.firstChild) ? n.firstChild.nodeValue : defaultValue;
		}
	},
	utils:{
		isIE:function(){
			var appVer = navigator.appVersion.toLowerCase(); 
		    var iePos = appVer.indexOf('msie'); 
		    if (iePos !=-1) return true;
		    return false;
		},
		displayModal:function(obj, options) {
		
			var window_header = new Element('div',{className: 'window_header'});
			
			var window_title = new Element('div',{className: 'window_title'});
			window_title.style.color = obj.titleColor ? "#"+obj.titleColor : "#FFF";
			window_title.innerHTML = obj.title;
			
			var window_close = new Element('div',{className: 'window_close'});
			var window_contents = new Element('div',{className: 'window_contents'});
			
			if (!obj.type || obj.type=="content"){
				window_contents.innerHTML = obj.content;
				window_contents.style.height = obj.height+"px";
				window_contents.style.overflow = "auto";
			}else if(obj.type=="div"){
				window_contents.appendChild(obj.content);
				window_contents.style.height = obj.height+"px";
				window_contents.style.overflow = "auto";
			} else if (obj.type=="iframe"){
				var iframe = document.createElement("iframe");
				iframe.frameBorder = 0;
				iframe.border = 0;
				iframe.align = "top";
				iframe.style.width = "100%";
				iframe.style.border = 0;
				iframe.style.margin = 0;
				
				if (obj.height) iframe.style.height = obj.height+"px";
				window_contents.insert(iframe);
			} else if (obj.type=="ajax"){
				window_contents.style.height = obj.height+"px";
			}
			
			var options = {
					className: 'window',
					closeOnClick: window_close,
					/*draggable: window_header,*/
					constrainToViewport:true,
					width:obj.width
			}
			
			if (obj.options){
				for (i in obj.options){
					options[i] = obj.options[i];
				}
			}
	
			if (obj.mode=="window"){
				var w = new Control.Window(false, options);
			} else {
				var w = new Control.Modal(false, options);
			}
			
			var color = obj.color ? obj.color : "000000";
			var opacity = obj.opacity ? obj.opacity : 70;
			w.container.style.backgroundImage = "url("+rootPath+"Fill?w=10&h=10&c="+color+"&a="+opacity+")";
			
			w.container.insert(window_header);
			window_header.insert(window_title);
			window_header.insert(window_close);
			
			/*
			if (obj.type=="iframe"){
				var window_loading = new Element('div',{className: 'window_title'});
				window_loading.style.height = obj.height+"px";
				window_loading.style.color = "#333";
				window_loading.style.backgroundColor = "#FFF";
				window_loading.innerHTML = "chargement...";
				window_loading.style.lineHeight = (obj.height-40)+"px";
				w.container.insert(window_loading);
				
				iframe.onload = function(){					
					this.style.display = "block";
					window_loading.style.display = "none";
				}
			}
			*/
			
			w.container.insert(window_contents);
			w.open();
			
			if (obj.type=="iframe"){
				setTimeout(function(){
					iframe.src = obj.url;
					iframe.style.display = "block";
				},1);
			}		
			
			
			if (obj.type=="ajax"){
				new Ajax.Request(obj.url, {
					method: 'get',
					onSuccess: function(transport) {						
						window_contents.innerHTML = transport.responseText;
						var scripts = window_contents.getElementsByTagName("script");
						$A(scripts).each(function(item){eval(item.innerHTML);});
						w.position();
					}
				});
			}
			
			return w;
			
		},
		getURLParamValue:function(url,param){
			var paramValue = "";
			var urls = url.split("?");
			if(isNotNull(urls[1])){
				var url_param = urls[1];
				var url_params = url_param.split("&");
				url_params.each(function(p){
					if(isNotNull(p)){
						var pp = p.split("=");
						var name = pp[0];
						var value = pp[1];
						if(isNotNull(name) && isNotNull(value) && param==name) paramValue = value;
					}
				});
			}
			return paramValue;
		},
		
	    clearAllFormFieldMsg:function(){
	       $$(".FormFieldMsgValidation").each(function(item){
	           Element.remove(item);
	       });
	    },
	    displayFormTabError:function(tab) {
            function removeMsgTab(){
	            tab.style.backgroundColor = "";
	            tab.style.color = "";
                Event.stopObserving(tab, 'click', removeMsgTab);
            }
            Event.observe(tab, 'click', removeMsgTab);
            tab.style.backgroundColor = "#FFFFCC";
            tab.style.color = "red";
        },
		displayFormFieldMsg1Param:function(field, msg, param1) {
			msg = msg.replace("%1", param1);
			mt.utils.displayFormFieldMsg(field, msg);
		},
		displayFormFieldMsg:function(field, msg) {
		    if(field.type == "hidden"){
		      try{
		          var fieldReference = field.fieldReference;
		          if(!isNotNull(fieldReference)){
		              throw "fieldReference is null"; 
		          }
		          field = fieldReference;
		      }catch(e){}
		    }
		    // Under IE, it doesn't work because the focus() activate the removeMsg() function 
		    //field.focus();
			try{field.removeInfosMsgFunc();}catch(e){};
			var pos = Position.cumulativeOffset(field);
			var span = document.createElement("span");
			span.style.position = "absolute";
			span.style.backgroundColor = "#FFFFCC";
			span.style.padding = "1px 3px 1px 3px";
			span.style.border = "1px solid #CC9933";
			span.style.font = "10px Arial";
			span.className = "FormFieldMsgValidation";
			span.innerHTML = msg;
			span.style.top = (pos[1]+(Element.getHeight(field)/2)-9)+"px";
			span.style.left = (pos[0]+Element.getWidth(field)+5)+"px";
			document.body.appendChild(span);
			function removeMsg(){
			    try{Element.remove(span);}
			    catch(e){}
				if(field.tagName == "BUTTON"){
	             field.style.color = "";
	            }else{
	             field.style.borderColor = "";//#7F9DB9
	            }
				Event.stopObserving(field, 'focus', removeMsg);
			}
			Event.observe(field, 'focus', removeMsg);
			field.removeInfosMsgFunc = removeMsg;
			if(field.tagName == "BUTTON"){
			 field.style.color = "red";
			}else{
			 field.style.borderColor = "red";
		    }
		},
		isEmailValid:function(e) {
			var ok = "1234567890qwertyuiop[]asdfghjklzxcvbnm.+@-_QWERTYUIOPASDFGHJKLZXCVBNM";
			for(var i=0; i<e.length; i++){
				if (ok.indexOf(e.charAt(i))<0) {
					return false;
				}
			}
			if (document.images) {
				var re = /(@.*@)|(\.\.)|(^\.)|(^@)|(@$)|(\.$)|(@\.)/;
				var re_two = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,8}|[0-9]{1,3})(\]?)$/;
				if (!e.match(re) && e.match(re_two)) {
					return -1;
				}
			}
		},
		isNumberString:function(NumStr) {
			var regEx=/^[0-9]+$/;
			return regEx.test(NumStr);
		},
		isFloatString:function(NumStr) {
			var regEx=/^[0-9.]+$/;
			return regEx.test(NumStr);
		},
		isAlphaString:function(str) {
			var regEx=/^[A-Za-z]+$/;
			return regEx.test(str);
		}
	},
	css:{
	   modifyCSSRule:function(tag, name, value){
		    var styleSheets = $A(document.styleSheets);

		    /*
		    $A(document.getElementsByTagName("iframe")).each(function(f, indexFrame){   
		    	if(f.name != "notTabFrame") {
		            var oDoc = f.contentWindow || f.contentDocument;
		            if (oDoc.document) {
		              oDoc = oDoc.document;
		            }
		            var frameStyleSheets = oDoc.styleSheets;
		            for(var i=0;i<frameStyleSheets.length;i++){
		               styleSheets.push(frameStyleSheets[i]);
		            }
		    	}
	        });
	        */
		    
			mt_getElementsByClassName("tab_iframe",document).each(function(f, indexFrame){
		    //$$(".tab_iframe").each(function(f, indexFrame){   
	            var oDoc = f.contentWindow || f.contentDocument;
	            if (oDoc.document) {
	              oDoc = oDoc.document;
	            }
	            var frameStyleSheets = oDoc.styleSheets;
	            for(var i=0;i<frameStyleSheets.length;i++){
	               styleSheets.push(frameStyleSheets[i]);
	            }
	        });
		    
		    for(var i=0;i<styleSheets.length;i++){
		    
		        var cssRules;
		        try{
		          if(styleSheets[i].cssRules) cssRules = styleSheets[i].cssRules;
		          else cssRules = styleSheets[i].rules;
		        }catch(e){/* for security reasons, we can't modify styleSheets on another domain */}
		        
		        for(var j=0;j<cssRules.length;j++){
		            if(cssRules[j].selectorText==tag || 
		            cssRules[j].selectorText==tag.toUpperCase() ||
		            cssRules[j].selectorText==tag.toLowerCase()){
		                cssRules[j].style[name] = value;
		                break;
		            }
		        }
		    }
		},
		changeDocumentSize:function(size){
		    try{documentFontSize = size;}
		    catch(e){
		    	try{parent.documentFontSize = size;}
				catch(e){size = 100;}
		    }
		    try{mt.css.modifyCSSRule("html","fontSize",size+"%");}
		    catch(e){}
		},
		loadDocumentSize:function(){
		  var size = 100;
		  try{size = documentFontSize;}
		  catch(e){
			  try{size = parent.documentFontSize;}
			  catch(e){size = 100;}
		  }
		  try{mt.css.modifyCSSRule("html","fontSize",size+"%");}
		  catch(e){}
		}
	},
	html:{
	    updateNavPath:function(pathArray,divName){
		    try{
			    $(divName).innerHTML = "";
			    pathArray.each(function(path,index){
			        if(index!=0){
			            var delim = document.createElement("img");
			            delim.src = rootPath + "images/icones/fleches/dark_small_next.gif";
			            $(divName).appendChild(delim);
			        }
			        var link = document.createElement("a");
			        link.innerHTML = path.name;
			        link.href = "#";
			        link.onclick = function(){
			            if(isNotNull(path.url) && path.url != "#") mt.html.addTab(path.name,path.url);
			        }
			        $(divName).appendChild(link);
			    });
		    }catch(e){
		      //div not exist
		    }
		},
	    hideTabs:function(tabFrame, divs) {
	        //var tabs = $C("tabs", tabFrame)[0].getElementsByTagName("div");
	        var tabs =  Element.select(tabFrame,'.tabs')[0].getElementsByTagName("div");
			for (var i=0; i<tabs.length; i++) {
	            Element.removeClassName(tabs[i],"active");
				//tabs[i].className = null;
	        }
	        for (var i=0; i<divs.length; i++) {
	            divs[i].style.display = "none";
	        }
        },
		applyTabEvents:function() {
			var tabFrames =  $$(".tabFrame");

			for (var z=0; z<tabFrames.length; z++) {
				var tabs = Element.select(tabFrames[z],'.tabs')[0].getElementsByTagName("div");
				for (var i=0; i<tabs.length; i++) {
					tabs[i].setAttribute("index", i);
					tabs[i].setAttribute("indexFrame", z);
					mt.dom.disableSelection(tabs[i]);
					
					var tabCloses = Element.select(tabs[i],'.closeTab');
                    if(tabCloses.length>0){
                        var tabClose = tabCloses[0];
                        if(tabs.length>1){
                            tabClose.style.display="";
                            tabClose.setAttribute("index", i);
                            tabClose.onmouseup = function() {
                                mt.html.removeTab(this.getAttribute("index"));
                            }
                        }else{
                            tabClose.style.display="none";
                        }
                    }

					tabs[i].onclick = function() {
						var tabFrame = tabFrames[this.getAttribute("indexFrame")];
						var divs = mt.dom.getChildrenByTagName(Element.select(tabFrame,".tabContent")[0], "div");
						
						mt.html.hideTabs(tabFrame, divs);
						//this.className = "active";
						Element.addClassName(this,"active");
						
						try{
							var tabContent = divs[this.getAttribute("index")];
							tabContent.style.display = "block";
                            

						}catch(e){}
						onTabChange(this.getAttribute("index"),this.id);
					}
					
					tabs[i].ondblclick = function() {
						onTabDoubleClick(this.getAttribute("index"),this.id);
					}
				}
			}
		},
		jumpToTab:function(tab, tabIndex) {
			if (tab == null)
				return;
			
            var node = tab.parentNode;
            while(!Element.hasClassName(node,"tabFrame")) {
            	node = node.parentNode;
           }

            var divs = mt.dom.getChildrenByTagName(Element.select(node,".tabContent")[0], "div");
			mt.html.hideTabs(node, divs);
            //tab.className = "active";
            Element.addClassName(tab,"active");
            try{
                var tabContent = divs[tabIndex];
                tabContent.style.display = "block";
            }catch(e){}
            onTabChange(tabIndex,tab.id);
        },
		jumpToTabName:function(tabName, tabIndex) {
			var tab = $(tabName);
			mt.html.jumpToTab(tab,tabIndex);
		},
		jumpToTabIndex:function(tabsFrame, tabIndex) {
            var tab = $(tabsFrame).getElementsByTagName("div")[tabIndex];
            mt.html.jumpToTab(tab,tabIndex);
        },
        jumpToTabId:function(tabsFrame, tabId) {
            var index = 0;
            var tabs = $A($(tabsFrame).getElementsByTagName("div")).each(function(tab,indexTab){
                if(tab.id == tabId)
                    index = indexTab;
            });
            mt.html.jumpToTabIndex(tabsFrame,index);
        },
        replaceTab:function(indexTab, tabName, url, idTab, nameTab){
        	
        	var tabs = $$(".tabs")[0];
        	var tabContent = $$(".tabContent")[0];
        	
        	var oldTabDiv = tabs.getElementsByTagName("div")[indexTab];
        	var oldTabContent = tabContent.getElementsByTagName("div")[indexTab];        	
        	
        	var newTabDiv = mt.html.createTabDiv(tabName, idTab, nameTab);
        	var newIframe = mt.html.createTabIframe(url, idTab);
        	var newTabContent = mt.html.createTabContent(newIframe, idTab);
        	        	
        	var iCountTab = mt.html.getCountTab();
        	var iCountTabContent = tabContent.getElementsByTagName("div").length;        	
        	
            var jumpable = (iCountTab>0);
            if(jumpable){            	
            	     	
            	tabs.replaceChild(newTabDiv, oldTabDiv);            	
            	tabContent.replaceChild(newTabContent, oldTabContent);
            	
            	mt.html.applyTabEvents();
            	Event.observe(newIframe,"load",function(){
                	mt.html.resizeLayout();
                	//mt.html.onAddTabEvent(indexTab);
                	mt.html.jumpToTabIndex("tabsTitle", indexTab);
                });
            	
	            	            	            
            }
           
        },
		getIndexTabFromId:function(idTab){
            var tabs = $$(".tabs")[0];
        	var childTabs = tabs.childNodes;
        	var indexTab = 0;
        	if(isNotNull(idTab)){
            	for(var iTab = 0; iTab < childTabs.length ; iTab++){
            		if(childTabs[iTab].id == idTab){
            			indexTab = iTab;
            			break;
            		}
            	}
        	}
        	return indexTab;
        },
        removeTab:function(indexTab,bForcedRemove){
            var tabs = $$(".tabs")[0];
            var indexJump = 0;//((indexTab==0)?(indexTab+1):(indexTab-1));
            var iCountTab = tabs.getElementsByTagName("div").length;
            var jumpable = (iCountTab>1);
            if(bForcedRemove || jumpable){
	            Element.remove(tabs.getElementsByTagName("div")[indexTab]);
	            var tabContent = $$(".tabContent")[0];
	            try{Element.remove(tabContent.getElementsByTagName("div")[indexTab]);
	            }catch(e){
	            	try{Element.remove(indexTab+"_div");
	            	}catch(e){}
	            }
	            mt.html.applyTabEvents();
	            mt.html.jumpToTabIndex("tabsTitle",indexJump );
            }else{
                alert("il ne reste qu'un seul onglet, il ne peut donc &eacirc;tre supprim&eacute;");
            }
            mt.html.onRemoveTabEvent(indexTab);
        },
        createTabDiv:function(tabName, idTab, nameTab){
        	        	
        	var newTab = document.createElement("div");
            Element.extend (newTab);
            if(isNotNull(idTab)) newTab.id = idTab;
            if(isNotNull(nameTab)) newTab.name = nameTab;
            
            var spanTitle = document.createElement("span");
            spanTitle.innerHTML = tabName ;
            if(isNotNull(idTab)) spanTitle.id= idTab + "_title" ;
            spanTitle.className = "tabSpanTitle";
            newTab.appendChild(spanTitle);
            var action = document.createElement("a");
            action.innerHTML = "&nbsp";
            action.className="closeTab";
            if(isNotNull(idTab)) action.id= idTab + "_action" ;
            
            action.onmousedown = function() {
                this.style.backgroundPosition= "-30px 0";
            }
            action.onmouseover = function() {
                this.style.backgroundPosition= "-15px 0";
            }
            action.onmouseout = function() {
                this.style.backgroundPosition= "0 0";
            }
            
            newTab.appendChild(action);
                        
            return newTab;
        },
        createTabIframe:function(url, idTab){
        	
        	var iframe = document.createElement("iframe");
            Element.extend (iframe);
            iframe.src = url;
            if(isNotNull(idTab)){
            	iframe.id = iframe.name = "main_"+idTab;
            }else{
            	iframe.id = iframe.name = "main";
            }
            iframe.style.border = "0";
            iframe.style.margin = "0";
            iframe.style.padding = "0";
            iframe.style.width = "100%";
            iframe.align = "top";
            iframe.frameBorder = "0";
            iframe.border = "0";
            iframe.addClassName('tab_iframe');
            
            return iframe;
        },
        createTabContent:function(iframe, idTab){
        	
        	var newTabContent = new Element("div",{"id":idTab+"_div"});
            newTabContent.appendChild(iframe);
            
            return newTabContent;
        },
        addTabReverseDefaultBehavior:function(tabName,url){
            mt.html.addTab(tabName,url,true); 
        },
        addTabForced:function(tabName, url, reverseDefaultBehavior, idTab, nameTab){
        	if(!isNotNull(reverseDefaultBehavior)) reverseDefaultBehavior = false;
            mt.html.addTab(tabName, url, reverseDefaultBehavior, true, idTab, nameTab);  
        },
        addTab:function(tabName,url, reverseDefaultBehavior, force, idTab, nameTab){
        	var tabs = $$(".tabs")[0];
            var tabsLength = tabs.childNodes.length;
            if( force
            || (enableDeskTabs && !reverseDefaultBehavior)
            || (!enableDeskTabs && tabsLength==0) 
            || (!enableDeskTabs && reverseDefaultBehavior)){
            	
            	var childTabs = tabs.childNodes;
            	var bAddNewTab = true;
            	var indexTab = 0;
            	if(isNotNull(idTab)){
	            	for(var iTab = 0; iTab < childTabs.length ; iTab++){
	            		if(childTabs[iTab].id == idTab){
	            			indexTab = iTab;
	            			bAddNewTab = false;
	            			break;
	            		}
	            	}
            	}
            	var iframe;
            	if(bAddNewTab){
		            var tabContent = $$(".tabContent")[0];
		            
		            var newTabDiv = mt.html.createTabDiv(tabName, idTab, nameTab);		    
		            tabs.appendChild(newTabDiv);		            
		            indexTab = (tabs.getElementsByTagName("div").length-1);		            
		            iframe = mt.html.createTabIframe(url, idTab);
		            var newTabContent = mt.html.createTabContent(iframe, idTab);
		            /** 
		             * JR: add hide to prevent page scroll to the bottom...
		             * frame is shown whith jumpToTab function 
		             */
		            Element.hide(newTabContent);
		            tabContent.appendChild(newTabContent);
            	}
	            mt.html.applyTabEvents();	            
	            
	            //var tabBorder = RUZEE.ShadedBorder.create({corner:6, border:1, edges:"blr"});
	            //tabBorder.render(newTab);
	            if(bAddNewTab){
		            Event.observe(iframe,"load",function(){
	                	mt.html.resizeLayout();
	                	mt.html.onAddTabEvent(indexTab);
	                	mt.html.jumpToTabIndex("tabsTitle", indexTab);
	                });
	            }else{
	            	 /** It is an existent tab, so reload it**/	 
	            	 var bReloadTab;
	                 var divs = $A(tabs.getElementsByTagName("div"));
	                 var iframeName = "main_"+idTab;
	                 divs.each(function(tab, index){
	                	 
	                	 if(!bReloadTab)
	                	 {
	                		 /** Search for the iFrame with the same name **/
	                		 var tabContent = $$(".tabContent")[0].getElementsByTagName("div")[index];
		                	 mt_getElementsByClassName("tab_iframe",tabContent).each(function(f){	                		 
		                		
		                		 if(f.id==iframeName)
		             			 {
		                			 bReloadTab = true;
		             			 }		                		 
		             		}); 
	                	 }	                	 
	                	 
	                 });
	                 
	                 if(bReloadTab)
	                 {/** Remove the tab and add it again **/
	                	//mt.html.removeTab(indexTab);
	   			    	//parent.addParentTabForced(tabName,url, reverseDefaultBehavior, nameTab, nameTab); 
	                	 mt.html.replaceTab(indexTab, tabName, url, nameTab, nameTab);
	                 }
	                 else
	                 {/** Old way **/
	                	mt.html.resizeLayout();
		            	mt.html.onAddTabEvent(indexTab);	 
	                 }            	
	            }
	           
	        }else{
                mt.html.redirectTabActive(url, idTab);
                mt.html.onAddTabEvent(indexTab);
            }
        },
        onAddTabEvent:function(indexTab){},
        onRemoveTabEvent:function(indexTab){},
        getIndexTabActive:function(){
            var tabsDiv = $$(".tabs")[0];
            var tabs = $A(tabsDiv.getElementsByTagName("div"));
            var indexTab;
            tabs.each(function(tab, index){
                if(tab.hasClassName("active")){
                    indexTab = index;
                    return;
                }
            });
            return indexTab;
        },
        getTabTitle:function(index){
            var tabsDiv = $$(".tabs")[0];
            var tabs = $A(tabsDiv.getElementsByTagName("div"));
            return tabs[index];
        },
        getCountTab:function(){
            var tabsDiv = $$(".tabs")[0];
            var tabs = $A(tabsDiv.getElementsByTagName("div"));
            return tabs.length;
        },
        getTabActive:function(){
            var tabsDiv = $$(".tabs")[0];
            var tabs = $A(tabsDiv.getElementsByTagName("div"));
            var activeTab;
            tabs.each(function(tab, index){
                if(tab.hasClassName("active")){
                    activeTab = tab;
                    return;
                }
            });
            return activeTab;
        },
        redirectTabActive:function(url, idTab){
            var tabsDiv = $$(".tabs")[0];
            var tabs = $A(tabsDiv.getElementsByTagName("div"));

            tabs.each(function(tab, index){
                if(tab.hasClassName("active")){
                	if(isNotNull(idTab)) tab.id = idTab;
                    var tabContent = $$(".tabContent")[0].getElementsByTagName("div")[index];

                    var iframe = null;
                    /** get the first tab */
                    
                    /*
                    $A(tabContent.getElementsByTagName("iframe")).each(function(f){
        			    if(iframe == null && f.name != "notTabFrame")
        				{
        			    	iframe = f;
        				}
        		    });
                    */
                    
        			mt_getElementsByClassName("tab_iframe",tabContent).each(function(f){
                    //$$(".tab_iframe").each(function(f){
        			    if(iframe == null )
        				{
        			    	iframe = f;
        				}
        		    });
                    
                    //var iframe = tabContent.getElementsByTagName("iframe")[0];
                    if(iframe != null) iframe.src = url;
                    
                    if(isNotNull(tab.addedClass)){
                    	tab.addedClass.each(function(cl){
    	            		Element.removeClassName(tab,cl);
    	            	});
    	            }
                    
                    Event.observe(iframe,"load",function(){
                    	mt.html.resizeLayout();
                    });
                    return;
                }
            });
            
            //main.location = url;
        },
        updateTabTitle:function(){
            var mainDoc;
            try{mainDoc = parent.document;}
            catch(e){mainDoc = document;}
            
            var isDeskFrame = false;
            try{isDeskFrame = (mainDoc.body.id == "index" && document.body.id != "index");}
            catch(e){isDeskFrame = false;}

	        if(isDeskFrame){
	        	var indexTabs = new Array();
	            var tabs = mainDoc.getElementById("tabsTitle").getElementsByTagName("div");
	            /**
	             * issue about it : 
	             * As of Prototype 1.6, document.getElementsByClassName has been deprecated since native 
	             * implementations return a NodeList  rather than an Array. Please use $$  or Element#select  instead.
	             */
	            //var frames = $A(mainDoc.getElementsByTagName("iframe"));
	            //var frames = mainDoc.getElementsByClassName("tab_iframe");
	            //var frames = mainDoc.select("[class='tab_iframe']");
	            var frames = mt_getElementsByClassName("tab_iframe",mainDoc);
	            
	            var indexOffset = 0;
	            
                frames.each(function(f, indexFrame){     
            		try{
	                   var oDoc = f.contentWindow || f.contentDocument;
	                   if (oDoc.document) {
	                       oDoc = oDoc.document;
	                   }
	                   if(oDoc.location.href == document.location.href){
	                       indexTabs.push(indexFrame);
	                   }
            	   }catch(e){}
               });
	            
               var docTitle = "";
               try{docTitle = $("pageTitle");}
               catch(e){}

               if(!isNotNull(docTitle.innerHTML))
               {
            	   docTitle.innerHTML = "no name";
               }

               indexTabs.each(function(index){
                   var spanList = null;
                   var t = tabs[index];
                   try {
                	   spanList = t.getElementsByTagName("span");
                   } catch (e) { 
                	   spanList =  new Array(); 
                   }
                   
                   if(docTitle.className.indexOf('updateTabClass')!=-1) {
                	   docTitle.classNames().each(function(c){
	                       if (c.indexOf('updateTabClass')!=-1) {
	                           var tabClass = c.split("-")[1];
	                           Element.addClassName(t,tabClass);
	                           t.addedClass = [tabClass];
	                       }
                	   });
                   }

                   if(spanList.length > 0) 
                   {
                	   var tabTitle = spanList[0];
	
	                   if(mt.config.limitTabsTitle){
	                	   var content = "";
	                	   if(isNotNull(docTitle.innerText)) content = docTitle.innerText;
	                	   else content = docTitle.textContent;
	                	   
	                	   if(isNotNull(docTitle.title)) tabTitle.title = docTitle.title;
	                	   else tabTitle.title = content;
	                	   
	                	   
	                	   tabTitle.innerHTML = tronquerChaine(content,mt.config.limitTabsTitleLength);
	                   }else{
	                	   tabTitle.innerHTML = docTitle.innerHTML;
	                   }
	                   var parentDiv = null;
	                   try{parentDiv = $("pageTitleRound");}
	                   catch(e){parentDiv = null;}
	                   
	                   if(isNotNull(parentDiv)){
	                        Element.hide(parentDiv);
	                   }else{
	                        Element.hide(docTitle);
	                   }
                   }
               });
	        }
        },
        resizeLayout:function() {
		    var hMenu = 100;
		    try{hMenu = Element.getHeight($('headerMenu'))+40;}
		    catch(e){hMenu = 100;}
		    
		    var h = Element.getHeight(document.documentElement);
		    try{$('tableLayout').style.height = (h-hMenu)+"px";}
		    catch(e){}
		    /*
		    $A(document.getElementsByTagName("iframe")).each(function(f){
			    if(f.name != "notTabFrame") 
				{
			    	f.style.height = (h-hMenu)+"px";
				}
		    });
		    */
		    
			mt_getElementsByClassName("tab_iframe",document).each(function(f){
		    //$$(".tab_iframe").each(function(f){
			    f.style.height = (h-hMenu)+"px";
		    });
		    
		    $$('.treeview').each(function(item){
		        item.style.height = (h-85)+"px";
		    });
		    mt.html.onResizeLayout();
		},
		onResizeLayout:function() {},
		updateUserConfig:function(callback) {
           if(confirm("Voulez-vous sauvegarder la configuration de vos onglets avant de quitter la session?")){
			   var tabs = $A($$(".tabs")[0].getElementsByTagName("div"));
			   var tabsStore = new Array();
			   
			   mt_getElementsByClassName("tab_iframe", document).each(function(f, indexFrame){
			   //$$(".tab_iframe").each(function(f, indexFrame){  
			   //$A(document.getElementsByTagName("iframe")).each(function(f, indexFrame){  
				    //if(f.name != "notTabFrame") 
					{
						var oDoc = f.contentWindow || f.contentDocument;
				        if (oDoc.document) {
				          oDoc = oDoc.document;
					    }
		                var url = oDoc.location;
		                url = url.pathname+url.search;
		                
		                var tabTitle = tabs[indexFrame].getElementsByTagName("span")[0];
		                tabTitle = tabTitle.innerHTML;
		                
		                var tabStore = new Object();
		                tabStore.sTabUrlComplete = url;
		                tabStore.sTabName = tabTitle;
		                tabsStore.push(tabStore);
					}
	            });
	            UserTab.storeAllFromJSONString(Object.toJSON(tabsStore),
	            function(result){
	                callback();
	            });
            }else{
                 callback();
            }
		},
		loadUserConfig:function() {
            UserTab.getJSONArrayFromSessionUserDWR(
            function(results){
                var tabs = results.evalJSON();
                tabs.each(function(tab,index){
                    mt.html.addTab(tab.sTabName,tab.sTabUrlComplete);
                });
            });
        },
		enableSuperCombos:function() {
			var combos = document.getElementsByTagName("select");
			for (var z=0; z<combos.length; z++) {
				mt.html.setSuperCombo(combos[z]);
			}
		},
		setSuperCombo:function(combo) {
			combo.addItem = function(itemObj) {
				this.options[this.options.length] = new Option(itemObj.value, itemObj.data);
			}
			combo.addItemValue = function(data, value) {
				this.options[this.options.length] = new Option(value, data);
			}
			combo.populate = function(dataSet, selectionValue, valueName, labelName) {
				this.removeAll();
				dataSet.each(function(item, index){
					var value = (valueName) ? dataSet[index][valueName] : dataSet[index].data;
					var label = (labelName) ? dataSet[index][labelName] : dataSet[index].value;
					var opt = new Option(label, value);
					combo.options[index] = opt;
					if (opt.value==selectionValue) combo.selectedIndex = index;
				});
			}
			combo.setSelectedValue = function(value) {
				for (var z=0; z<this.options.length; z++) {
					if (this.options[z].value==value) {
						this.selectedIndex = z;
						break;
					}
				}
			}
			combo.setSelectedValues = function(values) {
				values.each(function(item){
					for (var z=0; z<combo.options.length; z++) {
						if (combo.options[z].value==item) combo.options[z].selected = true;
					}
				});
			}
			combo.getSelectedValues = function() {
				var arr = [];
				for (var z=0; z<this.options.length; z++) {
					if (this.options[z].selected) arr.push(this.options[z].value);
				}
				return arr;
			}
			combo.setSelectedIndex = function(index) {
				this.selectedIndex = index;
			}
			combo.getSelectedText = function() {
				return this.options[this.selectedIndex].text;
			}
			combo.removeItem = function(index) {
				this.options[index] = null;
			}
			combo.removeAll = function() {
				this.options.length = 0;
			}
		},
		addHiddenToForm:function(form,hiddens){
            for (i in hiddens){
              if($(i)){
                //element exist, delete before
                Element.remove($(i));
              }
	          var hidden = document.createElement("input");
	          hidden.type = "hidden";
	          hidden.id = hidden.name = i;
	          hidden.value = hiddens[i];
	          form.appendChild(hidden);
	        }
		}
	},
	component:{
		layout:{},
		batch:{}
	}
};


mt.component.ToolTip = function(node, content, width, align) {
	this.node = node;
	var self = this;
	this.content = content;
	this.width = (width==null)?150:width;
	this.align = (align==null)?"left":align;
	var offsetxpoint=0;
	var offsetypoint=20;
	this.domNode = document.createElement("div");	
	this.domNode.id = "tooltip";
	with(this.domNode.style){left="-1000px";position="absolute";zIndex="65432"};
	document.body.appendChild(this.domNode);

	this.init = function(){
		Event.observe(this.node, 'mousemove', this.setPosition.bindAsEventListener(this));
		Event.observe(this.node, 'click', this.remove.bindAsEventListener(this));
		Event.observe(this.node, 'mouseout', this.remove.bindAsEventListener(this));
		this.domNode.style.textAlign=this.align;
		this.domNode.innerHTML='<div class="tooltipFrame"><div class="tooltipFrame2">'+this.content+'</div></div>';
		this.domNode.style.width=(this.domNode.offsetWidth>this.width)?this.width:this.domNode.offsetWidth+"px";
		if (width) this.domNode.style.width=width+"px";
	}
	this.setPosition = function(e){
		var curX=(window.ActiveXObject)?e.clientX+document.body.scrollLeft:e.pageX;
		var curY=(window.ActiveXObject)?e.clientY+document.body.scrollTop:e.pageY;
		
		var rightedge=window.ActiveXObject? document.body.clientWidth-e.clientX-offsetxpoint : window.innerWidth-e.clientX-offsetxpoint-20;
		var bottomedge=window.ActiveXObject? document.body.clientHeight-e.clientY-offsetypoint : window.innerHeight-e.clientY-offsetypoint-20;
		
		var leftedge=(offsetxpoint<0)? offsetxpoint*(-1) : -1000;
		
		if (rightedge<this.domNode.offsetWidth) {
			this.domNode.style.left=(window.ActiveXObject) ? document.body.scrollLeft+e.clientX-this.domNode.offsetWidth+"px" : window.pageXOffset+e.clientX-this.domNode.offsetWidth+"px";
		} else if (curX<leftedge) {
			this.domNode.style.left="5px";
		} else {
			this.domNode.style.left=curX+offsetxpoint+"px";
		}
		
		if (bottomedge<this.domNode.offsetHeight) {
			var d = (/Konqueror|Safari|KHTML/.test(navigator.userAgent)) ? 0 : window.pageYOffset;
			this.domNode.style.top=(window.ActiveXObject)? document.body.scrollTop+e.clientY-this.domNode.offsetHeight-offsetypoint+"px" : d+e.clientY-this.domNode.offsetHeight-offsetypoint+"px";
		} else {
			this.domNode.style.top=curY+offsetypoint+"px";
		}
	}
	this.remove = function(){
		Event.stopObserving(this.node, 'mouseout', this.remove.bindAsEventListener(this));
		Event.stopObserving(this.node, 'click', this.remove.bindAsEventListener(this));
		Event.stopObserving(this.node, 'mousemove', this.setPosition.bindAsEventListener(this));
		try {Element.remove(this.domNode);} catch(e){}
	}
	this.init();
}


function activateImagesReflections() {
	$$('.reflect').each(function(item){
		var rheight = null;
		var ropacity = null;
		
		var classes = item.className.split(' ');
		for (j=0;j<classes.length;j++) {
			if (classes[j].indexOf("rheight") == 0) {
				var rheight = classes[j].substring(7)/100;
			} else if (classes[j].indexOf("ropacity") == 0) {
				var ropacity = classes[j].substring(8)/100;
			}
		}
		
		ImageReflection.add(item, { height: rheight, opacity : ropacity});	
	});
}


mt.component.DataGrid = Class.create();
mt.component.DataGrid.prototype = {
	initialize:function(placeHolder) {
		this.domNode = $(placeHolder);
		this.dataSet = [];
		this.columnStyles = [];
		this.createTable();
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
	}
};



/* ===== Search Engine ===== */
mt.component.SearchEngine = function() {
	
	var self = this;
	this.params = [];
	this.sOrderBy  = "";
	this.searchString = "";
	this.sFilters = "";
	
	this.addParam = function(name, value) {
		this.params.push({name:name, value:value});
	}
	this.setIndex = function(index) {
		this.index = index;
	}
	this.setOffset = function(offset) {
		this.offset = offset;
	}
	this.setOrderBy = function(fieldName) {
		this.sOrderBy = (fieldName) ? ' orderBy="'+fieldName+'"' : '';
	}
	this.setSearchString = function(value) {
		this.searchString = (this.searchName && value!="") ? ' likeName="'+this.searchName+'" likeValue="'+value+'"' : '';
	}
	this.setSearchName = function(name) {
		this.searchName = name;
	}
	this.addFilter = function(name, value) {
		this.sFilters += '<filter name="'+name+'" value="'+value+'"/>';
	}
	this.setFilters = function(filters) {
		filters.each(function(item) {
			self.sFilters += '<filter name="'+item.name+'" value="'+item.value+'"/>';
		});
	}
	this.getParamsString = function() {
		var str = "";
		this.params.each(function(item){
			str += ' '+item.name+'="'+item.value+'"';
		});
		return str;
	}
	this.getXmlQuery = function() {

		return '<modula'+this.getParamsString()+'>'
				+ '<search'+((this.index!=null && this.offset!=null)?(' index="'+this.index+'" offset="'+this.offset+'"'):'')
				+ this.sOrderBy + this.searchString + '>'
				+ this.sFilters
				+ '</search>'
				+ '</modula>';
	}
	this.next = function() {
		this.setIndex(this.index+this.offset);
		this.search();
	}
	this.previous = function() {
		this.setIndex(this.index-this.offset);
		this.search();
	}
	this.enableSearchOption = function(enable) {
		this.searchOptionEnabled = enable;
		this.searchDiv.innerHTML = '';
	}
	this.onLoad = function() {};
	this.onExtraLoad = function() {};
	this.onSelect = function() {};
	this.onClosePopup = function() {};
	this.search = function() {
		this.request = new Ajax.Request(webService_url, {method:'post', parameters:"sXml="+encodeURIComponent(this.getXmlQuery()), onComplete:function(r){
			var root = r.responseXML.documentElement;
			self.count = root.getAttribute("count");
			self.isPreviousData = !(self.count<=self.offset || self.index == 0);
			self.isNextData = !(self.count<=self.offset || ((self.count-self.index)<=self.offset));
			self.nbPages = Math.ceil(self.count/self.offset);
			self.pageNum = Math.ceil(self.index/self.offset)+1;			
			self.onLoad(r);
			self.onExtraLoad();
		}});
	}
	this.updateInfos = function() {
		this.previousButton.style.visibility = (this.isPreviousData) ? "visible" : "hidden";
		this.nextButton.style.visibility = (this.isNextData) ? "visible" : "hidden";
		this.headerInfos.innerHTML = "page "+this.pageNum+"/"+this.nbPages+" ("+this.count+")";
	}
	this.buildPopUp = function(placeHolder) {
	
		this.onExtraLoad = function() {
			this.updateInfos();
		}
	
		this.placeHolder = $(placeHolder);
		var divDg = document.createElement("div");
		divDg.style.backgroundColor = "#FFF";
		divDg.style.height = "150px";
		divDg.style.overflow = "auto";
		this.datagrid = new mt.component.DataGrid(divDg);
		this.datagrid.table.style.borderSpacing = "1px";
		this.datagrid.render();
		var footer = document.createElement("div");
		footer.style.backgroundColor = "#F7F7F7";
		footer.style.marginTop = "2px";
		footer.innerHTML = '<table width="100%"><tr>'
							+ '<td><img src="'+rootPath+'images/icons/control_rewind_blue.gif" class="pointer"/></td>'
							+ '<td class="center"><input type="input" class="styled searchInput"/></td>'
							+ '<td><img src="'+rootPath+'images/icons/control_fastforward_blue.gif" class="pointer"/></td>'
							+ '</tr></table>';
		var header = document.createElement("div");
		header.style.backgroundColor = "#F7F7F7";			
		header.style.marginBottom = "2px";			
		var closeBtn = document.createElement("img");
		closeBtn.src = rootPath+"images/closeBlue.gif";
		closeBtn.style.cssFloat = "right";
		closeBtn.style.cursor = "pointer";
		closeBtn.onclick = function() {
			self.placeHolder.style.display = "none";
			self.onClosePopup();
		}
		this.headerInfos = document.createElement("div");
		this.headerInfos.style.textAlign = "center";
		this.headerInfos.style.fontSize = "10px";
		header.appendChild(closeBtn);
		header.appendChild(this.headerInfos);
		this.placeHolder.style.backgroundColor = "#F2E9B4";
		this.placeHolder.style.padding = "3px";
		this.placeHolder.style.border = "1px solid #666";
		this.placeHolder.appendChild(header);
		this.placeHolder.appendChild(divDg);
		this.placeHolder.appendChild(footer);
		var tds = footer.getElementsByTagName("td");
		this.searchDiv = tds[1];
		this.previousButton = tds[0].firstChild;
		this.previousButton.onclick = function() {
			self.datagrid.removeAll();
			self.previous();
		}
		tds[1].firstChild.onkeyup = function() {
			var input = this;
			clearTimeout(self.lastKeyUpTimeId);
			self.request.transport.abort();
			self.lastKeyUpTimeId = setTimeout(function() {
				self.setSearchString(input.value.trim());
				self.setIndex(0);
				self.datagrid.removeAll();
				self.search();
			}, 100);
		}
		this.nextButton = tds[2].firstChild;
		this.nextButton.onclick = function() {
			self.datagrid.removeAll();
			self.next();
		}
	}
	this.populate = function(items) {
		items.each(function(item) {
			var lineData = self.datagrid.addItem(item.value);
			var line = lineData.node;
			line.style.cursor = "pointer";
			line.onmouseover = function() {
				this.style.backgroundColor = "#FFF6C1";					
			}
			line.onmouseout = function() {
				this.style.backgroundColor = "#FAFAFA";
			}
			line.onclick = function() {
				self.onSelect(item.data);
			}
		});
	}
//	this.build();
}

/* ===== Input Suggestion Box ===== */

mt.component.InputSuggestionBox = function(input) {
	var self = this;
	this.input = $(input);
	this.dataProvider = null;
	this.filter = null;
	this.results = [];
	
	this.input.onkeyup = function() {
		if (this.value.trim()!="") {
			self.dataProvider(function(results) {
				self.results = results;
				self.updateBox();
			}, self.input.value.trim());
		} else {
			self.removeSuggestionBox();
		}
	}
	
	this.onKeyHit = function(e) {
		highlightItem(this.highlightedItem);
		this.setItemSelection(function(){
			alert("yo");
		});
		
	}
	
	Event.observe(document, 'keydown', this.onKeyHit);

	this.setDataProvider = function(dataProvider) {
		this.dataProvider = dataProvider;
	}
	
	this.setDataFilter = function(filter) {
		this.filter = filter;
	}
	
	this.removeSuggestionBox = function() {
		if ($("inputSuggestionBox")) Element.remove($("inputSuggestionBox"));
		Event.stopObserving(document, 'keydown', this.onKeyHit);
	}

	this.updateBox = function() {
		if (this.results.length>0 && this.input.value.trim()!="") {
			this.removeSuggestionBox();
			var frame = document.createElement("div");
			frame.style.position = "absolute";
			frame.style.backgroundColor = "#FFF";
			frame.id = "inputSuggestionBox";
			var pos = Position.cumulativeOffset(input);
			frame.style.left = pos[0]+"px";
			frame.style.top = pos[1]+input.offsetHeight-1+"px";
			frame.style.border = "1px solid #90B8E7";
			this.results.each(function(item, index){
				var div = document.createElement("div");
				div.innerHTML = self.filter(item);
				div.style.margin = "1px";
				div.style.backgroundColor = "#EFF5FF";
				div.style.padding = "0 3px 0 3px";
				div.onclick = function() {
					self.onSelect(self.results[index]);
					self.removeSuggestionBox();
					self.input.value = self.filter(item);
				}
				frame.appendChild(div);
			});
			document.body.appendChild(frame);
		} else {
			this.removeSuggestionBox();
		}
	}
	this.onSelect = function() {};
}



mt.component.InPlaceEditor = function(node) {
	var self = this;
	var div = document.createElement("div");
	var textarea = document.createElement("textarea");

	div.innerHTML = textarea.value = node.innerHTML;
	div.style.height = "1%";
	textarea.style.display = "none";
	
	this.onChange = function() {};
	node.innerHTML = '';
	node.appendChild(div);
	node.appendChild(textarea);

	var originalBackground = Element.getStyle(node, 'background-color');

	textarea.onblur = function() {
		var newValue = this.value;
		div.style.height = (newValue.trim()=="") ? '1em' : '1%';
		div.innerHTML = newValue.replace(/\n/gi,"<br/>");
		Element.show(div);
		Element.hide(this);
		node.onclick = onItemClick;
		node.onmouseover = onOver;
		node.onmouseout = onOut;
		self.onChange(newValue);
	}
	node.onmouseover = onOver;
	node.onmouseout = onOut;
	function onOver() {
		node.style.backgroundColor = "lightyellow";
	}
	function onOut() {
		node.style.backgroundColor = (originalBackground) ? originalBackground : "transparent";
	}
	function onItemClick() {
		node.onclick = null;
		textarea.style.width = node.offsetWidth-14+"px";
		textarea.style.height = (div.offsetHeight>45) ? div.offsetHeight+"px" : "45px";
		textarea.value = div.innerHTML.replace(/<br>/gi, "\n").replace(/<br\/>/gi, "\n").replace(/<\/p>/gi, "\n").replace(/<p>/gi, "");
		Element.hide(div);
		Element.show(textarea);
		setTimeout(function(){textarea.focus();}, 1);
		node.onmouseover = null;
		node.onmouseout = null;
		node.style.backgroundColor = (originalBackground) ? originalBackground : "transparent";
	}
	node.onclick = onItemClick;
	this.edit = onItemClick;
}


/* ======== PROTOTYPES ======== */

String.prototype.trim = function() {
	return this.replace(/^\s*|\s*$/g,"");
}

String.prototype.cleanString = function() {
	return this.replaceSpecialChars("").removeAccents().removeAllSpaces();
}

String.prototype.replaceSpecialChars = function(newStr) {
      re = /\$|,|@|#|~|`|\%|\*|\^|\&|\(|\)|\+|\=|\[|\-|\_|\]|\[|\}|\{|\;|\:|\'|\"|\<|\>|\?|\||\\|\!|\$|\./g;
      return this.replace(re, newStr);
}

String.prototype.removeAllSpaces = function() {
	/* regexp simple pour supprimer les espaces classiques */
	var str = this.replace(/\s+/g, "");

	/* 
	 * certains espaces ne sont pas pris en compte dans la regexp
	 * on cree une chaine ‡ partir des codes ascii des espaces (http://htmlhelp.com/reference/charset/iso032-063.html)
	 * 32 : Normal space
	 * 160 : Non-breaking space (utilisÈ par IE, va savoir pourquoi...)
	 */
	var returnStr = "";
	var spaces = String.fromCharCode(32,160);
	/* on recree la chaine en ne prenant pas en compte ces espaces */
	for(var i=0; i<str.length; i++){
		if (spaces.indexOf(str.charAt(i))<0) {
			returnStr += str.charAt(i);
		}
	}

	return returnStr;
}

String.prototype.isEmail = function() {
	var str = this.trim();
	var ok = "1234567890qwertyuiop[]asdfghjklzxcvbnm.+@-_QWERTYUIOPASDFGHJKLZXCVBNM";
	for(var i=0; i<str.length; i++){
		if (ok.indexOf(str.charAt(i))<0) {
			return false;
		}
	}
	if (document.images) {
		var re = /(@.*@)|(\.\.)|(^\.)|(^@)|(@$)|(\.$)|(@\.)/;
		var re_two = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,8}|[0-9]{1,3})(\]?)$/;
		if (!str.match(re) && str.match(re_two)) {
			return -1;
		}
	}
}
String.prototype.isHourMinute = function()
{
    var t = this.split(":");
    if(t.length != 2
    || t[0].length != 2
    || t[1].length != 2
    || !t[0].isNumber()
    || !t[1].isNumber()
    || parseInt(t[0]) < 0
    || parseInt(t[1]) < 0
    || parseInt(t[0]) > 24
    || parseInt(t[1]) > 59)
    {
      return false;
    }else{
        return true;
    }
}

String.prototype.isNumber = function() {
	var str = this.trim();	
	var regEx=/^[0-9]+$/;
	return regEx.test(str);
}

String.prototype.isPriceInteger = function() {
    var str = this.removeAllSpaces();  
    var regEx=/^[0-9]+$/;
    return regEx.test(str);
}
String.prototype.isPriceAllowNegative = function() {
    var str = this.removeAllSpaces();  
    var regEx=/^\-?[0-9]+$/;
    return regEx.test(str);
}

String.prototype.isFloat = function() {
	/*
	var str = this.trim();
	var regEx=/^[0-9.]+$/;
	return regEx.test(str);
	*/
	/*MODIFIED BY FB*/
	return /^\d+([.]\d+)?$/.test(this.trim());
}

String.prototype.isAlpha = function() {
	var str = this.trim();
	var regEx=/^[A-Za-z]+$/;
	return regEx.test(str);
}

String.prototype.isAlphaNumeric = function() {
	var str = this.trim();
	return /^[a-zA-Z0-9_\d]+$/.test(str);
};

String.prototype.isDate = function(){
	var str = this.trim();
	var datePattern = /^\d{1,2}[\/-]\d{1,2}[\/-]\d{4}$/;
	return datePattern.test(str);
}

String.prototype.addSlashes = function(){
	//return this.replace(/\\/g,"\\\\").replace(/\'/g,"\\'").replace(/\"/g,"\\\"");
	return this.replace(/("|'|\\)/g, "\\$1");
}
String.prototype.stripSlashes = function(){
	return this.replace(/\\("|'|\\)/g, "$1");
}
String.prototype.removeAccents = function() {
	var str = this.replace(/[√°√†√¢√£√§]/g, "a");
	str = str.replace(/[√©√®√™√´]/g, "e");
	str = str.replace(/[√≠√¨√Æ√Ø]/g, "i");
	str = str.replace(/[√≥√≤√¥√µ√∂]/g, "o");
	str = str.replace(/[√∫√π√ª√º]/g, "u");
	str = str.replace(/[√Ω√ø]/g, "y");
	str = str.replace(/[√ß]/g, "c");
	str = str.replace(/[√±]/g, "n");
	
	str = str.replace(/[√Å√Ä√Ç√É√Ñ]/g, "A");
	str = str.replace(/[√â√à√ä√ã]/g, "E");
	str = str.replace(/[√ç√å√é√è]/g, "I");
	str = str.replace(/[√ì√í√î√ï√ñ]/g, "O");
	str = str.replace(/[√ö√ô√õ√ú]/g, "U");
	str = str.replace(/[√ù]/g, "Y");
	str = str.replace(/[√á]/g, "C");
	str = str.replace(/[√ë]/g, "N");
	return str;
}

String.prototype.isNull = function() {
	return (this.trim()=='');
}

Object.extend(Number.prototype, {
  to2Digits: function() {
    var digits = this.toString();
    return (digits.length==1) ? ('0'+digits) : digits;
  }
});




function activateRoundedCorners() {
	var defaultBorder = RUZEE.ShadedBorder.create({corner:6, border:1, edges:"blr"});
	$$('.roundCorners').each(function(item){
	    item.addClassName("blockTitle");
		item.addClassName("sb");
		defaultBorder.render(item);
	});
	
	var blockBorder = RUZEE.ShadedBorder.create({corner:6, border:1, edges:"tlr"});
	$$('.blockBorder').each(function(item){
		item.addClassName("blockPave");
		item.addClassName("sb");
		blockBorder.render(item);
	});
	
	$$('.pave').each(function(item){
        roundPave(item);
    });
	
	$$('.round').each(function(item){
		roundItem(item);
	});
}

function roundItem(item){
    var params = {};
    if (item.getAttribute("corner")) params.corner = parseInt(item.getAttribute("corner"));
    if (item.getAttribute("border")) params.border = parseInt(item.getAttribute("border"));
    if (item.getAttribute("edges")) params.edges = item.getAttribute("edges");
    item.addClassName("sb");
    RUZEE.ShadedBorder.create(params).render(item);
}

function roundPave(item, disable){
     var blockPave = RUZEE.ShadedBorder.create({corner:6, border:1, edges:"tlr"});
     
     var titleLeft = Element.select(item,".pave_titre_gauche");
     var titleRight = Element.select(item,".pave_titre_droite");

     if(item.bAllReadyRounded == true)
     {
         return;
     } else {
         item.bAllReadyRounded = true;
     }

     var parentDiv = item.parentNode;
     var div = document.createElement("div");
     Element.addClassName(div, "blockBorder");
     Element.addClassName(div, "blockPave");
     Element.addClassName(div, "sb");

     var spanLeft = document.createElement("span");
     spanLeft.style.cssFloat = 'left'; 
     spanLeft.style.styleFloat = 'left'; 
     for(var i=0;i<titleLeft.length;i++){
         if(titleLeft[i].hasChildNodes()){
             for (var z=0; z<titleLeft[i].childNodes.length; z++) {
                var onclickfunc = titleLeft[i].childNodes[z].onclick;
                var n = titleLeft[i].childNodes[z].cloneNode(true);
                if(isNotNull(onclickfunc))
                   n.onclick = onclickfunc;
                spanLeft.appendChild(n);
             }
         }
         try{Element.remove(titleLeft[i].parentNode);}catch(e){}
     }
     div.appendChild(spanLeft);

     var spanRight = document.createElement("span");
     spanRight.style.cssFloat = 'right'; 
     spanRight.style.styleFloat = 'right'; 
     for(var i=0;i<titleRight.length;i++){
         if(titleRight[i].hasChildNodes()){
	         for (var z=0; z<titleRight[i].childNodes.length; z++) {
	            var onclickfunc = titleRight[i].childNodes[z].onclick;
	            var n = titleRight[i].childNodes[z].cloneNode(true);
	            if(isNotNull(onclickfunc))
	               n.onclick = onclickfunc;
	            spanRight.appendChild(n);
	         }
	     }
         try{Element.remove(titleRight[i].parentNode);}catch(e){}
     }
     var divClear = document.createElement("div");
     divClear.style.clear="both";

     div.appendChild(spanLeft);
     div.appendChild(spanRight);
     div.appendChild(divClear);

     parentDiv.insertBefore(div, item);
     if(!disable)
        blockPave.render(div);
}

function activateDisableOnClick() {
	$$('.disableOnClick').each(function(btn){
		Event.observe(btn, 'click', function(){
			btn.disabled = true;
		});
	});
}

function enableTabLinks(){
    $$("a.dataType-tablink").each(function(item){
        enableTabLink(item);
    });
}
function enableTabLink(item){
    var onclick = item.onclick;
    var link = item.href;

    if(!isNotNull(onclick)){
        item.href = "#";
        item.onclick = function(){
            if(parent.addParentTabForced)
                parent.addParentTabForced("Chargement...",link);
            else
                mt.html.addTabForced("Chargement...",link);
        }
    }
}

function enableCheckboxMultipleFields(){
    $$("input.dataType-checkbox2").each(function(item){
        enableCheckboxMultipleField(item,2);
    });
    $$("input.dataType-checkbox3").each(function(item){
        enableCheckboxMultipleField(item,3);
    });
    $$("input.dataType-checkbox4").each(function(item){
        enableCheckboxMultipleField(item,4);
    });
    $$("input.dataType-checkbox5").each(function(item){
        enableCheckboxMultipleField(item,5);
    });
}

function enableCheckboxMultipleField(input, size){
    var cbStateEmpty = 0;
    var cbStateChecked = 1; 
    var cbStateFull = 2;
    var cbStateFullBis = 3;
    var cbStateFullTer = 4;
    var size = (isNotNull(size)?size:3);
    
    input.type="hidden";
    var span = document.createElement("span");
    span.id = "span_"+input.id;
    span.className = "checkbox"+size;
    span.style.backgroundPosition= "-"+(input.value*13)+"px 0";
    span.innerHTML = "&nbsp;";
    
    input.parentNode.insertBefore(span, input);
    if(!input.value.isNumber() || input.value.isNull())
        input.value=0;

    span.onclick = function(){
       if(input.value == (size-1))
           input.value = 0;
       else
           input.value ++;

       span.style.backgroundPosition= "-"+(input.value*13)+"px 0";
       if(isNotNull(input.onclick)) input.onclick(span);
    }
}
function updateCheckboxMultipleFields(){
    $$("input.dataType-checkbox2").each(function(item){
        updateCheckboxMultipleField(item);
    });
    $$("input.dataType-checkbox3").each(function(item){
        updateCheckboxMultipleField(item);
    });
    $$("input.dataType-checkbox4").each(function(item){
        updateCheckboxMultipleField(item);
    });
    $$("input.dataType-checkbox5").each(function(item){
        updateCheckboxMultipleField(item);
    });
}
function updateCheckboxMultipleField(input){
    var span = $("span_"+input.id);
    span.style.backgroundPosition= "-"+(input.value*13)+"px 0";
}
function useLoadingMessage() {
  dwr.engine.setPreHook(function() {
	  if(mt.config.enableAutoLoading) openGlobalLoader();
  });
  dwr.engine.setPostHook(function() {
	  if(mt.config.enableAutoLoading) closeGlobalLoader();
  });
}
/* ======== DEFAULT START ACTIONS ======== */

onPageLoad = function(){};

FastInit.addOnLoad(function() {
    mt.css.loadDocumentSize();
    
    if(mt.config.enableAutoLoading) useLoadingMessage();
	if (mt.config.enableTabs) mt.html.applyTabEvents();
    
    try{
    mt.html.enableSuperCombos();
    
    if(mt.config.enableDateFieldAuto) enableDateFields();
    else enableDateFieldsOnClick();
    
    enableFormFieldsValidation();
    if(mt.config.enableAutoRoundPave){
       activateRoundedCorners();
    }
    activateDisableOnClick();
    //activateImagesReflections();
    enableCheckboxMultipleFields();
    enableTabLinks();
    }catch(e){alert(e);}

    try{if(mt.config.enableTabTitle) mt.html.updateTabTitle();}
    catch(e){}

    try{dwr.engine.setErrorHandler(openGlobalException);}
    catch(e){}
    try {onPageLoad();} catch(e){alert("onPageLoad error : "+e);}

});

Event.observe(window, 'resize', function(){
	if(mt.config.enableAutoRoundPave){
	   activateRoundedCorners();
	}
});



/* ======== DATE HANDLING ======== */
function enableFormFieldsValidation() {
	$$('form.validate-fields').each(function(form){
		form.ajaxBeforeControlExec = false;
		form.onsubmit = function() {
			mt.utils.clearAllFormFieldMsg();
			
			var self = this;
			try {
				var isValid = this.isValid();
			} catch(e){
				var isValid = true;
			}
			
			var indexTabActive;
			var isTabForm = false;
			var tabError = new Array();
			var iCountTab;
			if(Element.hasClassName(form,"validate-fields-tabs")){
                isTabForm = true;
                indexTabActive = mt.html.getIndexTabActive();
                iCountTab = mt.html.getCountTab();
			}
			
			this.checkElement = function (item) {
			    //alert(item.name+"/"+item.value+"/"+item.value.isNull());
			    item.isValid = true;
                item.error = "";
               
                var printMsg = true;
                if(isTabForm && !Element.hasClassName(item,"tab_field_index_"+indexTabActive)){
                    printMsg = false;
                }            
                
				if (Element.hasClassName(item, 'dataType-notNull')) {
					if (item.value.isNull()) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[1]);
						isValid = false;
						item.isValid = false;
						item.error = MESSAGE_RUNJS_FormFieldsValidation[1];
					}
				}
				
				if (Element.hasClassName(item, 'dataType-notNull')
				&& Element.hasClassName(item, 'dataType-id')
				&& Element.hasClassName(item, 'dataType-integer')) {
                    if ((!item.value.isNull() && item.value.isNumber() && parseInt(item.value)<=0)) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[1]);
                        isValid = false;
                        item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[1];
                    }
                }
				
				if (Element.hasClassName(item, 'dataType-email')) {
					if (!item.value.isEmail() && !item.value.isNull()) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[2]);
						isValid = false;
						item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[2];
					}
				}
				
				if (Element.hasClassName(item, 'dataType-integer')) {
					if (!item.value.isNumber() && !item.value.isNull()) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[3]);
						isValid = false;
						item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[3];
					}
				}
				
				if (Element.hasClassName(item, 'dataType-price')) {
                    if (!item.value.isPriceInteger() && !item.value.isNull()) {
                        if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[9]);
                        isValid = false;
                        item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[3];
                    }
                }
				
				if (Element.hasClassName(item, 'dataType-price-negative')) {
                    if (!item.value.isPriceAllowNegative() && !item.value.isNull()) {
                        if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[9]);
                        isValid = false;
                        item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[3];
                    }
                }
				
				if (Element.hasClassName(item, 'dataType-float')) {
					if (!item.value.isFloat() && !item.value.isNull()) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[3]);
						isValid = false;
						item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[3];
					}
				}
				
				if (Element.hasClassName(item, 'dataType-alpha')) {
					if (!item.value.isAlpha() && !item.value.isNull()) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[4]);
						isValid = false;
						item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[4];
					}
				}
				
				if (Element.hasClassName(item, 'dataType-alphaNumeric')) {
					if (!item.value.isAlphaNumeric() && !item.value.isNull()) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[5]);
						isValid = false;
						item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[5];
					}
				}
				
				if (Element.hasClassName(item, 'dataType-date')) {
					if (!item.value.isDate() && !item.value.isNull()) {
						if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[6]);
						isValid = false;
						item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[6];
					}
				}
				if (Element.hasClassName(item, 'dataType-hour-minute')) {
                    if (!item.value.isHourMinute() && !item.value.isNull()) {
                        if(printMsg) mt.utils.displayFormFieldMsg(item, MESSAGE_RUNJS_FormFieldsValidation[11]);
                        isValid = false;
                        item.isValid = false;
                        item.error = MESSAGE_RUNJS_FormFieldsValidation[11];
                    }
                }
				
				if (item.className.indexOf('dataType-minLength')!=-1) {
					item.classNames().each(function(c){
						if (c.indexOf('dataType-minLength')!=-1) {
							var length = c.split("-")[2];
							if (item.value.length<length) {
								if(printMsg) mt.utils.displayFormFieldMsg1Param(item, MESSAGE_RUNJS_FormFieldsValidation[7], length);
								isValid = false;
								item.isValid = false;
                                item.error = MESSAGE_RUNJS_FormFieldsValidation[7];
							}
							throw $break;
						}
					});
				}
				
				if (item.className.indexOf('dataType-maxLength')!=-1) {
                    item.classNames().each(function(c){
                        if (c.indexOf('dataType-maxLength')!=-1) {
                            var length = c.split("-")[2];
                            if (item.value.length>length) {
                                if(printMsg) mt.utils.displayFormFieldMsg1Param(item, MESSAGE_RUNJS_FormFieldsValidation[10], length);
                                isValid = false;
                                item.isValid = false;
                                item.error = MESSAGE_RUNJS_FormFieldsValidation[10];
                            }
                            throw $break;
                        }
                    });
                }
				
				if(isTabForm){
				    for(var iTab=0;iTab<iCountTab;iTab++){
				        if(Element.hasClassName(item,"tab_field_index_"+iTab)
				        && !item.isValid){
				            tabError[iTab] = true;
				        }
				    }
				}
			}
			
			//$$("input:not([type~=hidden])").each(checkElement);
			//PAS BON CA RECUEPERE TOUT $$("input").each(self.checkElement);
			$A(form.getElementsByTagName("input")).each(self.checkElement);
			//PAS BON CA RECUEPERE TOUT $$("textarea").each(self.checkElement);
			$A(form.getElementsByTagName("textarea")).each(self.checkElement);
			//PAS BON CA RECUEPERE TOUT $$("select").each(self.checkElement);		
			$A(form.getElementsByTagName("select")).each(self.checkElement);
			//PAS BON CA RECUEPERE TOUT $$("button").each(self.checkElement);  
			$A(form.getElementsByTagName("button")).each(self.checkElement);
			
			if(isTabForm){
                onTabChangeAddAction = function(index, id){
                    mt.utils.clearAllFormFieldMsg();
                    indexTabActive = mt.html.getIndexTabActive();
                    $$("input.tab_field_index_"+index).each(self.checkElement);
                    $$("textarea.tab_field_index_"+index).each(self.checkElement);
                    $$("select.tab_field_index_"+index).each(self.checkElement);       
                    $$("button.tab_field_index_"+index).each(self.checkElement);
                }
                for(var iTab=0;iTab<iCountTab;iTab++){
                   if(tabError[iTab] == true){
                        var tab = mt.html.getTabTitle(iTab);
                        //mt.utils.displayFormFieldMsg(tab, MESSAGE_RUNJS_FormFieldsValidation[8]);
                        mt.utils.displayFormTabError(tab);
                   }
                }
            }
			
			/**
			 * la fonction ajaxBeforeControl est executee juste apres le this.isValid();
			 * si elle retourne true alors on execute le traitement classique :
			 * this.isValid() est exÈcutÈ ‡ nouveau et on passe dans le else
			 * (form.ajaxBeforeControlExec = true; et du coup on passe dans le else)
			 */
			if(form.ajaxBeforeControl && !form.ajaxBeforeControlExec){
				 form.ajaxBeforeControl(function(result){
				     if(result){
				        form.ajaxBeforeControlExec = true;
				        var authorizeSubmit = form.onsubmit();
				        if(authorizeSubmit){
				            form.submit();
				        }
				     }				     
				 });
				 return false;
			}else{
			    form.ajaxBeforeControlExec = false;
				if (this.onIncompleteSubmit && !isValid) {
					/**
					 * si une fonction onIncompleteSubmit existe et que le formulaire n'est pas valide
					 * alors on execute onIncompleteSubmit et on retourne son resultat
					 * attention a faire un return false si on fait un traitement ajax
					 * car sinon ca va poster le form
					 */
	                return this.onIncompleteSubmit();
	            }else if (this.onValidSubmit && isValid) {
					/**
					 * si une fonction onValidSubmit existe et que le formulaire est valide
					 * alors on execute onValidSubmit et on retourne son resultat
					 * attention a faire un return false si on fait un traitement ajax
					 * car sinon ca va poster le form
					 */
					return this.onValidSubmit();
				} else {
					/**
					 * sinon on retourne le resultat isValid du traitement classique
					 */
					return isValid;
				}
		    }
		}
		
	});	
}
function enableDateField(item){
	var span = document.createElement("span");
	var input = item.cloneNode(true);
	var self = this;
	var currentDate = input.value;

	span.appendChild(input);
	item.parentNode.insertBefore(span, item);
	Element.remove(item);

	span.style.position = "relative";

	var calframe = document.createElement("div");
	calframe.style.position = "absolute";
	calframe.style.left = 0;
	Element.hide(calframe);

	var calendar = new mt.component.Calendar(calframe);
	input.onSelect = function(date){};
	input.getSelectedDate = function(){return calendar.getSelectedDate();};
	
	function applyValueDate() {
		if (!input.value.isNull() && input.value.isDate()) {
			var d = input.value.trim().split("/");
            var date = new Date(parseFloat(d[2]), parseFloat(d[1])-1, parseFloat(d[0]));
            calendar.setSelectedDate(date);
            input.onSelect(date);
		}
	}

	applyValueDate();
	
	calendar.onSelect = function(date) {
		input.value = date.getDate().to2Digits()+"/"+(date.getMonth()+1).to2Digits()+"/"+date.getFullYear();
		currentDate = input.value;
		hideCalendar();
		input.onSelect(date);
	}
	
	calendar.clean = function(){
	    input.value = "";
        currentDate = input.value;
        hideCalendar();
	}
	calendar.render();
	
	function hideCalendar() {
		span.style.zIndex = 0;
		//contournerBugSelectIE(calframe,true);
		Element.hide(calframe);
		Event.stopObserving(document.body, 'click', hideCalendar);
	}
	
	input.showCalendar = function(e) {
		try {window.openedPopupCalendarHideFunc();} catch(e){}
		window.openedPopupCalendarHideFunc = hideCalendar;
		span.style.zIndex = 998;
		Element.show(calframe); 
		//contournerBugSelectIE(calframe,true);
		if(e) Event.stop(e);
		setTimeout(function() {
			Event.observe(document.body, 'click', hideCalendar);
		}, 1);
	}
	
	Event.observe(input, 'click', input.showCalendar);
	
	Event.observe(input, 'blur', function() {
		
		
		if (input.value.isDate()) {
			if (currentDate!=input.value) {
				currentDate = input.value;
				applyValueDate();
				calendar.updateCalendar(new Date(calendar.getSelectedDate()));
			}
		} else {
			if (currentDate!=input.value) {
				currentDate = input.value;
				calendar.setSelectedDate(null);
				calendar.updateCalendar(new Date());
			}
		}
	});

	span.appendChild(calframe);
	calframe.style.top = Element.getHeight(input);
	
	return input;
}
function enableDateFields() {
	$$('input.dataType-date').each(function(item){
	enableDateField(item);
	});
}

function enableDateFieldsOnClick() {
    $$('input.dataType-date').each(function(item){
        item.setAttribute("enableDateField",false);
        
        item.onclick = function(){
            var isEnableDateField = item.getAttribute("enableDateField");
            if(isEnableDateField == false || isEnableDateField == "false"){
                item.setAttribute("enableDateField",true);
                var input = enableDateField(item);
                input.showCalendar();
            }
        }
    });
}


/* check http://www.xaprb.com/articles/date-formatting-demo.html */
Date.formatFunctions = {count:0};

Date.prototype.dateFormat = function(format) {
    if (Date.formatFunctions[format] == null) {
        Date.createNewFormat(format);
    }
    var func = Date.formatFunctions[format];
    return eval("this." + func + "();");
}

Date.createNewFormat = function(format) {
    var funcName = "format" + Date.formatFunctions.count++;
    Date.formatFunctions[format] = funcName;
    var code = "Date.prototype." + funcName + " = function(){return ";
    var special = false;
    var char = '';
    for (var i = 0; i < format.length; ++i) {
        char = format.charAt(i);
        if (!special && char == "\\") {
            special = true;
        }
        else if (special) {
            special = false;
            code += "'" + String.escape(char) + "' + ";
        }
        else {
            code += Date.getFormatCode(char);
        }
    }
    eval(code.substring(0, code.length - 3) + ";}");
}

Date.getFormatCode = function(character) {
    switch (character) {
    case "d":
        return "String.leftPad(this.getDate(), 2, '0') + ";
    case "D":
        return "Date.dayNames[this.getDay()].substring(0, 3) + ";
    case "j":
        return "this.getDate() + ";
    case "l":
        return "Date.dayNames[this.getDay()] + ";
    case "S":
        return "this.getSuffix() + ";
    case "w":
        return "this.getDay() + ";
    case "z":
        return "this.getDayOfYear() + ";
    case "W":
        return "this.getWeekOfYear() + ";
    case "F":
        return "Date.monthNames[this.getMonth()] + ";
    case "m":
        return "String.leftPad(this.getMonth() + 1, 2, '0') + ";
    case "M":
        return "Date.monthNames[this.getMonth()].substring(0, 3) + ";
    case "n":
        return "(this.getMonth() + 1) + ";
    case "t":
        return "this.getDaysInMonth() + ";
    case "L":
        return "(this.isLeapYear() ? 1 : 0) + ";
    case "Y":
        return "this.getFullYear() + ";
    case "y":
        return "('' + this.getFullYear()).substring(2, 4) + ";
    case "a":
        return "(this.getHours() < 12 ? 'am' : 'pm') + ";
    case "A":
        return "(this.getHours() < 12 ? 'AM' : 'PM') + ";
    case "g":
        return "((this.getHours() %12) ? this.getHours() % 12 : 12) + ";
    case "G":
        return "this.getHours() + ";
    case "h":
        return "String.leftPad((this.getHours() %12) ? this.getHours() % 12 : 12, 2, '0') + ";
    case "H":
        return "String.leftPad(this.getHours(), 2, '0') + ";
    case "i":
        return "String.leftPad(this.getMinutes(), 2, '0') + ";
    case "s":
        return "String.leftPad(this.getSeconds(), 2, '0') + ";
    case "O":
        return "this.getGMTOffset() + ";
    case "T":
        return "this.getTimezone() + ";
    case "Z":
        return "(this.getTimezoneOffset() * -60) + ";
    default:
        return "'" + String.escape(character) + "' + ";
    }
}

Date.prototype.getTimezone = function() {
    return this.toString().replace(
        /^.*? ([A-Z]{3}) [0-9]{4}.*$/, "$1").replace(
        /^.*?\(([A-Z])[a-z]+ ([A-Z])[a-z]+ ([A-Z])[a-z]+\)$/, "$1$2$3");
}

Date.prototype.getGMTOffset = function() {
    return (this.getTimezoneOffset() > 0 ? "-" : "+")
        + String.leftPad(Math.floor(this.getTimezoneOffset() / 60), 2, "0")
        + String.leftPad(this.getTimezoneOffset() % 60, 2, "0");
}

Date.prototype.getDayOfYear = function() {
    var num = 0;
    Date.daysInMonth[1] = this.isLeapYear() ? 29 : 28;
    for (var i = 0; i < this.getMonth(); ++i) {
        num += Date.daysInMonth[i];
    }
    return num + this.getDate() - 1;
}

Date.prototype.getWeekOfYear = function() {
    // Skip to Thursday of this week
    var now = this.getDayOfYear() + (4 - this.getDay());
    // Find the first Thursday of the year
    var jan1 = new Date(this.getFullYear(), 0, 1);
    var then = (7 - jan1.getDay() + 4);
    document.write(then);
    return String.leftPad(((now - then) / 7) + 1, 2, "0");
}

Date.prototype.isLeapYear = function() {
    var year = this.getFullYear();
    return ((year & 3) == 0 && (year % 100 || (year % 400 == 0 && year)));
}

Date.prototype.getFirstDayOfMonth = function() {
    var day = (this.getDay() - (this.getDate() - 1)) % 7;
    return (day < 0) ? (day + 7) : day;
}

Date.prototype.getLastDayOfMonth = function() {
    var day = (this.getDay() + (Date.daysInMonth[this.getMonth()] - this.getDate())) % 7;
    return (day < 0) ? (day + 7) : day;
}

Date.prototype.getDaysInMonth = function() {
    Date.daysInMonth[1] = this.isLeapYear() ? 29 : 28;
    return Date.daysInMonth[this.getMonth()];
}

Date.prototype.getSuffix = function() {
    switch (this.getDate()) {
        case 1:
        case 21:
        case 31:
            return "st";
        case 2:
        case 22:
            return "nd";
        case 3:
        case 23:
            return "rd";
        default:
            return "th";
    }
}
Date.prototype.addMonth = function (nbMonth){
    var addYears = Math.floor(nbMonth/12);
    var addMonths = nbMonth - (addYears * 12);
    var newMonth = this.getMonth() + addMonths;
    if (this.getMonth() + addMonths > 11) {
      ++addYears;
      newMonth = this.getMonth() + addMonths - 12;
    }
    this.setMonth(newMonth);
    this.setFullYear(this.getFullYear()+addYears);

}
/**
 * 0 si date1 = date2
 * 1 si date1 > date2
 * -1 si date1 < date2
 */
Date.compare = function(date1,date2){
	var diff = date1.getTime()-date2.getTime();
    return (diff==0?diff:diff/Math.abs(diff));
}

Date.compareStringDate = function(sDate1,sDate2){
	if (isNotNull(sDate1) && isNotNull(sDate2)) {
        var date1 = Date.parseShortDate(sDate1);
        var date2 = Date.parseShortDate(sDate2);
        
        return Date.compare(date1,date2);
	}
}
Date.parseShortDate = function(sDate){
	if (isNotNull(sDate)) {
		var d = sDate.trim().split("/");
        var date = new Date(parseFloat(d[2]), parseFloat(d[1])-1, parseFloat(d[0]));
        return date;
	}
}


String.escape = function(string) {
    return string.replace(/('|\\)/g, "\\$1");
}

String.leftPad = function (val, size, char) {
    var result = new String(val);
    if (char == null) {
        char = " ";
    }
    while (result.length < size) {
        result = char + result;
    }
    return result;
}

Date.daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31];
Date.monthNames =
   ["January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"];
Date.dayNames =
   ["Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"];
Date.patterns = {
    ISO8601LongPattern:"Y-m-d H:i:s",
    ISO8601ShortPattern:"Y-m-d",
    ShortDatePattern: "n/j/Y",
    LongDatePattern: "l, F d, Y",
    FullDateTimePattern: "l, F d, Y g:i:s A",
    MonthDayPattern: "F d",
    ShortTimePattern: "g:i A",
    LongTimePattern: "g:i:s A",
    SortableDateTimePattern: "Y-m-d\\TH:i:s",
    UniversalSortableDateTimePattern: "Y-m-d H:i:sO",
    YearMonthPattern: "F, Y"};

Date.parseIsoDate = function(dateString) {
    var result = new Date();
    var re = /^(\d\d\d\d)-(\d\d)-(\d\d)( (\d\d):(\d\d):(\d\d)).(\d)*$/;
    var re2 = /^(\d\d\d\d)-(\d\d)-(\d\d)( (\d\d):(\d\d):(\d\d))?$/;
    var match = dateString.match(re) || dateString.match(re2);
    if (match != null) {
        if (match[5] != null && match[5] != '') {
            result = new Date(
                parseInt(match[1], 10),
                parseInt(match[2], 10) - 1,
                parseInt(match[3], 10),
                parseInt(match[5], 10),
                parseInt(match[6], 10),
                parseInt(match[7], 10));
        }
        else {
            result = new Date(
                parseInt(match[1], 10),
                parseInt(match[2], 10) - 1,
                parseInt(match[3], 10));
        }
    }
    return result;
}

// check this regexp later
/*
Object.prototype.parseISODate = function(sDate) {
	if (sDate.match(/(\d{4})-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])T(0[0-9]|1[0-9]|2[0-4]):(0[0-9]|[1-5][0-9]):(0[0-9]|[1-5][0-9]).(\d{3})(Z)/)) {
		var t = Date.parse(RegExp.$2 + "/" + RegExp.$3 + "/" + RegExp.$1 + " " + RegExp.$4 + ":" + RegExp.$5 + ":" + RegExp.$6);
		if (RegExp.$7 != "")
			t += parseInt(RegExp.$7);
		return t
		}
		else
		{
		if (sDate.match(/(\d{4})-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])/))
		return Date.parse(RegExp.$2 + "/" + RegExp.$3 + "/" +
		RegExp.$1);
		else
		return Date.parse(sDate)
	}
}
*/

/**
 * @deprecated
 */
/*
function getElementsByClassName(node, className) {
	var children = node.getElementsByTagName('*');
	var elements = new Array();
	for (var i=0; i<children.length; i++) {
		var child = children[i];
		var classNames = child.className.split(' ');
		for (var j = 0; j < classNames.length; j++) {
			if (classNames[j] == className) {
				elements.push(child);
				break;
			}
		}
	}
	return elements;
}
*/

function compareInt(int1,int2){
	var diff = int1-int2;
    return (diff==0?diff:diff/Math.abs(diff));
}

function isNotNull(item) {
	if (item==null || item=="" || item=="undefined" || item=="null") return false;
	return true;
}

function isNotNullAcceptBlank(item) {
    if (item==null || item=="undefined" || item=="null") return false;
    return true;
}


function isAlphabet(elem, helperMsg){
	var alphaExp = /^[a-zA-Z]+$/;
	if(elem.value.match(alphaExp)){
		return true;
	}else{
		alert(helperMsg);
		elem.focus();
		return false;
	}
}

function isAlphanumeric(elem, helperMsg){
	var alphaExp = /^[0-9a-zA-Z]+$/;
	if(elem.value.match(alphaExp)){
		return true;
	}else{
		alert(helperMsg);
		elem.focus();
		return false;
	}
}

function displayURL(sUrl) {
	if (arguments.length==2) {
		frames[arguments[1]].location.href = sUrl;
	} else {
		location.href = sUrl;
	}
}

Element.addMethods({  
  getInnerText: function(element) {
    element = $(element);
    return element.innerText && !window.opera ? element.innerText
      : element.innerHTML.stripScripts().unescapeHTML().replace(/[\n\r\s]+/g, ' ');
  }
});

function getCheckedValue(radioObj) {
	if(!radioObj)
		return "";
	var radioLength = radioObj.length;
	if(radioLength == undefined)
		if(radioObj.checked)
			return radioObj.value;
		else
			return "";
	for(var i = 0; i < radioLength; i++) {
		if(radioObj[i].checked) {
			return radioObj[i].value;
		}
	}
	return "";
}

// Fonction permettant d'ins?rer du texte dans un champ ? la position du curseur
// NB : sIdChamp est l'id du champ
function insererTexteApresCurseur(sTexteAInserer, sIdChamp) { 
	var textField = document.getElementById(sIdChamp); 
	sTexteAInserer = sTexteAInserer.replace(/<br>/gi, "\n").replace(/<br\/>/gi, "\n").replace(/<br \/>/gi, "\n").replace(/<\/p>/gi, "\n").replace(/<p>/gi, "");

	//IE support 
	if (document.selection) { 
		textField.focus(); 
		var sel = document.selection.createRange(); 
		sel.text = sTexteAInserer;
	} 
	//MOZILLA/NETSCAPE support 
	else if (textField.selectionStart || textField.selectionStart == "0") {
		var startPos = textField.selectionStart; 
		var endPos = textField.selectionEnd; 
		var sChaine = textField.value; 
		textField.value = sChaine.substring(0, startPos) + sTexteAInserer 
			+ sChaine.substring(endPos, sChaine.length); 
	} else { 
		textField.value += sTexteAInserer; 
	} 
}


/**
* ADDED BY JR
*/
document.viewport = {
  getDimensions: function() {
    var dimensions = { };
    $w('width height').each(function(d) {
      var D = d.capitalize();
      dimensions[d] = self['inner' + D] ||
       (document.documentElement['client' + D] || document.body['client' + D]);
    });
    return dimensions;
  },

  getWidth: function() {
    return this.getDimensions().width;
  },

  getHeight: function() {
    return this.getDimensions().height;
  },

  getScrollOffsets: function() {
    return Element._returnOffset(
      window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft,
      window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop);
  }
};

function contournerBugSelectIE(sIdDiv,isElement,force){
    // recuperation des dimensions du div
    var oDiv = (isElement)?sIdDiv:$(sIdDiv);
    var x=0; var y=0; var oDivp; 
    if(oDiv.offsetParent){ 
        oDivp=oDiv; 
        while(oDivp.offsetParent){ 
            oDivp=oDivp.offsetParent;
            x+=oDivp.offsetLeft; 
            y+=oDivp.offsetTop; 
        } 
    } 
    x+=oDiv.offsetLeft; 
    y+=oDiv.offsetTop;
    w=oDiv.offsetWidth; 
    h=oDiv.offsetHeight;

    // on verifie qu'il s'agit bien de IE
    var appVer = navigator.appVersion.toLowerCase(); 
    var iePos = appVer.indexOf('msie'); 
    if (iePos !=-1) { 
        var is_minor = parseFloat(appVer.substring(iePos+5,appVer.indexOf(';',iePos))); 
        var is_major = parseInt(is_minor); 
    } 
    if (navigator.appName.substring(0,9) == "Microsoft" || force){ // Check if IE version is 6 or older 
        if (is_major <= 6 || force) {
            var selx,sely,selw,selh,i 
            var sel=document.getElementsByTagName("SELECT")
            for(i=0;i<sel.length;i++){ 
                selx=0; sely=0; var selp; 
                if(sel[i].offsetParent){ 
                    selp=sel[i]; 
                    while(selp.offsetParent){ 
                        selp=selp.offsetParent;
                        selx+=selp.offsetLeft; 
                        sely+=selp.offsetTop; 
                    } 
                } 
                selx+=sel[i].offsetLeft; 
                sely+=sel[i].offsetTop;
                selw=sel[i].offsetWidth; 
                selh=sel[i].offsetHeight; 
                if(selx+selw>x && selx<x+w && sely+selh>y && sely<y+h){
                    if(sel[i].style.visibility!="hidden") sel[i].style.visibility="hidden"; 
                    else sel[i].style.visibility="visible"; 
                }
            }
        } 
    } 
} 

function getPosTop(obj){
    toreturn = 0;
    while(obj){
        toreturn += obj.offsetTop;
        obj = obj.offsetParent;
    }
    return toreturn;
}
function getPosLeft(obj){
    toreturn = 0;
    while(obj){
        toreturn += obj.offsetLeft;
        obj = obj.offsetParent;
    }
    return toreturn;
}

Math.roundNum = function(n,p) {
 var t = Math.pow(10,p);
 return Math.round(n*t)/t;
}

function displayNumber(fValue, iDecimal, sDecimalSymbol, sDecimalSeparate) {
      // display a formated number
      // example : Math.displayNumber(12345.4449, 3, ",", " ") => 12 345,445
      fValue = Math.roundNum(fValue, iDecimal);
      var sFormatNum = fValue + '';
      var aSplitted = sFormatNum.split('.');
      if (!aSplitted[0]) aSplitted[0] = '0';
      if (!aSplitted[1]) aSplitted[1] = '';

      if (aSplitted[1].length < iDecimal) {
            iComa = aSplitted[1];
            for (var i=aSplitted[1].length + 1; i <= iDecimal; i++) iComa += '0';
            aSplitted[1] = iComa;
      }

      if(sDecimalSeparate != '' && aSplitted[0].length > 3) {
            iUnits = aSplitted[0];
            aSplitted[0] = '';
            for(var j = 3; j < iUnits.length; j+=3) {
                  i = iUnits.slice(iUnits.length - j, iUnits.length - j + 3);
                  aSplitted[0] = sDecimalSeparate + i + aSplitted[0] + '';
            }
            j = iUnits.substr(0, (iUnits.length % 3 == 0) ? 3 : (iUnits.length % 3));
            aSplitted[0] = j + aSplitted[0];
      }

      sDecimalSymbol = (iDecimal <= 0) ? '' : sDecimalSymbol;
      return aSplitted[0] + sDecimalSymbol + aSplitted[1];
}

function displayNumberFrench(fValue){
      return displayNumber(fValue, 2, ",", " ");
}

function displayNumberFrenchDecimal(fValue, iDecimal){
    return displayNumber(fValue, iDecimal, ",", " ");
}
 /** getDisplayedFileSize(iFileSize [, sFormat] [, sDecimalSymbol] [,sDecimalSeparate])
 * Display the file size with unity ;
 * getDisplayedFileSize(380475) give 380 Kb
 * getDisplayedFileSize(380475123456, "o", ",", " ") give  380 475,12 Mo
 */
function getDisplayedFileSize(iFileSize, sFormat, sDecimalSymbol, sDecimalSeparate){
	if (!sFormat) sFormat = "b";
	if (!sDecimalSymbol) sDecimalSymbol = ".";
	if (!sDecimalSeparate) sDecimalSeparate = " ";
    if (Math.floor(iFileSize/1000000)>0){
        return displayNumber(iFileSize/1000000, 2, sDecimalSymbol, sDecimalSeparate)+" M"+sFormat;
    }else if (Math.floor(iFileSize/1000)>0){
    	return displayNumber(iFileSize/1000, 0, sDecimalSymbol, sDecimalSeparate)+" K"+sFormat;
    }
    return displayNumber(iFileSize, 0, sDecimalSymbol, sDecimalSeparate)+" "+sFormat;
}
function htmlEntities(newString,type) {
        
    if(!newString.length) {
       return newString;  
    }
        
    var chars = new Array ('&','‡','·','‚','„','‰','Â','Ê','Á','Ë','È',
                                 "Í",'Î','Ï','Ì','Ó','Ô','','Ò','Ú','Û','Ù',
                                 'ı','ˆ','¯','˘','˙','˚','¸','˝','˛','ˇ','¿',
                                 '¡','¬','√','ƒ','≈','∆','«','»','…',' ','À',
                                 'Ã','Õ','Œ','œ','–','—','“','”','‘','’','÷',
                                 'ÿ','Ÿ','⁄','€','‹','›','ﬁ','ﬂ','<',
                                 '>','¢','£','§','•','¶','ß','®','©','™','´',
                                 '¨','Æ','Ø','∞','±','≤','≥','¥','µ','∂',
                                 '∑','∏','π','∫','ª','º','Ω','æ');
    var entities = new Array ('&amp;','&agrave;','&aacute;','&acirc;','&atilde;','&auml;','&aring;',
                               '&aelig;','&ccedil;','&egrave;','&eacute;','&ecirc;','&euml;','&igrave;',
                               '&iacute;','&icirc;','&iuml;','&eth;','&ntilde;','&ograve;','&oacute;',
                               '&ocirc;','&otilde;','&ouml;','&oslash;','&ugrave;','&uacute;','&ucirc;',
                               '&uuml;','&yacute;','&thorn;','&yuml;','&Agrave;','&Aacute;','&Acirc;',
                               '&Atilde;','&Auml;','&Aring;','&AElig;','&Ccedil;','&Egrave;','&Eacute;',
                               '&Ecirc;','&Euml;','&Igrave;','&Iacute;','&Icirc;','&Iuml;','&ETH;','&Ntilde;',
                               '&Ograve;','&Oacute;','&Ocirc;','&Otilde;','&Ouml;','&Oslash;','&Ugrave;',
                               '&Uacute;','&Ucirc;','&Uuml;','&Yacute;','&THORN;','&szlig;',
                               '&lt;','&gt;','&cent;','&pound;','&curren;','&yen;','&brvbar;','&sect;','&uml;',
                               '&copy;','&ordf;','&laquo;','&not;','&reg;','&macr;','&deg;','&plusmn;',
                               '&sup2;','&sup3;','&acute;','&micro;','&para;','&middot;','&cedil;','&sup1;',
                               '&ordm;','&raquo;','&frac14;','&frac12;','&frac34;','&quot;','&#039;');
    if(type=="json"){
        type = "decode";
        chars.push('\\"'); chars.push('\\\'');
    }else{
        chars.push('\"'); chars.push('\'');
    }
   
    if(type == "decode") {
    var from = chars;   
    var to = entities;
    } else {
    var from = entities;
    var to = chars;
    }

    for (var i = 0; i < from.length; i++)
     {
     try{
       myRegExp = new RegExp();
       myRegExp.compile(to[i],'g');
       newString = newString.replace(myRegExp,from[i]);
       }catch(e){alert(e);}
      }
         
     return newString;           

}

function getFileExtension(sFilename){
	var r = new RegExp("\.([^\.]*$)", "gi");
	var aR = sFilename.match(r);
	if (aR.length==0) return "";
	return (aR[aR.length-1]).toLowerCase(); 
}

function checkFlashVersion(sMinimalVersion, sFlashPluginURL,divCheckFlashVersion,divMain){
    var aTag = document.createElement("a");
    aTag.href = sFlashPluginURL;
    aTag.target = "_blank";
    aTag.innerHTML = "Cliquez ici pour tÈlÈcharger le plugin Flash.";
    var spanTag = document.createElement("span");   
    
    var currentPlayerVersion = deconcept.SWFObjectUtil.getPlayerVersion();
    var requirePlayerVersion = new deconcept.PlayerVersion(sMinimalVersion.split("."));
  	var bValid = currentPlayerVersion.versionIsValid(requirePlayerVersion);

    if (!bValid){
        spanTag.innerHTML = "Afin de pouvoir accÈder ‡ certaines fonctionnalitÈs du site, vous devez installer la derniËre version du plugin Flash. ";
        if (currentPlayerVersion.major > 0) spanTag.innerHTML += "Vous possÈdez la version : "+ currentPlayerVersion.major +"."+ currentPlayerVersion.minor +"."+ currentPlayerVersion.rev +". ";
        spanTag.innerHTML += "Version nÈcessaire : "+sMinimalVersion+" (ou supÈrieure). ";
        divCheckFlashVersion.appendChild(spanTag);
        divCheckFlashVersion.appendChild(aTag);
        divCheckFlashVersion.style.display = "block";
        Element.hide(divMain);
    }
}

function tronquerChaine(sChaineATronquer,iTaille) {
	var sChaineCourte;
	
	if(iTaille < 3 ){
		sChaineCourte = "...";
		return sChaineCourte;
	}
	
	if(sChaineATronquer.length > (iTaille - 3) ){
		sChaineCourte = sChaineATronquer.substring(0, iTaille - 3) + "...";
	}else{
		sChaineCourte = sChaineATronquer;
	}
	
	return sChaineCourte;
}