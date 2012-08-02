function Redirect(url)
{		
	// pour ?viter les pbs de lancement de script par des domaines diff?rents 
	// @see http://www.mozilla.org/docs/dom/domref/dom_window_ref76.html
	/*
	try {
		if (window.top.main != null)
		{
			window.top.main.location.href = url ;
		}
		else 
		{
			window.location.href = url ;
		}
	} catch(e) {
		//alert (e);
		window.location.href = url ;
	}
	*/
	window.location.href = url ;
}


function doUrl(url)
{		
	window.location.href = url ;
}


function doUrlForParentOrCurrentWindow(url)
{       
    try{
        parent.window.location.href = url ;
    }  catch(e) {
        window.location.href = url  ;
    }
}

function redirectUrlAndClosePopup(url)
{
    // FLON inside ... il faut que le iframe 'main' existe sinon cela ne fonctionne pas
    try {
        opener.parent.main.document.location.href=url;
    } catch(e) {
        // si pas de iframe 'main' alors on recharge compl?tement la page
        opener.parent.document.location.href=url;
    }
     
    setTimeout("self.close();",500);
}

function RedirectURL(url)
{
	// FLON inside ... il faut que le iframe 'main' existe sinon cela ne fonctionne pas
	/*
	try {
		opener.parent.main.document.location.href=url;
	} catch(e) {
		// si pas de iframe 'main' alors on recharge compl?tement la page
		opener.parent.document.location.href=url;
	}
	*/
	opener.parent.document.location.href=url;
	
	setTimeout("self.close();",500);
}

function RedirectURLWithoutClosing(url)
{
	// FLON inside ... il faut que le iframe 'main' existe sinon cela ne fonctionne pas
	/*
	try {
		opener.parent.main.document.location.href=url;
	} catch(e) {
		// si pas de iframe 'main' alors on recharge compl?tement la page
		opener.parent.document.location.href=url;
	}
	*/
	opener.parent.document.location.href=url;
}

