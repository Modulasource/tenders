<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.sql.*" %>
<%@ page import="modula.marche.*" %>
<%@ page import="org.coin.util.*" %>
<%@ page import="mt.modula.bean.mail.*" %>
<%
	int iIdAffaire = HttpUtil.parseInt("iIdAffaire", request, 0) ;
	Marche marche = Marche.getMarche(iIdAffaire);
	
	String sTitle = "Prévenir les candidats de la publication d'un avis rectificatif de l'affaire " 
		+ marche.getReference();
	
	String sMess = "";
	String sMessTitle = "";
	String sUrlIcone = "";
	
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, -1);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	
	Connection conn = ConnectionManager.getConnection();
	AvisRectificatif avis = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif, false, conn);
	avis.setMailCandidatEnvoye(true);
	avis.store(conn);
	
	String sRedirect = "afficherAffaire";
	boolean bIsAATR = false;
	AvisAttribution avisAttrib = null;
	if(marche.isAffaireAATR(false))
	{
		sRedirect = "afficherAttribution";
		bIsAATR = true;
		avisAttrib = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire, conn);
	}
	
	if(avis.isAllEtapesForRectificationValides())
	{
		if(bIsAATR)
		{
			avisAttrib.setAATREnCoursDeRectification(false);
			avisAttrib.store(conn);
		}
		else
		{
			marche.setAffaireEnCoursDeRectification(false);
			marche.store(conn);
		}
	}
	

	MailCandidature mailCandidature = new MailCandidature();
	mailCandidature.prevenirCandidatAvisRectificatif(
			marche.getIdMarche(),
			avis,
			request.getParameter("objet"),
			request.getParameter("contenuMail"),
			request.getParameter("contenuMail"),
			sessionUser,
			conn);
	
	sMess = mailCandidature.sMess;
	ConnectionManager.closeConnection(conn);
	
	if(mailCandidature.iErreur == 0)
	{
		Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-RECT-8", sessionUser.getIdUser(), "Les candidats ont été prévenus de la publication d'un avis rectificatif");
		sMessTitle = "Succès de l'étape";
		sUrlIcone =Icone.ICONE_SUCCES;
	}
	if(mailCandidature.iErreur > 0)
	{
		sMessTitle = "Echec de l'étape";
		sUrlIcone = Icone.ICONE_ERROR;
	}
	if(mailCandidature.iErreur == 0 && mailCandidature.vCandidatures.size() == 0)
	{
		Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-RECT-8", sessionUser.getIdUser(), "Les candidats ont été prévenus de la publication d'un avis rectificatif");
		sMessTitle = "Etape non effectuée";
		sMess = "Il n'y a aucun candidat à prevenir";
		sUrlIcone = Icone.ICONE_WARNING;
	}
	
	String sURLRedirect = response.encodeURL(rootPath+"desk/marche/algorithme/affaire/"+sRedirect
			+".jsp?sActionRectificatif=show&iIdAvisRectificatif=" 
			+ avis.getIdAvisRectificatif() + "&iIdOnglet=" + iIdOnglet
			+ "&iIdAffaire=" + avis.getIdMarche()
			+ "&none="+System.currentTimeMillis()
			+"&#ancreHP");
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<div style="padding-top:15px;">

</div>
<%@ include file="../../../../include/message.jspf" %>
<div style="text-align:center">
	<button type="button" onclick="closeModalAndRedirectTabActive('<%= sURLRedirect %>')" >Fermer la fenêtre</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.journal.Evenement"%>
</html>