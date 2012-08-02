<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.conf.Treeview"%>
<%@ page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%
	String sTitle = "HTML TreeView"; 
	long lIdTreeview = Long.parseLong(request.getParameter("lIdTreeview"));
	
	String sAction = request.getParameter("sAction");

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	
	Treeview item = Treeview.getTreeview(lIdTreeview);
	
%>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" method="post" action="<%= response.encodeURL("modifyTreeview.jsp" ) %>" >
	<input type="hidden" name="sAction" value="<%= sAction %>" />
	<input type="hidden" name="lIdTreeview" value="<%= item.getId() %>" />
		
		<table class="formLayout" cellspacing="3">
			<%= pave.getHtmlTrInput("Nom :", "sName", item.getName()) %>
			<%= pave.getHtmlTrInput("Noeud racine :", "lIdMenuTreeview", item.getIdMenuTreeview(),"size=\"100\"") %>
		</table>
		

	
	
<div align="center">
	<button type="submit" name="submit" >Modifier</button>
	&nbsp;<button type="reset" name="RAZ" 
	onclick="Redirect('<%= response.encodeURL("displayAllTreeview.jsp") 
	%>')" >Retour</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="org.coin.bean.ObjectType"%>
</html>