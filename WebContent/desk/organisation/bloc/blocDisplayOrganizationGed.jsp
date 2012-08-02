<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");

	Vector<Document> vDocuments 
		= Document.getAllDocumentFromTypeAndReferenceObjet(
			ObjectType.ORGANISATION,
			organisation.getIdOrganisation());
%>

<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.document.Document"%>
<%@page import="org.coin.bean.ObjectType"%><div>
<table class="pave" >
	<tr>
		<td>
			<table class="liste" >
				<tr>
					<th>Nom</th>
					<th>Type</th>
					<th>Date de création</th>
					<th>Visibilité</th>
					<th>&nbsp;</th>
				</tr>
				<%@ include file="/desk/document/pave/paveTousDocuments.jspf" %>
			</table>
		</td>
	</tr>
</table>
</div>


 