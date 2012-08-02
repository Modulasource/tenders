
<%@page import="org.coin.util.Outils"%>
<%@ page import="org.coin.bean.*,java.util.*,modula.algorithme.*" %>
<%

	String sSelected ;
	String sTitle ;
	String sAction = "store";
	String sIdEtapesListe ;
	int iIdPhaseProcedure;
	String rootPath = request.getContextPath()+"/";

	iIdPhaseProcedure = Integer.parseInt( request.getParameter("iIdPhaseProcedure") );
	PhaseProcedure oPhaseProcedure = PhaseProcedure.getPhaseProcedure(iIdPhaseProcedure);
	PhaseEtapes.removeAllEtapesFromPhaseProcedure(iIdPhaseProcedure);
	
	sIdEtapesListe = request.getParameter("iIdEtapeSelectionListe");
	Vector vIntegerList = Outils.parseIntegerList(sIdEtapesListe , "|");
	
	for(int i =0; i < vIntegerList.size(); i++)
	{
		int iIdEtape = ((Integer) vIntegerList.get(i)).intValue();
		PhaseEtapes oPhaseEtapes 
			= new PhaseEtapes ((int)oPhaseProcedure.getId(), iIdEtape, i+1 );
	
		oPhaseEtapes.create();
	}
	response.sendRedirect(
			response.encodeRedirectURL("modifierProcedureForm.jsp?iIdProcedure=" 
					+ oPhaseProcedure.getIdAlgoProcedure()));
%>