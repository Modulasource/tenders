
<%@ page import="java.io.*,modula.*,java.sql.*,modula.marche.*, java.util.*, modula.algorithme.*, modula.marche.cpv.*, org.coin.fr.bean.*,modula.commission.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%

	String sTitle = "R&eacute;sultat de la cr&eacute;ation de l'affaire";
	String rootPath = request.getContextPath()+"/";
	String sFormPrefix = "";
	int iIdOnglet=0;
	String sAction = request.getParameter("sAction");
	if(request.getParameter("sAction") == null) sAction="";
	
	String sFileName = request.getParameter("sFilename");
	String sPathFileFTP = sessionUser.getPath() + "/web/ftp/pa";
	
	
	if(sAction.equals("remove"))
	{
		String sPageUseCaseId = "IHM-DESK-PA-8";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		File file = new File(sPathFileFTP + "/" + sFileName);
		file.delete();
	}
	

	response.sendRedirect( response.encodeRedirectURL("afficherListeFichiersAImporter.jsp" ));
%>
