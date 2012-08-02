function validation()
{
	if (isNull(document.form1.nom.value))
	{
		alert("Veuillez remplir le nom");
		document.form1.nom.focus();
            	return false;
	}
	if (isNull(document.form1.prenom.value))
	{
		alert("Veuillez remplir le prénom");
		document.form1.prenom.focus();
            	return false;
	}
	if (isNull(document.form1.fonction.value))
	{
		alert("Veuillez remplir la fonction");
		document.form1.fonction.focus();
            	return false;
	}
	if (isNull(document.form1.idNationalite.value))
	{
		alert("Veuillez choisir la nationalité");
		document.form1.idNationalite.focus();
            	return false;
	}
	if (isNull(document.form1.tel.value))
	{
		alert("Veuillez remplir le téléphone");
		document.form1.tel.focus();
            	return false;
	}
	if (!isMail(document.form1.email.value))
	{
		alert("Veuillez remplir l'Email\nLa syntaxe de l'Email doit être de la forme identifiant@domaine.ext");
		document.form1.email.focus();
            	return false;
	}
	if (isNull(document.form1.adresseLigne1.value))
	{
		alert("Veuillez remplir l'adresse");
		document.form1.adresseLigne1.focus();
            	return false;
	}
	if (isNull(document.form1.codePostal.value))
	{
		alert("Veuillez remplir le Code Postal");
		document.form1.codePostal.focus();
            	return false;
	}
	if (!isNum(document.form1.codePostal.value))
	{
		alert("Le Code Postal ne doit comporter que des chiffres");
		document.form1.codePostal.focus();
            	return false;
	}
	if (isNull(document.form1.commune.value))
	{
		alert("Veuillez remplir la commune");
		document.form1.commune.focus();
            	return false;
	}
	if (isNull(document.form1.pays.value))
	{
		alert("Veuillez sélectionner un pays");
		document.form1.pays.focus();
            	return false;
	}
	return true;

}