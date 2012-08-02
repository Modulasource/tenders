<%@ include file="/include/headerXML.jspf" %>

<%@ page import="java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,modula.commission.*,java.text.*"%>
<%@ page import="modula.algorithme.*,modula.marche.*,java.util.*,org.coin.util.treeview.*"%>
<%@ page import="mt.modula.bean.mail.*,org.coin.util.*,org.coin.mail.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Convoquer les membres de la commission";
	String sMess = "";
	String rootPath = request.getContextPath()+"/";
	/* Récupération de la commission et de l'organisation PRM */
	Commission cCommission = null;
	try
	{
		cCommission = Commission.getCommission(marche.getIdCommission());
	}
	catch(Exception e){e.printStackTrace();}
	Organisation oOrganisationPrm = null;
	try
	{
		oOrganisationPrm = Organisation.getOrganisation(cCommission.getIdOrganisation());
	}
	catch(Exception e){e.printStackTrace();}
Adresse aAdresseColl = null;
try
{
	aAdresseColl = Adresse.getAdresse(oOrganisationPrm.getIdAdresse());
}
catch(Exception e){e.printStackTrace();}
/* Récupération du secrétaire de la commission */
//CommissionMembre cmSecretaire = CommissionMembre.getSecretaire(cCommission.getIdCommission());
//PersonnePhysique ppSecretaire = PersonnePhysique.getPersonnePhysique(cmSecretaire.getIdPersonnePhysique());
%>
<%@ include file="../../include/headerDesk.jspf" %>
<%
String sPageUseCaseId = "IHM-DESK-AFF-11"; 
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
</head>
<body>
<% 
String sHeadTitre = sTitle; 
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="../../include/headerAffaire.jspf" %>
<%
int iNbError = 0;

if (request.getParameterValues("selection") != null)
{
	/* Récupération des identifiants des personnes à qui on envoie le mail */
	String[] selection = request.getParameterValues("selection");
	/* Récupération de l'objet du mail */
	String objet = request.getParameter("objet");
	objet = Outils.replaceAll(objet, "[reference]", marche.getReference());
	objet = Outils.replaceAll(objet, "[objet]", marche.getObjet());
	/* Récupération du contenu du mail */
	String contenuMail = request.getParameter("contenuMail");
	try
	{
		contenuMail = Outils.replaceAll(contenuMail, "[civilite_personne_loguee]",
			PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getCivilite());
	}
	catch(Exception e){e.printStackTrace();}
	try
	{
		contenuMail = Outils.replaceAll(contenuMail, "[nom_personne_loguee]",
			PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getNom());
	}
	catch(Exception e){e.printStackTrace();}
	sMess += "Traitement des convocations<br />";
	for (int i = 0; i < selection.length; i++)
	{
		/* Récupération du membre à qui on envoie une convocation */
		CommissionMembre cmMembre = CommissionMembre.getCommissionMembre(Integer.parseInt(selection[i]));
		PersonnePhysique ppMembre = null;
		try
		{
			ppMembre = PersonnePhysique.getPersonnePhysique(cmMembre.getIdPersonnePhysique());
		}
		catch(Exception e){e.printStackTrace();}
		String sMembre = "";
		try
		{
			sMembre = ppMembre.getCivilitePrenomNom();
		}
		catch(Exception e){e.printStackTrace();}
		/* Parsing du contenu du mail */
		try
		{
			contenuMail = Outils.replaceAll(contenuMail, "[civilite_membre]",ppMembre.getCivilite()); 
		}
		catch(Exception e){e.printStackTrace();}
		contenuMail = Outils.replaceAll(contenuMail, "[nom_membre]", ppMembre.getNom());
		
		/* Préparation du mail à envoyer */
		Courrier courrier = new Courrier(); 
		courrier.setIdObject(marche.getIdMarche());
		courrier.setIdObjectType(org.coin.bean.ObjectType.AFFAIRE);
		courrier.setTo(ppMembre.getEmail());
		courrier.setSubject(objet);
		courrier.setMessage(contenuMail);
		courrier.setDateStockage(new Timestamp(System.currentTimeMillis()));
		courrier.setDateEnvoiPrevu(new Timestamp(System.currentTimeMillis()));
		courrier.setSend(false);
		
		MailModula AEnvoyer = new MailModula();
		try
		{
			courrier.setFrom(PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getEmail());
		}
		catch(Exception e){e.printStackTrace();}
		AEnvoyer.computeFromCourrier(courrier);
		if (AEnvoyer.send()){
			/* Envoi du mail au membre de la commission */
			courrier.setSend(true);
			courrier.setDateEnvoiEffectif(new Timestamp(System.currentTimeMillis()));
			courrier.create();
			modula.journal.Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-11", sessionUser.getIdUser(), "La commission a été convoquée");
			/* Stockage du mail adressé au membre */
			sMess += "Le mail adress&eacute; &agrave; " + sMembre 
					+ " a &eacute;t&eacute; envoy&eacute; et stock&eacute;<br />";
		}
		else
		{
			/* Le mail n'a pas été envoyé */
			sMess += "Le mail adress&eacute; &agrave; " + sMembre 
					+ " n'a pas &eacute;t&eacute; envoy&eacute; ni stock&eacute;<br />";
			iNbError++;
		}
	}
}
else
{
	/* Pas de membre à prévenir */
	sMess += "Aucun membre ne sera convoqu&eacute;.<br />";
	/* Faire une redirection sur une page informative (errorAdmin) */
	iNbError++;
}
String sMessTitle = "Succès de l'&eacute;tape";
String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;	
if (iNbError>0){
	sMessTitle = "Echec de l'&eacute;tape";
	sUrlIcone = modula.graphic.Icone.ICONE_ERROR;	
}
%>
<%@ include file="../../../include/message.jspf" %>
<div style="text-align:center">
	<input type="button" value="Retour à l'affaire" 
		onclick="Redirect('<%=response.encodeRedirectURL(rootPath+"desk/marche/algorithme/affaire/afficherAffaire.jsp?iIdAffaire="+marche.getIdMarche()) %>')" />
</div>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>