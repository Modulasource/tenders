function checkForm(){
	var item = $("raison_sociale").value;
	if(item == ""){
		alert("Vous devez renseigner votre raison sociale");
		return false;
	}

	item = $("nom").value;
	if(item == ""){
		alert("Vous devez renseigner votre nom");
		return false;
	}

	item = $("prenom").value;
	if(item == ""){
		alert("Vous devez renseigner votre prénom");
		return false;
	}

	item = $("tel").value;
	if(item == ""){
		alert("Vous devez renseigner votre téléphone");
		return false;
	}

	item = $("email").value;
	if(item == "" || !mt.utils.isEmailValid(item) ){
		alert("Vous devez renseigner un email valide ");
		return false;
	}

	item = $("contact");
	var item2 = $("offreEssai");
	
	if(!item.checked && !item2.checked){
		alert("Vous devez choisir au moins un type d'informations");
		return false;
	}

	return true;
}
