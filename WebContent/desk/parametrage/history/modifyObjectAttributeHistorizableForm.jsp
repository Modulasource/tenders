<%@page import="java.util.List"%>
<%@page import="org.coin.bean.history.ObjectAttributeHistory"%>
<%@page import="java.util.Iterator"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Object Attribute Historizable : "; 

	String sMessage = null;
	
    ObjectAttributeHistorizable item = null;
    ObjectType objType = null;
    
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new ObjectAttributeHistorizable();
		sTitle += "<span class=\"altColor\">New Object Type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = ObjectAttributeHistorizable.getObjectAttributeHistorizableMemory(Integer.parseInt(request.getParameter("lId")));
		try{
			objType = ObjectType.getObjectTypeMemory(item.getIdObjetType());
		} catch( Exception e) {
			objType = new ObjectType();
			objType.setName("undifined");
		}
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
	}
	
	sMessage = request.getParameter("sMessage");

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	List<ObjectAttributeHistory> lstObjectAttributeHistory = 
		ObjectAttributeHistory.getAllWithWhereAndOrderByClauseStatic(
				"WHERE id_object_attribute_historizable = "+item.getId(),"ORDER BY date_update ASC");
%>
</head>
<body>
<script type="text/javascript">
function removeItem()
{
    if(confirm("Do you want to delete this Object Attribute Historizable ?")){
         location.href = '<%= response.encodeURL("modifyObjectAttributeHistorizable.jsp?sAction=remove&lId="+item.getId()) %>';
     }
}

onPageLoad = function(){
    <% if(sMessage!=null){%>
		alert("<%=sMessage%>");
    <% }%>
}
</script>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyObjectAttributeHistorizable.jsp") %>" method="post" name="formulaire" id="formulaire" class="validate-fields">
<div id="fiche">
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<input type="hidden" name="lOldId" value="<%= item.getId() %>" />
		<table class="formLayout" cellspacing="3">
		    <%= pave.getHtmlTrInput("ID :", "lId", item.getId(),"size=\"100\"") %>
		    <%= pave.getHtmlTrSelect("Object Type Id :", "lIdObjetType", new ObjectType(item.getIdObjetType())) %>
		    <%= pave.getHtmlTrInput("Attribute Getter :", "sAttributeGetterName", item.getAttributeGetterName(),"size=\"100\" class=\"dataType-notNull\"") %>
		    <%= pave.getHtmlTrInput("Expression Filter :", "sExpressionFilter", item.getExpressionFilter(),"size=\"100\"") %>
		    <%= pave.getHtmlTr("","Expression Filter Samples : <ul><li>getIdVehicleCharacteristicType() = 798</li><li>getName() != toto</li></ul>") %>
		    <%= pave.getHtmlTrCheckbox("History only if values has changed :", "bOnChange", item.getOnChange()) %>
		    <%= pave.getHtmlTrCheckbox("Enable history :", "bEnabled", item.getEnabled()) %>
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
            response.encodeURL("displayAllObjectAttributeHistorizable.jsp") %>');" >
            <%= localizeButton.getValueCancel() %></button>
</div>
</form>
	<div style="padding:15px">
		<div class="dataGridHolder fullWidth">
			<table class="dataGrid fullWidth">
			<tr class="header">
			    <td>Date update</td>
			    <td>Id user</td>
			    <td>Id ref. object</td>
			    <td>Attr. value</td>
			</tr>
			<%
			Iterator<ObjectAttributeHistory> itObjAttHisto = lstObjectAttributeHistory.iterator();
			int i = 0;
			while(itObjAttHisto.hasNext()) {
				ObjectAttributeHistory objAttHisto = itObjAttHisto.next();
				//ObjectType objType = ObjectType.getObjectType(objAttHisto.getIdObjetType());
			%>
			    <tr class="liste<%=i%2%>" 
			        onmouseover="className='liste_over'" 
			        onmouseout="className='liste<%=i%2%>'" 
			 	>
			        <td style="width:10%"><%= objAttHisto.getDateUpdate() %></td>
					<td style="width:10%"><%= objAttHisto.getIdUser() %></td>
					<td style="width:10%"><%= objAttHisto.getIdReferenceObject() %></td>
					<td style="width:10%"><%= objAttHisto.getAttributeValue() %></td>
			    </tr>
			<%
			     i++;
			}
			%>
			</table>
		</div>
	</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.history.ObjectAttributeHistorizable"%>
</html>
