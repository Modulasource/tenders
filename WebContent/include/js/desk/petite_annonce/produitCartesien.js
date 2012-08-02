function vider(formListe){
	formListe.value = 1;
}

function viderTotal(formListe){
	formListe.value = 0;
}


function remplir(liste, tab){
	var l1 = eval("document.formulaire."+liste);
	
	if(l1 == null) return;
	vider(l1);
	
	if(tab == null) return;

	for (var i=0 ; i<tab.length ; i++){
		l1.options[l1.options.length] = new Option(tab[i][1],tab[i][0],0,0);
	}
}

function selectOptionByName(liste, listeValeurSelectionnee)
{
	var l1 = eval("document.formulaire." + liste);
	
	l1.options.selectedIndex = 0;
	for (var i=0 ; i < l1.length ; i++)
	{
		if(l1.options[i].text == listeValeurSelectionnee)
		{
			l1.options.selectedIndex = i;
			break;
		}
	}
	
}


function selectOptionById(liste, listeValeurSelectionnee)
{
	var l1 = eval("document.formulaire." + liste);
	
	l1.options.selectedIndex = 0;
	for (var i=0 ; i < l1.length ; i++)
	{
		if(l1.options[i].value == listeValeurSelectionnee)
		{
			l1.options.selectedIndex = i;
			break;
		}
	}
	
}


function selectionnerOption2Niveaux(liste, listeValeurSelectionnee, listeSuivante, listeValeurSuivanteSelectionnee)
{
	var l1 = eval("document.formulaire." + liste);
	var l2 = eval("document.formulaire." + listeSuivante);

	
	selectOptionByName(liste, listeValeurSelectionnee);
	
	remplir(listeSuivante, niveau2(l1.options[l1.options.selectedIndex].value));
	
	selectOptionByName(listeSuivante, listeValeurSuivanteSelectionnee);
	
	
}


function verifier(liste, listeSuivante, niveau){
	alert("hello");
	var l1 = eval("document.formulaire." + liste);
	var l2 = eval("document.formulaire." + listeSuivante);
	vider(l2);
	if (niveau == "2"){
		if (l1.value==""){
			return;
		}
		remplir(listeSuivante, niveau2(l1.value));
	}
	if (niveau == "3"){
		if (l1.options[l1.options.selectedIndex].value==""){
			return;
		}
		remplir(listeSuivante, niveau3(l1.options[l1.options.selectedIndex].value));
	}
}

function EffacerListe(liste){
	taille=liste.length;
	for(i=0;i<taille;i++){
		liste.options[0]=null;
	}
}

function viderEtRemplir(liste, tab,titre){
	var l1 = eval("document.formulaire."+liste);
	if(titre != "") 
	{
		l1.options[0] = new Option(titre,"",0,0);
		vider(l1);
	}
	else
	{
		EffacerListe(l1);
	}
	if(tab != "")
	{
		for (var i=0; i<tab.length ; i++)
		{
			l1.options[l1.options.length] = new Option(tab[i][1],tab[i][0],0,0);
		}
	}
}
