function checkObjet(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "sReference"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la référence de l'affaire");
		item.focus();
        return false;
	}
	
	item = form.elements[sFormPrefix + "sObjet"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir l'objet du marché");
		item.focus();
        return false;
	}
	else{
		if(item.value.length<5){
			alert("Le champ \"objet du marché\" doit faire au moins 5 caractères");
			return false;	
		}
	}
/*	item = form.elements[sFormPrefix + "sDesignationReduite"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la description succincte du march?");
		item.focus();
        return false;
	}
*/	
	item = form.elements[sFormPrefix + "iIdCompetenceSelectionListe"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la classification des produits");
		item.focus();
        return false;
	}
	return true;
}