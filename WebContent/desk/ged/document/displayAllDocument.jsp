<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDomain"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%
    String sTitle = "Display all document";
    Vector<GedDocument> vItem = GedDocument.getAllStatic();
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
    <div class="right">
        <button type="button" onclick="javascript:location.href='<%=
        response.encodeURL("modifyFolderForm.jsp?sAction=create") 
                %>';" >Add</button>
    </div>
    <br/>
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>ID</td>
		    <td>type</td>
		    <td>folder</td>
		    <td>folder type</td>
		    <td>Reference</td>
            <td>Name</td>
            <td>&nbsp;</td>
		</tr>
		<%
		for (int i=0; i < vItem.size(); i++) {
			GedDocument item = vItem.get(i);
			GedDocumentType type = null;
            GedFolder folder = null;
            GedFolderType folderType = null;
			try{
				type = GedDocumentType.getGedDocumentType(item.getIdGedDocumentType());
			} catch (CoinDatabaseLoadException e) {
				type = new GedDocumentType();
			}
			try{
	            folder = GedFolder.getGedFolder(item.getIdGedFolder());
			} catch (CoinDatabaseLoadException e) {
				folder = new GedFolder();
			}
            try{
            	folderType = GedFolderType.getGedFolderType(folder.getIdGedFolderType());
            } catch (CoinDatabaseLoadException e) {
            	folderType = new GedFolderType();
            }
		%>
		    <tr class="liste<%=i%2%>" 
		        onmouseover="className='liste_over'" 
		        onmouseout="className='liste<%=i%2%>'" 
		        onclick="javascript:location.href='<%=
		            response.encodeURL("displayDocument.jsp?lId="+item.getId()) 
		            %>';">
		        <td style="width:10%"><%= item.getId() %></td>
		        <td style="width:20%"><%= type.getName() %></td>
		        <td style="width:10%"><%= folder.getName() %></td>
		        <td style="width:10%"><%= folderType.getName() %></td>
		        <td style="width:10%"><%= item.getReference() %></td>
                <td style="width:20%"><%= item.getName() %></td>
                <td style="width:10%">
                    
                </td>
		    </tr>
		<%
		}
		%>
		</table>
	</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>



<%@page import="org.coin.db.CoinDatabaseLoadException"%></html>

