<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="java.util.Vector"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";

%>
<script type="text/javascript">
function openFolder(lId)
{
	doUrl("<%= response.encodeURL(rootPath 
			+ "desk/dropnsign/document/displayFolder.jsp" 
			+ "?lId=" ) %>" 
			+ lId);
}
</script>
<div>
<%
	long lIdParentFolder = HttpUtil.parseLong("lIdParentFolder", request, 0);

	Vector<GedFolder> vFolder =
		GedFolder.getAllWithWhereAndOrderByClauseStatic(
			"WHERE id_reference_object_owner=" + sessionUser.getIdIndividual()
			+ " AND id_type_object_owner=" + ObjectType.PERSONNE_PHYSIQUE
			+ " AND id_ged_folder_parent=" + lIdParentFolder 
			,
			"");

	for(GedFolder f : vFolder)
	{
		
%>
<div style="float: left;padding: 15px;" >
<img
	style="cursor: pointer;"
	onclick="openFolder(<%= f.getId() %>);" 
	src="<%= rootPath + "images/dropnsign/64x64/folder.png" %>" /><br/>
<div style="text-align: center;">
<%= f.getName() %>
</div>
</div>
<%
	}
%>
<div style="clear: both;"></div>
</div>
