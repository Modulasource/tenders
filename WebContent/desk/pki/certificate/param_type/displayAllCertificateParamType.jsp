<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%
    String sTitle = "Display all Vehicle Type";
    Vector<VehicleType> vType = VehicleType.getAllStaticMemory();
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyVehicleTypeForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Name</td>
		    <td>Description</td>
		</tr>
		<%
		for (int i=0; i < vType.size(); i++) {
		    VehicleType item = vType.get(i);
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("modifyVehicleTypeForm.jsp?sAction=store&lId="+item.getId()) 
		            %>';">
		        <td style="width:10%"><%= item.getId() %></td>
		        <td style="width:40%"><%= item.getName() %></td>
		        <td style="width:40%"><%= item.getDescription() %></td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.util.Vector"%>
<%@page import="mt.veolia.vfr.vehicle.VehicleType"%>
</html>

