function checkTypeMarche(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "iIdMarcheType"];
	if (isNull(item.value))
	{
		alert("Veuillez s�lectionner le type de march�.");
		item.focus();
        return false;
	}
	
	item = form.elements[sFormPrefix + "idTypeDetaille"];
	if (isNull(item.value))
	{
		alert("Veuillez s�lectionner le type de prestations");
		item.focus();
        return false;
	}
	
	return true;
}