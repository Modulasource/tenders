
<%@ page import="modula.algorithme.*" %>
<%
	String sAction = "";
	int iIdProcedure;
	String rootPath = request.getContextPath()+"/";

	sAction  = request.getParameter("sAction") ;
	iIdProcedure = -1;
	Procedure procedure = null;
	
	if(sAction.equals("remove") )
	{
		
		iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
		procedure = Procedure.getProcedure(iIdProcedure);
		procedure.remove();
		response.sendRedirect(response.encodeRedirectURL("afficherToutesProcedures.jsp"));
		return;
	}
	
	if(sAction.equals("store") )
	{
		iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
		procedure = Procedure.getProcedure(iIdProcedure);
		procedure.setFromForm(request, "");
		procedure.store();
	}
	
	if(sAction.equals("create") )
	{
		procedure = new Procedure();
		procedure.setFromForm(request, "");
		procedure.create();
	}
	response.sendRedirect(response.encodeRedirectURL("afficherToutesProcedures.jsp"));
%>