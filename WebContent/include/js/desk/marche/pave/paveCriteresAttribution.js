function ajoutOptionPondere(texte, unites, textebis, liste)
{
	if(isNum(texte.value))
		if(!isNull(unites.value)){
			var o=new Option(texte.value + " "+ unites.value +" " + textebis.value, texte.value + " "+ unites.value +" " + textebis.value);
			liste.options[liste.options.length]=o;
		}
		else{
			unites.focus();
			alert("Vous devez sp�cifier les unit�s");
		}
	else {texte.focus();alert("Vous devez sp�cifier un chiffre");}
}
function ajoutOptionClasse(texte,liste)
{
	var o=new Option(texte.value, texte.value);
	liste.options[liste.options.length]=o;
}
function supprimerOption(list) 
{
	if (list.options.selectedIndex>=0) 
	{
		list.options[list.options.selectedIndex]=null;
	} 
	else 
	{
		alert("Suppression impossible : aucune ligne s�lectionn�e");
	}
}

function checkCriteres(form, sFormPrefix){
	var item = form.elements[sFormPrefix + "selectionCritere"];
	for(i=0;i<item.length;i++)
	{
		if(item[i].checked)
			return true;
	}
	alert("Veuiller choisir un crit�re d'attribution");
	return false;
}

function checkCriteresAttribution(form, sFormPrefix)
{
	var item = form.elements[sFormPrefix + "selectionCritere"];
	if (checkCriteres(form, sFormPrefix))
	{
		for(i = 0; i < item.length; i++)
		{
			// Crit?res pond?r?s
			if ( (item[i].checked) && (item[i].value == '2') )
			{
				var itemPondere = form.elements["listePonderesHidden"];
				if (isNull(itemPondere.value))
				{
					alert("Veuillez sp�cifier la liste des crit�res pond�r�s.");
			        return false;
				}
			}

			// Crit?res class?s
			if ( (item[i].checked) && (item[i].value == '3') )
			{
				var itemClasse = form.elements["listeClassesHidden"];
				if (isNull(itemClasse.value))
				{
					alert("Veuillez sp�cifier la liste des crit�res class�s.");
			        return false;
				}
			}
		}
	}
	else
	{
		return false;
	}
	
	return true;
}
