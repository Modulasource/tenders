<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%
	int iIdGroup ;
	String sIdUser ;
	String sSelected ;
	String sAction;
	String sTitle ;
	Group group ;

	sAction = request.getParameter("sAction") ;
	
	if(sAction.equals("store"))
	{
		iIdGroup = Integer.parseInt( request.getParameter("iIdGroup") );
		sTitle = "Modifier groupe"; 
		group = Group.getGroup(iIdGroup );
	}
	else
	{
		iIdGroup = -1;
		sTitle = "Ajouter groupe"; 
		group = new Group();
	}
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script> 
</head>
<body>
<div style="padding:15px">
<br/>
<form name="formulaire" action="<%= response.encodeRedirectURL("modifierGroupe.jsp") %>" method="post" >
	<input type="hidden" name="iIdGroup" value="<%=group.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Groupe</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Nom : </td>
			<td class="pave_cellule_droite"><input type="input" name="sName" value="<%= group.getName()%>" size="60" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Référence : </td>
			<td class="pave_cellule_droite"><input type="input" name="sReference" value="<%= group.getReferenceNotNull()%>" size="60" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Référence externe : </td>
			<td class="pave_cellule_droite"><input type="input" name="sReferenceExterne" value="<%= group.getReferenceExterneNotNull()%>" size="60" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Rôles associés :</td>
			<td class="pave_cellule_droite">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				<select name="iIdRole" size="15" style="width:400px" multiple="multiple" >
<%
	Vector vRoles = GroupRole.getAllRole((int)group.getId());
	Vector vRolesAll = Role.getAllRole();

	for (int i=0; i < vRolesAll .size(); i++)
	{
		Role role = (Role) vRolesAll .get(i);
		boolean bDisplayRole = true;
		for (int j=0; j < vRoles.size(); j++)
		{
			Role roleTmp = (Role) vRoles.get(j);
		
			if(role.getId() == roleTmp.getId())
			{
				bDisplayRole = false;
			}
		}
		if(bDisplayRole )
		{
			out.write("<option value='"+ role.getId() +"'>" + role.getName() + "</option>");
		}
	}
		  %>
                </select>
			</td >
			<td >
				<table  >
					<tr>
						<td style="width : 100px" align="center">
							<a href="javascript:DeplacerTous(document.formulaire.iIdRoleSelection,document.formulaire.iIdRole)" >
								<img src="<%= rootPath + modula.graphic.Icone.ICONE_GAUCHE%>"  
								alt="Enlever" /></a>
							<a href="javascript:DeplacerTous(document.formulaire.iIdRole,document.formulaire.iIdRoleSelection)" >
								<img src="<%= rootPath + modula.graphic.Icone.ICONE_DROITE%>"  
								alt="Ajouter" /></a> 
						</td>
						<td>
							<select name="iIdRoleSelection" size="15" style="width:400px" multiple="multiple" >
<%

	for (int i=0; i < vRoles.size(); i++)
	{
		Role role = (Role) vRoles.get(i);
		out.write("<option value='"+ role.getId() +"'>" + role.getName() + "</option>");
	}
		  %>
		                    </select>
							<input type="hidden" name="iIdRoleSelectionListe" />
						</td>
					</tr>
				</table>

		  </td>
		</tr>
	</table>
	<br />
	<button type="submit" onclick="javascript:Visualise(document.formulaire.iIdRoleSelection,document.formulaire.iIdRoleSelectionListe);" ><%=sTitle 
		%></button>
	<button type="button" onclick="javascript:Redirect('<%=
		response.encodeRedirectURL("afficherTousGroupe.jsp")%>')" ><%= localizeButton.getValueCancel() %></button>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</html>
