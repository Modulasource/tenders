<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.Properties"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.Message.RecipientType"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.naming.*"%>
<%@page import="org.coin.mail.Mail"%>
<%
	String sTitle = "All mails";	
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">


<div class="dataGridHolder fullWidth">
        <table class="dataGrid fullWidth">
        <tr class="header">
            <td width="10px" >&nbsp;</td>
            <td width="40px" >Date</td>
            <td width="15%" >De</td>
            <td width="20%" >A</td>
            <td width="50%" >Objet</td>
            <td width="5%" >Taille</td>
            <td width="20px">&nbsp;</td>
        </tr>

<%
    long lStart = System.currentTimeMillis();

	// récupération des informations dans les fichiers XML
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	Session sessionMail = (Session) envCtx.lookup("mail/Session");

//	Properties props = new Properties();
//  Session sessionMail = Session.getDefaultInstance(props, null);
	
	//String host = "mail.matamore.com";
	//String username = "courier-entrant.test";
	//String password = "testmail";
	//String provider = "pop3";
	
	
    String host = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.pop3.host", "mail.matamore.com");
    String username = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.user", "courier-entrant.test");
    String password = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.password", "testmail");
    String provider = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptional(sessionUser.getIdIndividual(),"mail.store.protocol", "pop3");

    Store store = null;
    Folder inbox = null;
    
	long lConnectTime = (System.currentTimeMillis() - lStart);
    System.out.println("Connect time : " + lConnectTime);
	
	
	try{
        store = sessionMail.getStore(provider);
        store.connect(host, username, password);
        
		
	    inbox = store.getFolder("INBOX");
	    inbox.open(Folder.READ_ONLY);
	    System.out.println("open folder : " + (System.currentTimeMillis() - lStart - lConnectTime));
	    Message[] messages = inbox.getMessages();
	    System.out.println("get messages : " + (System.currentTimeMillis() - lStart  - lConnectTime));
	    
	    for (int i = 0; i < messages.length; i++) {
	      Message message = messages[i]; 
	      
	      String sDateRecv = "";
	      try{
	    	  sDateRecv = CalendarUtil.getFormatDateHeureStd( message.getSentDate()) ;
	      } catch (Exception e) {
	    	  
	      }
          
          String sRecipientsFROM = Mail.addressToString(message.getFrom());
          String sRecipientsTO = Mail.addressToString(message.getRecipients(RecipientType.TO));
          String sRecipientsCC = Mail.addressToString(message.getRecipients(RecipientType.CC));
	      
          //sRecipientsFROM = InternetAddress.toString(message.getFrom());
          
	%>
	            <tr class="liste<%=i%2%>" 
	                >
                    <td ><input type="checkbox" title="message ID <%= message.getMessageNumber() %>" /></td> 
                    <td ><%= sDateRecv %></td> 
                    <td ><%= sRecipientsFROM %></td>
                    <td ><%= sRecipientsTO %></td>
	                <td ><%= message.getSubject() %></td>
                    <td ><%= message.getSize() / 1024 %> Ko</td>
	                <td ><button onclick="doUrl('<%= 
	                	response.encodeURL( 
	                			rootPath + "desk/ged/import/email/exportToGedFolder.jsp"
	                			+ "?iMessageNumber=" + message.getMessageNumber()) 
	                			%>')">GED</button></td>
	            </tr>
	<%
	    }
		   	
	} catch(Exception e){
		e.printStackTrace();
	}
	
	
	if(inbox != null) inbox.close(false);
	if(store != null) store.close();

	//pour vérifier qu'il ne récup pas les pjs et juste l'entete du mail
    System.out.println("End : " + (System.currentTimeMillis() - lStart - lConnectTime));

%>
        </table>
    </div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>


<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%></html>