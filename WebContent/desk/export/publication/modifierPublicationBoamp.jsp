
<%@page import="org.coin.util.HttpUtil"%>
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
	int iIdOnglet = 0;
	try{
		iIdOnglet  = Integer.parseInt( request.getParameter("iIdOnglet"));
	}
	catch(Exception e){}
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request, -1);
	
	if(sAction.equals("remove"))
	{
		int iIdPublicationBoamp = Integer.parseInt(request.getParameter("iIdPublicationBoamp"));
		PublicationBoamp publi = PublicationBoamp.getPublicationBoamp(iIdPublicationBoamp );
		Export export = Export.getExport(publi.getIdExport());
		
		sUrlRedirect += 
				 "&iIdObjetReference=" + publi.getIdReferenceObjet()
				 // plus compliqué que cela ... il faut sans doute le IdExport ou d'autres trucs
				 // voir à le faire en ajax
				//+ "&iIdOnglet=" + iIdOnglet
				+ "&iIdNextPhaseEtapes="+iIdNextPhaseEtapes
				+ "&nonce=" +System.currentTimeMillis()+"&sIsProcedureLineaire="+sIsProcedureLineaire+"#ancreHP";
		
		publi.removeWithObjectAttached();
		
		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}


	if(sAction.equals("create"))
	{
		PublicationBoamp publi = new PublicationBoamp();
		publi.setFromForm(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationBoamp()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	if(sAction.equals("create"))
	{
		PublicationBoamp publi = new PublicationBoamp();
		publi.setFromForm(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationBoamp()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	


	if(sAction.equals("createIndentifiants"))
	{
		PublicationBoamp publi = new PublicationBoamp();
		publi.setFromFormIdentifiants(request, "");

		publi.create();

		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationBoamp()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	
	if(sAction.equals("store"))
	{
		int iIdPublicationBoamp = Integer.parseInt(request.getParameter("iIdPublicationBoamp"));
		PublicationBoamp publi = PublicationBoamp.getPublicationBoamp(iIdPublicationBoamp );
		publi.setFromForm(request, "");
		publi.store();
		
		sUrlRedirect 
			+= "&iIdPublication=" + publi.getIdPublicationBoamp()
			+ "&iIdObjetReference=" + publi.getIdReferenceObjet()
			+ "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	
	}	
	
%>
