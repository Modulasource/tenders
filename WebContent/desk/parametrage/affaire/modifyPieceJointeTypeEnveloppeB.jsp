<%@page import="org.coin.db.CoinDatabaseRemoveException"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.apache.poi.hssf.record.PageBreakRecord.Break"%>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%@page import="modula.candidature.EnveloppeBPieceJointeType"%>
<%@page import="modula.marche.Marche"%>
<%@ page import="modula.*,java.util.*,modula.marche.*" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath() + "/";
	
	String sId="";
	sId=request.getParameter("lId");
	

	if (sAction.equals("create")) {
		String sPageUseCaseId = "IHM-DESK-xxxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		EnveloppeBPieceJointeType piece = new EnveloppeBPieceJointeType();
		piece.setFromForm(request, "");
		piece.create();
	}

			
	if (sAction.equals("store")) {
		String sPageUseCaseId = "IHM-xxxxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		EnveloppeBPieceJointeType piece = EnveloppeBPieceJointeType
				.getEnveloppeBPieceJointeType(Integer.parseInt(request
						.getParameter("lId")));

		piece.setFromForm(request, "");
		piece.store();
	}
	response
			.sendRedirect(response
					.encodeRedirectURL(rootPath
							+ "desk/parametrage/affaire/displayAllPieceJointeTypeEnveloppeB.jsp"));
%>
