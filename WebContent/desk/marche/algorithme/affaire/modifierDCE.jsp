<%@ include file="/include/headerXML.jspf" %>
<%@page import="modula.journal.Evenement"%>

<%@ page import="modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("sAction");
	
	if(sAction.equals("debuter"))
	{
		marche.setDCEModifieApresPublication(true);
		marche.setCandidatsPrevenusModificationDCE(false);
		marche.store();
		response.sendRedirect(
				response.encodeRedirectURL(
						"afficherAffaire.jsp?sAction=store&iIdOnglet=7&iIdAffaire=" 
						+ marche.getIdMarche() 
						+ "&nonce=" + System.currentTimeMillis() ));
		return;
	}
	
	if(sAction.equals("cloturer"))
	{
		marche.setDCEModifieApresPublication(false);
		marche.setCandidatsPrevenusModificationDCE(true);
		Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-23", sessionUser.getIdUser(), "Rectification du DCE");	
		Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-81", sessionUser.getIdUser(), "Les candidats ont été prévenus de la réctification du DCE");	
		marche.store();
		response.sendRedirect( response.encodeRedirectURL("afficherAffaire.jsp?iIdOnglet=7&iIdAffaire=" + marche.getIdMarche() + "&nonce=" + System.currentTimeMillis()  ));
		return;
	}
				
%>