<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Archiver le marché";
	int iIdNextPhaseEtapes = Integer.parseInt(request.getParameter("iIdNextPhaseEtapes"));
%>
</head>
<body  >
<%
String sHeadTitre = "Archiver le marche"; 
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<form action="<%= response.encodeURL("archiverMarche.jsp") %>" method="post"  name="formulaires">
<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
<input type="hidden" name="iIdAffaire" value="<%= iIdAffaire %>" />
<br />
<div class="tabFrame">
<div style="text-align:center">
	<button type="submit" name="submit" >Archiver le marché</button>
</div>
</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>