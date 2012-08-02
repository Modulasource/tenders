<%@ page import="org.coin.fr.bean.security.*" %>
<%
	int iIdAutoriteCertification 
		= Integer.parseInt( request.getParameter("iIdAutoriteCertification") );
	
	if(request.getParameter("sType").equals("acr"))
	{
		AutoriteCertificationRacine acr
			= AutoriteCertificationRacine.getAutoriteCertificationRacineMemory(iIdAutoriteCertification);
	
		acr.remove();
	}
	
	if(request.getParameter("sType").equals("aci"))
	{
		AutoriteCertificationIntermediaire aci
			= AutoriteCertificationIntermediaire.getAutoriteCertificationIntermediaireMemory(iIdAutoriteCertification);
	
		aci.remove();
	}
			
	String sUrlRedirect = "afficherToutesAutoriteCertification.jsp?nonce=" + System.currentTimeMillis();
	response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
	

%>
