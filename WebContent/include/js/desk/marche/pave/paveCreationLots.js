function checkCreationLots(form)
{
		var des = "sDesignationReduite";
		var item = $("sDesignationReduite");
		if (item != null && isNull(item.value))
		{
			alert("Veuillez remplir la description succincte du lot");
			item.focus();
			return false;
		}
		
		
		var item = $("tsDateLivraison");
		if (item != null && !isNull(item.value))
		{
			if(!checkDate(item.value))
			{
				alert("Veuillez v�rifier la date d'ex�cution du lot");
				item.focus();
				return false;
			}
		}
		
		var item = $("tsDateLivraison");
		if (item != null && !isNull(item.value))
		{
			if(!checkDate(item.value))
			{
				alert("Veuillez v�rifier la date de livraison du lot");
				item.focus();
				return false;
			}
		}
	return true;
}