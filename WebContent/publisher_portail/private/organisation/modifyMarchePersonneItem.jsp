
<%@page import="mt.modula.affaire.personne.MarchePersonneItem"%>
<%@page import="org.coin.util.HttpUtil"%>
<%

	
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	MarchePersonneItem item = null;
    String sUrlRedirect = "";
	
	if(sAction.equals("remove"))
	{
		item = MarchePersonneItem.getMarchePersonneItem(HttpUtil.parseLong("lId", request));
		item.remove();
		
		// idPP get from sessionUser account
		sUrlRedirect = "displayAllMarchePersonneItem.jsp";
	}

	
    if(sAction.equals("modifyType"))
    {
        item = MarchePersonneItem.getMarchePersonneItem(HttpUtil.parseLong("lId", request));
        item.setIdMarchePersonneItemType(HttpUtil.parseLong("lIdMarchePersonneItemType", request));
        item.store();
        
        // idPP get from sessionUser account
        sUrlRedirect = "displayAllMarchePersonneItem.jsp";
    }

	
	response.sendRedirect(
			response.encodeRedirectURL(
					sUrlRedirect));
%>