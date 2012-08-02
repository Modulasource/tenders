<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.*,org.coin.bean.*,java.util.*,org.coin.util.treeview.*"%>
<%
	int iIdRole;
	iIdRole = Integer.parseInt(request.getParameter("iIdRole"));
	Role role = Role.getRole(iIdRole);
  	String sTitle = "Modifier la Treeview du rôle " + role.getName();
%>
<script type="text/javascript" src="<%= rootPath + "include/js/desk/treeview.js"  %>" ></script>
<script type="text/javascript">

function checkChainedNode(iIdNode)
{
	var iParentNode;
	var node;
	var nodeTemp;
	node = getNode(iIdNode);
	
	iParentNode = node.id ;

	if(node.checked == true)
	{
		// on traite le fait de cocher en cascade !
		while (iParentNode != -1 && iParentNode != 0)
		{
			nodeTemp = getNode(iParentNode);			
			nodeTemp.checked = true;
			iParentNode = nodeTemp.id;
		}
	}
	else
	{	// on traite le fait de décocher en cascade !
		visitAndCheck (node.value , false);
	}
	
}
</script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

<form name="formulaire" method="post" action="<%= response.encodeURL("modifierRoleTreeview.jsp") %>" >
	<input type="hidden" name="iIdRole" value="<%= role.getId() %>" />
	<br />	

	<input type="submit" value="Modifier" />
	<input type="button" name="CheckAll" value="Tout cocher" onclick="visitAndCheck(1, true)" />
	<input type="button" name="UncheckAll" value="Tout décocher" onclick="visitAndCheck(1, false)"/>
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=response.encodeURL("modifierRoleForm.jsp?iIdRole="+role.getId()) %>')" />
	<br />
	<br />

	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="3">Liste des noeuds du rôle : <%= role.getName()  %></td>
		</tr>
<%
	Vector vHabilitation = TreeviewNoeud.getHabilitations((int)role.getId() );
	Vector vItemList ;
	Treeview treeview = null;
	if(role.getIdTreeview() == 0)
	{
%>
		<tr>
			<td class="pave_cellule_gauche" colspan="3">Attention la treeview n'a pas été sélectionnée, 
			utilisation de la treeview par défaut</td>
		</tr>

<%	role.setIdTreeview( 1);
	}
		
	try{
		treeview = Treeview.getTreeview(role.getIdTreeview()); 
	} catch (CoinDatabaseLoadException e) {
		throw new ServletException("La treeview n'a pas été sélectionnée pour ce rôle");
	}
	vItemList = TreeviewNoeud.getItemList( (int) treeview.getIdMenuTreeview()  , 0, request.getContextPath()+"/" ) ;
		
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
					<td style="width:1%;vertical-align:middle">
					<input title='<%= node.iNextSiblingNode %>' 
					  value="<%= node.iFirstChildNode  %>" onclick='checkChainedNode(<%= node.getId() %>)'  
					<%
						if(TreeviewParsing.isHabilitate(vHabilitation, (int)node.getId()) )
							out.write ("checked='checked'");
						else
							out.write("");
					%> 
					type="checkbox" id="<%= node.iParentNode %>" name="node_<%= node.getId() %>" />
				</td>
			<td class="pave_cellule_droite"><%=node.sNodeLabel %></td>
		</tr>	
<%}
	Vector vUseCases = Habilitation.getAllUseCase((int)role.getId() );
 %>
	</table>
	<br />
		
	<input type="submit" value="Modifier" />
	<input type="button" name="CheckAll" value="Tout cocher" onclick="visitAndCheck(1, true)" />
	<input type="button" name="UncheckAll" value="Tout décocher" onclick="visitAndCheck(1, false)"/>
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=response.encodeURL("modifierRoleForm.jsp?iIdRole="+role.getId()) %>')" />
	
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
</html>