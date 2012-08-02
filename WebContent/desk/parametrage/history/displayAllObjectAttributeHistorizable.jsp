<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.history.ObjectAttributeHistory"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
    String sTitle = "Display all Object Attribute Historizable";
    List<ObjectAttributeHistorizable> lstObjectAttributeHistorizable = ObjectAttributeHistorizable.getAllStaticMemory();
    Map<ObjectAttributeHistorizable,Long> mapHistoryCount = new HashMap<ObjectAttributeHistorizable,Long>();
    for(ObjectAttributeHistorizable oah:lstObjectAttributeHistorizable){
    	Long lCount = oah.countObjectAttributeHistoryAttached();
    	mapHistoryCount.put(oah,lCount);
    }
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyObjectAttributeHistorizableForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Object Type Name</td>
		    <td>Attribute Getter</td>
		    <td>Expression Filter</td>
		    <td>On Change</td>
		    <td>Enabled</td>
		    <td>History count</td>
		</tr>
		<%
		Iterator<ObjectAttributeHistorizable> itObjAttHisto = lstObjectAttributeHistorizable.iterator();
		int i = 0;
		while(itObjAttHisto.hasNext()) {
			ObjectAttributeHistorizable objAttHisto = itObjAttHisto.next();
			ObjectType objType = null;
			try{
				objType = ObjectType.getObjectType(objAttHisto.getIdObjetType());
			} catch( Exception e) {
				objType = new ObjectType();
				objType.setName("undifined");
			}
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("modifyObjectAttributeHistorizableForm.jsp?sAction=store&lId="+objAttHisto.getId()) 
		            %>';">
		        <td style="width:10%"><%= objAttHisto.getId() %></td>
		        <td style="width:30%;"><%= objType.getName() %></td>
		        <td style="width:30%"><%= objAttHisto.getAttributeGetterName() %></td>
		        <td style="width:30%"><%= objAttHisto.getExpressionFilter() %></td>
		        <td style="width:30%"><%= objAttHisto.getOnChange() %></td>
		        <td style="width:30%"><%= objAttHisto.getEnabled() %></td>
		        <td style="width:30%"><%= mapHistoryCount.get(objAttHisto) %></td>
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
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.bean.ObjectType"%>
</html>

