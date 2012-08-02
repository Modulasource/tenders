<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*, modula.candidature.*" %>
<%@ page import="modula.journal.*" %>
<%@ page import="java.util.*,org.coin.mail.*,modula.marche.*,org.coin.fr.bean.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.fr.bean.mail.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

    String sMess = "";
	String sMessTitle = "";
	String sUrlIcone = "";
	int iErreur = 0;
	boolean bIsAnonyme = marche.isEnveloppesCAnonyme(false);;
	Courrier courrier = null;
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	int iMailType = Integer.parseInt(request.getParameter("iMailType"));
	String sTitle = request.getParameter("sTitle");
	String sRedirectURLEncoded = request.getParameter("sRedirectURL");
	String sRedirectURL = SecureString.getSessionPlainString(sRedirectURLEncoded, session);
		
	String objet = request.getParameter("objet");
	String contenuMail = request.getParameter("contenuMail");
	String sTypeEnveloppe = "B";
	
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-28");

	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
    Vector vEnveloppes = new Vector();

    
	Connection conn = ConnectionManager.getConnection();
	MailCandidature mc = new  MailCandidature();
	 
	mc.sTypeEnveloppe = sTypeEnveloppe;
    mc.updateEnveloppe(
            iMailType,
            marche,
            lot,
            vLots ,
            sessionUser,
            sRedirectURL) ;
    
	vEnveloppes = mc.vEnveloppes;
	sTypeEnveloppe =  mc.sTypeEnveloppe;
    
	mc.envoyerMailMarche(
			marche.getIdMarche(),
			iIdLot,
			iMailType,
			vEnveloppes,
			sTypeEnveloppe,
			objet,
			contenuMail,
			contenuMail,
			bIsAnonyme,
			sessionUser,
			conn);

	sMess = mc.sMess;
	iErreur = mc.iErreur;
	
	ConnectionManager.closeConnection(conn);

	if (iErreur != 0)
	{
		sMessTitle = "Echec de l'étape";
		sMess += "Echec du traitement des candidatures<br />";
		sUrlIcone = Icone.ICONE_ERROR;
	}
	else
	{
		sMessTitle = "Succès de l'étape";
		sUrlIcone = Icone.ICONE_SUCCES;
		sMess += "Succès du traitement des candidatures<br />";
	}
	String sURLRedirect = response.encodeURL(sRedirectURL+"?"
			+ "iIdNextPhaseEtapes=" + iIdNextPhaseEtapes 
			+ "&iIdLot=" + iIdLot 
			+ "&iIdAffaire=" + marche.getId()
            + "&iIdOnglet=" + (lot.getNumero()-1));
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" onclick="closeModalAndRedirectTabActive('<%= sURLRedirect %>')" >Fermer la fenêtre</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.security.SecureString"%>
</html>