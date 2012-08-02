<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.util.treeview.*,java.text.*,modula.algorithme.*,modula.*,modula.marche.*,java.util.*, modula.candidature.*, org.coin.util.*"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Liste des offres de prestation de l'affaire réf. " + marche.getReference();
	String sURL = "afficherEnveloppesC.jsp";
	
	int iNbCandidaturesNonRetenues = 0;
	int iNbCandidaturesRetenues = 0;
	boolean bPoursuivreProcedure = true;
	
	long iIdNextPhaseEtapes 
		= HttpUtil.parseInt(
			"iIdNextPhaseEtapes", 
			request,
			(int)AlgorithmeModula.getNextPhaseEtapesInProcedure(marche.getIdAlgoPhaseEtapes()).getId());

	
	boolean bIsAnonyme = marche.isEnveloppesCAnonyme(false);
	int iIdCandidature = HttpUtil.parseInt("iIdCandidature", request,-1);	
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	int iIdLot = vLots.firstElement().getIdMarcheLot();
	iIdLot = HttpUtil.parseInt("iIdLot ", request,iIdLot );	
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	
	Vector<Candidature> vCandidaturesClassees = Candidature.getAllCandidaturesRecevablesFromMarcheOrderByLotClassement(iIdAffaire,iIdLot);	
	boolean bIsCandidatsNonConformesNotifies = true;
	String sHeadTitre = "Gestion des offres de prestation"; 
	boolean bAfficherPoursuivreProcedure = false;
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<table class="tabDoubleEntree" cellpadding="5" width="100%">
	<tr>
		<th style="background:transparent url('<%= rootPath %>/images/icones/tabDoubleEntree.gif') no-repeat top left;width:190px;">
			<table width="100%" >
				<tr>
					<td style="text-align:right;vertical-align;top;border:0;font-weight:bold"><%= 
						(vLots.size()>1)?"Lots":"Marché" %></td>
				</tr>
				<tr>
					<td style="text-align:left;border:0;font-weight:bold">&nbsp;Organismes</td>
				</tr>
			</table>
		</th>
		<%
		if(vLots.size()>1)
		{
			for(int i=0;i<vLots.size();i++)
			{
			%>
			<th><a href="<%= response.encodeURL("afficherEnveloppesC.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes
					+"&iIdLot="+vLots.get(i).getIdMarcheLot()) %>">Lot <%= vLots.get(i).getNumero() %></a></th>
			<%
			}
		}
		else
		{
		%>
			<th><a href="#">Marché</a></th>
		<%
		}
		%>
	</tr>
	<%
	for(int i=0;i<vCandidaturesClassees.size();i++)
	{
		Candidature oCandidature = vCandidaturesClassees.get(i);
		PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(oCandidature.getIdPersonnePhysique());
		Organisation organisationCDT = Organisation.getOrganisation(oCandidature.getIdOrganisation());

		int iTargetIdCandidature = -1;
		if(iIdCandidature != oCandidature.getIdCandidature()) iTargetIdCandidature = oCandidature.getIdCandidature();
		
		String sNomCandidature = organisationCDT.getRaisonSociale();
		if(bIsAnonyme)
			sNomCandidature = "Candidature ORG"+organisationCDT.getId();
	%>
	<tr>
		<th><a href="<%= response.encodeURL("afficherEnveloppesC.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdLot="+iIdLot+"&iIdCandidature="+iTargetIdCandidature) %>"><%= sNomCandidature %></a></th>
		<%
		for(int j=0;j<vLots.size();j++)
		{
			EnveloppeC oEnveloppeC = null;
			try
			{
				oEnveloppeC = EnveloppeC.getAllEnveloppesCFromCandidatureAndLot(oCandidature.getIdCandidature(),vLots.get(j).getIdMarcheLot()).firstElement();
			}
			catch(Exception e){}
			
			if(oEnveloppeC != null)
			{
				boolean bIsRetenue = oEnveloppeC.isRetenue(false);
				
				if(!bIsRetenue) 
				{
					iNbCandidaturesNonRetenues ++;

					if(!oEnveloppeC.isNotifieNonConforme(false)) bIsCandidatsNonConformesNotifies = false;
				}
				else iNbCandidaturesRetenues++;
				
				String sStatut = "";
				if(bIsRetenue)
				{
					if(oEnveloppeC.getClassement()==0)
						sStatut = "Retenue";
					else
						sStatut = Integer.toString(oEnveloppeC.getClassement());
				}
				else
					sStatut = "Non conforme";
				%>
				<td><%= sStatut %></td>
				<%
			}
			else
			{
				%>
				<td>Pas d'offre</td>
				<%
			}
		}
		%>
	</tr>
	<%
	}
	%>
</table>
<br />
<%
if(iIdCandidature != -1)
{
%>
<br />
<%  
	Vector<Candidature> vCandidatures = new Vector<Candidature>();
	vCandidatures.add(Candidature.getCandidature(iIdCandidature));
	String sTitre = "Candidature de "+Organisation.getOrganisation(vCandidatures.firstElement().getIdOrganisation()).getRaisonSociale();
	if(bIsAnonyme)
		sTitre = "Candidature ORG"+vCandidatures.firstElement().getIdOrganisation();
	int iStatut = EnveloppeC.ID_STATUS_RETENUE;
	int iNbCandidatures = 0;
	int iCompteurStatut = 0;
	boolean bAfficherBoutonContenu = true;
	boolean bAfficherBoutonCommentaire = true;
%>
<%@ include file="pave/paveOffreC.jspf" %>
<%
}
%>
<p class="mention">
Pour poursuivre l&rsquo;affaire et passer à l&rsquo;&eacute;tape suivante, les candidats non conformes doivent en &ecirc;tre inform&eacute;s gr&acirc;ce aux mails ci-dessous.
<br />
Cependant, ces notifications ne remplacent pas, pour les candidats ayant envoy&eacute; leurs plis par voie papier les notifications sur support papier.
</p>
<div style="text-align:center">
<%
	if(iNbCandidaturesNonRetenues > 0 && !bIsCandidatsNonConformesNotifies)
	{
		bPoursuivreProcedure = false;
		String sURLRejetOffreConformite = response.encodeURL("envoyerMailForm.jsp?iMailType=" + ((vLots.size() > 1)?MailConstant.MAIL_CDT_REJET_OFFRE_CONFORMITE_SEPARE:MailConstant.MAIL_CDT_REJET_OFFRE_CONFORMITE_UNIQUE) +"&amp;iIdLot="+ lot.getIdMarcheLot() + "&amp;iIdNextPhaseEtapes="+ iIdNextPhaseEtapes+"&amp;iIdAffaire="+iIdAffaire+"&amp;sRedirectURL="+sURL);
	%>
		<button type="button" name="envoi" 
		onclick="OuvrirPopup('<%=sURLRejetOffreConformite
		%>',700,580,'menubar=no,scrollbars=yes,statusbar=no');" >Prévenir les candidats non conformes</button>&nbsp;
	<%
	}
	if(bPoursuivreProcedure)
	{
			iIdNextPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdNextPhaseEtapes).getId();
	%>
		<button type="button" name="poursuivre" onclick="Redirect('<%= 
			response.encodeURL(
					rootPath 
					+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
					+ "?sAction=next"
					+ "&iPreTraitement="+iIdNextPhaseEtapes
					+ "&iIdAffaire=" + marche.getId()) 
			%>');" >Poursuivre la procédure</button>&nbsp;
	<%
	}
%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>