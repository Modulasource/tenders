function validation()
{
	var sFormPrefix = "";
	var item = document.formulaires.elements[sFormPrefix + "objet"];

	if (isNull(item.value))
	{
		alert("Veuillez remplir l'objet");
		item.focus();
		return false;
	}

	item = document.formulaires.elements[sFormPrefix + "contenuMail"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir le contenu");
		item.focus();
		return false;
	}
	return true;
}