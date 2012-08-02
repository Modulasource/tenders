<%@page import="org.coin.fr.bean.*,modula.graphic.*" %>
<%
	int iIdCorrespondant = -1;
	String sRedirection = request.getParameter("sRedirection");
	
	iIdCorrespondant = Integer.parseInt(request.getParameter("iIdCorrespondant"));
	Correspondant oCorrespondant = Correspondant.getCorrespondant(iIdCorrespondant);
	try{ 
		CorrespondantInfo oCorrespondantInfo = CorrespondantInfo.getAllFromCorrespondant(oCorrespondant.getIdCorrespondant()).firstElement();
		oCorrespondantInfo.remove();
	} catch (Exception e) {}
	oCorrespondant.remove();

	response.sendRedirect(
			response.encodeRedirectURL(
					sRedirection+"&sAction=store&iIdOnglet="+Onglet.ONGLET_AFFAIRE_ORGANISME));
%>