<%
	String rootPath = request.getContextPath() +"/";
	int iIdPersonne = HttpUtil.parseInt("iIdPersonne", request);
	
	Vector<Document> vDocuments 
		= Document.getAllDocumentFromTypeAndReferenceObjet(
				ObjectType.PERSONNE_PHYSIQUE,
				iIdPersonne);
%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.document.Document"%>
<div>
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