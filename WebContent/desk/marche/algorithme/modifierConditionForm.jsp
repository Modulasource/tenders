<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.condition.*" %>
<%
	String sSelected ;
	String sTitle = null;
	int iIdCondition;
	String sAction = null;
	ConditionBean condition = null;

	sAction = request.getParameter("sAction") ;
	if(sAction.equals("store"))
	{
		iIdCondition = Integer.parseInt( request.getParameter("iIdCondition") );
		sTitle = "Modifier une condition"; 
		condition = ConditionBean.getConditionBean(iIdCondition);
	}
	
	if(sAction.equals("create"))
	{
		iIdCondition = -1;
		sTitle = "Ajouter une condition"; 
		condition = new ConditionBean();
	}
	
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifierCondition.jsp")%>" method='post' >
	<input type="hidden" name="iIdCondition" value="<%= condition.getId() %>" />
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
			<td class="pave_cellule_droite"><input value="<%=condition.getName() %>" name="sName" size="100" /></td>
		</tr>
		<tr>
			<td  colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<input type="submit" value="<%=sTitle %>" />
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=response.encodeRedirectURL("afficherCondition.jsp?iIdCondition="+condition.getId()) %>')" />
</form>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
