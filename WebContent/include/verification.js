function unEspace(chaine){
	var tab = chaine.split(' ');
	if (tab.length > 1) return true;	// si aucun ou plus de 2 espaces
	return false;
}

// fonction d?terminant l'absence de caract&egrave;re dans le champ
function isNull(mot){
	if (mot == null) return true;
	if (mot == "") return true;
	
	/*if (mot == 0)
		return true;*/
	// Patch pour Mozilla	
	var temoin = mot.substr(0,2);
	if (temoin == "--")
		return true;
}

// fonction testant si la valeur est num?rique ou pas
function isNum(nbr){
	if (isNull(nbr)) return 1;
	for (cpt=0;cpt<nbr.length;cpt++){
		if ( !((nbr.charAt(cpt)>=0) && (nbr.charAt(cpt)<=9)) || (nbr.charCodeAt(cpt)==32) ){
			return false;
		}
	}
	return true;
}

// Fonction v?rifiant le formatage correct d'un email
function isMail(mail){
/* (C) Fran?ois Blanchard [francois.blanchard@free.fr]  */
/* V?rifie la validit? d'un mail (1 seul @ et n pt */
/* apr&egrave;s le @ ; position du @ et du point)              */
	if (isNull(mail)) return false;
	if (unEspace(mail)) return false;
	/// controle du @
	tarobasse = mail.split("@");
	if (tarobasse.length != 2) return false;	// si aucun ou plus de 2 @
	if ( isNull(tarobasse[0]) || isNull(tarobasse[1]) ) return false;	// si l'une des 2 parties est vide
	
	/// controle du ou des points avant le @
	var avant = tarobasse[0];
	var tpt = avant.split(".");
	for (i=0 ; i<tpt.length ; i++)
	{
		//if ( isNull(tpt[i]) ) return false;
	}
	
	/// contr?le du ou des points apr&egrave;s le @
	var apres = tarobasse[1];
	var tpoint = apres.split(".");
	if (tpoint.length < 2) return false;		// si aucun point (nom de domaine)
	for (i=0 ; i<tpoint.length ; i++)
	{
		if ( isNull(tpoint[i]) ) return false;
	}
	return true;
}

// V?rification du champ "siret" du formulaire "formulaire"
// Non nul, valeur num?rique, et SIRET bien construit
function valideSiret() {
	var siret = document.formulaire.siret1.value
				+ "" + document.formulaire.siret2.value
				+ "" + document.formulaire.siret3.value
				+ "" + document.formulaire.siret4.value;
				
   if (isNull(siret))
    {
            alert("Remplissez le champ \"SIRET\" SVP...");
            document.formulaire.siret1.focus();
            return false;
    }
    if (!isNum(siret))
    {
      		alert("ATTENTION: Le num?ro de SIRET est une valeur num?rique.");
      		document.formulaire.siret1.focus();
      		return false;
    }
  
     if ( siret.length != 14 )
      	{
      		alert("Un num?ro SIRET fait 14 caract&egrave;res de longueur");
      		return false;
      	}
    	else 
    	{
	       // Donc le SIRET est un num?rique &agraveg; 14 chiffres
	       // Les 9 premiers chiffres sont ceux du SIREN (ou RCS), les 4 suivants
	       // correspondent au num?ro d'?tablissement
	       // et enfin le dernier chiffre est une clef de LUHN. 
	      var somme = 0;
	      var tmp;
	      var siret_val = siret;
	      for (var cpt = 0; cpt<siret_val.length; cpt++) {
        	if ((cpt % 2) == 0) { // Les positions impaires : 1er, 3&egrave;, 5&egrave;, etc... 
          	tmp = siret_val.charAt(cpt) * 2; // On le multiplie par 2
          	if (tmp > 9) 
            	tmp -= 9;  // Si le r?sultat est sup?rieur &agraveg; 9, on lui soustrait 9
       		 }
      		 else
         		tmp = siret_val.charAt(cpt);
         	 somme += parseInt(tmp);
      		}

	      if ((somme % 10) != 0)
	      {
	      	alert("Le num?ro SIRET fourni n'est pas coh?rent");
	      	document.formulaire.siret1.focus();
	        return false; // Si la somme est un multiple de 10 alors le SIRET est valide 
	      }
	}
    return true;
}

//Fonction de validation des champs de l'inscription de la soci?t? candidate
function valideSociete()
{
	// Partie champs Soci?t?
	if (isNull(document.formulaire.raisonSociale.value))
	{
		alert("Remplissez le champ \"Raison Sociale\", SVP...");
		document.formulaire.siret.focus();
            	return false;
	}
	if (!isMail(document.formulaire.mailSociete.value))
	{
		alert("ATTENTION: La syntaxe de l'email de la soci?t? n'est pas correct");
		document.formulaire.mailSociete.focus();
            	return false;
	}
	if (isNull(document.formulaire.telephone.value))
	{
		alert("Remplissez le champ \"Telephone\", SVP...");
		document.formulaire.telephone.focus();
            	return false;
	}
	if (!isNum(document.formulaire.telephone.value))
	{
      		alert("ATTENTION: Le num?ro de t?l?phone est une valeur num?rique.");
      		document.formulaire.telephone.focus();
      		return false;
      	}
	// Partie champs Adresse
	if (isNull(document.formulaire.adresseLigne1.value))
	{
		alert("Remplissez le champ \"Ligne 1\", SVP...");
		document.formulaire.adresseLigne1.focus();
            	return false;
	}
	if (isNull(document.formulaire.codePostal.value))
	{
		alert("Remplissez le champ \"Code Postal\", SVP...");
		document.formulaire.codePostal.focus();
            	return false;
	}
	if (!isNum(document.formulaire.codePostal.value))
	{
      		alert("ATTENTION: Le code postal est une valeur num?rique.");
      		document.formulaire.codePostal.focus();
      		return false;
      	}
	if (isNull(document.formulaire.commune.value))
	{
		alert("Remplissez le champ \"Commune\", SVP...");
		document.formulaire.commune.focus();
            	return false;
	}
	if (isNull(document.formulaire.pays.value))
	{
		alert("Remplissez le champ \"Pays\", SVP...");
		document.formulaire.pays.focus();
            	return false;
	}
	return true;
}

// Fonction de validation des champs d'une personne candidate || membre
function valideInscriptionPersonne() 
{
	if (!valideModificationPersonne())
	{
		return false;
	}	
	// Partie MtUser
	if (isNull(document.formulaire.password.value))
	{
		alert("ATTENTION : Vous devez absolument remplir le champ Mot de passe");
		document.formulaire.password.focus();
            	return false;
	}
	return true;
}

function valideModificationPersonne() 
{
// Partie Personne Physique
	if (isNull(document.formulaire.nom.value))
	{
		alert("Remplissez le champ \"Nom\", SVP...");
		document.formulaire.nom.focus();
            	return false;
	}
	if (isNull(document.formulaire.prenom.value))
	{
		alert("Remplissez le champ \"Pr?nom\", SVP...");
		document.formulaire.prenom.focus();
            	return false;
	}
	if (isNull(document.formulaire.fonction.value))
	{
		alert("Remplissez le champ \"Fonction\", SVP...");
		document.formulaire.fonction.focus();
            	return false;
	}
	if (isNull(document.formulaire.tel.value))
	{
		alert("Remplissez le champ \"Tel\", SVP...");
		document.formulaire.tel.focus();
            	return false;
	}
	/*if (!isNum(document.formulaire.tel.value))
	{
      		alert("ATTENTION: Le t?l?phone est une valeur num?rique.");
      		document.formulaire.tel.focus();
      		return false;
      	}*/
	if (!isMail(document.formulaire.email.value))
	{
		alert("ATTENTION: La syntaxe de l'email n'est pas correct");
		document.formulaire.email.focus();
            	return false;
	}
	/*if (!isNum(document.formulaire.telDomicile.value))
	{
      		alert("ATTENTION: Le t?l?phone du domicile est une valeur num?rique.");
      		document.formulaire.codePostal.focus();
      		return false;
      	}
      if (!isNum(document.formulaire.telPortable.value))
	{
      		alert("ATTENTION: Le t?l?phone portable est une valeur num?rique.");
      		document.formulaire.codePostal.focus();
      		return false;
      	}*/
	
	// Partie Adresse
	if (isNull(document.formulaire.adresseLigne1.value))
	{
		alert("Remplissez le champ \"Ligne 1\", SVP...");
		document.formulaire.adresseLigne1.focus();
            	return false;
	}
	if (isNull(document.formulaire.codePostal.value))
	{
		alert("Remplissez le champ \"Code Postal\", SVP...");
		document.formulaire.codePostal.focus();
            	return false;
	}
	if (!isNum(document.formulaire.codePostal.value))
	{
      		alert("ATTENTION: Le code postal est une valeur num?rique.");
      		document.formulaire.codePostal.focus();
      		return false;
      	}
	if (isNull(document.formulaire.commune.value))
	{
		alert("Remplissez le champ \"Commune\", SVP...");
		document.formulaire.commune.focus();
            	return false;
	}
	if (isNull(document.formulaire.pays.value))
	{
		alert("Remplissez le champ \"Pays\", SVP...");
		document.formulaire.pays.focus();
            	return false;
	}
	return true;
}

function confirmSubmit(phrase){
var agree=confirm("Etes vous s?r de vouloir "+phrase);
if (agree)
	return true ;
else
	return false ;
}