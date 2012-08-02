
<%@ page import="java.util.*,org.coin.fr.bean.export.*"%>
<%
	String sAction = request.getParameter("sAction");
	String sUrlRedirect ="";
	if (request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect") ;
	}
	
	String sIsProcedureLineaire = null;
	try{
		sIsProcedureLineaire = request.getParameter("sIsProcedureLineaire");
	}
	catch(Exception e){}
	if(sAction.equals("remove"))
	{
		int iIdPublicationSpqr = Integer.parseInt(request.getParameter("iIdPublicationSpqr"));
		PublicationSpqr publi = PublicationSpqr.getPublicationSpqr(iIdPublicationSpqr );
		
		sUrlRedirect += "&iIdObjetReference=" + publi.getIdReferenceObjet()
				 + "&nonce=" +System.currentTimeMillis()+"&sIsProcedureLineaire="+sIsProcedureLineaire;
		
		publi.remove();
		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}


	if(sAction.equals("create"))
	{
		PublicationSpqr publi = new PublicationSpqr();
		publi.setFromForm(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationSpqr()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	if(sAction.equals("create"))
	{
		PublicationSpqr publi = new PublicationSpqr();
		// TODO : Attention ici le set ne prend que les var de la classe mere
		publi.setFromForm(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationSpqr()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	


	if(sAction.equals("createIndentifiants"))
	{
		PublicationSpqr publi = new PublicationSpqr();
		publi.setFromFormIdentifiantsSpqr(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationSpqr()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	
	if(sAction.equals("store"))
	{
		int iIdPublicationSpqr = Integer.parseInt(request.getParameter("iIdPublicationSpqr"));
		PublicationSpqr publi = PublicationSpqr.getPublicationSpqr(iIdPublicationSpqr );
		publi.setFromForm(request, "");
		publi.store();
		
		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationSpqr()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	
	}	
	
%>
