<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");


	Vector<EditorialAssistance> vContenus 
			= EditorialAssistance
				.getAllEditorialAssistanceFromTypeAndReferenceObjet(
						ObjectType.ORGANISATION,
						organisation.getIdOrganisation());
%>

<div>
<table class="pave" >
	<tr>
		<td>
			<table class="liste" >
				<tr>
					<th>Nom</th>
					<th>Type</th>
					<th>Groupe</th>
					<th>Auteur</th>
					<th>Date de création</th>
					<th>Visibilité</th>
					<th>&nbsp;</th>
				</tr>
				<%@ include file="/desk/editorial/pave/paveTousEditorialAssistance.jspf" %>
			</table>
		</td>
	</tr>
</table>   
</div>
