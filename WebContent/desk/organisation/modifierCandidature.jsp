<%@ include file="/include/headerXML.jspf" %>

<%@ page import="modula.candidature.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%
	//String rootPath = request.getContextPath()+"/";

	Candidature candidature = Candidature.getCandidature(Integer.parseInt(request.getParameter("lIdCandidature")));

	int iIdPersonnePhysique = candidature.getIdPersonnePhysique();
	
	String sUrlRedirect = "afficherToutesCandidatures.jsp?iIdPersonnePhysique="
			+ iIdPersonnePhysique;
	
	candidature.removeWithObjectAttached();
	
	response.sendRedirect(response.encodeURL(sUrlRedirect ));
%>