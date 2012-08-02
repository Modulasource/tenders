function checkOrganisationCoordonnees(form)
{
	var item = form.elements["sMailOrganisation"];
	if (!isMail(item.value))
	{
		alert("Veuillez remplir l'Email\nLa syntaxe de l'Email doit �tre de la forme identifiant@domaine.ext");
		item.focus();
        return false;
	}

	
	item = form.elements["sTelephone"];
	if (isNull(item.value))
	{
		alert("Remplissez le champ \"Telephone\", SVP...");
		item.focus();
        return false;
	}
	
	if (!isNum(item.value))
	{
  		alert("ATTENTION: Le t�l�phone est une valeur num�rique. Entrez un n� de t�l�phone sans espaces.");
  		item.focus();
  		return false;
    }
	
	return true;
}