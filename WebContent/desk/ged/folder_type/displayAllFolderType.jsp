<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%
    String sTitle = "Display all Folder Type";
    Vector<GedFolderType> vItem = GedFolderType.getAllWithWhereAndOrderByClauseStatic(""," ORDER BY id_ged_domain");
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyFolderTypeForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Domain</td>
		    <td>Type index</td>
		    <td>Reference</td>
		    <td>Name</td>
		    <td>Description</td>
		</tr>
		<%
		for (int i=0; i < vItem.size(); i++) {
			GedFolderType item = vItem.get(i);
			GedDomain domain = GedDomain.getGedDomain(item.getIdGedDomain());
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("modifyFolderTypeForm.jsp?sAction=store&lId="+item.getId()) 
		            %>';">
		        <td style="width:10%"><%= item.getId() %></td>
		        <td style="width:20%"><%= domain.getName() %></td>
		        <td style="width:10%"><%= item.getTypeIndex() %></td>
		        <td style="width:10%"><%= item.getReference() %></td>
		        <td style="width:20%"><%= item.getName() %></td>
		        <td style="width:20%"><%= item.getDescription() %></td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.bean.ged.GedFolderType"%>
</html>

