function checkObjet(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "sReference"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la r?f?rence de l'affaire");
		item.focus();
        return false;
	}
	
	item = form.elements[sFormPrefix + "sObjet"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir l'objet du march?");
		item.focus();
        return false;
	}
	else{
		if(item.value.length<5){
			alert("Le champ \"objet du march?\" doit faire au moins 5 caract?res");
			return false;	
		}
	}
	return true;
}