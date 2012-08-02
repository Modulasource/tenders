<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%

	String rootPath = request.getContextPath() + "/";
	GedDocument doc = (GedDocument) request.getAttribute("doc");
	Vector<GedDocumentRevision> vDocumentRevision = (Vector<GedDocumentRevision>) request.getAttribute("vDocumentRevision");
%>
<%
	if(vDocumentRevision .size() > 0)
	{
%>
<script type="text/javascript">
function removeDocumentRevision(lId)
{
	if(confirm("Etes vous sûr ?"))
	{
		doUrl("<%= response.encodeURL(
				rootPath + "desk/dropnsign/document/modifyDocument.jsp"
				+ "?lId=" + doc.getId()
				+ "&sAction=removeDocumentRevision"
				) %>"
			+ "&lIdGedDocumentRevision=" + lId);
	}
}
</script>

<div id="documentRevisionList_<%= doc.getId() %>" style="display: none;text-align: left;" class="overlay_action" >
	<table style="border: thin solid;">
		<tr>
			<th>Revision</th>
			<th>Date</th>
			<th></th>
		</tr>
<%
		for(GedDocumentRevision rev : vDocumentRevision)
		{
%>
		<tr>
			<td><%= rev.getRevisionLabel() %></td>
			<td><%= CalendarUtil.getFormatDateHeureStd( rev.getDateCreation()) %></td>
			<td><button onclick="removeDocumentRevision(<%= rev.getId() %>)" >Remove</button></td>
		
		</tr>
<%			
			
		}
%>		
	</table>
</div>
<%
	}
%>
