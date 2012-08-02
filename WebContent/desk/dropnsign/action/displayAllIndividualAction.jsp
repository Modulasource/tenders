<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.bean.addressbook.IndividualActionState"%>
<%@page import="org.coin.bean.addressbook.IndividualActionType"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.addressbook.IndividualAction"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@include file="/include/new_style/headerDeskUtf8.jspf" %>
<%
	IndividualAction ia = new IndividualAction();
	Vector<IndividualAction> vIndividualActionSend 
		= ia.getAllWithWhereAndOrderByClause(
			" WHERE id_individual_source=" + sessionUser.getIdIndividual()
			+ " AND id_individual_destination<>" + sessionUser.getIdIndividual(),
			"");
	
	Vector<IndividualAction> vIndividualActionReceived
	= ia.getAllWithWhereAndOrderByClause(
		" WHERE id_individual_destination=" + sessionUser.getIdIndividual()
		+ " AND id_individual_source<>" + sessionUser.getIdIndividual(),
		"");

	Vector<IndividualAction> vIndividualActionMine
	= ia.getAllWithWhereAndOrderByClause(
		" WHERE id_individual_destination=" + sessionUser.getIdIndividual()
		+ " AND id_individual_source=" + sessionUser.getIdIndividual(),
		"");

	
	Vector<PersonnePhysique> vPersonnePhysique = new Vector<PersonnePhysique >();
	request.setAttribute("vPersonnePhysique", vPersonnePhysique);
	request.setAttribute("ppAction", PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()));

%>
<script type="text/javascript">
function signDocument(lId, sUrlReturnPostTraitmentCipher)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/signature/displayAppletSignature.jsp" 
			+ "?sAction=sign"
			+ "&lId=") %>"
			+ lId
			+ "&sUrlReturnPostTraitmentCipher=" + sUrlReturnPostTraitmentCipher);
}

function refuseAction(lId)
{
	doUrl("<%= response.encodeURL(
			rootPath + "desk/dropnsign/action/modifyIndividualAction.jsp" 
			+ "?sAction=setState"
			+ "&lIdIndividualActionState=" + IndividualActionState.STATE_REFUSED
			+ "&lId=") %>"
			+ lId
			);
}
</script>
</head>
<body>

<div style="margin-top: 20px">
<div>My tasks</div>
<%
	request.setAttribute("vIndividualAction", vIndividualActionMine);
%>
<jsp:include page="bloc/blocTaskActionList.jsp" />
</div>

<div style="margin-top: 20px">
<div>Tasks send</div>
<%
	request.setAttribute("vIndividualAction", vIndividualActionSend);
%>
<jsp:include page="bloc/blocTaskActionList.jsp" />
</div>

<div style="margin-top: 20px">
<div>Tasks received</div>
<%
	request.setAttribute("vIndividualAction", vIndividualActionReceived);
%>
<jsp:include page="bloc/blocTaskActionList.jsp" />
</div>

</body>
</html>