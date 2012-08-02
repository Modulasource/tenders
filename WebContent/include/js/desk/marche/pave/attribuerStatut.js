function checkStatut(form) 
{
	var item = form.elements["statut"];
	if (isNull(item.value))
	{
		alert("Veuillez sélectionner un statut.");
		item.focus();
        return false;
	}
	
	return true;
}