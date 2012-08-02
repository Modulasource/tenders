<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.modula.common.util.HttpUtil"%>
<%@include file="/include/new_style/headerDeskUtf8.jspf" %>
<%

	String sAction = HttpUtil.parseStringBlank("sAction", request);
	String sCancelUrl = null;
	GedFolder item = null;
	
	if(sAction.equals("create"))
	{
		sCancelUrl = "desk/dropnsign/main.jsp";
		long lIdParentFolder = HttpUtil.parseLong("lIdParentFolder", request, 0);
		item = new GedFolder();
		item.setIdGedFolderParent(lIdParentFolder);
	} else if(sAction.equals("store"))
	{
		item = GedFolder.getGedFolder(HttpUtil.parseLong("lId", request));
		sCancelUrl = "desk/dropnsign/document/displayFolder.jsp"
			+ "?lId=" + item.getId();
	}
	
	
%>
</head>
<body>
<script type="text/javascript">
function cancel()
{
	doUrl("<%= response.encodeURL(rootPath + sCancelUrl) %>");
}
</script>
<div>
<form action="<%= response.encodeURL(rootPath + "desk/dropnsign/document/modifyFolder.jsp" ) %>">
<input type="hidden" name="lId" value="<%= item.getId() %>" />
<input type="hidden" name="lIdGedFolderParent" value="<%= item.getIdGedFolderParent() %>" />
<input type="hidden" name="sAction" value="<%= sAction %>" />
<%
	if(item.getIdGedFolderParent() > 0)
	{
		GedFolder parent = GedFolder.getGedFolder(item.getIdGedFolderParent());
%>
<div >
Parent folder: <%= parent.getName() %>
</div>
<%		
	}
%>

Name: <input name="sName" value="<%= item.getName() %>" /><br/>
Reference: <input name="sReference" value="<%= item.getReference() %>" /><br/>
Description: <textarea name="sDescription" ><%= item.getDescription() %></textarea><br/>
<button type="submit"">Submit</button>
<button type="button" onclick="cancel();">Cancel</button>
</form>
</div>
</body>
</html>