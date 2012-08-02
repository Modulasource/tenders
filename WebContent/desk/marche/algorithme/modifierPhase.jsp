
<%@ page import="modula.algorithme.*" %>
<%
	String sAction = "";
	int iIdPhase;
	String rootPath = request.getContextPath()+"/";

	sAction  = request.getParameter("sAction") ;
	iIdPhase = -1;
	Phase phase = null;
	
	if(sAction.equals("remove") )
	{
		iIdPhase = Integer.parseInt( request.getParameter("iIdPhase") );
		phase = Phase.getPhase(iIdPhase);
		phase.remove();
		response.sendRedirect(response.encodeRedirectURL("afficherToutesPhases.jsp"));
		return;
	}
	
	if(sAction.equals("store") )
	{
		iIdPhase = Integer.parseInt( request.getParameter("iIdPhase") );
		phase = Phase.getPhase(iIdPhase);
		phase.setName( request.getParameter("sName") );
		phase.store();
	}
	
	if(sAction.equals("create") )
	{
		phase = new Phase();
		phase.setName( request.getParameter("sName") );
		phase.create();
	}
	
	response.sendRedirect(response.encodeRedirectURL("afficherPhase.jsp?iIdPhase=" + phase.getId()));
	
%>