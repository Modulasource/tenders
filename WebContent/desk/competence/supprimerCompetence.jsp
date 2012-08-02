
<%@ page import="org.coin.bean.boamp.*" %>
<%	String rootPath = request.getContextPath()+"/";
	int iIdCompetence;
	try{
		iIdCompetence = Integer.parseInt(request.getParameter("iIdCompetence"));
		BoampCPF cpf = new BoampCPF(iIdCompetence); 
		cpf.remove();
	}
	catch (Exception e) {
		out.println("pas de compétence");	
		return;
	}
	response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/competence/afficherToutesCompetences.jsp"));
%>