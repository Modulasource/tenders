/* M?thode renvoyant true si un bouton radio est check? sinon false
 * Param&egrave;tres: item - champ &agraveg; tester
 * 			   message - message d'erreur
 * Fonctionne avec les boutons radios
 */
function checkRadio(item, message)
{
	if (item == null){
		alert("checkRadio(item == null , message='" + message + "'");
	 	return false;
	}
	for(i=0;i<item.length;i++)
	{
		if(item[i].checked)
		{
			return true;
		}
	}
	alert(message);
	return false;
}

function checkPublications(form, sFormPrefix, pubAAPC, pubRectificatif)
{
	var item = form.elements[sFormPrefix + "iPublicationAAPC"];
	var message = "Veuillez spécifier si l'AAPC a fait l'objet d'une publication.";
	/**
	* Ce champ n'existe pas pour un AATR simple
	*/
	if (item!=null )
	{
		if( checkRadio(item, message ))
		{
			for (i=0; i<item.length; i++)
			{
				if( (item[i].checked) && (item[i].value == pubAAPC) )
				{
					var itemParution = form.elements[sFormPrefix + "numeroParutionAAPC"];
					if (isNull(itemParution.value))
					{
						alert("Veuillez spécifier le numéro de parution de l'AAPC.");
						itemParution.focus();
				        return false;
					}
					
					itemParution = form.elements[sFormPrefix + "numeroAnnonceAAPC"];
					if (isNull(itemParution.value))
					{
						alert("Veuillez spécifier le numéro d'annonce de l'AAPC.");
						itemParution.focus();
				        return false;
					}
					
					itemParution = form.elements[sFormPrefix + "tsDateParutionAAPC"];
					if (isNull(itemParution.value))
					{
						alert("Veuillez spécifier la date de parution de l'AAPC.");
						itemParution.focus();
				        return false;
					}
					else {
						if(!checkDate(itemParution.value))
						{
							alert("Veuillez vérifier la date de parution de l'AAPC");
							itemParution.focus();
							return false;
						}
					}
				}
			}
		}
		else
		{
			return false;
		}
	}
	
	item = form.elements[sFormPrefix + "iPublicationRectification"];
	if (item!=null )
	{
		if (checkRadio(item, "Veuillez spécifier si l'AAPC a fait l'objet d'une publication rectificative." ))
		{
			for (i=0; i<item.length; i++)
			{
				if( (item[i].checked) && (item[i].value == pubRectificatif) )
				{
					var itemParution = form.elements[sFormPrefix + "numeroParutionRectification"];
					if (isNull(itemParution.value))
					{
						alert("Veuillez spécifier le numéro de parution du rectificatif.");
						itemParution.focus();
				        return false;
					}
					
					itemParution = form.elements[sFormPrefix + "numeroAnnonceRectification"];
					if (isNull(itemParution.value))
					{
						alert("Veuillez spécifier le numéro d'annonce du rectificatif.");
						itemParution.focus();
				        return false;
					}
					
					itemParution = form.elements[sFormPrefix + "tsDateParutionRectification"];
					if (isNull(itemParution.value))
					{
						alert("Veuillez spécifier la date de parution du rectificatif.");
						itemParution.focus();
				        return false;
					}
					else {
						if(!checkDate(itemParution.value))
						{
							alert("Veuillez vérifier la date de parution du rectificatif");
							itemParution.focus();
							return false;
						}
					}
				}
			}
		}
		else
		{
			return false;
		}
	}
	
	item = form.elements["AATR_tsDateValiditeDebut"];
	if (isNull(item.value))
	{
		alert("Veuillez specifier la date de publication de l'AATR.");
		item.focus();
        return false;
	}
	else {
		if(!checkDate(item.value))
		{
			alert("Veuillez vérifier la date de publication de l'AATR");
			item.focus();
			return false;
		}
	}
	
	item = form.elements["AATR_sDureePublication"];

	if(isNull(item.value))
	{
		alert("Veuillez specifier la durée de publication de l'AATR.");
		item.focus();
        return false;
	}
	else 
	{
		if (!isNum(item.value))
		{
			alert("La durée spécifié doit etre un nombre.");
			item.focus();
	        return false;
		}
	}
	
	
	return true;
}
