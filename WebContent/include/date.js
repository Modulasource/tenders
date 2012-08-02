// Fonction v�rifiant le format de l'heure
function checkHeure(heure)
{
	var heureTab = heure.split(":");
	if (heureTab.length < 2)
	{
		alert("Veuillez remplir l'heure au bon format(HH:MM)");
		return false;
	}
	if (isNull(heureTab[0]) || isNull(heureTab[1])) 
	{
		alert("Veuillez remplir l'heure au bon format(HH:MM)");
		return false;
	}
	if (!(isNum(heureTab[0]) || isNum(heureTab[1])))
	{
		alert("L'heure doit �tre une valeur num�rique");
		return false;
	}
	// les heures sont comprises entre 0 et 23
	if (heureTab[0] < 0 || heureTab[0] > 23)
	{
		alert("Veuillez v�rifier l'heure");
		return false;
	}
	// les minutes sont comprises entre 0 et 59
	if (heureTab[1] < 0 || heureTab[1] > 59)
	{
		alert("Veuillez v�rifier les minutes");
		return false;
	}
return true;
}


function checkHourMinuteWithSpanPromt(elt, info)
{
	if( ! checkHourMinute(elt) )
	{
		$(info).innerHTML = "format attendu hh:mm";
	}
	else
	{
		$(info).innerHTML = "";
	}
}



/**
 * check if the format is hh:mm
 */
function checkHourMinute(elt)
{
	var val = elt.value ;
	var t = val.split(":");
	
	if(t.length != 2)
	{
	  return false;
	}

	if(t[0].length != 2)
	{
	  return false;
	}

	if(t[1].length != 2)
	{
	  return false;
	}

	if(isNaN (t[0]) )
	{
	  return false;
	}

	if(isNaN (t[1]) )
	{
	  return false;
	}
	
	if(parseInt(t[0]) < 0  || parseInt(t[0]) > 24  )
	{
	  return false;
	}

	if(parseInt(t[1]) < 0  || parseInt(t[1]) > 60  )
	{
	  return false;
	}
	
	return true;
}




/**
 * check if the format is hh:mm
 */
function checkDateWithSpanPromt(elt, info)
{
	if( ! checkDate(elt.value) )
	{
		$(info).innerHTML = "format attendu jj/mm/aaaa";
	}
	else
	{
		$(info).innerHTML = "";
	}
}




function checkDate(s){  // V�rifie si la chaine s (jj/mm/aaaa) est correcte et si la date correspondante existe
	var tab = s.split("/");
    if (tab.length!=3) return false;
    if (tab[0].length != 2 || tab[1].length != 2 || tab[2].length != 4 ) return false;
    if (isNull(tab[0]) || isNull(tab[1]) || isNull(tab[2])) return false;
    if (!(isNum(tab[0]) && isNum(tab[1]) && isNum(tab[2])))  return false;
    // le mois doit �tre compris entre 1 et 12
    if (tab[1]<1 && tab[1]>12) return false;
    
    // V�rification d'une date donn�e : exemple 12/05/2004 : le jour 12 doit correspondre � mai 2004
    var y_s = new String (tab[2]);
    var m_s = new String (tab[1]-1);
    if (m_s.length == 1) m_s = "0" + m_s;
    var d_s = new String (tab[0]);
    if (d_s.length == 1) d_s = "0" + d_s;
    
    // Cr�ation de la date � v�rifier
    var dd = new Date(y_s, m_s, d_s);
    //alert("dd="+dd+" ann�e="+(dd.getYear()+1900)+" mois="+(dd.getMonth()+1)+" y_s="+y_s+" m_s="+(parseInt(m_s, 10)+1));
    if (document.all){
        if (dd.getFullYear()!=parseInt(y_s, 10)) return false;   // la propri�t� getYear() est diff�rente chez ces abrutis de MS
    }else{
        if ((dd.getYear()+1900)!=parseInt(y_s, 10)) return false;
   }
    if ((dd.getMonth()+1)!=parseInt(m_s, 10)+1) return false;
return true;
}
function comparerDate(d1, d2){ // retourne vrai si d1<d2   d1 et d2 sont des string
   if (!(checkDate(d1) && checkDate(d2))) return false;
    var t1 = d1.split("/");
    var t2 = d2.split("/");
    var y_s = new String (t1[2]);
    var m_s = new String (t1[1]-1);
    if (m_s.length == 1) m_s = "0" + m_s;
    var d_s = new String (t1[0]);
    if (d_s.length == 1) d_s = "0" + d_s;
    var dd1 = new Date(y_s, m_s, d_s);
    
    var y_s = new String (t2[2]);
    var m_s = new String (t2[1]-1);
    if (m_s.length == 1) m_s = "0" + m_s;
    var d_s = new String (t2[0]);
    if (d_s.length == 1) d_s = "0" + d_s;
    var dd2 = new Date(y_s, m_s, d_s);
    return (dd1<dd2);
}

function comparerheure(h1, h2){ // retourne vrai si h1<h2   h1 et h2 sont des string
    if (!(checkHeure(h1) && checkHeure(h2))) return false;
    var t1 = h1.split(":");
    var t2 = h2.split(":");
    var heure1 = new String(t1[0]);
    var heure2 = new String(t2[0]);
    var min1 = new String(t1[1]);
    var min2 = new String(t2[1]); 
	if(!(heure1<heure2)){
		if(!(min1<min2)){
			return false;
		}
	}
return true;
}

function comparerDateComplete(d1,h1,d2,h2){
	if (!(checkDate(d1) && checkDate(d2))) return false;
	if (!(checkHeure(h1) && checkHeure(h2))) return false;
   
    var t1 = d1.split("/");
    var t2 = d2.split("/");
    var y_s = new String (t1[2]);
    var m_s = new String (t1[1]-1);
    if (m_s.length == 1) m_s = "0" + m_s;
    var d_s = new String (t1[0]);
    if (d_s.length == 1) d_s = "0" + d_s;
    
   	var t1 = h1.split(":");
    var heure1 = new String(t1[0]);
    var min1 = new String(t1[1]);
    
    var dd1 = new Date(y_s, m_s, d_s,heure1,min1);

    var y_s = new String (t2[2]);
    var m_s = new String (t2[1]-1);
    if (m_s.length == 1) m_s = "0" + m_s;
    var d_s = new String (t2[0]);
    if (d_s.length == 1) d_s = "0" + d_s;
    
    var t2 = h2.split(":");
    var heure2 = new String(t2[0]);
    var min2 = new String(t2[1]);
    
    var dd2 = new Date(y_s, m_s, d_s,heure2,min2);

    return (dd1<dd2);
}