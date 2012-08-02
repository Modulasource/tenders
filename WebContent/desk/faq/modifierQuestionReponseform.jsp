<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.faq.*,java.util.*" %>
<%	
	String sTitle = "Modification d'une Question - Réponse";
	String sPageUseCaseId = "IHM-DESK-FAQ-007";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/js/desk/faq/modifierQuestionReponseForm.js"></script>
</head>
<body>
<%
	int id;
	id = Integer.parseInt(request.getParameter("id"));
	FAQ faq = new FAQ();
	faq.setIdCoupleFAQ(id);
	faq.load();
%>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<form action="<%= response.encodeRedirectURL("modifierQuestionReponse.jsp") %>" method="post" name="formulaire" onSubmit="javascript:return checkQuestionReponse()">
<input type="hidden" name="id" value="<%=id%>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2"><%=sTitle%></td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Categorie :</td>
			<td class="pave_cellule_droite">
				<select name="type">
					<option value="0" selected='selected'>Attribuer une catégorie</option>
<%	Vector vType = FAQType.getAllFAQType();
	for (int i=0;i<vType.size();i++){
		FAQType type = (FAQType)vType.get(i);
%>
					<option value="<%=type.getId()%>" 
					<%
					if (type.getId()==faq.getIdTypeQuestion()) { %> selected='selected'<%}%>><%=type.getName()%></option>
<%
	}
%>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Question :</td>
			<td class="pave_cellule_droite">
				<input type="text" name="question" maxlength="255" size="50" value="<%=faq.getQuestion()%>">
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Réponse :</td>
			<td class="pave_cellule_droite"><textarea name="reponse" cols="70" rows="8"><%=faq.getReponseQuestion()%></textarea></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><button type="submit" >Modifier ce couple Question-Réponse</button></td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>