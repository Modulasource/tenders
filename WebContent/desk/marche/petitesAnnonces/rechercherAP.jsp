<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="modula.fqr.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Rechercher un acheteur public"; 
%>
<%@ include file="../../include/headerDesk.jspf" %> 
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/date.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/cryptage.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/calendrier.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/overlib_mini.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/produitCartesien.js" ></script>
<%@ include file="../../../include/headerXML.jspf" %>
<body> 
<div class="titre_page"><%= sTitle %></div>
<form action="rechercherPA.jsp" method="post">
	<table class="pave" summary="none">
		<tr>
			<td classs="pave_cellule_gauche">Nom de l'organisme :</td>
			<td classs="pave_cellule_droite">
			<input type="text" value="" name="sOrganismeToFind" />
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align:center">
				<input type="submit" value="Rechercher" />
			</td>
		</tr>
</form>

<%@include file="../../include/footerDesk.jspf" %>
</body>
</html>
