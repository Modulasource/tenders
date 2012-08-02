<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.*" %>
<%
	String sSelected ;
	String sTitle = null;
	int iIdPhase;
	String sAction = null;
	Phase phase = null;

	sAction = request.getParameter("sAction") ;
	if(sAction.equals("store"))
	{
		iIdPhase = Integer.parseInt( request.getParameter("iIdPhase") );
		sTitle = "Modifier une phase"; 
		phase = Phase.getPhase(iIdPhase);
	}
	
	if(sAction.equals("create"))
	{
		iIdPhase = -1;
		sTitle = "Ajouter une phase"; 
		phase = new Phase();
	}
	
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifierPhase.jsp")%>" method='post' >
	<input type="hidden" name="iIdPhase" value="<%= phase.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Informations</td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Libellé : </td>
			<td class="pave_cellule_droite"><input value="<%=phase.getName() %>" name="sName" size="100" /></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<input type="submit" value="<%=sTitle %>" />
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=response.encodeRedirectURL("afficherPhase.jsp?iIdPhase="+phase.getId()) %>')" />
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
