function checkForm(){

	var item = document.formulaire.raison_sociale.value;
	if(item == ""){
		alert("Vous devez renseigner votre raison sociale");
		return false;
	}

	item = document.formulaire.nom.value;
	if(item == ""){
		alert("Vous devez renseigner votre nom");
		return false;
	}

	item = document.formulaire.prenom.value;
	if(item == ""){
		alert("Vous devez renseigner votre pr?nom");
		return false;
	}

	item = document.formulaire.tel.value;
	if(item == ""){
		alert("Vous devez renseigner votre t?l?phone");
		return false;
	}

	item = document.formulaire.email.value;
	if(item == ""){
		alert("Vous devez renseigner votre email");
		return false;
	}

	item = document.formulaire.formation;
	var item2 = document.formulaire.certificat;
	if(!item.checked && !item2.checked){
		alert("Vous devez choisir au moins un type d'informations ? recevoir");
		return false;
	}

return true;
}
