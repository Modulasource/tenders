<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*,java.util.*" %>
<%@page import="modula.candidature.EnveloppeBPieceJointeType"%>

<%
	String sTitle = "Pièce jointe: ";
	EnveloppeBPieceJointeType piece = null;
	String sPageUseCaseId = "xxx";
	String sAction = request.getParameter("sAction");
	if (sAction.equals("create")) {
		piece = new EnveloppeBPieceJointeType();
	}

	if (sAction.equals("store")) {
		long lId = Long.parseLong(request.getParameter("lId"));
		piece = EnveloppeBPieceJointeType
				.getEnveloppeBPieceJointeType((int) lId);
		sTitle += "<span class=\"altColor\">" + piece.getId() + " "
				+ piece.getName() + "</span>";
	}
	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
<script type="text/javascript" src="<%=rootPath%>dwr/interface/EnveloppeBPieceJointeType.js"></script>
</head>
<body>
<script type="text/javascript">
function displayAllPieceJointeTypeEnveloppeB() {
	location.href = "<%=response
									.encodeURL(rootPath
											+ "desk/parametrage/affaire/displayAllPieceJointeTypeEnveloppeB.jsp")%>";
}
function removeItem()
{
    if(confirm("Voulez vous vraiment effacer cette pièce jointe type ?")){
    	EnveloppeBPieceJointeType.removeFromId(<%=piece.getId()%>,function() { 
            location.href = '<%=response
									.encodeURL("displayAllPieceJointeTypeEnveloppeB.jsp")%>';
           });
     }
}

</script>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%=response
									.encodeURL("modifyPieceJointeTypeEnveloppeB.jsp")%>" method="post" id="formulaire" name="formulaire">
<div id="fiche">
		<input type="hidden" name="sAction" value="<%=sAction%>" />
		<input type="hidden" name="lId" value="<%=piece.getId()%>" />
		<table class="formLayout" cellspacing="3">
		<%=pave.getHtmlTrInput("Libellé :", "sName",
							piece.getName(), "size=\"100\"")%>
		
		
		</table>
</div>


<div id="fiche_footer">
	<button type="submit">Valider</button>

<%
	if (sAction.equals("store")) {
%>
	<button type="button" onclick="removeItem();">Supprimer</button>
<%
	}
%>
	<button type="button" onclick="javascript:displayAllPieceJointeTypeEnveloppeA();">Annuler</button>

</div>
</form>

<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>


<%@page import="org.coin.db.CoinDatabaseLoadException"%>

</html>
