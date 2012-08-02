<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,org.coin.util.*,java.util.*" %>
<%
	
	int iIdGroup ;
	String sAction;
	String sGroupName;
	String sIdRolesListe;
	
	iIdGroup = Integer.parseInt( request.getParameter("iIdGroup") );
	sAction = request.getParameter("sAction") ;
	Group group = null;
	if(sAction.equalsIgnoreCase("create"))
		group = new Group();
	else
		group = Group.getGroup(iIdGroup);
	
	// partie Group
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-HAB-9";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		Connection conn = ConnectionManager.getConnection();
		group.removeWithObjectAttached(conn);
		ConnectionManager.closeConnection(conn);
		response.sendRedirect(response.encodeRedirectURL("afficherTousGroupe.jsp"));
		return;
	}

	sIdRolesListe = request.getParameter("iIdRoleSelectionListe");
	Vector vIntegerList = Outils.parseIntegerList(sIdRolesListe, "|");
	group.setFromForm(request,"");
	
	if(sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-HAB-8";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		group.store();
	}
	if(sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-HAB-10";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		group.create();
	}
	
	// partie Roles
	GroupRole.removeAllByIdGroup((int)group.getId());
	for(int i =0; i < vIntegerList.size(); i++)
	{
		int iIdRole = ((Integer) vIntegerList.get(i)).intValue();
		GroupRole gr = new GroupRole((int)group.getId(), iIdRole);
		gr.create();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherGroupe.jsp?iIdGroup=" + group.getId()
					+ "&nonce" + System.currentTimeMillis()));
%>
