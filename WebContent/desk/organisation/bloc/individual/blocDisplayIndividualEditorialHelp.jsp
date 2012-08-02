<%
	String rootPath = request.getContextPath() +"/";
	int iIdPersonne = HttpUtil.parseInt("iIdPersonne", request);

	Vector<EditorialAssistance> vContenus 
		= EditorialAssistance.getAllEditorialAssistanceFromTypeAndReferenceObjet(
				ObjectType.PERSONNE_PHYSIQUE,
				iIdPersonne);
%>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.editorial.EditorialAssistance"%>

<%@page import="org.coin.util.HttpUtil"%><div>
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