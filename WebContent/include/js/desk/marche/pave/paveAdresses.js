function checkAdresses(form, sFormPrefix){
	var item = form.elements[sFormPrefix + "iIdPRM"];
	if (isNull(item.value))
	{
		alert("Veuillez s�lectionner le pouvoir adjudicateur");
		item.focus();
		return false;
	}
		
	item = form.elements[sFormPrefix + "iTypeAcheteurPublic"];
	
	return true;
}