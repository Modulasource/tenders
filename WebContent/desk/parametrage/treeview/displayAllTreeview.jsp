<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*" %>
<%@page import="modula.graphic.BarBouton"%>
<%@page import="org.coin.bean.conf.Treeview"%>
<%
	Vector vTreeview = Treeview.getAllStatic();
	String sTitle = "Liste des treeviews <span class=\"altColor\">"+vTreeview.size()+"</span>"; 

	String sUseCaseIdAfficherDroits = "IHM-DESK-PARAM-TV-8";
	String sPageUseCaseId  = sUseCaseIdAfficherDroits;
	
	
	// Les boutons
	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();
	
	vBarBoutons.add( 
		new BarBouton(0 ,
	 "Ajouter une treeview", 
	 response.encodeURL(rootPath 
			 + "desk/parametrage/treeview/modifyTreeview.jsp?sAction=create"), 
	 rootPath+"images/icons/36x36/treeview_add.png", 
	 "",
	 "",
	 "" ,
	 true
		) 
	);
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<script type="text/javascript">
function displayTreeview(id) {
	location.href = "<%=response.encodeURL(
			rootPath+"desk/parametrage/treeview/modifierTreeviewForm.jsp")%>?iIdRootNode="+id;
}
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>

	<!-- Les boutons -->
	<div class="sectionTitle"><div>Actions</div></div>
	<div class="sectionFrame">
	<table class="menu" cellspacing="2">
		<tr>
<%
	for(int i=0;i<vBarBoutons.size();i++)
	{
		BarBouton bouton = vBarBoutons.get(i);
		if(bouton.bVisible)
		{
%>	
		<%=bouton.getHtmlDesk()%>
		<%
			}
			}
		%>
			<td>&nbsp;</td>
		</tr>
	</table>
	</div>
	<br />

<div id="fiche">
<br />
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr class="header">
				<td width="30%">Name</td>
				<td width="50%">Noeud Racine</td>
				<td width="50%"></td>
			</tr>
<%
for (int i=0; i < vTreeview.size(); i++)
{
	Treeview treeview = (Treeview) vTreeview.get(i);
%>
			<tr class="liste<%=i%2%>" 
				onmouseover="className='liste_over'" 
				onmouseout="className='liste<%=i%2%>'" 
				onclick="">
		    	<td style="width:30%"><%=treeview.getName()  %></td>
		    	<td style="width:50%"><%=treeview.getIdMenuTreeview()  %></td>
		    	<td style="width:50%">
	    			<a class="image" 
	    				href="javascript:displayTreeview(<%= treeview.getIdMenuTreeview()%>);" >
	    			<img src="<%= rootPath %>images/icons/closeTreeItem.gif" alt="<%= localizeButton.getValueDisplay() %>" title="<%= localizeButton.getValueDisplay() %>" />
	    			</a>
	    			<a class="image" 
	    				href="<%= 
	    					response.encodeURL( 
	    						rootPath + "desk/parametrage/treeview/modifyTreeviewForm.jsp" 
	    						+ "?sAction=store&lIdTreeview=" + treeview.getId()
	    						)
	    						%>" >
	    			<img src="<%= rootPath %>images/icons/default.gif" alt="<%= localizeButton.getValueModify() %>" title="<%= localizeButton.getValueModify() %>" />
	    			</a>
	    			<a class="image" 
	    				href="<%= 
	    					response.encodeURL( 
	    						rootPath + "desk/parametrage/treeview/modifyTreeview.jsp" 
	    						+ "?sAction=remove&lIdTreeview=" + treeview.getId()
	    						)
	    						%>" >
	    			<img src="<%= rootPath %>images/icons/delete.gif" alt="<%= localizeButton.getValueDelete() %>" title="<%= localizeButton.getValueDelete() %>" />
	    			</a>
	    		</td>
		  	</tr>
<%
}
%>
		</table>
	</div>
	<br/>
	<div id="fiche_footer">
		&nbsp;
	</div>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
