function checkTypeMarche(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "iIdMarcheType"];
	if (isNull(item.value))
	{
		alert("Veuillez sélectionner le type de marché.");
		item.focus();
        return false;
	}
	
	item = form.elements[sFormPrefix + "idTypeDetaille"];
	if (isNull(item.value))
	{
		alert("Veuillez sélectionner le type de prestations");
		item.focus();
        return false;
	}
	
	return true;
}