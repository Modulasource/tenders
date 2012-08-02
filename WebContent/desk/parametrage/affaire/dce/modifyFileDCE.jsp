<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="modula.marche.MarchePieceJointeType"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>

<%@ page import="org.coin.bean.conf.*"%>

<%
	String sAction = request.getParameter("sAction");
MarchePieceJointeType marchePJT = null;

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxxx";
		 marchePJT = new MarchePieceJointeType();
		marchePJT.setFromForm(request, "");
		marchePJT.create();
	}

	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-xxxxx";
		 marchePJT 
				=  MarchePieceJointeType.getMarchePieceJointeTypeMemory(Integer.parseInt( request.getParameter("iIdType")));
			
			marchePJT.setFromForm(request, "");
			marchePJT.store();
	}
	response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/parametrage/affaire/dce/displayAllFileDCE.jsp"));
%>
