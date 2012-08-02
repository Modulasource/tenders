var calendrierW;
function calendrierDesk(name,rootPath,niveau){
	var url;
	eval("ladate = "+name+".value");
	if(niveau == null) niveau = 0;
	switch(niveau)
	{
	case 0:
		url = rootPath+"include/calendar.jsp?name=main."+name;
		break;
	case 1:
		url = rootPath+"include/calendar.jsp?name="+name;
		break;
	}
	
	if (ladate != ""){
		var tab = ladate.split("/");
		url += "&annee="+tab[2]+"&jour="+tab[0]+"&amp;mois="+tab[1];
	}
	
	try
	{
		calendrierW = window.open(url, 'calendrierW', 'width=350,height=145,"menubar=no,scrollbars=no,statusbar=no"');
	}
	catch(e)
	{
		alert("imposible d'ouvrir le calendrier" + e);
	}
	if (calendrierW.opener == null)
	{
		switch(niveau)
		{
			case 0:
				calendrierW.opener = window;
				break;
			case 1:
				calendrierW.opener = filleW;
				break;
		}
	}
	else calendrierW.focus();

}

function calendrierPublisher(name,rootPath){
	eval("ladate = "+name+".value");
	var url = rootPath+"include/calendar.jsp?name="+name;
	if (ladate != ""){
		var tab = ladate.split("/");
		url += "&annee="+tab[2]+"&jour="+tab[0]+"&amp;mois="+tab[1];
	}
	calendrierW = window.open(url, 'calendrierW', 'width=350,height=145,"menubar=no,scrollbars=no,statusbar=no"');
	if (calendrierW.opener == null)	calendrierW.opener = window;
	else calendrierW.focus();

}
