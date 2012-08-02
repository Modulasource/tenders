<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="mt.modula.affaire.param.MarcheVolumeType"%>
<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.accountancy.Currency"%>
<%@ page import="org.coin.util.*,modula.graphic.*,modula.marche.*" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Liste des offre de prestation de l'affaire réf. " + marche.getReference();
	String sURL = "afficherLotsEtEnveloppesC.jsp";
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	
	if(MarcheLot.isAllLotsFromMarcheFigesForEnveloppesC(iIdAffaire))
	{
		response.sendRedirect(response.encodeRedirectURL("afficherEnveloppesC.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes));
		return ;
	}
	
	boolean bAfficherBoutonCommentaire = true;
	boolean bAfficherBoutonContenu = true;
	
	String sUseCaseIdBoutonOuvrir = "IHM-DESK-AFF-16";
	String sUseCaseIdBoutonAttribuerStatut = "IHM-DESK-AFF-38";
	String sUseCaseIdBoutonConfirmerStatus = "IHM-DESK-AFF-17";
	
	//if( !sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAttribuerStatut)) bAfficherBoutonStatut = false;
	
	int iCompteurStatut = 0;
	int iStatut = 0;
	String sTitre = "";
	String sRedirection = "";
	int iNbCandidatures = 0;
	int iNbCandidaturesRecevables = 0;
	Vector<Candidature> vCandidatures = null;
	
	boolean bClassementEnregistre = HttpUtil.parseBoolean("bClassementEnregistre", request, false);
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

	
	Vector<Onglet> vOnglets = new Vector<Onglet>();
	for (int i = 0; i < vLots.size(); i++) 
	{
		MarcheLot oLot = vLots.get(i);
		String sUrlTarget = response.encodeURL(
				"afficherLotsEtEnveloppesC.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes
						+"&amp;iIdOnglet=" + oLot.getNumero() );
		
		String sLibelleOnglet = "";
		if(vLots.size()==1) sLibelleOnglet = "Marché";
		else sLibelleOnglet = "Lot " + oLot.getNumero();
		
		vOnglets.add( new Onglet( oLot.getNumero(), false, sLibelleOnglet, sUrlTarget ) ); 
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
	
	boolean bIsAnonyme = marche.isEnveloppesCAnonyme(false);
	String sHeadTitre = "Gestion des offres de prestation"; 
	boolean bAfficherPoursuivreProcedure = false;
	
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
<script src="<%= rootPath %>include/bascule.js"></script>
<%@ include file="/include/mail.jspf" %>
</head>
<body
<%
if(bClassementEnregistre)
{
%>
onload="alert('Classement enregistr&eacute!');"
<%
}
%>
>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<p class="mention">
La pr&eacute;sente &eacute;tape permet de visualiser le contenu des offres de prestation re&ccedil;ues et de les classer.<br />
Pour passer &agrave; l'&eacute;tape suivante, qui consiste en la notification des candidats non conformes, le classement des candidatures doit avoir &eacute;t&eacute; confirm&eacute; d&eacute;finitivement gr&acirc;ce au bouton "Figer les statuts" pour le march&eacute; ou pour tous les lots.
</p>
<div class="classeur">
	<ul class="onglet">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		try {
			onglet = vOnglets.get(i);
			%><li <%= onglet.getStyle2() %> ><a href="<%= onglet.sTargetUrl %>&amp;iIdAffaire=<%= marche.getIdMarche() %>"><%= onglet.sLibelle %></a></li><%
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
		<!-- Liste des candidatures recevables -->
		<%  
			vCandidatures = Candidature.getAllCandidaturesRecevablesFromLot(lot.getIdMarcheLot());
			sTitre = "Liste des candidatures recevables";
			iStatut = EnveloppeALot.ID_STATUS_RECEVABLE;
		%>
		<%@ include file="pave/paveCandidatureC.jspf" %>
		<% iNbCandidaturesRecevables = iNbCandidatures; %>
		<!-- /Liste des candidatures recevables -->
		<%@ include file="pave/paveStatusEnveloppesC.jspf" %>
	</div>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
