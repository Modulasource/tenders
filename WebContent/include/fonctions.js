if (navigator.appName=="Netscape" && parseInt(navigator.appVersion)>=3)
{
	var nav="n3";
}

if(navigator.appName!='Netscape' && parseInt(navigator.appVersion)>=3)
{
	var nav="ie4";
}

var ie = document.all ? true : false;
var ns = document.layers ? true : false;

var scrlong ;
var scrlarg ;

try{
	scrlong = screen.width;
	scrlarg = screen.height;
} catch (e) {}

function isNull(mot){
	if (ie)
		return (mot.length==0);
	else
		return (mot=="null" || mot=="");
}

function isNum(nbr){
	if (isNull(nbr)) return 1;
	for (cpt=0;cpt<nbr.length;cpt++){
		if ( !((nbr.charAt(cpt)>=0) && (nbr.charAt(cpt)<=9)) || (nbr.charCodeAt(cpt)==32) ){
			return false;
		}
	}
	return true;
}
function isFloat(nbr){
	if (isNull(nbr)) return true;
	var tvir = nbr.split(',');
	var taille=tvir.length;
	if (tvir.length>2) return false;	// plus d'une virgule
	else if (tvir.length == 2){		// on remplace l'?ventuelle virgule par un point
		nbr = nbr.replace(",",".");
	}
	return (!isNaN(nbr));		// isNaN : is Not a Number
}
function donnerFocus(elt){
	eval("document.fform."+elt+"[1].click()");
}
function isJPG(image){		// v?rifie s'il s'agit bien d'une image jpg
	var point = image.split(".");
	point[point.length-1] = point[point.length-1].toLowerCase();
	return (point[point.length-1]=="jpg");
}

function sameEXT(fichier,ext){		// v?rifie s'il s'agit bien de la meme extension
	var point = fichier.split(".");
	point[point.length-1] = point[point.length-1].toLowerCase();
	return (point[point.length-1]==ext);
}

function keep_nombre(champ)		// retire tout ce qui n'est pas nombre lors de la frappe
{
	cpt = 0;
	taille = champ.length;
	while ( cpt < taille )
	{
		if ( !((champ.charAt(cpt)>=0) && (champ.charAt(cpt)<=9)) || (champ.charCodeAt(cpt)==32) )
		{
			champ = champ.substring(0,cpt) + champ.substring(cpt+1,taille); 			// supression du caract?re
		}
		cpt++;
	}
	return champ;
}

function keep_car(champ)		// retire tout ce qui n'est pas nombre et car alpha lors de la frappe
{
	nbr = eval('document.fref.'+champ+'.value');

	cpt = 0;
	taille = nbr.length;
	while ( cpt < taille )
	{
		if ( !((nbr.charAt(cpt)>=0) && (nbr.charAt(cpt)<=9)) && !((nbr.charAt(cpt)>="a") && (nbr.charAt(cpt)<="z")) )
		{
			nbr = nbr.substring(0,cpt) + nbr.substring(cpt+1,taille); 			// supression du caract?re
			eval('document.fref.'+champ+'.value=nbr');
			eval('document.fref.'+champ+'.focus()');		// donne le focus ? l'?l?ment en question
		}
		cpt++;
	}
}

function tailleMini(texte, longueur){
	if (isNull(texte)) return 0;
	return (texte.length >= longueur);
}
function tailleMaxi(texte, longueur){
	if (isNull(texte)) return 1;
	return (texte.length <= longueur);
}
function bonne_taille(texte, longueur){
	if (isNull(texte)) return 1;
	return (texte.length <= longueur);
}
function isNumIsCar(chaine){
	if (isNull(chaine)) return 1;
	if (unEspace(chaine)) return 0;
	cpt = 0;
	taille = chaine.length;
	chaine = chaine.toLowerCase();
	while ( cpt < taille ){
		if ( !((chaine.charAt(cpt)>=0) && (chaine.charAt(cpt)<=9)) && !((chaine.charAt(cpt)>="a") && (chaine.charAt(cpt)<="z")) ){
			return false;
		}
		cpt++;
	}
	return true;
}
function unEspace(chaine){
	tab = chaine.split(' ');
	if (tab.length > 1) return true;	// si aucun ou plus de 2 espaces
	return false;
}

function converttoeuro(prixf)
{
	return parseInt(prixf/6.55957,10);
}


function unEspace(chaine){
	tab = chaine.split(' ');
	if (tab.length > 1) return true;	// si aucun ou plus de 2 espaces
	return false;
}
function isMail(mail){
/* (C) Fran?ois Blanchard [francois.blanchard@free.fr]  */
/* V?rifie la validit? d'un mail (1 seul @ et n pt */
/* apr?s le @ ; position du @ et du point)              */
	if (isNull(mail)) return true;
	if (unEspace(mail)) return false;
	/// controle du @
	tarobasse = mail.split("@");
	if (tarobasse.length != 2) return false;	// si aucun ou plus de 2 @
	if ( isNull(tarobasse[0]) || isNull(tarobasse[1]) ) return false;	// si l'une des 2 parties est vide
	
	/// controle du ou des points avant le @
	avant = tarobasse[0];
	tpt = avant.split(".");
	for (i=0 ; i<tpt.length ; i++)
	{
		//if ( isNull(tpt[i]) ) return false;
	}
	
	/// contr?le du ou des points apr?s le @
	apres = tarobasse[1];
	tpoint = apres.split(".");
	if (tpoint.length < 2) return false;		// si aucun point (nom de domaine)
	for (i=0 ; i<tpoint.length ; i++)
	{
		if ( isNull(tpoint[i]) ) return false;
	}
	return true;
}

var gest_hor;
function gestion(url)
{
	haut=480;
	larg=640;
	posx = (scrlong - larg) / 2;		// permet de centrer la fen?tre
	posy = (scrlarg - haut) / 2;
	/*
	if (document.layers){
		if ( (url == '../groupe/index.html') || (url == '../archive/index.html'))
			alert("N'oubliez pas de cliquer sur \"newsletter\" afin de raffraichir vos modifications.\n\nUtilisez Internet Explorer pour ?viter ce genre de contraintes.");
		else
			alert("N'oubliez pas de cliquer sur \"Ajouter un abonn?\" afin de raffraichir vos modifications.\n\nUtilisez Internet Explorer pour ?viter ce genre de contraintes.");
	}
	*/
	gest_hor = window.open(url, 'gest', 'height=480,width=640,top='+posy+',left='+posx+',scrollbars=1,toolbar=1,status=1,resizable=1');

	if (gest_hor.opener==null)
	{
		gest_hor.opener = window;
	}
	else
	{
		setTimeout("gest_hor.focus();",250);
	}
}

var newWind
function ouvrir(page){
      newWind = window.open(page, 'titre', 'width=450,height=400');
      if (newWind.opener == null)
		newWind.opener = window;
	  else
	  	newWind.focus();
}

var cpW;
function proposerCP(formCP, formVille){
	eval("valCP = document.fform."+formCP+".value");
	eval("valVille = document.fform."+formVille+".value");
	if (isNull(valCP) && isNull(valVille)){
		alert("Vous devez renseigner au moins un des 2 champs avant de pouvoir obtenir des informations.");
		eval("document.fform."+formCP+".focus()");
		return;
	}
	if (isNull(valVille)){
		if (!isNum(valCP)){
			alert("Le code postal n'est pas un format num?rique");
			eval("document.fform."+formCP+".focus()");
			return;
		}
		if (valCP.length<=1){
			alert("Veuillez saisir au moins 2 chiffres pour le code postal SVP.");
			eval("document.fform."+formCP+".focus()");
			return;
		}
	}
	var url = "cp.php?formCP="+formCP+"&valCP="+valCP+"&formVille="+formVille+"&valVille="+valVille;
	cpW = window.open(url, 'cpW', 'width=450,height=400,scrollbars=1');
	if (cpW.opener == null)	cpW.opener = window;
	else cpW.focus();
}

var calendrierW;
function calendrier(name){
	eval("ladate = document.fform."+name+".value");
	var url = "calendrier.php?name="+name;
	if (ladate != ""){
		var tab = ladate.split("-");
		url += "&annee="+tab[0]+"&jour="+tab[2]+"&amp;mois="+tab[1];
	}
	calendrierW = window.open(url, 'calendrierW', 'width=450,height=400');
	if (calendrierW.opener == null)	calendrierW.opener = window;
	else calendrierW.focus();

}

function effacerDate(nom){
	eval("document.fform.b_"+nom+".value = \"Aucune date\"");
	eval("document.fform."+nom+".value = \"\"");
}

function effacer(bouton){
	eval("document.fform."+bouton+".value = '';");
}

function modif(id, no){
	if (no != "") window.location="modif.php?"+id+"="+no;
}

function gotopage(nb){
	document.fform.start.value = nb;
	document.fform.submit();
}
function inString(chaine, car){
	for (i=0;i<chaine.length;i++){
		if (chaine.charAt(i)==car) return 1;
	}
	return;
}

function oterAccents(chaine){
	var accent = "?????????????????????????????????????????????????????";
	var noaccent = "AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn";
	var newchaine = "";
	var tabAccent = Array();
	for (var i=0;i<accent.length;i++){
		tabAccent[accent.charAt(i)]=noaccent.charAt(i);
	}
	for (i=0;i<chaine.length;i++){
		if (inString(accent, chaine.charAt(i))){
			newchaine += tabAccent[chaine.charAt(i)];
		}else{
			newchaine += chaine.charAt(i);
		}
	}
	return newchaine;
}

function oterEspace(chaine){	// supprime les espaces d'une chaine
	var newchaine = "";
	for (i=0;i<chaine.length;i++){
		if (!unEspace(chaine.charAt(i))){
			newchaine += chaine.charAt(i);
		}
	}
	return newchaine;
}

function proposerLogin(){
	var loginuser = document.fform.loginuser.value;
	var nom = document.fform.nom.value;
	var prenom = document.fform.prenom.value;
	if (confirm("Proposer un identifiant automatiquement ?")){
		var newID = oterEspace(prenom).substring(0, 3)+oterEspace(nom).substring(0, 10);
		var taille = newID.length;
		if (taille<6){	// comblement par des chiffres al?atoires
			for (i=0;i<(6-taille);i++){
				newID += Math.floor(9 * Math.random());
			}
		}
		document.fform.loginuser.value = oterAccents(newID.toLowerCase());
	}
}
// Fonction permettant d'ins?rer du texte dans un champ ? la position du curseur
// NB : sIdChamp est l'id du champ
function insererTexteApresCurseur(sTexteAInserer, sIdChamp) { 
	var textField = document.getElementById(sIdChamp); 
	sTexteAInserer = sTexteAInserer.replace(/<br>/gi, "\n").replace(/<br\/>/gi, "\n").replace(/<br \/>/gi, "\n").replace(/<\/p>/gi, "\n").replace(/<p>/gi, "");

	//IE support 
	if (document.selection) { 
		textField.focus(); 
		var sel = document.selection.createRange(); 
		sel.text = sTexteAInserer;
	} 
	//MOZILLA/NETSCAPE support 
	else if (textField.selectionStart || textField.selectionStart == "0") {
		var startPos = textField.selectionStart; 
		var endPos = textField.selectionEnd; 
		var sChaine = textField.value; 
		textField.value = sChaine.substring(0, startPos) + sTexteAInserer 
			+ sChaine.substring(endPos, sChaine.length); 
	} else { 
		textField.value += sTexteAInserer; 
	} 
}


// Fonctions du composant DoubleMultiSelect
function AFCPT_DoubleMultiSelect_Swap(sIdList1,sIdList2) {
	var l1 = document.getElementById(sIdList1);
	var l2 = document.getElementById(sIdList2);
	if (l1.options.selectedIndex>=0) {
		o=new Option(l1.options[l1.options.selectedIndex].text,l1.options[l1.options.selectedIndex].value);
		l2.options[l2.options.length]=o;
		l1.options[l1.options.selectedIndex]=null;
	}
}
function AFCPT_DoubleMultiSelect_Display(sIdList, sIdTip){
	var l = document.getElementById(sIdList);
	if(l.options.selectedIndex>=0){
		document.getElementById(sIdTip).setAttribute('className', 'AF_CPT_multiselect_tip');
		document.getElementById(sIdTip).setAttribute('class', 'AF_CPT_multiselect_tip');
		var sText = l.options[l.options.selectedIndex].text;
		document.getElementById(sIdTip).innerHTML = "Elément sélectionné : <b>"+sText+"</b>";
	}
}
function AFCPT_StoreDatasToHidden(sIdList, sIdHidden){
	var l = document.getElementById(sIdList);
	var h = document.getElementById(sIdHidden);
	var sValue = "";
	for (var i=0;i<l.options.length;i++){
		sValue += l.options[i].value+"|";
	}
	h.value = sValue;
}
function AFCPT_Select_Up(sIdList){
	var l1 = document.getElementById(sIdList);
	if (l1.options.selectedIndex>0) {
		initIndex = l1.options.selectedIndex;
		initTaille = l1.options.length;
		var tabText = new Array();
		var tabVal = new Array();
		for(i=0 ; i<l1.options.length ; i++){
			tabText[i] = l1.options[i].text;
			tabVal[i] = l1.options[i].value;
		}
		l1.options.length=0;

		i=0;
		while(i<initTaille){
			if (i==initIndex-1){
				l1.options[l1.options.length] = new Option(tabText[i+1],tabVal[i+1],1,1);
				l1.options[l1.options.length] = new Option(tabText[i],tabVal[i]);
				i++;
			}else{
				l1.options[l1.options.length] = new Option(tabText[i],tabVal[i]);
			}
			i++;
		}
		
	}
}
function AFCPT_Select_Down(sIdList){
	var l1 = document.getElementById(sIdList);
	if (l1.options.selectedIndex>=0 && (l1.options.length-1 > l1.options.selectedIndex)) {
		initIndex = l1.options.selectedIndex;
		initTaille = l1.options.length;
		var tabText = new Array();
		var tabVal = new Array();
		for(i=0 ; i<l1.options.length ; i++){
			tabText[i] = l1.options[i].text;
			tabVal[i] = l1.options[i].value;
		}
		l1.options.length=0;

		i=0;
		while(i<initTaille){
			if (i==initIndex){
				l1.options[l1.options.length] = new Option(tabText[i+1],tabVal[i+1]);
				l1.options[l1.options.length] = new Option(tabText[i],tabVal[i],1,1);
				i++;
			}else{
				l1.options[l1.options.length] = new Option(tabText[i],tabVal[i]);
			}
			i++;
		}
		
	}
}
// donne la position d'un élément
function getPosTop(obj){
	toreturn = 0;
	while(obj){
		toreturn += obj.offsetTop;
		obj = obj.offsetParent;
	}
	return toreturn;
}
function getPosLeft(obj){
	toreturn = 0;
	while(obj){
		toreturn += obj.offsetLeft;
		obj = obj.offsetParent;
	}
	return toreturn;
}
/**
* Ferme toutes les bulles d'alert
*/
function closeAllAlerts(){
	var tDiv = document.getElementsByTagName("div");
	var noeud = "";
	if (document.all){
	    for (var n=0; n<tDiv.length; n++) {
	    	noeud = String(tDiv[n].getAttributeNode("class").nodeValue);
	       if (noeud.search(/alertControl/g)>=0) {
	            tDiv[n].setAttribute('class', 'alertControlHidden');
			    tDiv[n].setAttribute('className', 'alertControlHidden');
	        }
	    }
	}else{
	    for (var n=0; n<tDiv.length; n++) {
	    	noeud = String(tDiv[n].getAttribute("class"));
	       if (noeud.search(/alertControl/g)>=0) {
	            tDiv[n].setAttribute('class', 'alertControlHidden');
			    tDiv[n].setAttribute('className', 'alertControlHidden');
	        }
	    }
	}
}
function showAlert(sIdField, sMessage){
/*	alert(sMessage);
	document.getElementById(sIdField).focus();
*/
	var oChamp = document.getElementById(sIdField);
	var sPrefix = "alert_";
	var div = document.createElement("div");
	
	div.id = sPrefix+sIdField;
	div.setAttribute('class', 'alertControl');
    div.setAttribute('className', 'alertControl');
    div.innerHTML = sMessage;
    div.onclick = function(){
    	this.setAttribute('class', 'alertControlHidden');
	    this.setAttribute('className', 'alertControlHidden');
    }
    window.document.body.appendChild(div);
    
    if (document.all){
		var iTop = eval(getPosTop(oChamp)-div.offsetHeight)+ "px";
		var iLeft = eval(getPosLeft(oChamp)) + "px";
	}else{
		// sous FF, il faut lui indiquer la position du scroll
		var iTop = eval(getPosTop(oChamp)-document.body.scrollTop-div.offsetHeight)
					 + "px";
		var iLeft = eval(getPosLeft(oChamp)-document.body.scrollLeft) + "px";
	}
    div.style.left = iLeft;
    div.style.top = iTop;
}
/**
* Retourne l'extension en minuscule d'un nom de fichier
* @param sFilename : le nom du fichier
*/
function getExtension(sFilename){
	var point = sFilename.split(".");
	if (point.length<2) return;
	return point[point.length-1].toLowerCase();
}
/**
* Retourne true si l'extension fait partie des extensions autoris?es
* @param sExtensionToCheck : extension ? v?rifier
* @param aExtensionList : Tableau des extensions autoris?es
*/
function isAuthorisedExtension(sExtensionToCheck, aExtensionList){
	 for (i=0;i<aExtensionList.length;i++){
	     if (aExtensionList[i]==sExtensionToCheck) return true;
	 }
	 return false;
}


/**
 * TODO : à supprimer et remplacer par 
 * item.sName = htmlEntities(item.sName,"encode");
 */
var function_js_aCharTable_Html = [
               			[232 , "&egrave;"], [233 , "&eacute;"], [234 , "&ecirc;"]
              			];


/**
* Filtre les caractères Word et les remplaces par des caractères conventionnels.
*/
var function_js_aCharTable_MsWord = [
             			[8218, ","], [402, "f"], [8222, ",,"], [8230, "..."],
             			[8224, "+"], [8225, "+"], [710, "^"], [8240, "%0"],
             			[352, "S"], [8249, "."], [338, "OE"], [8216, "'"],
             			[8217, "'"], [8220, "\""], [8221, "\""], [8226, "."],
             			[8211, "-"], [8212, "-"], [732, "~"], [8482, "TM"],
             			[353, "s"], [8250, "."], [339, "oe"], [376, "Y"],
             			[171, "\""], [187, "\""]
             		];

function cleanUpWordCharacter(sString){
	var aCharTable = function_js_aCharTable_MsWord;
	return cleanUpCharacter(sString,aCharTable);
}

function cleanUpCharacter(
		sString,
		aCharTable){
	// 8249 est "<" et 8250 est ">" mais on les remplace par des "." car même avec des &gt; et &lt;
	// ça ne marche pas.
	
	
	var sWord = "";
	var bFound = false;
	for(var i=0;i<sString.length;i++){
		bFound = false;
		for(var iTable=0;iTable<aCharTable.length;iTable++){
			if (sString.charCodeAt(i)==aCharTable[iTable][0]){
				sWord += aCharTable[iTable][1];
				bFound = true;
				break;
			}
		}
		if (!bFound) sWord += sString.charAt(i);
	}
	return sWord;
}

