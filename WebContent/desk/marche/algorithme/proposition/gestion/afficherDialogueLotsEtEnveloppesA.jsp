<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.graphic.*,org.coin.fr.bean.mail.*,modula.marche.*" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Liste des candidatures de l'affaire réf. " + marche.getReference();
	String sURL = "afficherDialogueLotsEtEnveloppesA.jsp";
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	if(MarcheLot.isAllLotsFromMarcheFigesForDialogue(iIdAffaire))
	{
		response.sendRedirect(response.encodeRedirectURL("afficherEnveloppesA.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire="+iIdAffaire));
		return ;
	}
	boolean bIsAnonyme = marche.isEnveloppesAAnonyme(false);
	boolean bAfficherBoutonCommentaire = true;
	boolean bAfficherBoutonContenu = true;
	//String sUseCaseIdBoutonAutoriserDialogue = "IHM-DESK-AFF-76";
	String sUseCaseIdBoutonCloreDialogue = "IHM-DESK-AFF-77";
	
	int iCompteurStatut = 0;
	int iStatut = 0;
	String sTitre = "";
	String sRedirection = "";
	int iNbCandidatures = 0;
	int iNbCandidaturesRecevables = 0;
	Vector<Candidature> vCandidatures = null;
	
	boolean bClassementEnregistre = HttpUtil.parseBoolean("bClassementEnregistre", request, false);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request,0);
	
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
	MarcheLot lot = null;
	for (int i = 0; i < vLots.size(); i++)
	{
		MarcheLot lotTemp = vLots.get(i);
		if(lotTemp.getNumero() == (iIdOnglet+1) )
			lot = lotTemp ;
	}
	
	MarcheLotDetail marcheLotDetail = null;
	try {
		marcheLotDetail = MarcheLotDetail.getMarcheLotDetailFormIdMarcheLot(lot.getId());
	} catch (Exception e) {
		marcheLotDetail = new MarcheLotDetail();
	}
	
	Currency currency = null;
	try {
		currency = Currency.getCurrency(marcheLotDetail.getIdCurrencyCoutEstime());
	} catch (Exception e) {
		currency = new Currency ("EUR");
	}

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	for (int i = 0; i < vLots.size(); i++) 
	{
		MarcheLot oLot = vLots.get(i);
		
		String sUrlTarget = response.encodeURL(
				sURL+"?iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&amp;iIdAffaire="+iIdAffaire
				+"&amp;iIdOnglet=" + i);
		
		String sLibelleOnglet = "";
		if(vLots.size()==1) sLibelleOnglet = "Marché";
		else sLibelleOnglet = "Lot " + oLot.getNumero();
		
		vOnglets.add( new Onglet(i, false, sLibelleOnglet, sUrlTarget ) ); 
	}

	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	
	/**
     * MarcheVolumeType
     */ 
    MarcheVolumeType marcheVolumeType = null;
    try{
        MarcheVolume marcheVolume = MarcheVolume.getMarcheVolumeFromIdMarche(marche.getId());
        marcheVolumeType = MarcheVolumeType.getMarcheVolumeTypeMemory(marcheVolume.getIdMarcheVolumeType());
    } catch (CoinDatabaseLoadException e){
        marcheVolumeType = new MarcheVolumeType();
    }

%>
<%@ include file="/desk/include/typeForm.jspf" %>
<%@page import="org.coin.bean.accountancy.Currency"%><script src="<%= rootPath %>include/bascule.js"></script>
</head>
<body
<%
	String sHeadTitre = "Gestion des dialogues"; 
	boolean bAfficherPoursuivreProcedure = false;
	if(bClassementEnregistre)
	{
%>
onload="alert('Classement enregistr&eacute!');"
<%
	}
%>
>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="../../../../../include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<p class="mention">
La pr&eacute;sente &eacute;tape sert à s&eacute;lectionner les candidats admis &agrave; participer &agrave; la phase de dialogue.
<br />
Pour la premi&egrave;re phase de dialogue, les candidats consid&eacute;r&eacute;s comme recevables doivent tous être consid&eacute;r&eacute;s comme « Admis à dialoguer ».
<br />
Lancer le dialogue permet de passer à l'&eacute;tape suivante et de pr&eacute;venir les candidats du nouveau statut de leur dossier.
<br />
Pour passer &agrave; l'&eacute;tape suivante, qui consiste en la notification des candidats invit&eacute;s &agrave; pr&eacute;senter une offre, la clôture des dialogues doit avoir &eacute;t&eacute; confirm&eacute; d&eacute;finitivement gr&acirc;ce au bouton "Indéfinir le dialogue" pour le march&eacute; ou pour tous les lots.
</p>
<div class="classeur">
	<ul class="onglet">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		try {
			onglet = vOnglets.get(i);
			%><li <%= onglet.getStyle2() %> ><a href="<%= onglet.sTargetUrl %>"><%= onglet.sLibelle %></a></li><%
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
	</ul>
	<div class="corps">
		<div <%= Onglet.sEnddingTabStyle2 %> />
		<br />						
		<%
			String sFormPrefix = "";
			if(vOnglets.size()==1) 
			{
				String sPaveObjetMarcheTitre = "Description de l'affaire ref."+marche.getReference();
				%><%@ include file="../../affaire/pave/paveObjet.jspf" %><%
			}
			else 
			{
				String sPaveDefinitionLotsTitre = "Description du lot " + lot.getNumero();
				%><%@ include file="../../affaire/pave/paveCreationLots.jspf" %><%
			}
		%>
		<br />
		<%  
			vCandidatures = Candidature.getAllCandidaturesRecevablesFromLot(lot.getIdMarcheLot());
			sTitre = "Liste des candidatures recevables";
			iStatut = EnveloppeALot.ID_STATUS_ADMIS_DIALOGUE;
		%>
		<%@ include file="pave/paveCandidature.jspf" %>
		<% iNbCandidaturesRecevables = iNbCandidatures; %>
		<%@ include file="pave/paveDialogueEnveloppesA.jspf" %>
	</div>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>

<%@page import="mt.modula.affaire.param.MarcheVolumeType"%>
<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%></html>