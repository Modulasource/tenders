function checkGestionLots(form, sFormPrefix){

	var item = form.elements[sFormPrefix + "iIdDivisionEnLot"];
	if (isNull(item.value))
	{
		alert("Choisissez le mode de division en lots");
		item.focus();
		return false;
	}
	
	if (item.value == 2){
		
		item = form.elements[sFormPrefix + "iNbLots"];
		if (isNull(item.value))
		{
			alert("Choisissez le nombre de lots");
			item.focus();
			return false;
		}
	}
	
	return true;
}
