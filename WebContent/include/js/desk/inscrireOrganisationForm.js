function validation()
{
	if (isNull(document.form1.raisonSociale.value))
	{
		alert("Veuillez remplir la Raison sociale");
		document.form1.raisonSociale.focus();
            	return false;
	}

	if (!valideSiret(document.form1.siret1.value,
					document.form1.siret2.value,
					document.form1.siret3.value,
					document.form1.siret4.value))
	{
		document.form1.siret1.focus();
		return false;
	}
		
	/*if (isNull(document.form1.tvaIntra.value))
	{
		alert("Veuillez remplir le Numéro TVA intracommunautaire");
		document.form1.tvaIntra.focus();
            	return false;
	}*/
	if (isNull(document.form1.idCategorieJuridique.value))
	{
		alert("Choissisez une Catégorie juridique");
		document.form1.idCategorieJuridique.focus();
            	return false;
	}
	if (isNull(document.form1.idCodeNaf.value))
	{
		alert("Choissisez le Code NAF (ou APE)");
		document.form1.idCodeNaf.focus();
            	return false;
	}
	if (!isMail(document.form1.mailOrganisation.value))
	{
		alert("Veuillez remplir l'Email\nLa syntaxe de l'Email doit être de la forme identifiant@domaine.ext");
		document.form1.mailOrganisation.focus();
            	return false;
	}
	if (isNull(document.form1.telephone.value))
	{
		alert("Veuillez remplir le téléphone");
		document.form1.telephone.focus();
            	return false;
	}
	/*if (isNull(document.form1.fax.value))
	{
		alert("Veuillez remplir le fax");
		document.form1.fax.focus();
            	return false;
	}*/
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
	if (isNull(document.form1.idOrganisationType.value))
	{
		alert("Veuillez sélectionner le type de l\'organisation");
		document.form1.idOrganisationType.focus();
            	return false;
	}
	return true;
}