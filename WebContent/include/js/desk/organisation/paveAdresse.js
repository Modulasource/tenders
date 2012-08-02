
function checkAdresseIfNecessary(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "sCodePostal"];
	if (isNull(item.value))
	{
	    return true;
	}
	else{
		if (!isNum(item.value))
		{
			alert("Le code postal ne doit comporter que des chiffres");
			item.focus();
	        return false;
		}
		
		if (!(item.value.length == 5))
		{
			alert("Le code postal doit comporter 5 chiffres");
			item.focus();
	        return false;
		}
	
		item = form.elements[sFormPrefix + "sVoieNumero"];
		if (isNull(item.value))
		{
			alert("Veuillez remplir le numéro de la voie");
			item.focus();
	        return false;
		}
		
		item = form.elements[sFormPrefix + "sVoieType"];
		if (isNull(item.value))
		{
			alert("Veuillez remplir le type de la voie");
			item.focus();
	        return false;
		}
		
		item = form.elements[sFormPrefix + "sVoieNom"];
		if (isNull(item.value))
		{
			alert("Veuillez remplir le nom de la voie");
			item.focus();
	        return false;
		}
		
		item = form.elements[sFormPrefix + "sIdPays"];
		if (isNull(item.value))
		{
			alert("Veuillez sélectionner un pays");
			item.focus();
	        return false;
		}
	}
		item = form.elements[sFormPrefix + "sVoieNom"];
		if (isNull(item.value))
		{
			alert("Veuillez remplir le nom de la voie");
			item.focus();
	        return false;
		}
		
		item = form.elements[sFormPrefix + "sIdPays"];
		if (isNull(item.value))
		{
			alert("Veuillez sélectionner un pays");
			item.focus();
	        return false;
		}
	return true;
}

function checkAdresse(form, sFormPrefix)
{
	/*var item = form.elements[sFormPrefix + "sVoieNom"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir le nom de la voie");
		item.focus();
        return false;
	}*/

	var item = form.elements[sFormPrefix + "sCodePostal"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir le code postal");
		item.focus();
        return false;
	}
	if (!isNum(item.value))
	{
		alert("Le code postal ne doit comporter que des chiffres");
		item.focus();
        return false;
	}
	
	item = form.elements[sFormPrefix + "sCommune"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la commune");
		item.focus();
        return false;
	}

	
	item = form.elements[sFormPrefix + "sIdPays"];
	if (isNull(item.value))
	{
		alert("Veuillez sélectionner un pays");
		item.focus();
        return false;
	}

	
	return true;
}