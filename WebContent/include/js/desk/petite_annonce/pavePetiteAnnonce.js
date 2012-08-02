function checkObjet(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "sReference"];
	
	if (isNull(item.value))
	{
		alert("Veuillez remplir la reference de l'affaire");
		item.focus();
        return false;
	}
	
	item = form.elements[sFormPrefix + "sObjet"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir l'objet de la petite annonce");
		item.focus();
        return false;
	}
			
	return true;

}

function checkTypeMarche2(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "iIdMarcheType"];
	if (isNull(item.value))
	{
		alert("Veuillez s?lectionner le type de march?");
		item.focus();
        return false;
	}
	
	item = form.elements[sFormPrefix + "idTypeDetaille"];
	if (isNull(item.value))
	{
		alert("Veuillez s?lectionner le type de prestations");
		item.focus();
        return false;
	}


	item = form.elements[sFormPrefix + "iIdMarchePassation"];
	if (isNull(item.value))
	{
		alert("Veuillez s?lectionner le mode de passation");
		item.focus();
        return false;
	}
	
	return true;
}