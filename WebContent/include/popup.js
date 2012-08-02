var filleW;
var filleW2;
function OuvrirPopup(page,largeur,hauteur,options,niveau) {
  if(niveau == null) niveau = 0;
  var top=(screen.height-hauteur)/2;
  var left=(screen.width-largeur)/2;
  switch(niveau)
  {
	case 0:
		filleW = window.open(page,"filleW","top="+top+",left="+left+",width="+largeur+",height="+hauteur+","+options);
		if (filleW.opener == null) 
  		{
  			filleW.opener = window;
  		}
  		else filleW.focus();
		break;
	case 1:
		filleW2 = window.open(page,"filleW2","top="+top+",left="+left+",width="+largeur+",height="+hauteur+","+options);
		if (filleW2.opener == null) 
  		{
  			filleW2.opener = filleW;
  		}
  		else filleW2.focus();
		break;
  }
  
}