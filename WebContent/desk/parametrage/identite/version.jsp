<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "Identité du système";

	String sVersionApplication = "";
	String sVersionDatabase = "";

	if(Theme.getTheme().equalsIgnoreCase("veolia"))
	{
		sVersionApplication = mt.veolia.vfr.Version.VERSION_APPLICATION ;
		sVersionDatabase = mt.veolia.vfr.Version.VERSION_DATABASE ;
	} else {
		sVersionApplication = mt.modula.Version.VERSION_APPLICATION ;
		sVersionDatabase = mt.veolia.vfr.Version.VERSION_DATABASE ;
	}
	
%>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
<br/>

	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2"> Informations du système</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Version de l'application :</td>
			<td class="pave_cellule_droite"><%=sVersionApplication%></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Version de la Base de données :</td>
			<td class="pave_cellule_droite"><%=sVersionDatabase %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">N° de licence :</td>
			<td class="pave_cellule_droite">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Détenteur de la licence :</td>
			<td class="pave_cellule_droite">&nbsp;</td>
		</tr>
	</table>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.configuration.ModulaConfiguration"%>
</html>
