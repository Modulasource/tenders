<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*" %>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<% 
	String sTitle = "Code Naf"; 
	Vector<CodeNaf> vCode = CodeNaf.getAllCodeNaf(); 
	
%>
<script type="text/javascript">
	function checkCode(){
		if (document.formulaire.code_libelle.value != "") return true;
	return false;
	}
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
	<div id="fiche">
	<div class="right">
	</div><br />

	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche">Liste des Codes Naf</td>
<%
	if(vCode.size() > 1){
%>
			<td class="pave_titre_droite"><%= vCode.size() %> codes Naf</td>
<%
	}
	else {
		if(vCode.size() == 0) {
%>
			<td class="pave_titre_droite">Pas de code Naf</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 code Naf</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<tr>
						<th>Id code Naf</th>
						<th>Code Naf</th>
						<th>Libellé</th>
						<th>Etat</th>
						<th>&nbsp;</th>
					</tr>
<%
	for(int i=0;i<vCode.size();i++){
	CodeNaf code = vCode.get(i);
%>
					<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=i%2%>'">
				    	<td><%= code.getIdCodeNaf() %></td>
				    	<td><%= code.getCodeNaf() %></td>
				    	<td><%= code.getLibelle() %></td>
				    	<td><%= CodeNafEtat.getCodeNafEtatMemory(code.getIdCodeNafEtat()).getName() %></td>
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
<%@page import="org.coin.fr.bean.CodeNaf"%>


<%@page import="org.coin.fr.bean.CodeNafEtat"%></html>
