<%@page import="org.coin.util.HttpUtil"%>

<%@ page import="modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sAction = request.getParameter("sAction");
	String sFormPrefix = "";
	int iIdMarcheLot = 0;
	String sIdMarcheLot = request.getParameter("iIdMarcheLot");
	int iIdOnglet  = HttpUtil.parseInt("iIdOnglet", request, 0);

	String sRedirect = "afficherAffaire.jsp";
	if(marche.isAffaireAATR(false))
		sRedirect = "afficherAttribution.jsp";
	
	MarcheLot lot = null;
	if( sAction.equals("moveUp") ) 
	{
		iIdMarcheLot = Integer.parseInt( sIdMarcheLot );
		lot = MarcheLot.getMarcheLot(iIdMarcheLot );
		
		int iNumero = lot.getNumero() ;
		
		MarcheLot lot2 = MarcheLot.getLotFromMarcheAndNumero (marche.getIdMarche(), (iNumero - 1) );
		
		if(lot2 != null)
		{
			lot2.setNumero( iNumero);
			lot.setNumero( iNumero - 1);
			
			lot.store();
			lot2.store();
		}
	}

	if( sAction.equals("moveDown") ) 
	{
		iIdMarcheLot = Integer.parseInt( sIdMarcheLot );
		lot = MarcheLot.getMarcheLot(iIdMarcheLot );
		
		int iNumero = lot.getNumero() ;
		
		MarcheLot lot2 = MarcheLot.getLotFromMarcheAndNumero (marche.getIdMarche(), (iNumero + 1) );
		
		if(lot2 != null)
		{
			lot2.setNumero( iNumero);
			lot.setNumero( iNumero + 1);
			
			lot.store();
			lot2.store();
		}
	
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					sRedirect+"?sAction=store&iIdOnglet="+iIdOnglet
					+"&iIdAffaire=" + marche.getIdMarche()));


%>