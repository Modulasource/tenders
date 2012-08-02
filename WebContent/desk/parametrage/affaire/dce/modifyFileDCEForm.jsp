<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*,org.coin.bean.conf.*,java.util.*" %>
<%
	String sTitle = "Marché pièce jointe type: ";
	MarchePieceJointeType marchePJT = null;
	String sPageUseCaseId = "xxx";
	String sAction = request.getParameter("sAction");
	if (sAction.equals("create")) {
		marchePJT = new MarchePieceJointeType();

	}
	if (sAction.equals("store")) {
		int iId = Integer.parseInt(request.getParameter("iIdType"));
		
		marchePJT = MarchePieceJointeType.
		getMarchePieceJointeTypeMemory(iId);
		sTitle += "<span class=\"altColor\">"
		+ marchePJT.getIdType() + " "
		+ marchePJT.getTypeDocument() +"</span>";

	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
%>
<script type="text/javascript" src="<%=rootPath%>dwr/interface/MarchePieceJointeType.js"></script>
<script type="text/javascript">
function displayAllFileDCE() {
	location.href = "<%=
		response.encodeURL("displayAllFileDCE.jsp")
		%>";
}

function removeItem()
{
    if(confirm("Voulez vous vraiment effacer ce document type ?")){
    	MarchePieceJointeType.removeFromId(<%=marchePJT.getId()%>,function() { 
            location.href = '<%=response
									.encodeURL("displayAllFileDCE.jsp")%>';
           });
     }
}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyFileDCE.jsp") %>" method="post" name="formulaire">
<div id="fiche">
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">

		<tr>
			<td><input type="hidden" name="iIdType" id="iIdType" value="<%=marchePJT.getIdType()%>"></td>
		</tr>
		



		<%=pave.getHtmlTrInput("Type de document :", "sTypeDocument", marchePJT
							.getTypeDocument(), "size=\"100\"")%>
		
		</table>
</div>


<div id="fiche_footer">
	<button type="submit">Valider</button>
<%
if(sAction.equals("store"))
{

%>
	<button type="button" onclick="removeItem(<%= marchePJT.getIdType() %>);">Supprimer</button>
<%
}
%>
	<button type="button" onclick="javascript:displayAllFileDCE();">Annuler</button>
</div>
</form>

<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.MarchePieceJointeType"%>

<%@page import="org.apache.jasper.xmlparser.ParserUtils"%></html>
