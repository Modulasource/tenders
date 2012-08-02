function showDHTMLPopup(divisionName){
    var popupEnCour = document.getElementById(divisionName);
    popupEnCour.style.display = "block";
    popupEnCour.style.visibility = "visible";
 	var fondModal = document.getElementById('fondModal');
    fondModal.setAttribute('class','fondModal');
    fondModal.setAttribute('className', 'fondModal');
	fondModal.onclick = function(){
		hideDHTMLPopup(divisionName);
	}
  // 	popupEnCour.setAttribute('class', 'divModifierCellule');
    popupEnCour.setAttribute('className', 'divModifierCellule');
    
    // Positionnement du calque au niveau du scrolling de la page
	if (document.all){ 
		popupEnCour.style.top = (document.documentElement.scrollTop+250)+"px";
		popupEnCour.style.left = (document.documentElement.scrollLeft+250)+"px";
	}else{
		popupEnCour.style.top = (window.pageYOffset+250)+"px";
	}
		popupEnCour.style.left = ((screen.width)-(popupEnCour.style.width).replace("px",""))/2-220+"px";
}


// Fonction js qui ferme la popup :
function hideDHTMLPopup (divisionName) {
	var fondModal = document.getElementById('fondModal');
	fondModal.setAttribute('class', '');
	fondModal.setAttribute('className', '');
	
	var popupACacher = document.getElementById(divisionName);
	popupACacher.setAttribute('className', '');
	popupACacher.setAttribute('class', '');
	popupACacher.style.display = "none";
	
}