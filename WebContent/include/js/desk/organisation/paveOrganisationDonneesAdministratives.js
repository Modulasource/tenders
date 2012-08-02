// V?rification du champ "siret" du formulaire "formulaire"
// Non nul, valeur num?rique, et SIRET bien construit
function valideSiret(siret1, siret2, siret3, siret4) {
	var siret = siret1
				+ "" + siret2
				+ "" + siret3
				+ "" + siret4;
  if(!isNull(siret)){			
    if (!isNum(siret))
    {
      		alert("ATTENTION: Le num?ro de SIRET est une valeur num?rique.");
      		return false;
    }
  
     if ( siret.length != 14 )
      	{
      		alert("Un num?ro SIRET fait 14 caract?res de longueur");
      		return false;
      	}
    	else 
    	{
	       // Donc le SIRET est un num?rique ? 14 chiffres
	       // Les 9 premiers chiffres sont ceux du SIREN (ou RCS), les 4 suivants
	       // correspondent au num?ro d'?tablissement
	       // et enfin le dernier chiffre est une clef de LUHN. 
	      var somme = 0;
	      var tmp;
	      var siret_val = siret;
	      for (var cpt = 0; cpt<siret_val.length; cpt++) {
        	if ((cpt % 2) == 0) { // Les positions impaires : 1er, 3?, 5?, etc... 
          	tmp = siret_val.charAt(cpt) * 2; // On le multiplie par 2
          	if (tmp > 9) 
            	tmp -= 9;  // Si le r?sultat est sup?rieur ? 9, on lui soustrait 9
       		 }
      		 else
         		tmp = siret_val.charAt(cpt);
         	 somme += parseInt(tmp);
      		}

	      if ((somme % 10) != 0)
	      {
	      	alert("Le num?ro SIRET fourni n'est pas coh?rent");
	        return false; // Si la somme est un multiple de 10 alors le SIRET est valide 
	      }
	}
  }
    return true;
}



function checkOrganisationDonneesAdministratives(form)
{
	var item = form.elements["sRaisonSociale"];
	if (isNull(item.value))
	{
		alert("Remplissez le champ \"Raison Sociale\", SVP...");
		item.focus();
        return false;
	}

	/* if (!valideSiret(form.sSiret1.value,
					form.sSiret2.value,
					form.sSiret3.value,
					form.sSiret4.value))
	{
		form.sSiret1.focus();
		return false;
	}
		
	item = form.elements["iIdCategorieJuridique"];
	if (isNull(item.value))
	{
		alert("Choissisez une Cat?gorie juridique");
		item.focus();
        return false;
	}
	
	item = form.elements["iIdCodeNaf"];
	if (isNull(item.value))
	{
		alert("Choissisez le Code NAF (ou APE)");
		item.focus();
        return false;
	} */

	return true;
}