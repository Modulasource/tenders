<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%
    String sTitle = "Display all Document Type";
    Vector<GedDocumentType> vItem = GedDocumentType.getAllWithWhereAndOrderByClauseStatic("","");
	GedDomain domain = new GedDomain();
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
 <form action="<%= response.encodeURL("modifyDocumentTypeForm.jsp?sAction=create") 
 	%>" method="post" name="formulaire">
   <%= domain.getAllInHtmlSelect("lIdGedDomain") %> 
        <button type="submit" >Add</button>
</form>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>Domain</td>
		    <td>Folder type</td>
		    <td>Type index </td>
		    <td>Reference</td>
		    <td>Name</td>
		    <td>Description</td>
		</tr>
		<%
		for (int i=0; i < vItem.size(); i++) {
			GedDocumentType item = vItem.get(i);
			GedFolderType folderType = GedFolderType.getGedFolderType(item.getIdGedFolderType());
			domain = GedDomain.getGedDomain(folderType.getIdGedDomain());
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("displayDocumentType.jsp?lId="+item.getId()) 
		            %>';">
		        <td style="width:5%"><%= item.getId() %></td>
		        <td style="width:10%"><%= domain.getName() %></td>
		        <td style="width:10%"><%= folderType.getName() %></td>
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
</html>