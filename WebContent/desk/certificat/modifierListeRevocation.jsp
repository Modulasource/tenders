<%@ page import="org.coin.fr.bean.security.*" %>
<%
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdListeRevocation = -1;
	if(request.getParameter("iIdListeRevocation") != null)
		iIdListeRevocation = Integer.parseInt(request.getParameter("iIdListeRevocation"));
	
	ListeRevocation liste = null;
	if(sAction.equals("create"))
	{
		liste = new ListeRevocation();
		liste.setFromFormMultiPart(request,"");
		liste.create();
	}
	
	if(sAction.equals("store"))
	{
		liste = ListeRevocation.getListeRevocationMemory(iIdListeRevocation);
		liste.setFromFormMultiPart(request,"");
		liste.store();
	}
	
	if(sAction.equals("remove"))
	{
		liste = ListeRevocation.getListeRevocationMemory(iIdListeRevocation);
		liste.remove();
	}
		
	String sUrlRedirect = "afficherToutesListeRevocation.jsp?nonce=" + System.currentTimeMillis();
	response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
%>
