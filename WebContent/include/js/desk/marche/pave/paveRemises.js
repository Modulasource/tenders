function checkRemises(form, sFormPrefix, bAfficheDate){

	var item = form.elements[sFormPrefix + "tsDateLimiteReceptionCandidature"];
	if (bAfficheDate)
	{
		if (isNull(item.value))
		{
			alert("Veuillez remplir la date limite de r�ception des candidatures");
			item.focus();
			return false;
		}
		else {
			if(!checkDate(item.value))
			{
				alert("Veuillez v�rifier la date limite de r�ception des candidatures");
				item.focus();
				return false;
			}
		}
	}

	item = form.elements[sFormPrefix + "tsDateCloture"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la date limite de r�ception des offres");
		item.focus();
		return false;
	}
	else {
		if(!checkDate(item.value))
		{
			alert("Veuillez v�rifier la date limite de r�ception des offres");
			item.focus();
			return false;
		}
	}

	if (bAfficheDate)
	{
		item = form.elements[sFormPrefix + "tsHeureLimiteReceptionCandidature"];
		if (isNull(item.value))
		{
			if(!checkHeure(item.value))
			{
				alert("Veuillez remplir l'heure limite de r�ception des candidatures");
				item.focus();
				return false;
			}
		}
		else{
			if(!checkHeure(item.value))
			{
				alert("Veuillez v�rifier l'heure limite de r�ception des candidatures");
				item.focus();
				return false;
			}
		}
	}

	item = form.elements[sFormPrefix + "tsHeureCloture"];
	if (isNull(item.value))
	{
		if(!checkHeure(item.value))
		{
			alert("Veuillez remplir la date limite de r�ception des offres");
			item.focus();
			return false;
		}
	}
	else{
		if(!checkHeure(item.value))
		{
			alert("Veuillez v�rifier l'heure limite de r�ception des offres");
			item.focus();
			return false;
		}
	}


	item = form.elements[sFormPrefix + "tsDateValidite"];
	if (!isNull(item.value))
	{
		if(!checkDate(item.value))
		{
			alert("Veuillez v�rifier la date de validit� des offres");
			item.focus();
			return false;
		}
	}
	
		 item = form.elements[sFormPrefix + "dateSysteme"];
	var item1 = form.elements[sFormPrefix + "heureSysteme"];
	var item2 = form.elements[sFormPrefix + "tsDateLimiteReceptionCandidature"];
	var item3 = form.elements[sFormPrefix + "tsHeureLimiteReceptionCandidature"];
	var item4 = form.elements[sFormPrefix + "tsDateCloture"];
	var item5 = form.elements[sFormPrefix + "tsHeureCloture"];
	
	// Comparaison entre date syst&egrave;me et date limite de r�ception des candidatures
	if (!comparerDate(item.value, item2.value))
	{	
		if(item.value == item2.value){
			if(!comparerheure(item1.value, item3.value))
			{
			alert("La date et l'heure limite de r�ception des candidatures est ant�rieure &agraveg; la date et &agraveg; l'heure du jour");
			item4.focus();
			return false;
			}
		}
		else{
			alert("La date et l'heure limite de r�ception des candidatures est ant�rieure &agraveg; la date et &agraveg; l'heure du jour");
			item4.focus();
			return false;
		}
	}

	// Comparaison entre date syst&egrave;me et date limite de r�ception des offres
	if (!comparerDate(item.value, item4.value))
	{	
		if(item.value == item4.value){
			if(!comparerheure(item1.value, item5.value))
			{
			alert("La date et l'heure limite de r�ception des offres est ant�rieure &agraveg; la date et &agraveg; l'heure du jour");
			item4.focus();
			return false;
			}
		}
		else{
			alert("La date et l'heure limite de r�ception des offres est ant�rieure � la date et � l'heure du jour");
			item4.focus();
			return false;
		}
	}
	
	/* Comparaison entre date limite de r�ception des candidatures et date limite 
		de r�ception des offres */
	if (!comparerDate(item2.value, item4.value))
	{	
		if(item2.value == item4.value){
			if (item3.value != item5.value)
			{
				if(!comparerheure(item3.value, item5.value))
				{
					alert("La date et l'heure limite de r�ception des offres est ant�rieure &agraveg; la date et &agraveg; l'heure limite de r�ception des candidatures");
					item4.focus();
					return false;
				}
			}
		}
		else{
			alert("La date et l'heure limite de r�ception des offres est ant�rieure &agraveg; la date et &agraveg; l'heure limite de r�ception des candidatures");
			item4.focus();
			return false;
		}
	}


	return true;
}