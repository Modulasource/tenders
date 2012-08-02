<%@page import="java.util.Collections"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%
	String rootPath = request.getContextPath() +"/";
	GedFolder item = (GedFolder) request.getAttribute("getFolder");
%>
<div>
<img src="<%= rootPath + "images/dropnsign/32x32/folder.png" %>" />
<span style="font-size: 14px;cursor: pointer;" onclick="displayRootFolder()"><%= "Racine" %></span> / 
<%
	Vector<GedFolder> vFolderPath = new Vector<GedFolder>();
	GedFolder pathItem = item;
	while (pathItem.getIdGedFolderParent() > 0)
	{
		pathItem = GedFolder.getGedFolder(pathItem.getIdGedFolderParent());
		vFolderPath.add(pathItem);
	}
	
	Collections.reverse(vFolderPath);
	for(GedFolder gf : vFolderPath)
	{
%>
<span style="font-size: 14px;cursor: pointer;" onclick="displayFolder(<%= gf.getId() %>)"><%= gf.getName() %></span> / 
<%		
	}
%>
<span style="font-size: 14px;cursor: pointer;" onclick="displayFolder(<%= item.getId() %>)"><%= item.getName() %></span>
<br/>
Ref : <%= item.getName() %><br/>
Description : <%= item.getDescription() %><br/>
</div>