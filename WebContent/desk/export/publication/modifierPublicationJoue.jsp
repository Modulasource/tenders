
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
		int iIdPublicationJoue = Integer.parseInt(request.getParameter("iIdPublicationJoue"));
		PublicationJoue publi = PublicationJoue.getPublicationJoue(iIdPublicationJoue );
		
		sUrlRedirect += "&iIdObjetReference=" + publi.getIdReferenceObjet()
				 + "&nonce=" +System.currentTimeMillis();
		
		publi.remove();
		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}


	if(sAction.equals("create"))
	{
		PublicationJoue publi = new PublicationJoue();
		publi.setFromForm(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationJoue()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	if(sAction.equals("create"))
	{
		PublicationJoue publi = new PublicationJoue();
		publi.setFromForm(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationJoue()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	


	if(sAction.equals("createIndentifiants"))
	{
		PublicationJoue publi = new PublicationJoue();
		publi.setFromFormIdentifiants(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationJoue()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	
	if(sAction.equals("store"))
	{
		int iIdPublicationJoue = Integer.parseInt(request.getParameter("iIdPublicationJoue"));
		PublicationJoue publi = PublicationJoue.getPublicationJoue(iIdPublicationJoue );
		publi.setFromForm(request, "");
		publi.store();
		
		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationJoue()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	
	}	
	
%>
