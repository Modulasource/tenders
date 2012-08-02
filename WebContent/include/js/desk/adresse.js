function checkAdresse(sFormPrefix)
{
	var item = document.forms['formulaire'].elements[sFormPrefix + "sAdresseLigne1"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la ligne 1 de l\'adresse technique du marché");
		item.focus();
        return false;
	}

	item = document.forms['formulaire'].elements[sFormPrefix + "sCodePostal"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir le code postal");
		item.focus();
        return false;
	}
	if (!isNum(item.value))
	{
		alert("Le code postal de doit comporter que des chiffres");
		item.focus();
        return false;
	}
	
	item = document.forms['formulaire'].elements[sFormPrefix + "sCommune"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la commune");
		item.focus();
        return false;
	}
	
	item = document.forms['formulaire'].elements[sFormPrefix + "sIdPays"];
	if (isNull(item))
	{
		alert("Veuillez sélectionner un pays");
		item.focus();
        return false;
	}
	
	return true;
}