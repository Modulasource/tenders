<%@ include file="/include/new_style/headerDesk.jspf" %>
</head>
<body>
<%

	String sTitle = "Afficher organigramme";
	int iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	Organisation organisation = Organisation.getOrganisation(iIdOrganisation);

	

    Vector<Organigram> vOrganisationOrganigramInterService
        = Organigram.getAllFromObject(
            ObjectType.ORGANISATION,
            organisation.getId(),
            ObjectType.ORGANISATION_SERVICE);

    Organigram organigram = (Organigram )vOrganisationOrganigramInterService.get(0);
%>
<div style="padding:15px">

<%
	if(!HttpUtil.parseBoolean("bDisplayOrganigramNode", request, false))
	{
%>
	<button
	type="button"
	onclick="javascript:Redirect('<%= response.encodeURL(
	rootPath + "desk/organisation/groupe/displayOrganisationServiceOrganigram.jsp?"
	+ "&iIdOrganisation=" + organisation.getIdOrganisation()
	+ "&bDisplayOrganigramNode=true"
	) %>')"
	>Afficher les postes</button>
<%
	}
%>
<jsp:include page="/desk/organisation/pave/blocOrganisationService.jsp" />		

</div>
</body>

<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
</html>