<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.util.*,java.sql.*,org.coin.bean.conf.*,org.coin.fr.bean.mail.*,org.coin.mail.*,org.coin.fr.bean.*,org.coin.bean.*" %>
<%
	String sFormPrefix = "";
	String sTitle = "Report de bug";
	String sPageUseCaseId = "IHM-DESK-BUG-1";

	String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
	String sMess = "Le signalement a été transmis avec succès";
	String sMessTitle = "";

	try {
		PersonnePhysique pp = null;
		try {
			pp = PersonnePhysique.getPersonnePhysique(sessionUser
					.getIdIndividual());
		} catch (Exception e) {
			pp = new PersonnePhysique();
		}

		String sTo = Configuration
				.getConfigurationValueMemory("mail.to.defaut");

		
		sTo = "david.keller@matamore.com;sebastien.cochegrue@matamore.com;federico.vidal@matamore.com;julien.renier@matamore.com";
		
		//MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_REPORT_BUG,false);

		/*
		Courrier courrier = new Courrier();  
		courrier.setIdObject(pp.getIdPersonnePhysique());
		courrier.setIdObjectType(ObjectType.PERSONNE_PHYSIQUE);
		courrier.setTo(sTo);
		courrier.setDateStockage(new Timestamp(System.currentTimeMillis()));
		courrier.setDateEnvoiPrevu(new Timestamp(System.currentTimeMillis()));
		courrier.setSend(true);
		 */

		Connection conn = ConnectionManager.getConnection();

		Courrier courrier = MailUser.prepareCourrierPersonnePhysique(
				MailConstant.MAIL_REPORT_BUG, 
				pp, 
				conn);

	    courrier.setTo(sTo);
	    try {
	    	
	        courrier.replaceAllMessageKeyWord("[sUserSession]", 
	        		pp.getPrenomNom() 
	        		+ " " + pp.getEmail()
	        		+ " / " + organisation.getRaisonSociale());
	    } catch (Exception e) { }
		
		Enumeration<String> en = request.getParameterNames();
		for (; en.hasMoreElements();) {
			String sParameterName = en.nextElement();
			System.out.println("sParameterName : " + sParameterName);
	        courrier.replaceAllMessageKeyWord("[" + sParameterName + "]", request.getParameter(sParameterName));
		}


		MailModula mail = new MailModula();
		courrier.send(mail, conn);

		ConnectionManager.closeConnection(conn);


	} catch (Exception e) {
		e.printStackTrace();
		sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
		sMess = "Une erreur est survenue lors de la transmission du signalement";
	}
%>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Signalement envoyé</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth pave" >
		<tr>
			<td style="vertical-align:top">
				<div>
					<%@ include file="/include/message.jspf" %>
				</div>
			</td>
		</tr>
    </table>
</div>
</div>
<%@ include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
<%@page import="org.coin.mail.mailtype.MailUser"%>
<%@page import="org.coin.db.ConnectionManager"%>
</html>