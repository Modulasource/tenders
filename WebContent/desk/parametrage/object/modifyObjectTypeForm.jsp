<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Object Type : "; 


    ObjectType item = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new ObjectType();
		sTitle += "<span class=\"altColor\">New Object Type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = ObjectType.getObjectTypeMemory(Integer.parseInt(request.getParameter("lId")));
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/ObjectType.js"></script>
</head>
<body>
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this Object Type ?")){
         ObjectType.removeFromId(<%= item.getId() %>,function() { 
            location.href = '<%= response.encodeURL("displayAllObjectType.jsp") %>';
           });
     }
}
</script>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyObjectType.jsp") %>" method="post" name="formulaire">
<div id="fiche">
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<input type="hidden" name="lOldId" value="<%= item.getId() %>" />
		<table class="formLayout" cellspacing="3">
		    <%= pave.getHtmlTrInput("ID :", "lId", item.getId(),"size=\"100\"") %>
		    <%= pave.getHtmlTrInput("Name :", "sLibelle", item.getLibelle(),"size=\"100\"") %>
		    <%= pave.getHtmlTrInput("Table :", "sTableObjet", item.getTableObjet(),"size=\"100\"") %>
		    <%= pave.getHtmlTrInput("Field :", "sChampIdObjet", item.getChampIdObjet(),"size=\"100\"") %>
		    <%= pave.getHtmlTrInput("Class :", "sClass", item.getClassName(),"size=\"100\"") %>
		</table>
</div>
<div id="fiche_footer">
	<button type="submit" >Valid</button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:removeItem();">
			Delete</button>
	<%} %>
	<button type="button" onclick="javascript:doUrl('<%=
            response.encodeURL("displayAllObjectType.jsp") %>');" >
            <%= localizeButton.getValueCancel() %></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
