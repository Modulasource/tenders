<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<%@ page import="java.util.*,modula.*" %>
<%  
	int iIdRole;
	iIdRole = Integer.parseInt(request.getParameter("iIdRole"));

	Enumeration eEnum = request.getParameterNames();
	TreeviewNoeud.removeHabilitations(iIdRole);
	while(eEnum.hasMoreElements())
	{	
		String sValue = eEnum.nextElement().toString();
		String sMask = "node";
		String sValuePrefix = sValue.substring(0,4);
		if(sMask.equals(sValuePrefix))
		{
			int iNodeId = Integer.parseInt(sValue.substring(5));
			TreeviewNoeud.createHabilitation(iIdRole, iNodeId );
		}	
	}

	response.sendRedirect(response.encodeRedirectURL("modifierRoleForm.jsp?iIdRole=" + iIdRole));

%>
