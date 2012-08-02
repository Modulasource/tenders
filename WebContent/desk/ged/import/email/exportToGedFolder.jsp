
<%@page import="org.coin.bean.ged.GedFolderUtil"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.mail.PopUtil"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Vector"%><%@page import="java.util.Properties"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.Message.RecipientType"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.naming.*"%>
<%@page import="org.coin.mail.Mail"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = ConnectionManager.getConnection();


	// récupération des informations dans les fichiers XML
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	Session sessionMail = (Session) envCtx.lookup("mail/Session");
	
	
   	String host = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.pop3.host", "mail.matamore.com");
   	String username = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.user", "courier-entrant.test");
   	String password = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.password", "testmail");
   	String provider = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.store.protocol", "pop3");
   
	GedFolder folder = new GedFolder();
	Message message = null;
	try{
        int iMessageNumber = HttpUtil.parseInt("iMessageNumber", request);

        message = PopUtil.getMessage(
                sessionMail,
                host,
                username,
                password,
                provider,
                "INBOX",
                iMessageNumber);
	    
	    
	    GedFolderUtil.generateFromMessage(folder, message, true, true, conn);
	        
	    
	} catch(Exception e){
	    e.printStackTrace();
	} finally {
        PopUtil.closeMessageWithObjectAttached(message);
    }
	


    ConnectionManager.closeConnection(conn);
    
    response.sendRedirect(
    		response.encodeURL(
    				rootPath + "desk/ged/folder/displayFolder.jsp"
    				+ "?lId=" + folder.getId()));
    
%>