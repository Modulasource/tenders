function checkStatut(form) 
{
	var item = form.elements["statut"];
	if (isNull(item.value))
	{
		alert("Veuillez s�lectionner un statut.");
		item.focus();
        return false;
	}
	
	return true;
}