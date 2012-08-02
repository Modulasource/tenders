<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.*,modula.graphic.*" %>
<%
	String sSelected ;
	String sTitle ;
	int iIdPhase ;
	
	iIdPhase = Integer.parseInt( request.getParameter("iIdPhase") );
	sTitle = "Afficher une phase"; 
	Phase phase = Phase.getPhase(iIdPhase);
	
%>
<script type="text/javascript">
function confirmSubmit(phrase){
	var agree=confirm("Etes vous sûr de vouloir "+phrase);
	if (agree)
		return true ;
	else
		return false ;
}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<table class="menu" cellspacing="2" summary="menu">
	<tr>
		<th>
			<a href="<%= response.encodeURL(rootPath+"desk/marche/algorithme/modifierPhaseForm.jsp?sAction=store&amp;iIdPhase="+ phase.getId()) %>" ><img width="25" src="<%= rootPath %>images/icones/modifier.gif" border"0" alt="Modifier la phase" /></a>
		</th>
		<th>
			<a href="<%= response.encodeURL(rootPath+"desk/marche/algorithme/modifierPhase.jsp?sAction=remove&amp;iIdPhase="+phase.getId()) %>" onclick="return confirmSubmit('supprimer cette phase ?')" ><img width="25" src="<%= rootPath + Icone.ICONE_SUPPRIMER %>"  alt="Supprimer la phase" /></a>
		</th>
		<td>&nbsp;</td>
	</tr>
	</table>
	<br />
	
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2" >Phase: <%=phase.getName()%></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Libellé : </td>
			<td class="pave_cellule_droite"><%=phase.getName() %></td>
		</tr>			
	</table>
	<br />
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
