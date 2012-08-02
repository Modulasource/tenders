<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%
    String sTitle = "Display all Domain";
    Vector<GedDomain> vItem = GedDomain.getAllStatic();
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyDomainForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Reference</td>
		    <td>Type</td>
		    <td>Name</td>
		</tr>
		<%
		for (int i=0; i < vItem.size(); i++) {
			GedDomain item = vItem.get(i);
			GedDomainType type = GedDomainType.getGedDomainType(item.getIdGedDomainType());
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("modifyDomainForm.jsp?sAction=store&lId="+item.getId()) 
		            %>';">
		        <td style="width:5%"><%= item.getId() %></td>
		        <td style="width:10%"><%= item.getReference() %></td>
		        <td style="width:10%"><%= type.getName() %></td>
		        <td style="width:60%"><%= item.getName() %></td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.bean.ged.GedDomainType"%>
</html>

