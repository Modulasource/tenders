function checkQuestionReponse(){
	if(document.formulaire.type.value==0){
		alert("Vous devez s?lectionner une cat?gorie pour le couple Question-R?ponse");
		return false;
	}
	if(document.formulaire.question.value==0){
		alert("Vous devez remplir la question");
		return false;
	}
	if(document.formulaire.reponse.value==0){
		alert("Vous devez remplir la question");
		return false;
	}
	
return true;
}
