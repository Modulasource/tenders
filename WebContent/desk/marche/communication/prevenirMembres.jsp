<%@ include file="/include/headerXML.jspf" %>

<%@ page import="java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,modula.commission.*,org.coin.util.treeview.*,java.text.*,modula.algorithme.*,modula.*,modula.marche.*,java.util.*, modula.candidature.*, org.coin.util.*"%>
<%@ page import="mt.modula.bean.mail.*,org.coin.util.*,org.coin.mail.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Pr&eacute;venir les membres de la commission";
	String rootPath = request.getContextPath()+"/";
	String sMess="";
%>
<%@ include file="../../include/headerDesk.jspf" %>
<%
String sPageUseCaseId = "IHM-DESK-AFF-80"; 
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
</head>
<body>
<% 
String sHeadTitre = "Pr&eacute;venir les membres du lancement de l'affaire"; 
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="../../include/headerAffaire.jspf" %>
<%
String message = "";
if (request.getParameterValues("selection") != null)
{
	Commission cCommission = Commission.getCommission(marche.getIdCommission());
	Organisation oOrganisationPrm = Organisation.getOrganisation(cCommission.getIdOrganisation());
	Adresse aAdresseColl = Adresse.getAdresse(oOrganisationPrm.getIdAdresse());
	
	/* Récupération des identifiants des personnes à qui on envoie le mail */
	String[] selection = request.getParameterValues("selection");
	
	/* Récupération de l'objet du mail */
	String objet = request.getParameter("objet");
	objet = Outils.replaceAll(objet, "[reference]", marche.getReference());
	objet = Outils.replaceAll(objet, "[objet]", marche.getObjet());
	
	/* Récupération du contenu du mail */
	String contenuMail = request.getParameter("contenuMail");
	/* PARSING DU CONTENU */
	contenuMail = Outils.replaceAll(contenuMail, "[nom_commission]", cCommission.getNom());

	Vector<Validite> vValiditesAAPC = Validite.getAllValiditeAAPCFromAffaire(marche.getIdMarche());
	Timestamp tsDateMiseEnLigne = vValiditesAAPC.firstElement().getDateDebut();
    
	contenuMail = Outils.replaceAll(contenuMail, "[date_mise_en_ligne]",
								 CalendarUtil.getDateFormattee(tsDateMiseEnLigne));

	contenuMail = Outils.replaceAll(contenuMail, "[civilite_personne_loguee]",
								 PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getCivilite());

	contenuMail = Outils.replaceAll(contenuMail, "[nom_personne_loguee]",
								 PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getNom());

	String sPassation = "";
	try
	{
		int iIdMarchePassation = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdMarchePassation();
		sPassation = MarchePassation.getMarchePassationGlobalNameMemory(iIdMarchePassation,false);
	}
	catch(Exception e){}
	
	contenuMail = Outils.replaceAll(contenuMail, "[mode_passation]", sPassation);
	
	/* /PARSING DU CONTENU */
	for (int i = 0; i < selection.length; i++)
	{
		CommissionMembre cmMembre = CommissionMembre.getCommissionMembre(Integer.parseInt(selection[i]));
		PersonnePhysique ppMembre = PersonnePhysique.getPersonnePhysique(cmMembre.getIdPersonnePhysique());
		
		/* Parsing du contenu du mail */
		
		/* Préparation du mail à envoyer */
		Courrier courrier = new Courrier(); 
		courrier.setIdObject(marche.getIdMarche());
		courrier.setIdObjectType(TypeObjetModula.AFFAIRE);
		courrier.setTo(ppMembre.getEmail());
		courrier.setSubject(objet);
		courrier.setMessage(contenuMail);
		courrier.setDateStockage(new Timestamp(System.currentTimeMillis()));
		courrier.setDateEnvoiPrevu(new Timestamp(System.currentTimeMillis()));
		courrier.setSend(false);
		
		MailModula AEnvoyer = new MailModula();
		AEnvoyer.computeFromCourrier(courrier);
		if (AEnvoyer.send())
		{
			courrier.setSend(true);
			courrier.setDateEnvoiEffectif(new Timestamp(System.currentTimeMillis()));
			courrier.create();
			sMess += "Le mail adress&eacute; &agrave; " + ppMembre.getCivilitePrenomNom() 
				+ " a &eacute;t&eacute; envoy&eacute; et stock&eacute;<br />";
			modula.journal.Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-80", sessionUser.getIdUser(),
			"La commission a été prévenue du lancement de l'affaire");
		}
		else
		{
			sMess += "ERREUR : Le mail adress&eacute; &agrave; " + ppMembre.getCivilitePrenomNom() 
				+ " n'a pas &eacute;t&eacute; envoy&eacute; ni stock&eacute;<br />";
		}
	}
}
else
{
	sMess += "Aucun membre ne sera pr&eacute;venu.<br />";
	/* Faire une redirection sur une page informative (errorAdmin) */
}

String sMessTitle = "Succ&egrave;s de l'&eacute;tape";
if (request.getParameterValues("selection") != null)
	sMess += InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_PUBLICATIONS_MEMBRES);
String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;			
%>
<%@ include file="../../../include/message.jspf" %>
<div style="text-align:center">
	<input type="button" value="Retour à l'affaire" 
		onclick="Redirect('<%=response.encodeRedirectURL(rootPath+"desk/marche/algorithme/affaire/afficherAffaire.jsp?iIdAffaire="+marche.getIdMarche()) %>')" />
</div>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>