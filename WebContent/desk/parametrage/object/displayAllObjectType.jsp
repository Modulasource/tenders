<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
    String sTitle = "Display all Object Type";
    Vector<ObjectType> vObjectType = ObjectType.getAllStaticMemory();
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyObjectTypeForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Name</td>
		    <td>Table</td>
		    <td>Field</td>
		    <td>Class</td>
		</tr>
		<%
		for (int i=0; i < vObjectType.size(); i++) {
			ObjectType item = vObjectType.get(i);
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("modifyObjectTypeForm.jsp?sAction=store&lId="+item.getId()) 
		            %>';">
		        <td style="width:10%"><%= item.getId() %></td>
		        <td style="width:30%;"><%= item.getName() %></td>
		        <td style="width:30%"><%= item.getTableObjet() %></td>
		        <td style="width:30%"><%= item.getChampIdObjet() %></td>
		        <td style="width:30%"><%= item.getClassName() %></td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
</html>

