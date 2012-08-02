<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,org.coin.fr.bean.*,modula.graphic.*,org.coin.fr.bean.mail.*,modula.candidature.*,java.util.*,modula.*, modula.marche.*,modula.algorithme.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Gestion des candidatures de l'affaire réf. " + marche.getReference();
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);

	if(MarcheLot.isAllLotsFromMarcheFigesForEnveloppesA(iIdAffaire))
	{
		response.sendRedirect(response.encodeRedirectURL(
				"afficherEnveloppesA.jsp"
				+ "?iIdNextPhaseEtapes="+iIdNextPhaseEtapes
				+ "&iIdAffaire=" + iIdAffaire));
		return ;
	}
	
	boolean bAfficherBoutonCommentaire = true;
	boolean bAfficherBoutonContenu = true;
	String sUseCaseIdBoutonAttribuerStatut = "IHM-DESK-AFF-37";
	String sUseCaseIdBoutonConfirmerStatus = "IHM-DESK-AFF-14";
	//if( !sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAttribuerStatut)) bAfficherBoutonStatut = false;
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request,0);
	
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

	
	
	String sLibelleLot = "";
	if(vLots.size()==1) sLibelleLot = "marché";
	else sLibelleLot = "Lot " + lot.getNumero();

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	for (int i = 0; i < vLots.size(); i++) 
	{
		MarcheLot oLot = vLots.get(i);
		
		String sUrlTarget = response.encodeURL(
				"afficherLotsEtEnveloppesA.jsp"
				+ "?iIdNextPhaseEtapes="+iIdNextPhaseEtapes
				+ "&amp;iIdOnglet=" + oLot.getNumero() 
				+ "&amp;iIdAffaire="+ iIdAffaire);
		
		String sLibelleOnglet = "";
		if(vLots.size()==1) sLibelleOnglet = "Marché";
		else sLibelleOnglet = "Lot " + oLot.getNumero();
		
		vOnglets.add( new Onglet(oLot.getNumero(), false, sLibelleOnglet, sUrlTarget ) ); 
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
	
	boolean bIsAnonyme = marche.isEnveloppesAAnonyme(false);
	boolean bIsClassementEnveloppesAFige = lot.isClassementEnveloppesAFige(false);

	Vector<EnveloppeALot> vRecevables = EnveloppeALot.getAllEnveloppeALotRecevablesFromLot(lot.getIdMarcheLot());
	Vector<EnveloppeALot> vNonRecevables = EnveloppeALot.getAllEnveloppeALotNonRecevablesFromLot(lot.getIdMarcheLot());
	
	Vector vDemandes = DemandeInfoComplementaire.getAllDemandeEnCoursEnveloppeAFromMarche(marche.getIdMarche());
%>
<script type="text/javascript">
var sortableEventActive = true;
function selectAction(hidden,action)
{
	return hidden.value = action;
}
function figerClassement()
{
	if(confirm("Etes vous sûr de vouloir figer les statuts du <%= sLibelleLot %> définitivement ?"))
	{
		selectAction(document.formulaire.sAction,'figer');
		return true;
	}
	return false;
}

onPageLoad = function(){
	Element.hide($("compl"));
	if(<%= vDemandes.size() %> > 0){
		Element.show($("compl"));
	}
}
function showEnvoiComp(){
	Element.show($("compl"));
}
function hideEnvoiComp(){
	Element.hide($("compl"));
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<p class="mention_altColor">
La pr&eacute;sente &eacute;tape permet de visualiser le contenu des candidatures re&ccedil;ues et de les classer.<br />
Pour passer &agrave; l'&eacute;tape suivante, qui consiste en la notification des candidats non retenus et des 
candidats invit&eacute;s &agrave; pr&eacute;senter une offre le cas &eacute;ch&eacute;ant, le classement des 
candidatures doit avoir &eacute;t&eacute; confirm&eacute; d&eacute;finitivement gr&acirc;ce au bouton "Figer les statuts" 
pour le march&eacute; ou pour tous les lots.
</p>
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
<div class="tabSubtitle">
	<div style="float:left">Classement des candidatures
		<%=	!bIsClassementEnveloppesAFige?InfosBulles.getModal(
				InfosBullesConstant.DRAG_n_DROP,rootPath,"Aide"):"" %>
	</div>
	<div style="float:right"><%=(bIsClassementEnveloppesAFige)?"Classement figé":""	%></div>
	<div style="clear:both"></div>
</div>
<%
if(!bIsClassementEnveloppesAFige)
{
%>
<div class="mention_altColor">
	Attention!<br />
	Cliquer sur le bouton "Enregistrer le classement" revient à enregistrer le classement des candidatures et 
	à le conserver.<br />
	Cliquer sur le bouton "Figer les statuts" revient à confirmer définitivement le classement des candidatures.
</div>
<%
	QuestionAnswer qaProcedureSimpleEnveloppe = null;
	
	try{
	    String sMarcheParametreProcedureSimpleEnveloppe = "";
	
	    MarcheParametre marcheParametreProcedureSimpleEnveloppe 
	       = MarcheParametre.getMarcheParametre(marche.getIdMarche(),"iIdProcedureSimpleEnveloppe");
	    sMarcheParametreProcedureSimpleEnveloppe 
	       = marcheParametreProcedureSimpleEnveloppe.getValue(); 
	       
	    qaProcedureSimpleEnveloppe 
	        = QuestionAnswer.getQuestionAnswerMemory(
	                Integer.parseInt(sMarcheParametreProcedureSimpleEnveloppe));
	    
	    
	} catch (CoinDatabaseLoadException e ) {}


    if(qaProcedureSimpleEnveloppe != null
    && qaProcedureSimpleEnveloppe.getIdAnswer() == Answer.YES)
    {
%>  
<br/>
<div class="mention_altColor" style="color:#111;border: 1px solid;">
   
<br/>
   <b> Attention, Procédure ouverte à une enveloppe : </b><br/>
   Pour passer à l'étape suivante et consulter les plis électroniques dans le
cadre des procédures à une enveloppe (AOO, MAPA 1 enveloppe, etc.) il vous faut passer
ici les candidatures à l'état "Candidatures recevables" puis figer les
statuts. Vous aurez alors accès au contenu des enveloppes électroniques et
pourrez donc définir le titulaire du marché.
<br/>
<br/>
</div>
<br/>
<%
    }
}
%>
<form action="<%= response.encodeURL("validerEnveloppesAClassement.jsp"
		+ "?nonce="+System.currentTimeMillis())
%>" method="post" name="formulaire">	
	<div class="center" id="liste_recevables_div"></div>
	<div class="center" id="liste_nonrecevables_div"></div>
	<input type="hidden" name="iIdAffaire" value="<%= iIdAffaire %>" />
	<script type="text/javascript">
	var listeRecevables,listeNonRecevables;
	var allList = new Array();
	
	Event.observe(window, 'load', function(){
		listeRecevables = new mt.component.Envelope("liste_recevables", 
							$("liste_recevables_div"), 
							true, 
							<%= EnveloppeALot.toJSONArrayList(
									vRecevables,
									response,
									request,
									bIsAnonyme,
									bAfficherBoutonContenu,
									bAfficherBoutonCommentaire)%>, 
							"<%= rootPath %>");
		listeRecevables.setStyle("<%= rootPath %>images/icons/candidat_ok.png",
						"Candidatures recevables (avec rang de classement)",
						"list_ok",
						"candidat_");
		if(<%=!bIsClassementEnveloppesAFige%>){
			listeRecevables.addContainment("liste_recevables");
			listeRecevables.addContainment("liste_nonrecevables");
		}
		listeRecevables.render();
		
		listeNonRecevables = new mt.component.Envelope("liste_nonrecevables", 
							$("liste_nonrecevables_div"), 
							false, 
							<%= EnveloppeALot.toJSONArrayList(
									vNonRecevables,
									response,
									request,
									bIsAnonyme,
									bAfficherBoutonContenu,
									bAfficherBoutonCommentaire)%>, 
							"<%= rootPath %>");
		listeNonRecevables.setStyle("<%= rootPath %>images/icons/candidat_nok.png",
						"Candidatures non recevables",
						"list_nok",
						"candidat_");	
		if(<%=!bIsClassementEnveloppesAFige%>){
			listeNonRecevables.addContainment("liste_nonrecevables");
			listeNonRecevables.addContainment("liste_recevables");
		}	
		listeNonRecevables.render();

		allList.push(listeRecevables);
		allList.push(listeNonRecevables);
		
		allList.each(function(list){
			list.createSortable();
		});
	});
	</script>
	
	<div class="tabFooter">
	<%
		String sUrlEnvoiInfosComp = "desk/marche/algorithme/ceu/envoyerDemandeInfoForm.jsp?iIdLot="+lot.getIdMarcheLot();
	%>
		<button type="button" name="compl" id="compl"
		onclick="openModal('<%= response.encodeURL(rootPath + sUrlEnvoiInfosComp) %>','Envoyer les demandes d\'informations complémentaires')">
		Envoyer les demandes d'informations complémentaires
		</button>
	<%
	if(!bIsClassementEnveloppesAFige)
	{
	%>
		<input type="hidden" name="sAction" value="" />
		<input type="hidden" name="liste_recevables_ids" id="liste_recevables_ids" value="" />
		<input type="hidden" name="liste_nonrecevables_ids" id="liste_nonrecevables_ids" value="" />
		<input type="hidden" name="iIdLot" value="<%= lot.getIdMarcheLot() %>" />
		<input type="hidden" name="iIdNextPhaseEtapes" value="<%= iIdNextPhaseEtapes %>" />
		<button type="submit" name="classement" onclick="selectAction(document.formulaire.sAction,'enregistrer');">
		Enregistrer le classement
		</button>&nbsp;
		<button type="submit" name="classement" onclick="return figerClassement();">
		Figer les statuts
		</button>
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

<%@page import="org.coin.bean.question.Answer"%>
<%@page import="org.coin.bean.question.QuestionAnswer"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%></html>
