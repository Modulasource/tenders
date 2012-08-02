/*
	Post-It - Crispin Parker 17/10/2005
*/

var mouseDownObj = null;
var notes = new Array();
var basePath = "http://www.aous36.dsl.pipex.com/PostIt/";
//var basePath = rootPath + "images/";
var g_stickerCurrentZIndex = 1000;

function noteObj(obj, x, y){
	this.element = obj;
	this.x = x;
	this.y = y;
}

function mouseMove(e){
	if(!e)e=window.event;
	var curPos = new getPos(e);
	with(mouseDownObj){
		element.style.left = curPos.x - x + "px";
		element.style.top = curPos.y - y + "px";
	}
	return false;
}

document.onmousedown = function(e){
	if(!e)e=window.event;
	var caller = e.target ? e.target : e.srcElement;
	
	for(i=0;i<notes.length;i++){
		if(caller == notes[i]){
			//bringToTop(caller);
			var x = e.pageX ? e.pageX - caller.offsetLeft : e.offsetX;
			var y = e.pageY ? e.pageY - caller.offsetTop : e.offsetY;
			mouseDownObj = new noteObj(caller, x, y);
			document.onmousemove = mouseMove;
		}else{
			//notes[i].style.zIndex = 0;
		}
	}
	
	return false;
}

document.onmouseup = function(e){
	if(!e)e=window.event;
	
	/**
	 * Save position
	 */
	var caller = e.target ? e.target : e.srcElement;
	x = e.pageX;
	y = e.pageY;
		
	//alert("x=" + x +"y=" + y);

	document.onmousemove = null;

}

function bringToTop(caller){
	var i = 0;
	try{
		for(i=0;i<notes.length;i++){if(!notes[i]==caller)notes[i].style.zIndex = 1;}
		caller.style.zIndex=10;
	}catch(e){
		// empty catch
	}
}
function getPos(e){
	this.x = e.pageX ? e.clientX : e.clientX + document.body.scrollLeft;
	this.y = e.pageY ? e.clientY : e.clientY + document.body.scrollTop;
}



function addStickerOld(){
	var myText = prompt("Tapez la description de votre sticker : ", "");
	if(!myText)return;
	var index = notes.length
	notes[index] = buildPostIt(myText);
	document.body.appendChild(notes[index]);
}

function addSticker(sText){
	var index = notes.length
	notes[index] = buildPostIt(sText);
	document.body.appendChild(notes[index]);
}


function buildPostIt(sticker){
	var div1 = document.createElement("div");
	var a = document.createElement("a");
	var img1 = document.createElement("img");

	img1.src = basePath + "close.gif";
	img1.setAttribute("align", "right");

	a.appendChild(img1);
	a.onmouseover = function(){this.childNodes[0].src=basePath+"closeRed.gif";};
	a.onmouseout = function(){this.childNodes[0].src=basePath+"close.gif";};
	a.lIdSticker = sticker.lId;
	a.onclick = function(){
		if(!confirm("Etes-vous sûr de vouloir supprimer ce sticker ?"))
		{
			return ;
		}
		
		Sticker.removeStatic(
			this.lIdSticker,
			function (s) {
				
			}
		);
		document.body.removeChild(this.parentNode);
	};

	div1.appendChild(a);
	div1.appendChild(document.createTextNode(sticker.sDescription));
	div1.style.cssText = "color: #0000ff; font-family: arial; font-size: 12px; position:absolute; left: " + (20 + (notes.length * 3)) + "px; top: " + (20 + (notes.length * 3)) + "px; width: 140px; height: 110px; border-top: 1px solid #000000; border-left: 1px solid #000000; border-right: none; border-bottm: none; background-color: none; background-image: url(" + basePath + "background.gif); background-position: bottom right; background-repeat: no-repeat; cursor: pointer; cursor: hand;";
	div1.style.zIndex = g_stickerCurrentZIndex;
		
	div1.onclick = function(){
		
	};
		
		
	return div1;
}

function createSticker(
	lIdTypeObject,
	lIdReferenceType,
	lIdTab,
	sUri,
	sParamAction)
{
	var sticker=  {};
	sticker.lIdTypeObject = lIdTypeObject;
	sticker.lIdReferenceType = lIdReferenceType;
	sticker.lIdTab = lIdTab;
	sticker.sUri = sUri;
	sticker.sParamAction = sParamAction;
	sticker.sDescription = "Nouveau sticker";
	
	Sticker.createJSONObjectString(
		Object.toJSON(sticker),
		function (s) {
			var obj = s.evalJSON();
			addSticker(obj);
		}
	);


}



