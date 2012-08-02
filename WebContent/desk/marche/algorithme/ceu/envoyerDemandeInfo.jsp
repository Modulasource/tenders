<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.marche.*, org.coin.util.*,modula.commission.*, modula.candidature.*, modula.*, java.sql.*, java.util.*, org.coin.fr.bean.mail.*, org.coin.fr.bean.* " %>
<%@ page import="org.coin.mail.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sFormPrefix = "";

	/* Récupération de la date de début de la période de remise */
	Timestamp tsDateDebutRemise
		= CalendarUtil.getConversionTimestamp(
				request.getParameter(sFormPrefix + "tsDateDebutRemise")
				+ " " + request.getParameter(sFormPrefix + "tsHeureDebutRemise"));
	/* Récupération de la date de fin de la période de remise */
	Timestamp tsDateFinRemise = CalendarUtil.getConversionTimestamp(
				request.getParameter(sFormPrefix + "tsDateFinRemise")
				+ " " + request.getParameter(sFormPrefix + "tsHeureFinRemise"));
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));

	Commission commission=  Commission.getCommission(marche.getIdCommission()); 
	Organisation organisation = Organisation.getOrganisation(commission.getIdOrganisation());
	MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_CDT_DEMANDE_INFOS_COMP);
	String objet = mailType.getObjetType();
	String contenuMail = mailType.getContenuType();

/* Récupération des demandes d'informations complémentaires du marché identifié */
Vector vDemandes = DemandeInfoComplementaire.getAllDemandeEnCoursEnveloppeAFromMarche(marche.getIdMarche());

for (int i = 0; i < vDemandes.size(); i++)
{
	/* Pour chaque demande d'info complémentaire, on stocke les dates de la période de remise, on formate l'email
	et on le stocke */
	/* Récupération de la demande d'info */
	DemandeInfoComplementaire demandeInfoComplementaire = (DemandeInfoComplementaire)vDemandes.get(i);
	demandeInfoComplementaire.setDateDebutRemise(tsDateDebutRemise);
	demandeInfoComplementaire.setDateFinRemise(tsDateFinRemise);
	Candidature candidature = Candidature.getCandidature((EnveloppeA.getEnveloppeA(demandeInfoComplementaire.getIdEnveloppe()).getIdCandidature()));
	
	boolean bCandidaturePapier = candidature.isCandidaturePapier(false);
	if(!bCandidaturePapier)
	{
		PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());	
		PersonnePhysique user = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
		PersonnePhysique membre = null;
		PersonnePhysique gestionnaireCarnet = null;
		String sUrlValidation = "";
		String sNouveauPassword = "";
		String sPassword = "";
		String sMailNouveauMembre = "";
		String sStatut = "";
		%>
		<%@ include file="/include/parserMail.jspf" %>
		<%
		
		/* Préparation du mail à envoyer */
		Courrier courrier = new Courrier(); 
		courrier.setIdObject(marche.getIdMarche());
		courrier.setIdObjectType(TypeObjetModula.AFFAIRE);
		courrier.setTo(candidat.getEmail());
		courrier.setSubject(objet);
		courrier.setMessage(contenuMail);
		courrier.setDateStockage(new Timestamp(System.currentTimeMillis()));
		courrier.setDateEnvoiPrevu(new Timestamp(System.currentTimeMillis()));
		courrier.setSend(false);
		courrier.setFrom(PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getEmail());
		
		courrier.setDateEnvoiPrevu(demandeInfoComplementaire.getDateDebutRemise());
		courrier.create();
		/* Stockage de la demande et du mail à stocker */
		demandeInfoComplementaire.store();
	}
}
%>
<script type="text/javascript">
onPageLoad = function(){
	try{parent.frames[0].hideEnvoiComp();}
	catch(e){parent.hideEnvoiComp();}
}
</script>
</head>
<body>
<div style="padding:15px">
	<table height="100%">
	<tr>
    	<td style="vertical-align:middle;height:100%">
<%
	Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-30", sessionUser.getIdUser(), "Demande d'information complémentaire au candidat");
	String sMessTitle = "Succès de l'étape";
	String sMess = "Toutes les demandes d'informations complémentaires ont été envoyées.";
	String sUrlIcone = Icone.ICONE_SUCCES;	
%>
<%@ include file="/include/message.jspf" %>
		</td>
	</tr>
</table>
</body>
<%@page import="modula.journal.Evenement"%>
<%@page import="modula.graphic.Icone"%>
</html>