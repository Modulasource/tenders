
<%@ page import="org.coin.util.*,org.coin.bean.*,java.util.*,modula.algorithme.*" %>
<%
	String sIdConditionsListe ;
	int iIdProcedure;
	int iIdPhaseTransition;

	iIdProcedure = Integer.parseInt( request.getParameter("iIdProcedure") );
	iIdPhaseTransition = Integer.parseInt( request.getParameter("iIdPhaseTransition") );
	
	PhaseTransition oPhaseTransition = PhaseTransition.getPhaseTransition(iIdPhaseTransition);
	sIdConditionsListe = request.getParameter("oPhaseTransition.getId() :" + oPhaseTransition.getId());
	PhaseTransitionConditions.removeAllConditionFromIdPhaseTransitionConditions(oPhaseTransition.getIdPhaseTransitionConditions());
	
	sIdConditionsListe = request.getParameter("iIdConditionSelectionListe");
	Vector vIntegerList = Outils.parseIntegerList(sIdConditionsListe , "|");
	
	for(int i =0; i < vIntegerList.size(); i++)
	{
		int iIdCondition = ((Integer) vIntegerList.get(i)).intValue();
		if(oPhaseTransition.getIdPhaseTransitionConditions() == 0)
		{
			oPhaseTransition.setIdPhaseTransitionConditions(PhaseTransitionConditions.getNextMaxId());
			oPhaseTransition.store();
		}
		PhaseTransitionConditions oPhaseTransitionConditions 
			= new PhaseTransitionConditions (oPhaseTransition.getIdPhaseTransitionConditions(), iIdCondition);
	
		oPhaseTransitionConditions.create();
	}
	response.sendRedirect(
			response.encodeRedirectURL("modifierProcedureForm.jsp?iIdProcedure=" + iIdProcedure));
%>