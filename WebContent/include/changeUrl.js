function ChangeUrl(formulaire, champFormulaire, message, redirection)
{
	var champ = formulaire.elements[champFormulaire];
		
	if (champ.selectedIndex != 0)
	{
	
		var url =  redirection + champ.options[champ.selectedIndex].value;
		
		window.top.main.location.href = url ;
 	}
	else 
	{
		if (message != null)
			alert(message);
	}
}