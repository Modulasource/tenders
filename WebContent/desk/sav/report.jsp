<%@ include file="../../include/headerXML.jspf" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.util.*,java.sql.*,org.coin.bean.conf.*,org.coin.fr.bean.mail.*,org.coin.mail.*,org.coin.fr.bean.*,org.coin.bean.*" %>

<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sFormPrefix = "";
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Report de bug"; 
	String sPageUseCaseId = "IHM-DESK-BUG-1";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<%
	String sMessTitle = sTitle;
	String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
	String sMess = "Le report de bug a été transmis avec succès";
	
try{
	PersonnePhysique pp = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	String sApplication = Configuration.getConfigurationValueMemory("modula.application.name");
	String sVersion = Configuration.getConfigurationValueMemory("modula.version");
	String sDB = Configuration.getConfigurationValueMemory("modula.db.version");
	String sTo = Configuration.getConfigurationValueMemory("mail.to.defaut");
	
	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_REPORT_BUG,false);
	
	Courrier courrier = new Courrier();  
	courrier.setIdObject(pp.getIdPersonnePhysique());
	courrier.setIdObjectType(ObjectType.PERSONNE_PHYSIQUE);
	courrier.setTo(sTo);
	courrier.setDateStockage(new Timestamp(System.currentTimeMillis()));
	courrier.setDateEnvoiPrevu(new Timestamp(System.currentTimeMillis()));
	courrier.setSend(true);
	
	String contenuMail = mailType.getContenuType();
	contenuMail = Outils.replaceAll(contenuMail, "[reporter]", pp.getName());
	contenuMail = Outils.replaceAll(contenuMail, "[application]", sApplication);
	contenuMail = Outils.replaceAll(contenuMail, "[version]", sVersion);
	contenuMail = Outils.replaceAll(contenuMail, "[db_version]", sDB);
	contenuMail = Outils.replaceAll(contenuMail, "[plateforme]", request.getParameter("plateforme") +" "+ request.getParameter("plateforme_compl"));
	contenuMail = Outils.replaceAll(contenuMail, "[os]", request.getParameter("os") +" "+ request.getParameter("os_compl"));
	contenuMail = Outils.replaceAll(contenuMail, "[navigateur]", request.getParameter("navigateur"));
	contenuMail = Outils.replaceAll(contenuMail, "[priorite]",request.getParameter("priorite") );
	contenuMail = Outils.replaceAll(contenuMail, "[severite]",request.getParameter("severite") );
	contenuMail = Outils.replaceAll(contenuMail, "[composant]", request.getParameter("composant") +" "+ request.getParameter("composant_compl"));
	contenuMail = Outils.replaceAll(contenuMail, "[page]", request.getParameter("page"));
	contenuMail = Outils.replaceAll(contenuMail, "[resume]", request.getParameter("resume"));
	contenuMail = Outils.replaceAll(contenuMail, "[description]", request.getParameter("description"));
	
	courrier.setSubject(mailType.getObjetType());
	courrier.setMessage(contenuMail);
	
	MailModula mail = new MailModula();
	mail.computeFromCourrier(courrier);
	mail.setTo(sTo);
	mail.setCC( HTMLEntities.unhtmlentitiesComplete(request.getParameter("cc")));
	mail.send();
	
	courrier.setDateEnvoiEffectif(new Timestamp(System.currentTimeMillis()));
	courrier.create();
}catch(Exception e){
	sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
	sMess = "Une erreur est survenue lors de la transmission du report de bug";
}
%>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<table style="vertical-align:top;width:100%;border:0" summary="none">
	<tr>
		<td style="vertical-align:top">
			<div>
				<%@ include file="../../include/message.jspf" %>
			</div>
		</td>
	</tr>
</table>
<%@ include file="../include/footerDesk.jspf" %>
</body>
</html>
