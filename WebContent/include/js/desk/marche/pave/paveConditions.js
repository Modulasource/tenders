function checkConditions(form){
	var item = form.elements["iNbMinCandidats"];
	if (!isNull(item.value)&& !isNum(item.value))
	{
		alert("Attention, seuls les chiffres peuvent ?tre pris en compte pour le champ nombre minimal de candidats.");
		item.focus();
        return false;
	}
	
	item = form.elements["iNbMaxCandidats"];
	if (!isNull(item.value)&& !isNum(item.value))
	{
		alert("Attention, seuls les chiffres peuvent �tre pris en compte pour le champ nombre maximal de candidats.");
		item.focus();
        return false;
	}
	/*
	item = form.elements["sCriteresCandidature"];
	if (isNull(item.value))
	{
		alert("Vous devez renseigner les crit�res de s�lection des candidatures.");
		item.focus();
        return false;
	}
	else {
		if(item.value.length <5){
			alert("Les crit�res de s�lection des candidatures doivent faire au moins 5 caract�res.");
			item.focus();
	        return false;
		}
	}*/
 return true;
 }