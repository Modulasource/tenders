function checkRenseignements(form, sFormPrefix){
	var item = form.elements[sFormPrefix + "tsDateAttribution"];
	if (isNull(item.value))	{
		alert("Veuillez sp?cifier la date d'attribution du march?.");
		item.focus();
        return false;
	}
	else {
		if(!checkDate(item.value))
		{
			alert("Veuillez v?rifier le format de la date d'attribution du march?.");
			item.focus();
			return false;
		}
	}
	
	item = form.elements[sFormPrefix + "sAutresInfosAATR"];
	if(!isNull(item.value)){
		if(item.value.length<5){ 
			alert("Le champs \"Autres informations\", s'il est rempli, doit contenir au moins 5 caract?res");
			item.focus();
			return false;
		}
	}	
	item = form.elements[sFormPrefix + "iNbOffre"];
	if (!isNull(item.value))
	{
		if(!isNum(item.value))
		{
			alert("Modula attend un nombre pour le \"Nombre total d'offres re?ues\".");
			item.focus();
			return false;
		}
	}
	
	item = form.elements[sFormPrefix + "iNbParticipants"];
	if (!isNull(item.value))
	{
		if(!isNum(item.value))
		{
			alert("Modula attend un nombre pour le \"Nombre de participants\".");
			item.focus();
			return false;
		}
	}
	
	item = form.elements[sFormPrefix + "iNbParticipantsEtrangers"];
	if (!isNull(item.value))
	{
		if(!isNum(item.value))
		{
			alert("Modula attend un nombre pour le \"Nombre de participants ?trangers\".");
			item.focus();
			return false;
		}
	}
	
	return true;
}