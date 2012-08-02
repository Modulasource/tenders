<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.faq.*,java.util.*"%>
<% 
	String sTitle = "FAQ - Gestion des catégories";
	String sPageUseCaseId = "IHM-DESK-FAQ-001";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath%>include/cacherDivision.js"></script>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Liste des catégories de questions</td>
<%
	Vector vType = FAQType.getAllFAQType();
	if(vType.size() > 1){
%>
		<td class="pave_titre_droite"><%= vType.size() %> catégories</td>
<%
	}
	else {
		if(vType.size() == 0) {
%>
		<td class="pave_titre_droite">Pas de catégorie</td>
<%
		}
		else {
%>
		<td class="pave_titre_droite">1 catégorie</td>
<%
		}
	}
%>
	</tr>
	<tr>
		<td colspan="2">
			<table class="liste" summary="none">
				<tr>
					<th>Libellé</th>
					<th style="text-align:right">&nbsp;</th>
				</tr>
<%
	for(int i=0;i<vType.size();i++){
	FAQType type = (FAQType)vType.get(i);
	type.load();
	Vector vQR = FAQ.getAllCoupleQR(" WHERE id_type="+type.getId());
	
%>
				<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=i%2%>'">
			    	<td><%=type.getName()%></td>
			    	<td style="text-align:right">
			    	<%
			    	if (vQR.size()==0) {
			    		if(sessionUserHabilitation.isHabilitate("IHM-DESK-FAQ-004") ) {
			    	%>
			    	<a href="<%= response.encodeURL("supprimerFAQType.jsp?iIdType="+ type.getId()) %>" onclick="javascript:return confirm('Etes -vous sûr de vouloir supprimer définitivement cette catégorie ?')">Supprimer</a>
			    	<%
			    		}
			    	}
			    	else {
			    	%>
			    	Catégorie non vide
			    	<%
			    		}
			    	%>
			    	</td>
			  	</tr>
<%
	}
%>
			</table>
		</td>
	</tr>
</table>
<br />
<%
if(sessionUserHabilitation.isHabilitate("IHM-DESK-FAQ-002") )
	{
%>
<form action="<%= response.encodeURL("ajouterFAQType.jsp") %>" name="formulaire" method="post">
	<div class="division">
	<br />
		<input type="text" name="FAQType_libelle" style="width:200px"/>&nbsp;&nbsp;<input type="submit" value="Ajouter la catégorie" />
	<br /><br />
	</div>
</form>
<%
	}
%>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>
