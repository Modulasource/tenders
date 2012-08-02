
<%@ page import="modula.algorithme.*" %>
<%
	String sAction = "";
	int iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
	int iIdPhaseProcedure;
	
	sAction  = request.getParameter("sAction") ;
	PhaseProcedure oPhaseProcedure = null;
	
	if(sAction.equals("create"))
	{
		oPhaseProcedure = new PhaseProcedure();
		oPhaseProcedure.setFromForm(request, "");
		oPhaseProcedure.create();
		
		int iIdPhaseTransition = Integer.parseInt(request.getParameter("iIdPhaseTransition")) ;
	  	PhaseTransition.insertPhaseTransition(
	  			iIdPhaseTransition , 
	  			(int)oPhaseProcedure.getId(), 
	  			iIdProcedure );
	}
	
	if(sAction.equals("remove") )
	{
		iIdPhaseProcedure = Integer.parseInt( request.getParameter("iIdPhaseProcedure") );
		oPhaseProcedure = PhaseProcedure.getPhaseProcedure(iIdPhaseProcedure);
		oPhaseProcedure.remove();
	}
	response.sendRedirect(response.encodeRedirectURL("modifierProcedureForm.jsp?iIdProcedure=" + iIdProcedure));

%>