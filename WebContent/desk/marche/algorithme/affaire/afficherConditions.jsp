<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,modula.algorithme.*,modula.algorithme.condition.*" %>
<%
    int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
    Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Traitement des Conditions";
	
	String sMessTitle = "";
	String sMention = "";
	String sHeadTitre = "";
	PhaseEtapes oPhaseEtapeCourante = PhaseEtapes.getPhaseEtapesMemory(marche.getIdAlgoPhaseEtapes());
	Phase oPhaseCourante = Phase.getPhaseMemory(PhaseProcedure.getPhaseProcedureMemory(oPhaseEtapeCourante.getIdAlgoPhaseProcedure()).getIdAlgoPhase());
	Phase oPhaseSuivante = Phase.getPhaseMemory(PhaseProcedure.getPhaseProcedureMemory(PhaseEtapes.getPhaseEtapesMemory(AlgorithmeModula.getNextPhaseEtapesInProcedure(oPhaseEtapeCourante.getId()).getId()).getIdAlgoPhaseProcedure()).getIdAlgoPhase());
	boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
	int iTypeProcedure = 0;
	try{
		iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	} catch (Exception e) {}

	switch((int)oPhaseCourante.getId())
	{
		case Phase.PHASE_CREATION:
			sHeadTitre = "Validation de l'affaire";
			sMessTitle = "Etat de l'affaire";
			break;
			
		case Phase.PHASE_CREATION_AATR:
			sHeadTitre = "Validation de l'Avis d'Attribution";
			sMessTitle = "Etat de l'Avis d'Attribution";
			break;
			
		case Phase.PHASE_PUBLICATION_AAPC:
			sHeadTitre = "Publicité de l'affaire";
			sMessTitle = "Etat des publications";
			break;
		
		case Phase.PHASE_PUBLICATION_AATR:
			sHeadTitre = "Publicité de l'Avis d'Attribution";
			sMessTitle = "Etat des publications";
			break;
		
		case Phase.PHASE_CONSTITUTION_PROPOSITIONS:
			sHeadTitre = "Vérification du planning";
			sMessTitle = "Etat du planning";
			break;
		
		case Phase.PHASE_CONSTITUTION_ENVELOPPE_A:
			sHeadTitre = "Vérification du planning";
			sMessTitle = "Etat du planning";
			break;
		
		case Phase.PHASE_CONSTITUTION_ENVELOPPE_B:
			sHeadTitre = "Vérification du planning";
			sMessTitle = "Etat du planning";
			break;
			
		case Phase.PHASE_CONSTITUTION_ENVELOPPE_B_C:
			sHeadTitre = "Vérification du planning";
			sMessTitle = "Etat du planning";
			break;
			
		default:
			sHeadTitre = "Vérification des conditions";
			sMessTitle = "Etat des conditions de transition";
			break;
	}

%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<% 
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="../../../../include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%
	Vector<Vector> vMessages = new Vector<Vector>();
	boolean bSucces = true;
	Vector vConditions = null;
	try
	{
		vConditions = AlgorithmeModula.getAllConditions(marche.getIdMarche(),marche.getIdAlgoPhaseEtapes());
	}
	catch(Exception e){
		vConditions = new Vector();
	}
	
	for(int i=0;i<vConditions.size();i++)
	{
		Vector<String> vMessage = new Vector<String>();
		Condition oCondition = (Condition)vConditions.get(i);
		if(oCondition.isSatisfied(iIdAffaire)) vMessage.add(rootPath+Icone.ICONE_SUCCES);
		else 
		{
			vMessage.add(rootPath + Icone.ICONE_WARNING);
			bSucces = false;
		}
		vMessage.add(oCondition.getName());
		vMessages.add(vMessage);
	}
	
	
/*	if (iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE)
	{
		//if(oPhaseCourante.getId() == 0)
		Vector<String> vMessage = new Vector<String>();
		vMessage.add(rootPath + Icone.ICONE_WARNING);
		vMessage.add("Attention, après cette étape vous ne pourrez plus créer de candidatures papiers.");
		vMessages.add(vMessage);	
		
	}
*/
%>
<%@ include file="../../../../include/messageMultiple.jspf" %>
<%
	String sTargetURL = "afficherAffaire.jsp";
	if(marche.isAffaireAATR(false)) sTargetURL = "afficherAttribution.jsp";
	
	if(bSucces)
	{
		String sBouton = "Poursuivre la procédure";
		if(oPhaseSuivante.getId() == Phase.PHASE_CREATION_AATR)
		{
			sBouton = "Créer l'Avis d'Attribution";
		}
%>
<div align="center">
	<button type="button" 
		onclick="Redirect('<%= 
			response.encodeURL(rootPath 
					+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
					+ "?sAction=next"
					+ "&iTesterConditions=0"
					+ "&iIdAffaire=" + marche.getId()) 
				%>')" ><%= sBouton %> </button>&nbsp;
</div>
<%
	}
	else if(oPhaseSuivante.getId() == Phase.PHASE_CREATION_AATR && !bIsContainsCandidatureManagement)
	{
		sMention = "Vous pourrez créer l'avis d'attribution une fois toutes les conditions ci-dessus validées.";
%>

<div style="text-align:center;" class="mention"><%= sMention %></div>
<br/>
<%
	}
%>
</div>
<input type="hidden" name="iIdAffaire" value="<%= iIdAffaire %>" />
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>