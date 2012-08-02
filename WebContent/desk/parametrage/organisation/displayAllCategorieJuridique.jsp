<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*" %>
<% 
	String sTitle = "Catégorie Juridique"; 
	Vector<CategorieJuridique> vCategorie = CategorieJuridique.getAllCategorieJuridique(); 
%>
<script type="text/javascript">
	function checkCategorie(){
		if (document.formulaire.categorie_libelle.value != "") return true;
	return false;
	}
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche">Liste des Catégories Juridique</td>
<%
	if(vCategorie.size() > 1){
%>
			<td class="pave_titre_droite"><%= vCategorie.size() %> catégorie juridique</td>
<%
	}
	else {
		if(vCategorie.size() == 0) {
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
						<th>Id</th>
						<th>Name</th>
						<th>&nbsp;</th>
					</tr>
<%
	for(int i=0;i<vCategorie.size();i++){
	CategorieJuridique categorie = vCategorie.get(i);
%>
					<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=i%2%>'">
				    	<td><%= categorie.getId() %></td>
				    	<td><%= categorie.getName() %></td>
				    	<td style="text-align:right">
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
	</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.fr.bean.CategorieJuridique"%>

</html>