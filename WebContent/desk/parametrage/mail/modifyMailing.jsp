<%@page import="javax.mail.SendFailedException"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="mt.modula.bean.mail.MailModula"%>
<%@page import="org.coin.mail.Courrier"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.db.CoinDatabaseDuplicateException"%>
<%@page import="java.sql.SQLException"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.db.CoinDatabaseTraitment"%>
<%@ include file="../../../include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.html.*" %>
<%
	String sTitle = "Mail Type ";
	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	String sPageUseCaseId = "IHM-DESK-xxx";

	
	CoinDatabaseTraitment traitmentMailing = new CoinDatabaseTraitment() {
		public void doTraitment(
				CoinDatabaseAbstractBean item,
				Connection conn) 
		throws InstantiationException,
		IllegalAccessException, NamingException, SQLException,
		CoinDatabaseDuplicateException 
		{
			try {
				String sMess = "";
				PersonnePhysique personne = (PersonnePhysique) item;
				String sRaisonSociale = Organisation.getOrganisation(
						personne.getIdOrganisation(), false, conn)
						.getRaisonSociale();
		
				Courrier courrier = Courrier
						.newCourrierPersonnePhysique(
						(String) this.context1,
						(String) this.context2,
						(String) this.context3, personne);
		
				MailModula mail = new MailModula();
				mail.setSendBlindCarbonCopyToSender(true);
				try {
					if (courrier.send(mail, conn)) {
						sMess += "Envoi du mail effectué de "
						+ courrier.getFrom() + " à "
						+ personne.getEmail() + " ("
						+ sRaisonSociale + ") .";
						sMess += "<br />";
		
					} else {
						sMess += "Erreur: Envoi du mail impossible.<br />";
					}
				} catch (SendFailedException e) {
					sMess += "Erreur: Envoi du mail impossible à '"
					+ personne.getEmail() + "' : "
					+ e.getMessage() + "<br />";
				}
				
				((JspWriter)this.context4).println(sMess);
				((JspWriter)this.context4).flush();
				
			} catch (Exception e) {
				  e.printStackTrace();
			}
		}
	};
	Connection conn = ConnectionManager.getConnection();
	Connection connStreaming = ConnectionManager.getConnection();
	String sSQLQuery = PersonnePhysique
			.getSqlQueryAllFromOrganisationType(" AND pers.email IS NOT NULL ");
	traitmentMailing.context1 = request.getParameter("sObjet");
	traitmentMailing.context2 = request.getParameter("sContenu");
    traitmentMailing.context3 = request.getParameter("sContenuHTML");
    traitmentMailing.context4 = out;

    Configuration conf = new Configuration();
    conf.setId("server.mail.mailtype.send." + System.currentTimeMillis() );
    conf.setName("Envoi du " + CalendarUtil.getDateFormattee(new Timestamp(System.currentTimeMillis())));
    conf.setDescription(request.getParameter("sObjet") + "\n" + request.getParameter("sContenuHTML"));
    conf.create(conn);
    
%>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
<%
    Vector<Object> vParams = new Vector<Object>();
    vParams.add(new Integer(request.getParameter("lIdOrganisationType")));

	traitmentMailing.connStreaming = connStreaming;
	traitmentMailing.doAll(
			sSQLQuery,
			vParams,
			(CoinDatabaseAbstractBean) new PersonnePhysique(), 
	        conn);
	
	ConnectionManager.closeConnection(conn);
	ConnectionManager.closeConnection(connStreaming);
   
%>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.util.Vector"%>

<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="java.sql.Timestamp"%></html>