function checkRemises(form, sFormPrefix, bAfficheDate){

	var item = form.elements[sFormPrefix + "tsDateLimiteReceptionCandidature"];
	if (bAfficheDate)
	{
		if (isNull(item.value))
		{
			alert("Veuillez remplir la date limite de réception des candidatures");
			item.focus();
			return false;
		}
		else {
			if(!checkDate(item.value))
			{
				alert("Veuillez vérifier la date limite de réception des candidatures");
				item.focus();
				return false;
			}
		}
	}

	item = form.elements[sFormPrefix + "tsDateCloture"];
	if (isNull(item.value))
	{
		alert("Veuillez remplir la date limite de réception des offres");
		item.focus();
		return false;
	}
	else {
		if(!checkDate(item.value))
		{
			alert("Veuillez vérifier la date limite de réception des offres");
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
				alert("Veuillez remplir l'heure limite de réception des candidatures");
				item.focus();
				return false;
			}
		}
		else{
			if(!checkHeure(item.value))
			{
				alert("Veuillez vérifier l'heure limite de réception des candidatures");
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
			alert("Veuillez remplir la date limite de réception des offres");
			item.focus();
			return false;
		}
	}
	else{
		if(!checkHeure(item.value))
		{
			alert("Veuillez vérifier l'heure limite de réception des offres");
			item.focus();
			return false;
		}
	}


	item = form.elements[sFormPrefix + "tsDateValidite"];
	if (!isNull(item.value))
	{
		if(!checkDate(item.value))
		{
			alert("Veuillez vérifier la date de validité des offres");
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
	
	// Comparaison entre date syst&egrave;me et date limite de réception des candidatures
	if (!comparerDate(item.value, item2.value))
	{	
		if(item.value == item2.value){
			if(!comparerheure(item1.value, item3.value))
			{
			alert("La date et l'heure limite de réception des candidatures est antérieure &agraveg; la date et &agraveg; l'heure du jour");
			item4.focus();
			return false;
			}
		}
		else{
			alert("La date et l'heure limite de réception des candidatures est antérieure &agraveg; la date et &agraveg; l'heure du jour");
			item4.focus();
			return false;
		}
	}

	// Comparaison entre date syst&egrave;me et date limite de réception des offres
	if (!comparerDate(item.value, item4.value))
	{	
		if(item.value == item4.value){
			if(!comparerheure(item1.value, item5.value))
			{
			alert("La date et l'heure limite de réception des offres est antérieure &agraveg; la date et &agraveg; l'heure du jour");
			item4.focus();
			return false;
			}
		}
		else{
			alert("La date et l'heure limite de réception des offres est antérieure é la date et é l'heure du jour");
			item4.focus();
			return false;
		}
	}
	
	/* Comparaison entre date limite de réception des candidatures et date limite 
		de réception des offres */
	if (!comparerDate(item2.value, item4.value))
	{	
		if(item2.value == item4.value){
			if (item3.value != item5.value)
			{
				if(!comparerheure(item3.value, item5.value))
				{
					alert("La date et l'heure limite de réception des offres est antérieure &agraveg; la date et &agraveg; l'heure limite de réception des candidatures");
					item4.focus();
					return false;
				}
			}
		}
		else{
			alert("La date et l'heure limite de réception des offres est antérieure &agraveg; la date et &agraveg; l'heure limite de réception des candidatures");
			item4.focus();
			return false;
		}
	}


	return true;
}