
<%@ page import="modula.candidature.*,modula.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="../../../include/publisherType.jspf" %> 
<%
	String rootPath = request.getContextPath()+"/";
	EnveloppeC eEnveloppe =  EnveloppeC.getEnveloppeC(Integer.parseInt(request.getParameter("iIdEnveloppe")));

	if (request.getParameter("commentaireEnveloppe") != null)
	{
		eEnveloppe.setCommentaire(request.getParameter("commentaireEnveloppe"));
		eEnveloppe.store();
	}
	response.sendRedirect(response.encodeRedirectURL(rootPath + sPublisherPath+"/private/candidat/constituerOffreCForm.jsp?iIdEnveloppe=" + eEnveloppe.getIdEnveloppe()));
%>
