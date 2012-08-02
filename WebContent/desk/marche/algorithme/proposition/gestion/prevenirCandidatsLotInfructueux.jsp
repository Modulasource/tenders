<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%@ page import="mt.modula.bean.mail.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Lot infructueux, prévenir les candidats";
	String sMess="";
	
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot, false);

	String contenuMail = request.getParameter("contenuMail");
	String objet = request.getParameter("objet");
	
	MailCandidature mailCandidature = new MailCandidature();
	mailCandidature.prevenirCandidatLotInfructueux(
			objet,
			contenuMail,
			sessionUser,
			iIdLot);

%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%
	String sMessTitle = "";
	String sUrlIcone = "";
	if(mailCandidature.iErreur == 0)
	{
		lot.setCandidatsPrevenusLotInfructeux(true);
		lot.store();	
		sMessTitle = "Succès de l'étape";
		sUrlIcone = Icone.ICONE_SUCCES;
	}
	if(mailCandidature.iErreur > 0)
	{
		sMessTitle = "Echec de l'étape";
		sUrlIcone =Icone.ICONE_ERROR;
	}
	if(mailCandidature.iErreur == 0 && mailCandidature.vCandidatures.size() == 0)
	{
		sMessTitle = "Etape non effectuée";
		sMess = "Il n'y a aucun candidat à prevenir";
		sUrlIcone = Icone.ICONE_WARNING;
		lot.setCandidatsPrevenusLotInfructeux(true);
		lot.store();	
	}
%>
<%@ include file="/include/message.jspf" %>
<br />
<button type="button" 
	onclick="RedirectURL('<%= response.encodeURL(rootPath 
		+ "desk/marche/algorithme/proposition/gestion/afficherLotsEtEnveloppesB.jsp?iIdOnglet="
				+ lot.getNumero()) %>')" >Retour</button>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>

