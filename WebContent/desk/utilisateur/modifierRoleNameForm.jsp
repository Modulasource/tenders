<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*" %>
<%
	int iIdRole = -1;
	String sIdUser ;
	String sSelected ;
	String sAction;
	Role role = null;
	String sTitle  = "";
	boolean bShowForm = false;
	
	sAction = request.getParameter("sAction") ;
	if(request.getParameter("sAction") == null) sAction="";
	
	
	if(sAction.equals("create"))
	{
		iIdRole = -1;
		sTitle = "Ajouter rôle";
		role = new Role();	
	}
	
	sTitle = "Ajouter un rôle";

%>
<head>
<script type="text/javascript" >
	
function checkForm()
{
	var form = document.formulaire;
} // end checkForm()
</script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

	<form name="formulaire" action="<%= response.encodeRedirectURL("modifierRole.jsp") %>" method="post" onSubmit="return checkForm();" >
	<input type="hidden" name="sAction" value="create" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Rôle</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Nom : </td>
			<td class="pave_cellule_droite"><input type="input" name="sName" value="<%= role.getName()%>" size="60" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" colspan="2">&nbsp;</td>
		</tr>
	</table>

	<br />
	<button type="submit" ><%= localizeButton.getValueAdd() %></button>	
	<button type="button" onclick="javascript:Redirect('<%= 
		response.encodeRedirectURL("afficherTousRole.jsp") %>');" ><%= localizeButton.getValueCancel() %></button>	
	</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
