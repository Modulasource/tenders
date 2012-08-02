function selectAll(item){
	var cases = eval(item);
	for(i=0;i<cases.length;i++){
		if(!cases[i].disabled) cases[i].checked = true;
	}
}
function unselectAll(item){
	var cases = eval(item);
	for(i=0;i<cases.length;i++){
		if(!cases[i].disabled) cases[i].checked = false;
	}
}
function remplirItemFromCheckboxesChecked(itemfrom, itemto){
	var cases=eval(itemfrom);
	var chaine = eval(itemto);
	for(i=0;i<cases.length;i++)
	{
		if(cases[i].checked == true)
		{
			chaine.value += cases[i].value+",";
		}
	}
}

function selectAllByName(item){
	var cases = document.getElementsByName(item);
	for(i=0;i<cases.length;i++){
		if(!cases[i].disabled) cases[i].checked = true;
	}
}
function unselectAllByName(item){
	var cases = document.getElementsByName(item);
	for(i=0;i<cases.length;i++){
		if(!cases[i].disabled) cases[i].checked = false;
	}
}
function remplirItemFromCheckboxesCheckedByName(itemfrom, itemto){
	var cases=document.getElementsByName(itemfrom);
	var chaine = document.getElementsByName(itemto)[0];
	
	var isChecked = false;
	for(i=0;i<cases.length;i++)
	{
		if(cases[i].checked == true)
		{
			isChecked = true;
			chaine.value += cases[i].value+",";
		}
	}
	return isChecked;
}
