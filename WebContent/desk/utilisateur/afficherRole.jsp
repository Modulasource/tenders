<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,modula.*,org.coin.util.treeview.*" %>
<%
	int iIdRole = Integer.parseInt( request.getParameter("iIdRole") );
	Role role = Role.getRole(iIdRole );
	
	String sTitle = "Modifier rôle"; 
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-11";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

	<form action="none" >
		<input type="button" value="Modifier Cas d'utilisation" onclick="javascript:Redirect('<%=response.encodeRedirectURL("modifierRoleForm.jsp?sAction=store&amp;iIdRole="+role.getId()) %>')" />
		<input type="button" value="Modifier Treeview" onclick="javascript:Redirect('<%=response.encodeRedirectURL("modifierRoleTreeviewForm.jsp?iIdRole="+role.getId()) %>')" />
		<input type="button" value="Supprimer" onclick="javascript:Redirect('<%=response.encodeRedirectURL("modifierRole.jsp?sAction=remove&amp;iIdRole="+role.getId()) %>')" />
		<input type="button" value="Retour" onclick="javascript:Redirect('<%=response.encodeRedirectURL("afficherTousRole.jsp")%>')" />
	</form>
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Rôle</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Nom : </td>
			<td class="pave_cellule_droite"><%= role.getName()%></td>
		</tr>
	</table>

	<br />

	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Treeview</td>
		</tr>
<%
	Vector vHabilitation = TreeviewNoeud.getHabilitations((int)role.getId() );
	Vector vItemList ;
	
	vItemList = TreeviewNoeud.getItemListWithHabilitations(0, request.getContextPath()+"/", vHabilitation ) ;
		
 	for (int i=0; i < vItemList.size(); i++)
 	{
	 	TreeviewNode node = (TreeviewNode ) vItemList.get(i);
		int j;
	%> 	
		<tr>
			<td class="pave_cellule_gauche">
		  	  <table summary="none">
				<tr >
	
	<%@ include file="pave/paveTreeviewNode.jspf" %>
				</tr>
			  </table>
			</td>
			<td class="pave_cellule_droite"><%=node.sNodeLabel %></td>
		</tr>	

<%}
 
	Vector vUseCases = Habilitation.getAllUseCase((int)role.getId() );
 %>
	</table>


	<br />
<%@ include file="pave/paveListUseCase.jspf" %>
	<br />
	<form action="none" >
		<input type="button" value="Modifier Cas d'utilisation" onclick="javascript:Redirect('<%=response.encodeRedirectURL("modifierRoleForm.jsp?sAction=store&amp;iIdRole="+role.getId()) %>')" />
		<input type="button" value="Modifier Treeview" onclick="javascript:Redirect('<%=response.encodeRedirectURL("modifierRoleTreeviewForm.jsp?iIdRole="+role.getId()) %>')" />
		<input type="button" value="Supprimer" onclick="javascript:Redirect('<%=response.encodeRedirectURL("modifierRole.jsp?sAction=remove&amp;iIdRole="+role.getId()) %>')" />
		<input type="button" value="Retour" onclick="javascript:Redirect('<%=response.encodeRedirectURL("afficherTousRole.jsp")%>')" />
	</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
