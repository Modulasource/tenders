function montrer(_id){    // dévoile la partie
	if ( document.getElementById(_id) == null)
	{
		return;
	}
	document.getElementById(_id).style.display = '';
	document.getElementById(_id).style.visibility = "visible";
}
function cacher(_id){    // cache la partie
	if ( document.getElementById(_id) == null)
	{
		return;
	}
	
	document.getElementById(_id).style.display = 'none';
	document.getElementById(_id).style.visibility = "hidden";
}
function montrer_cacher(_id){    // cache la partie si elle est visible et réciproquement
	if ( document.getElementById(_id) == null)
	{
		return;
	}

		if (document.getElementById(_id).style.display == 'none'){
		montrer(_id);
	}else{
		cacher(_id);
	}
}


function upTopEl(theDiv) {
	theDiv = getRefToDiv(theDiv);

	if( !theDiv ) { window.alert( 'Nothing works in this browser.' ); return; }
	if( theDiv.style ) { theDiv = theDiv.style; }
	theDiv.zIndex = 3000;
}


function doNuhn() {}


function getRefToDiv(divID) {
	if( document.layers ) { return document.layers[divID+'C'].document.layers[divID]; }
	if( document.getElementById ) { return document.getElementById(divID); }
	if( document.all ) { return document.all[divID]; }
	if( document[divID+'C'] ) { return document[divID+'C'].document[divID]; }
	return false;
}
