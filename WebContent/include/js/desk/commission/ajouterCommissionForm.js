function checkCommission(formulaire, sFormPrefix)
{
	var item = formulaire.elements[sFormPrefix + "sNom"];
	if (isNull(item.value))
	{
		alert("Veuillez renseigner le nom.");
		item.focus();
        return false;
	}
	
	// champ non obligatoire
	/*item = formulaire.elements[sFormPrefix + "sCompetence"];
	if (isNull(item.value))
	{
		alert("Veuillez renseigner la compétence.");
		item.focus();
        return false;
	}
	*/
	return true;
}