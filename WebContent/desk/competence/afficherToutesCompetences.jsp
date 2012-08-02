<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*,modula.graphic.*" %>
<% 
	String sTitle = "Tous les Codes CPF"; 
	Vector<BoampCPF> vCompetences = BoampCPF.getAllStaticMemory(); 
%>
<script type="text/javascript">
	function checkCompetence(){
		if (document.formulaire.competence_libelle.value != "") return true;
	return false;
	}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>

	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche">Liste des Codes CPF</td>
<%
	if(vCompetences.size() > 1){
%>
			<td class="pave_titre_droite"><%= vCompetences.size() %> codes CPF</td>
<%
	}
	else {
		if(vCompetences.size() == 0) {
%>
			<td class="pave_titre_droite">Pas de code CPF</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 code CPF</td>
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
						<th>&nbsp;</th>
					</tr>
<%
	for(int i=0;i<vCompetences.size();i++){
	BoampCPF cpf = vCompetences.get(i);
%>
					<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=i%2%>'">
				    	<td><%= cpf.getName() %></td>
				    	<td style="text-align:right">
				    	<a href="<%= response.encodeURL("supprimerCompetence.jsp?iIdCompetence="+ cpf.getId()) %>" >
				    		<img width="25" src="<%= rootPath + Icone.ICONE_SUPPRIMER %>" />
						</a>
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
	<div class="division">
		<br />
		<form action="<%= response.encodeURL("ajouterCompetence.jsp") %>" name="formulaire" method="post" onsubmit="javascript: return checkCompetence()">
			<input type="text" name="competence_libelle" style="width:200px"/>&nbsp;&nbsp;<input type="submit" value="Ajouter la compétence" />
		</form>
	</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
</html>
