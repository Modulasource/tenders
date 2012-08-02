<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.condition.*,modula.graphic.*" %>
<%
	String sSelected ;
	String sTitle ;
	int iIdCondition;

	iIdCondition = Integer.parseInt( request.getParameter("iIdCondition") );
	sTitle = "Afficher une phase"; 
	ConditionBean condition = ConditionBean.getConditionBean(iIdCondition);

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
	<table class="pave" >
		<tr>
			<td class="pave_cellule_gauche">Libellé : </td>
			<td class="pave_cellule_droite"><%=condition.getName() %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
			<a href="<%= response.encodeURL(rootPath + "desk/marche/algorithme/modifierConditionForm.jsp?sAction=store&amp;iIdCondition="+condition.getId()) %>" ><img width="25" src="<%= rootPath %>images/icones/modifier.gif"  /></a>
			</td>
			<td class="pave_cellule_droite">
			<a href="<%= response.encodeURL(rootPath + "desk/marche/algorithme/modifierCondition.jsp?sAction=remove&amp;iIdCondition="+condition.getId()) %>" onclick="return confirmSubmit('supprimer cette condition ?')" ><img width="25" src="<%= rootPath + Icone.ICONE_SUPPRIMER %>" /> </a>
			<a href="<%= response.encodeURL(rootPath + "desk/marche/algorithme/afficherToutesConditions.jsp")%>" >Retour Liste des conditions</a></td>
		</tr>			
	</table>
	<br />
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
