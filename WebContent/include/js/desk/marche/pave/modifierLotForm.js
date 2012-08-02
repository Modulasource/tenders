var numdiv = 0;
function checkForm()
{
	
	var form = document.formulaire;
	if(!checkCreationLots(form))
		return false;

	return true;
}

function ajouterDiv(prefix)
{
	numdiv++;
	var division = prefix+'objetSupp'+numdiv;
	montrer(division);
	if(numdiv>2)
	{
		cacher(prefix+'ajouterCPV');
	}
}

function cacherToutesDivisions()
{
	var i = 1;
	for(var j=1; j < 5; j++)
	{
		cacher('Lot'+i+'_objetSupp'+j);
	} 
} 

function onAfterPageLoading()
{
	montrer('ajouterCPV');
	cacher('objetSupp1');
	cacher('objetSupp2');
	cacher('objetSupp3');
}
