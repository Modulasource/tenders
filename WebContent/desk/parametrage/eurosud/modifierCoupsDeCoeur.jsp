<%@ page import="java.util.*,modula.configuration.*,org.coin.fr.bean.*" %>

<% 
CoupCoeur.removeAll();
if (request.getParameterValues("vIdOrganisation") != null) {
	String[] selection = request.getParameterValues("vIdOrganisation");
	out.println("kiki"+selection.length);
	for (int i = 0;i<selection.length; i++)
	{
		CoupCoeur cc = new CoupCoeur();
		cc.setIdOrganisation(Integer.parseInt(selection[i]));
		cc.create();
	}
}
String sMessage = "Vos Coups de Coeur ont été modifiés";
response.sendRedirect(response.encodeRedirectURL("afficherCoupsDeCoeur.jsp?sMessage="+sMessage));
%>