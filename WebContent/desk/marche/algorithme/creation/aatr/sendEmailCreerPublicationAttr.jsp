
<%@page import="mt.modula.cron.SendMailReminderCreateAATRJob"%>
<%@page import="modula.algorithme.AffaireProcedureType"%>
<%@page import="modula.algorithme.AffaireProcedure"%>
<%@page import="modula.marche.AvisAttribution"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%><%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="mt.modula.bean.mail.MailModula"%>
<%@page import="org.coin.mail.Courrier"%>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="mt.modula.bean.mail.MailMarche"%>
<%@page import="org.coin.fr.bean.mail.MailConstant"%>
<%@page import="org.coin.fr.bean.mail.MailType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.marche.Marche"%>
<%
	Connection conn = ConnectionManager.getConnection();
	Marche marche = Marche.getMarche(HttpUtil.parseInt("lId", request), conn, false);

    SendMailReminderCreateAATRJob.sendMail(marche, conn);

  
	ConnectionManager.closeConnection(conn);
	
	response.sendRedirect(
		    response.encodeRedirectURL(rootPath + 
		    		"desk/marche/algorithme/affaire/displayAllEmailMarche.jsp"
		            + "?lId=" + marche.getId()));

%>