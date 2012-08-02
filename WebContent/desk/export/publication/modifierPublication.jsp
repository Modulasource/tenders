
<%@ page import="java.util.*,org.coin.fr.bean.export.*"%>
<%
	String sAction = request.getParameter("sAction");
	String sUrlRedirect ="";
	if (request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect") ;
	}
	
	if(sAction.equals("remove"))
	{
		int iIdPublication = Integer.parseInt(request.getParameter("iIdPublication"));
		Publication publi = Publication.getPublication(iIdPublication );
		
		sUrlRedirect += "&iIdObjetReference=" + publi.getIdReferenceObjet()
				 + "&nonce=" +System.currentTimeMillis();
		
		// ATTENTION ici on ne supprime pas l'objet fille !
		publi.remove();
		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}


	if(sAction.equals("create"))
	{
		Publication publi = new Publication();
		publi.setFromForm(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublication()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	if(sAction.equals("store"))
	{
		int iIdPublication = Integer.parseInt(request.getParameter("iIdPublication"));
		Publication publi = Publication.getPublication(iIdPublication );
		publi.setFromForm(request, "");
		publi.store();
		
		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublication()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	
	}	
	
%>
