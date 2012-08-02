
<%@ page import="modula.algorithme.*" %>
<%
	String sAction = "store";
	int iIdEtape;
	String rootPath = request.getContextPath()+"/";

	sAction  = request.getParameter("sAction") ;
	iIdEtape = -1;
	Etape etape = null;
	
	if(sAction.equals("remove") )
	{
		iIdEtape = Integer.parseInt( request.getParameter("iIdEtape") );
		etape = Etape.getEtape(iIdEtape);
		etape.remove();
		response.sendRedirect(response.encodeRedirectURL("afficherToutesEtapes.jsp"));
		return;
	}
	
	if(sAction.equals("store") )
	{
		iIdEtape = Integer.parseInt( request.getParameter("iIdEtape") );
		etape = Etape.getEtape(iIdEtape);
		etape.setFromForm(request, "");
		etape.store();
	}
	
	if(sAction.equals("create") )
	{
		etape = new Etape();
		etape.setFromForm(request, "");
		etape.create();
	}
	response.sendRedirect(response.encodeRedirectURL("afficherEtape.jsp?iIdEtape=" + etape.getId()));
%>