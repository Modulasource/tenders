/*
	Réalisé par oli.
	http://blog.oli-web.com
*/

var isDragging = false;
var objectToDrag;
var obj;
var ecartX;
var ecartY;
var curX;
var curY;

function positionne(p_id, p_posX, p_pos_Y){
	document.getElementById(p_id).style.left = p_posX;
	document.getElementById(p_id).style.top = p_pos_Y;
}




function getPositionCurseur(e){
	//ie
	if(document.all){
		curX = event.clientX;
		curY = event.clientY;
	}

	//netscape 4
	if(document.layers){
		curX = e.pageX;
		curY = e.pageY;
	}

	//mozilla
	if(document.getElementById){
		curX = e.clientX;
		curY = e.clientY;
	}
}

function beginDrag(p_obj,e){
	isDragging = true;
	objectToDrag = p_obj;
	getPositionCurseur(e);
	ecartX = curX - parseInt(objectToDrag.style.left);
	ecartY = curY - parseInt(objectToDrag.style.top);
}

function drag(e){
	var newPosX;
	var newPosY;
	if(isDragging == true){

		getPositionCurseur(e);
		newPosX = curX - ecartX;
		newPosY = curY - ecartY;

		objectToDrag.style.left = newPosX + 'px';
		objectToDrag.style.top = newPosY + 'px';

	}

}

function endDrag(){
	isDragging = false;
}