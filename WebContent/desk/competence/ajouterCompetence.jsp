
<%@ page import="org.coin.bean.boamp.*" %>
<%	
	String rootPath = request.getContextPath()+"/";
	String sCompetence;
	sCompetence = request.getParameter("competence_libelle");
	BoampCPF cpf = new BoampCPF();
	cpf.setLibelle(sCompetence);
	cpf.create();
	response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/competence/afficherToutesCompetences.jsp"));
%>