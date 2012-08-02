<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,org.coin.fr.bean.*,modula.graphic.*,org.coin.fr.bean.mail.*,modula.candidature.*,java.util.*,modula.*, modula.marche.*,modula.algorithme.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Gestion des offres de l'affaire réf. " + marche.getReference(); 
	
	boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsAnonyme = marche.isEnveloppesBAnonyme(false);
	
	long iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);;
	if(iIdNextPhaseEtapes < 0)
	{
		iIdNextPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes()).getId();
		iIdNextPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdNextPhaseEtapes).getId();
	}
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request,0);
	String sUseCaseIdBoutonOuvrirB = "IHM-DESK-AFF-16";
	String sUseCaseIdBoutonAttribuerStatutB = "IHM-DESK-AFF-38";
	String sUseCaseIdBoutonConfirmerStatusB = "IHM-DESK-AFF-17";
	boolean bAfficherBoutonContenu = true;
	boolean bAfficherBoutonCommentaire = true;
	
	
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
	/**
	 * Ici les numéros des lots de se suivent pas forcément
	 * on peut commencer par le 2, 5, 8.
	 * donc si iIdOnglet = 0, alors il faut prendre le premier de la liste
	 */ 
	MarcheLot lot = null;
	
	for (int i = 0; i < vLots.size(); i++)
	{
		MarcheLot lotTemp = vLots.get(i);
		if(lotTemp.getNumero() == iIdOnglet )
			lot = lotTemp ;
	}
	if(lot==null)
	{
		lot = vLots.firstElement();
		iIdOnglet = lot.getNumero();
	}
	
	Vector<Onglet> vOnglets = new Vector<Onglet>();

	for (int i = 0; i < vLots.size(); i++) 
	{
		MarcheLot oLot = vLots.get(i);
		String sUrlTarget = response.encodeURL("afficherLotsEtEnveloppesB.jsp?iIdNextPhaseEtapes="
				+iIdNextPhaseEtapes+"&amp;iIdOnglet=" + oLot.getNumero() 
				+"&amp;iIdAffaire="+iIdAffaire);
		
		String sLibelle = "";
		if(vLots.size()==1) sLibelle = "Marché";
		else sLibelle = "Lot " + oLot.getNumero();
		
		vOnglets.add( new Onglet( oLot.getNumero(), false, sLibelle, sUrlTarget ) ); 
	}

	Onglet onglet = null;
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		Onglet ongletTmp = (Onglet ) vOnglets.get(i);
		if(ongletTmp.iId==iIdOnglet)
		{
			onglet = ongletTmp;
		}
	}
	onglet.bIsCurrent = true;
	
	String sLibelleOnglet = onglet.sLibelle;
	
	boolean bIsAttribue =lot.isAttribue(false);
	boolean bIsInfructueux = lot.isInfructueux(false);
	boolean bIsNegociationFige = lot.isNegociationFige(false);
	boolean bIsEnAttenteDeNegociation = lot.isEnAttenteDeNegociation(false);
	boolean bIsClassementEnveloppesBFige = lot.isClassementEnveloppesBFige(false);
	//bIsClassementEnveloppesBFige=true;
	String sTitre="";
	String sURL = SecureString.getSessionSecureString(  
			rootPath +  "desk/marche/algorithme/proposition/gestion/afficherLotsEtEnveloppesB.jsp",
			session);
	
	if(bIsAttribue) {
		sTitle = "Information des candidats de l'affaire réf. " + marche.getReference(); 
	}

%>

<script src="<%= rootPath %>include/js/scriptaculous/scriptaculous.js"></script>
<script src="<%= rootPath %>include/js/mt.component.js?v=<%= JavascriptVersion.MT_COMPONENT_JS %>"></script>
<script type="text/javascript">
function checkPoursuivre()
{
	return confirm("Avez-vous bien notifié tous les candidats non retenus avant de poursuivre l'affaire?");
}
function checkLancerNegociation()
{
	return confirm("Etes vous sûr de vouloir lancer les négociation ?");
}
function checkMailsNego()
{
	if(confirm("Avant de lancer les négociations, vous devez notifier les candidats \"non retenus\" et \"non conformes\".\nLes négociations de tous les lots seront lancées en même temps via le bouton \"confirmer les negociations\" en bas de page.\nEtes vous sûr de vouloir lancer une phase de négociation pour le <%= sLibelleOnglet %> ?")){
		$('sAction').value='negociation';
		document.formulaire.submit();
	}
	return false;
}
function checkValidation()
{
	return confirm("Etes vous sûr de vouloir attribuer le <%= sLibelleOnglet %> définitivement ?");
}
function checkFinalisation()
{
	if(confirm("Avant de finaliser un classement, vous devez notifier les candidats \"non retenus\" et \"non conformes\".\nEtes vous sûr de vouloir finaliser un classement pour le <%= sLibelleOnglet %> ?")){
		$('sAction').value='finaliser';
		document.formulaire.submit();
	}
	return false;
}
function checkInfructueux()
{
	return confirm('Attention! Si vous cliquez sur le bouton "OK", vous déclarer définitivement le <%= sLibelleOnglet %> comme infructueux, et ne pourrez plus l\'attribuer à un candidat.Etes vous sûr?');
}
function checkNonRetenu()
{
	return confirm('Attention! Si vous cliquez sur le bouton "OK", vous déclarer que le candidat n\'est pas titulaire du <%= sLibelleOnglet %>. Vous pourrez ensuite séléctionner le premier des retenus avec rang classement comme titulaire sous réserve. Etes vous sûr?');
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br/>
<div align="center">
<img alt="Fichier zip" style="cursor:pointer;vertical-align:middle;" src="<%= rootPath %>images/icons/32x32/zip.png" 
onclick="javascript:openModal('<%= 
		response.encodeURL(rootPath + "desk/DownloadZipAffaireEnveloppeServlet?"
			+ DownloadZipAffaireDceServlet
				.getSecureTransactionString(marche.getIdMarche(), request)) 
		%>','Fichier zip contenant toutes pièces')"/>
Téléchargez le fichier zip contenant toutes les pièces
</div>
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets) %>
<div class="tabContent">
<form action="<%= response.encodeURL("validerEnveloppesBClassement.jsp?nonce="+System.currentTimeMillis())
    %>" method="post"  name="formulaire">
<input type="hidden" name="iIdAffaire" value="<%= iIdAffaire %>" />
<%
	if(bIsAttribue)
	{%>
		<%@ include file="pave/pavePrevenirTitulaire.jspf" %> 
		<div class="tabFooter">
	<% 
	}
	else if (bIsInfructueux) 
	{%>
		<%@ include file="pave/paveLotInfructueux.jspf" %>
		<div class="tabFooter">
	<% 
	} 
	else 
	{
		Vector<EnveloppeB> vNonConformes = EnveloppeB.getAllEnveloppesBNonConformesFromLotAndValidite(lot.getIdMarcheLot(),lot.getIdValiditeEnveloppeBCourante());
		Vector<EnveloppeB> vRetenues = EnveloppeB.getAllEnveloppesBRetenuesAndNonAttribueesFromLotAndValidite(lot.getIdMarcheLot(),lot.getIdValiditeEnveloppeBCourante());
		Vector<EnveloppeB> vAttribuees = EnveloppeB.getAllEnveloppesBAttribueesFromLotAndValidite(lot.getIdMarcheLot(),lot.getIdValiditeEnveloppeBCourante());
		Vector<EnveloppeB> vNonRetenues = new Vector<EnveloppeB>();
		
		String sTitreListeNonConformes = "Offres inappropriées, irrégulières ou inacceptables";
		String sTitreListeRetenues = "Offres retenues (avec rang de classement)";
		if(bIsContainsEnveloppeCManagement)
			sTitreListeRetenues = "Lauréats (avec rang de classement)";
		String sTitreListeNonRetenues = "";
		String sTitreListeAttribues = "Offre "+((vAttribuees.size() > 1)?"s":"")+" retenue "+((vAttribuees.size() > 1)?"s":"")+" (titulaire sous reserve)";
		
		boolean bAfficheListeNonConformes = true;
		boolean bAfficheListeRetenues = true;
		boolean bAfficheListeNonRetenues = false;
		boolean bAfficheListeAttribues = true;
		boolean bAfficheBoutonFigerClassement = true;
		boolean bAfficheBoutonLancerNego = false;
		boolean bAfficheBoutonFinaliserClassement = false;

		if(bIsClassementEnveloppesBFige) bAfficheListeNonConformes = false;
							
		if(AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure()) == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE
		|| AffaireProcedure.isForcedNegociationManagement(marche.getIdAlgoAffaireProcedure()))
		{
			if(!bIsNegociationFige)
			{
				bAfficheListeAttribues = false;
				bAfficheListeNonRetenues = true;
				bAfficheBoutonFigerClassement = false;
				if(!bIsEnAttenteDeNegociation)
					bAfficheBoutonLancerNego = true;
				bAfficheBoutonFinaliserClassement = true;
				if(!Validite.isFirstValiditeFromAffaire(lot.getIdValiditeEnveloppeBCourante(),marche.getIdMarche()))
					bAfficheListeNonConformes = false;
			
				vNonRetenues = EnveloppeB.getAllEnveloppesBConformesAndNonRetenuesFromLotAndValidite(lot.getIdMarcheLot(),lot.getIdValiditeEnveloppeBCourante());
			
				sTitreListeRetenues = "Offres séléctionnées (avec rang de classement)";
				if(bIsContainsEnveloppeCManagement)
					sTitreListeRetenues = "Lauréats (avec rang de classement)";
				sTitreListeNonConformes = "Offres non conformes";
				sTitreListeNonRetenues = "Offres non retenues";
			}
			else
			{
				bAfficheListeAttribues = true;
				bAfficheListeNonRetenues = false;
				bAfficheBoutonFigerClassement = true;
				bAfficheBoutonLancerNego = false;
				bAfficheBoutonFinaliserClassement = false;
				bAfficheListeNonConformes = false;
			}
		}
		if(bIsContainsEnveloppeCManagement)
			bAfficheListeNonConformes = false;
	%>
		<div class="tabSubtitle">
			<div style="float:left">Classement des offres<%= !bIsClassementEnveloppesBFige?InfosBulles.getModal(InfosBullesConstant.DRAG_n_DROP,rootPath):"" %></div>
			<div style="float:right"><%=(bIsClassementEnveloppesBFige)?"Classement fig&eacute;":""	%></div>
			<div style="clear:both"></div>
		</div>
		<%
		if(!bIsClassementEnveloppesBFige)
		{
		%>
		<div class="mention_altColor">
		Attention!<br />
		Cliquer sur le bouton "Enregistrer le classement" revient &agrave; enregistrer le classement des offres et &agrave; le conserver.<br />
		<%if(bAfficheBoutonFigerClassement){ %>Cliquer sur le bouton "Figer les statuts" revient &agrave; confirmer d&eacute;finitivement le classement des offres.<br /><%}%>
		<%if(bAfficheBoutonLancerNego){ %>Cliquer sur le bouton "Lancer une phase de n&eacute;gociation" revient &agrave; inviter les candidats "s&eacute;lectionn&eacute;s" à envoyer une nouvelle offre allant dans le sens que vous leur indiquerez.<br /><%}%>
		<%if(bAfficheBoutonFinaliserClassement){ %>Cliquer sur le bouton "Finaliser le classement" revient &agrave; poursuivre la proc&eacute;dure pour passer &agrave; l&rsquo;&eacute;tape de classement d&eacute;finitif puis d&rsquo;attribution du <%= sLibelleOnglet %>.<br /><%}%>
		</div>
		<%
		}
		%>
		
		<%@ include file="/include/mail.jspf" %>
		<%@ include file="paveTable/listB.jspf" %>
		<%@ include file="paveTable/listScriptB.jspf" %>
		
		<div class="tabFooter">
		<%@ include file="paveTable/listButtonB.jspf" %>
	<%
	} 

	if(bIsEnAttenteDeNegociation)
	{
	%>
		<button style="width:240px" type="button" 
		onclick="if (checkLancerNegociation()) openModal('<%= 
			response.encodeURL(rootPath 
			+ "desk/marche/algorithme/proposition/gestion/envoyerMailInvitationOffreForm.jsp?bNegociation=true&amp;iIdNextPhaseEtapes="
			+ iIdNextPhaseEtapes
			+ "&amp;iIdAffaire=" + iIdAffaire
			+ "&amp;iIdOnglet="+iIdOnglet
			) 
			%>','Confirmer le lancement des négociations');" >Confirmer le lancement des négociations</button>
	<%
	}

	if(MarcheLot.isAllLotsAttribuesOrInfructeuxFromAffaire(iIdAffaire))
	{
	%>
		<button type="button" 
		onclick="if (checkPoursuivre()) Redirect('<%= 
			response.encodeURL(rootPath 
					+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
					+ "?sAction=next"
					+ "&amp;iPreTraitement=" + iIdNextPhaseEtapes
					+ "&amp;iIdAffaire=" + iIdAffaire) %>');">Poursuivre l'affaire</button>
	<%
	}
	%>
	</div>
	<div id="print">
	</div>
</form>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="mt.modula.servlet.DownloadZipAffaireDceServlet"%>
<%@page import="org.coin.security.SecureString"%>
</html>
