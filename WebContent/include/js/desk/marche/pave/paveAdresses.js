function checkAdresses(form, sFormPrefix){
	var item = form.elements[sFormPrefix + "iIdPRM"];
	if (isNull(item.value))
	{
		alert("Veuillez sélectionner le pouvoir adjudicateur");
		item.focus();
		return false;
	}
		
	item = form.elements[sFormPrefix + "iTypeAcheteurPublic"];
	
	return true;
}