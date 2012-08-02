<%@ include file="/include/new_style/headerDesk.jspf" %>
</head>
<body>
<%
	String sTitle = "Afficher génération de circuit";
	int lIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
    boolean bAddNodeHead = HttpUtil.parseBoolean("bAddNodeHead", request, true);
    long lIdOrganisationServiceStart = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganisationServiceStart", -1);
    long lIdOrganisationServiceEnd = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganisationServiceEnd", -1);
    long lIdOrganigramNodeStart = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganigramNodeStart", -1);
    long lIdOrganigramNodeEnd = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdOrganigramNodeEnd", -1);
    Connection conn= ConnectionManager.getConnection();
	
	Organisation organisation = Organisation.getOrganisation(lIdOrganisation);
	
    Vector vOrganisation = null;


    
    if(lIdOrganisation != -1 )  {
    	organisation = Organisation.getOrganisation((int) lIdOrganisation);
    }
    else
    {
        vOrganisation = OrganisationService.getAllOrganisationWithAtLeastOneService();
    }
	
%>
<div style="padding:15px">


<%@ include file="/desk/workflow/bloc/blocDisplayGenerateCircuit.jspf" %>

</div>
</body>

<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%

	ConnectionManager.closeConnection(conn);
%>

</html>