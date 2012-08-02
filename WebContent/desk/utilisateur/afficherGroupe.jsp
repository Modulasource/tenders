<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,modula.*,org.coin.util.treeview.*" %>
<%@ include file="include/localization.jspf" %>
<%
	int iIdGroup ;
	String sIdUser ;
	String sSelected ;


	iIdGroup = Integer.parseInt( request.getParameter("iIdGroup") );
	Group group = Group.getGroup(iIdGroup );
	group.setAbstractBeanLocalization(sessionLanguage);
	
	String sTitle = "Modifier groupe"; 
	String sPageUseCaseId = "IHM-DESK-PARAM-HAB-7";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Groupe</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Nom : </td>
			<td class="pave_cellule_droite"><%= group.getName()%></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" style="	vertical-align:top;" >Rôles associés :</td>
			<td class="pave_cellule_droite"  >
<%
	Vector vRoles = GroupRole.getAllRole((int)group.getId());

	for (int i=0; i < vRoles.size(); i++)
	{
		Role role = (Role) vRoles.get(i);
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") ){
			%>
			<a class="dataType-tablink" href="<%= response.encodeURL("modifierRoleForm.jsp?iIdRole="+role.getId()) %>">
			<%= role.getName() %>
			</a>
			<%
		}else{
			%><%= role.getName() %><%
		}
		out.write("<br />");
	}
		  %>
		  </td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	
	<form action="none" >	
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("modifierGroupeForm.jsp?sAction=store&amp;iIdGroup="+group.getId()) 
			%>')" >Modifier</button>
		<button type="button" onclick="javascript:Redirect('<%= 
			response.encodeRedirectURL("modifierGroupe.jsp?sAction=remove&amp;iIdGroup=" + group.getId()) 
			%>')" >Supprimer</button>
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("afficherTousGroupe.jsp")%>')" >Retour</button>
	</form>	
	<br />
	
		<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Treeview</td>
		</tr>
<%
	Vector vHabilitation = TreeviewNoeud.getHabilitationsFromIdGroup((int)group.getId() );
	Vector vItemList ;
	Treeview treeview = null;
	try {
		treeview = Treeview.getTreeview(TreeviewNoeud.getIdTreeviewFromIdGroup( (int)group.getId()));
	}catch (CoinDatabaseLoadException e) {
		treeview = new Treeview();
	}
	vItemList = TreeviewNoeud.getItemListWithHabilitations((int) treeview.getIdMenuTreeview(), 0, request.getContextPath()+"/", vHabilitation ) ;
		
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
 
 	ArrayList<Vector<UseCase>> arrCU = Habilitation.getAllUseCaseFromIdGroup((int)group.getId());
	Vector<UseCase> vUseCases = arrCU.get(0);
	Vector<UseCase> vUseCasesManageable = arrCU.get(1);
	Vector<UseCase> vUseCasesDifferential = null;
	boolean bUseManageableAdmin = false;
	long lIdItemManageable = 0;
	boolean bDisplayOnlyManageable = false;
	int iBlocID = 3;
	String sBlocDefaultTitle = "Cas d'Utilisation consolidés";
 %>
	</table>

	<br />
		<%@include file="pave/paveListeUseCase.jspf" %> 
	<br />
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
</html>
