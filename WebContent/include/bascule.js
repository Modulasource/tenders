// D?place de la liste l1 ? la liste l2
function Deplacer(l1,l2) {
	if (l1.options.selectedIndex>=0) {
		var o=new Option(l1.options[l1.options.selectedIndex].text,l1.options[l1.options.selectedIndex].value);
		l2.options[l2.options.length]=o;
		l1.options[l1.options.selectedIndex]=null;
	}else{
		alert("Aucun ?l?ment s?lectionn?");
	}
}
function DeplacerPremier(l1,l2) 
{
	if(l1.options[0].value != null)
	{
		var o=new Option(l1.options[0].text,l1.options[0].value);
		l2.options[l2.options.length]=o;
		l1.options[0]=null;
	}
}

// D?place de la liste l1 &agraveg; la liste l2
function copierDansListe(l1,l2) {
	if (l1.options.selectedIndex>=0) {
		var o=new Option(l1.options[l1.options.selectedIndex].text,l1.options[l1.options.selectedIndex].value);
		l2.options[l2.options.length]=o;
	}else{
	}
}

// D?place de la liste l1 &agraveg; la liste l2
function supprimerDansListe(l1) {
	if (l1.options.selectedIndex>=0) {
		l1.options[l1.options.selectedIndex]=null;
	}else{
	}

}


function equilibrerBalance(l1, l2)
{
	var listeValeur ;
	
	for (var i=0 ; i < l1.length ; i++)
	{
		listeValeur = l1.options[i].text ;
		for (var j=0 ; j < l2.length ; j++)
		{
			if(l2.options[j].text == listeValeur)
			{
				// on efface la valeur de gauche
				supprimer(l2 , j);
			}
		}
	}
}


// supprimer
function supprimer(l1, item) 
{
	
	l1.options[item]=null;
	
}

function moveAllItem(list1,list2) 
{
	var l1Opt = $(list1);
	var l2Opt = $(list2);
	
	
	while (l1Opt.selectedIndex>=0) {
		var index = l1Opt.selectedIndex;
		var o=new Option(
				l1Opt [index ].text,
				l1Opt [index ].value);
		l2Opt.options[l2Opt .length] = o;
		l1Opt [index ] = null;
	}

}

function moveItemFromInput(textInput,list2) 
{
	//var l1Opt = $(list1);
	var textInput = $(textInput);
	var l2Opt = $(list2);
	if(textInput.value!=""){
		//var index = l1Opt.selectedIndex;
		var o=new Option(
				textInput.value,
				textInput.value);
		l2Opt.options[l2Opt .length] = o;
		//l1Opt [index ] = null;
	}
}

function selectAllItem(list) 
{
	var selectBox = $(list);
	
	for (var i=0; i<selectBox.options.length; i++) {
	 	selectBox.options[i].selected=true;
	}
}

function selectAllItemLists(list, list1) 
{
	//used in the Send of Report by Mail
	for (var i=0; i<$(list).options.length; i++) {
	 	$(list).options[i].selected=true;
	}
	
	for (var j=0; j<$(list1).options.length; j++) {
	 	$(list1).options[j].selected=true;
	}
}

// D?place de la liste l1 &agraveg; la liste l2
// Si aucun ?l?ment n'est selectionn?, apparition du message d'alerte
function DeplacerTous(l1,l2) {
	while (l1.options.selectedIndex>=0) {
		var o=new Option(l1.options[l1.options.selectedIndex].text,l1.options[l1.options.selectedIndex].value);
		l2.options[l2.options.length]=o;
		l1.options[l1.options.selectedIndex]=null;
	}
	
}
function Visualise(liste, hidden){
	var tab_select = "";
	var i=0;

	while (i < liste.options.length){
		tab_select += liste.options[i++].value + "|";
	}
	
	return hidden.value = tab_select;
}



function monter(l1){
	if (l1.options.selectedIndex>0) {
		var initIndex = l1.options.selectedIndex;
		var initTaille = l1.options.length;
		var tabText = new Array();
		var tabVal = new Array();
		var i=0;
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
function descendre(l1){
	if (l1.options.selectedIndex>=0 && (l1.options.length-1 > l1.options.selectedIndex)) {
		var initIndex = l1.options.selectedIndex;
		var initTaille = l1.options.length;
		var tabText = new Array();
		var tabVal = new Array();
		var i = 0;
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
