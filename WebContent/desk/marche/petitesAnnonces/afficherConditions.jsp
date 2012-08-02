<%@ include file="/include/headerXML.jspf" %>

<%@ page import="modula.marche.*,modula.algorithme.*,modula.*,org.coin.util.treeview.*,modula.algorithme.condition.*,java.util.*,java.text.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%

/**
 * @deprecated : ne compile plus !!
 */

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Traitement des Conditions";
	String rootPath = request.getContextPath()+"/";
	String sMessTitle = "";
	String sAction = "";
%>
<%@ include file="/desk/include/headerDesk.jspf" %>
</head>
<body>
<% String sHeadTitre = "Vérification des conditions"; %>
<%@ include file="../../include/headerPetiteAnnonce.jspf" %>
<%			
		Vector vMessages = new Vector();
		boolean bSucces = true;
		Vector vConditions = AlgorithmeModula.getAllConditions(marche.getIdMarche(),marche.getIdAlgoPhaseEtapes());
		for(int i=0;i<vConditions.size();i++)
		{
			Vector vMessage = new Vector();
			Condition oCondition = (Condition)vConditions.get(i);
			if(oCondition.isSatisfied(iIdAffaire, 0)) vMessage.add(rootPath+modula.graphic.Icone.ICONE_SUCCES);
			else 
			{
				vMessage.add(rootPath+modula.graphic.Icone.ICONE_WARNING);
				bSucces = false;
			}
			vMessage.add(oCondition.getName());
			vMessages.add(vMessage);
		}
		
		if(bSucces) sMessTitle = "Validation des conditions avec succ&egrave;s";
		else sMessTitle = "Echec de la validation des conditions";

%>
<table>
	<tr>
		<td style="vertical-align:middle">
<%@ include file="../../../include/messageMultiple.jspf" %>
<%
if(bSucces)
{
	PhaseEtapes oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes());
	PhaseProcedure oPhaseProcedure = PhaseProcedure.getPhaseProcedure(oPhaseEtapes.getIdAlgoPhaseProcedure());

	int iPreTraitement = -1;
	if( oPhaseProcedure.getIdAlgoPhase() == Phase.PHASE_CREATION_AATR)
	{
		// FLON : !!!!! à revoir
		PhaseEtapes oPhaseEtapesSuivante = null;
		for(int i=0;i<4;i++)
		{
			oPhaseEtapesSuivante = AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes());
			if(oPhaseEtapesSuivante.getId() != 0)
			{
				try
				{
					marche.setIdAlgoPhaseEtapes(oPhaseEtapesSuivante.getId());
				}
				catch(Exception e)
				{
					System.out.println("Exception > afficherConditions.jsp: "+e.getMessage());
				}
		}
		iPreTraitement = oPhaseEtapesSuivante.getId();
	}
%>
<div style="text-align:center">
	<input type="button" value="Poursuivre l'affaire" 
		onclick="Redirect('<%= 
			 response.encodeURL(
					 rootPath 
					 + "desk/marche/petitesAnnonces/poursuivreProcedure.jsp"
					 + "?sAction=next"
					 + "&amp;iTesterConditions=0"
					 + "&amp;iPreTraitement="+iPreTraitement
					 + "&iIdAffaire=" + marche.getId()) %>')" />
</div>
<%
	}
	else
	{
%>
<div style="text-align:center">
	<input type="button" value="Retour à l'affaire" 
		onclick="Redirect('<%= response.encodeURL(rootPath + "desk/marche/petitesAnnonces/afficherPetiteAnnonce.jsp?iIdOnglet=0&amp;iIdAffaire="+ iIdAffaire) %>')" />
</div>
<%
	}
}
%>

		</td>
	</tr>
	<tr>
		<td style="vertical-align:bottom">
		<%@ include file="/desk/include/footerDesk.jspf" %>
		</td>
	</tr>
</table>
</body>
</html>