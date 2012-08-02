<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.util.treeview.*,java.text.*,modula.algorithme.*,modula.*,modula.marche.*,java.util.*, modula.candidature.*, org.coin.util.*"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Liste des candidatures de l'affaire réf. " + marche.getReference();
	int iNbCandidaturesNonRecevables = 0;
	int iNbCandidaturesRecevables = 0;
	boolean bPoursuivreProcedure = true;
	
	long lIdNextPhaseEtapesInMarche = 0;
	try{
		lIdNextPhaseEtapesInMarche 
		  = AlgorithmeModula.getNextPhaseEtapesInProcedure(
				  marche.getIdAlgoPhaseEtapes())
				.getId();
	}catch (Exception e) {}
	
	long iIdNextPhaseEtapes 
		= HttpUtil.parseInt(
				"iIdNextPhaseEtapes", 
				request,
				(int)lIdNextPhaseEtapesInMarche );
	
	boolean bIsAnonyme =marche.isEnveloppesAAnonyme(false);
	int iIdCandidature = HttpUtil.parseInt("iIdCandidature", request,-1);	
	
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	int iIdLot = vLots.firstElement().getIdMarcheLot();
	iIdLot = HttpUtil.parseInt("iIdLot", request,iIdLot);	
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	
	Vector<Candidature> vCandidaturesClassees = Candidature.getAllCandidaturesValidesFromMarcheOrderByLotClassement(iIdAffaire,iIdLot);	
	
	boolean bIsContainsEnveloppeAManagement = AffaireProcedure.isContainsEnveloppeAManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsDialogue = false;
	boolean bIsAllLotsFigesForDialogue = false; 
	if(AffaireProcedure.isDialogueComplete(marche.getIdAlgoAffaireProcedure()))
	{
		bIsDialogue = true;
		bIsAllLotsFigesForDialogue = MarcheLot.isAllLotsFromMarcheFigesForDialogue(iIdAffaire);
	}
	String sHeadTitre = "Gestion des candidatures"; 
	boolean bAfficherPoursuivreProcedure = false;
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
%>
<script src="<%= rootPath %>include/js/mt.component.js?v=<%= JavascriptVersion.MT_COMPONENT_JS %>"></script>
<script type="text/javascript">
function checkPoursuivre(url)
{
	var redirect = true;
	<%
	if(!bIsContainsEnveloppeAManagement)
	{
	%>
		redirect = confirm("Avez-vous bien ajouté tous les candidats contactés avant de poursuivre l'affaire?");
	<%
	}
	%>
	if(redirect) Redirect(url);
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br/>
<div class="mention_altColor">
<img alt="Fichier zip" style="cursor:pointer;vertical-align:middle;" src="<%= rootPath %>images/icons/32x32/zip.png" 
onclick="javascript:openModal('<%= 
		response.encodeURL(rootPath + "desk/DownloadZipAffaireEnveloppeServlet?"
			+ DownloadZipAffaireDceServlet
				.getSecureTransactionString(marche.getIdMarche(), request)) 
		%>','Fichier zip contenant toutes pièces')"/>
Téléchargez un fichier zip contenant toutes les pièces
</div>
<table class="tabDoubleEntree" cellpadding="5" width="100%" >
	<tr>
		<th style="background:#E7EEF6 url('<%= rootPath 
		%>/images/icones/tabDoubleEntree.gif') no-repeat top left;width:190px;">
			<table width="100%" >
				<tr>
					<td style="text-align:right;vertical-align;top; border:0;font-weight:bold"><%= 
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
			<th><a href="<%= response.encodeURL("afficherEnveloppesA.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire="+iIdAffaire
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
	EnveloppeALot oEnveloppeALotSelected = null;
	String sTitleSelected = "";
	for(int i=0;i<vCandidaturesClassees.size();i++)
	{
		Candidature oCandidature = vCandidaturesClassees.get(i);
		PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(oCandidature.getIdPersonnePhysique());
		Organisation organisationCDT = Organisation.getOrganisation(oCandidature.getIdOrganisation());
		EnveloppeA oEnveloppeA = EnveloppeA.getAllEnveloppeAFromCandidature(oCandidature.getIdCandidature()).firstElement();
		
		int iTargetIdCandidature = -1;
		if(iIdCandidature != oCandidature.getIdCandidature()){
			iTargetIdCandidature = oCandidature.getIdCandidature();
		}
		
		String sNomCandidature = organisationCDT.getRaisonSociale();
		if(bIsAnonyme)
			sNomCandidature = "Candidature ORG"+organisationCDT.getId();
		
	%>
	<tr>
		<th><a href="<%= response.encodeURL("afficherEnveloppesA.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire="+iIdAffaire
				+"&iIdLot="+iIdLot+"&iIdCandidature="+iTargetIdCandidature) %>"><%= sNomCandidature %></a></th>
		<%
		for(int j=0;j<vLots.size();j++)
		{
			EnveloppeALot oEnveloppeALot = EnveloppeALot.getEnveloppeALotFromEnveloppeAAndLot(oEnveloppeA.getIdEnveloppe(),vLots.get(j).getIdMarcheLot());
			if(oEnveloppeALot != null)
			{
				if(iIdCandidature == oCandidature.getIdCandidature()){
					oEnveloppeALotSelected = oEnveloppeALot;
					sTitleSelected = sNomCandidature;
				}
				
				boolean bIsRecevable = oEnveloppeALot.isRecevable(false);
				if(!bIsRecevable) iNbCandidaturesNonRecevables ++;
				else iNbCandidaturesRecevables ++;
				
				boolean bIsAdmiseDialogue = true;
				if(bIsDialogue && bIsAllLotsFigesForDialogue && bIsRecevable)
				{
					bIsAdmiseDialogue = oEnveloppeALot.isAdmisDialogue(true);
				}
				String sStatut = "";
				if(bIsRecevable)
				{
					if(oEnveloppeALot.getClassement()==0)
						sStatut = "Recevable";
					else
						sStatut = Integer.toString(oEnveloppeALot.getClassement());
					
					if(!bIsAdmiseDialogue)
						sStatut = "Non admise";
				}
				else
					sStatut = "Non recevable";
				%>
				<td><%= sStatut %></td>
				<%
			}
			else
			{
				%>
				<td>Pas de candidature</td>
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
	Vector<EnveloppeALot> vItems = new Vector<EnveloppeALot>();
	vItems.add(oEnveloppeALotSelected);
%>
<div class="center" id="candidatureDiv"></div>
<script type="text/javascript">
var candidature;
Event.observe(window, 'load', function(){
	candidature = new mt.component.Envelope("candidature", 
						$("candidatureDiv"), 
						true, 
						<%= EnveloppeALot.toJSONArrayList(vItems,response,request,bIsAnonyme,true,true)%>, 
						"<%= rootPath %>");
	candidature.setStyle("<%= rootPath %>images/icons/candidat.png",
					"<%= sTitleSelected %>",
					"list_neutral",
					"candidat_");
	candidature.render();
});
</script>
<%
}
%>
<p class="mention">
<%
if(bIsContainsEnveloppeAManagement)
{
	String sMention = "Pour poursuivre l&rsquo;affaire et passer à l&rsquo;&eacute;tape suivante, les candidats non retenus et les candidats invités à présenter un offre le cas &eacute;ch&eacute;ant doivent en &ecirc;tre inform&eacute;s gr&acirc;ce aux mails ci-dessous.";
	if(bIsDialogue && !bIsAllLotsFigesForDialogue)
	{
		sMention = "Pour poursuivre l&rsquo;affaire et passer à l&rsquo;&eacute;tape suivante, les candidats non retenus doivent en &ecirc;tre inform&eacute;s gr&acirc;ce au mail ci-dessous.<br />";
		sMention += "Les candidats recevables seront habilités à participer à la ou les phases de dialogue.";
	}	
%>
<%= sMention %><br />
Cependant, ces notifications ne remplacent pas, pour les candidats ayant envoy&eacute; leurs plis par voie papier les notifications sur support papier.
<%
}
else
{
%>
Vous pouvez maintenant ajouter les candidats contact&eacute;s de votre carnet d'adresse via l'interface disponible dans ce dernier.<br/>
Les candidats invités à présenter un offre peuvent en &ecirc;tre inform&eacute;s gr&acirc;ce au mail ci-dessous.<br />
Cependant, ces notifications ne remplacent pas les notifications sur support papier.
<%
}
%>
</p>


<div style="text-align:center">
<%

	boolean bDisplayButtonSendMailCandidatsNonRecevables = false;  
	boolean bDisplayButtonSendMailCandidatsRecevables = false;

    boolean bIsCandidatsNonRecevablesNotifies = marche.isCandidatsNonRecevablesNotifies(false);
	if(iNbCandidaturesNonRecevables > 0 
	&& !bIsCandidatsNonRecevablesNotifies  )
	{
        bPoursuivreProcedure = false;
		bDisplayButtonSendMailCandidatsNonRecevables = true;
	}
	
	// pour permettre de relancer en débug n fois le mail
	if(bDisplayButtonSendMailCandidatsNonRecevables || (sessionUserHabilitation.isSuperUser() && iNbCandidaturesNonRecevables>0) )
	{
		String sAddTxt = "";
		if(!bDisplayButtonSendMailCandidatsNonRecevables){
			sAddTxt = " (Super Admin)";
		}
			
	%>
		<button type="button" name="envoi_non_rec" 
		onclick="openModal('<%= 
			response.encodeURL(rootPath+"desk/marche/algorithme/proposition/gestion/envoyerMailNonRecevableForm.jsp?iIdNextPhaseEtapes="
					+iIdNextPhaseEtapes+ "&iIdAffaire=" + iIdAffaire) 
			%>','Prévenir les candidats non recevables')" >Prévenir les candidats non recevables<%= sAddTxt %></button>&nbsp;

		<button type="button" name="non_envoi_non_rec" 
		onclick="openModal('<%= 
			response.encodeURL(rootPath+"desk/marche/algorithme/proposition/gestion/confirmNoMailForm.jsp?iIdNextPhaseEtapes="
					+iIdNextPhaseEtapes+ "&iIdAffaire=" + marche.getId()+"&sAction=nonRec") 
			%>','Confirmer ne pas vouloir prévenir les candidats non recevables')" >Confirmer ne pas vouloir prévenir les candidats non recevables<%= sAddTxt %></button><br><br>
	<%
	}
	
	boolean bIsInvitationOffreEnvoyee = marche.isMailInvitationPresenterOffreEnvoye(false);
	/**
	  * Cas des procédures autres que OUVERTE
	*/
	if(iTypeProcedure != AffaireProcedure.TYPE_PROCEDURE_OUVERTE)
	{
	    if(!bIsDialogue 
   	    || (bIsDialogue && bIsAllLotsFigesForDialogue))
   	    {
   	        if(iNbCandidaturesRecevables > 0 
   	        && !bIsInvitationOffreEnvoyee )
   	        {
   	        	bDisplayButtonSendMailCandidatsRecevables = true;
   	            bPoursuivreProcedure = false;
   	            if(!bIsContainsEnveloppeAManagement)
   	                bPoursuivreProcedure = true;
   	            
   	        
   	        }
   	    }
	      // pour permettre de relancer en débug n fois le mail
	    if(bDisplayButtonSendMailCandidatsRecevables || 
	     	(sessionUserHabilitation.isSuperUser() 
	     	&& iNbCandidaturesRecevables > 0 
	     	&& (!bIsDialogue || (bIsDialogue && bIsAllLotsFigesForDialogue))
	     	) 
	    )
	    {
	    	String sAddTxt = "";
			if(!bDisplayButtonSendMailCandidatsRecevables){
				sAddTxt = " (Super Admin)";
			}
				
	    %>
	          <button type="button" name="envoi_rec" 
	          onclick="openModal('<%= 
	              response.encodeURL(
	            		  rootPath+"desk/marche/algorithme/proposition/gestion/envoyerMailInvitationOffreForm.jsp"
	            		  + "?iIdNextPhaseEtapes=" + iIdNextPhaseEtapes
			              + "&iIdAffaire=" + iIdAffaire) 
	              %>','Prévenir les candidats recevables')" >Prévenir les candidats recevables<%= sAddTxt
	              %></button>&nbsp;&nbsp;

 			<button type="button" name="non_envoi_rec" 
	          onclick="openModal('<%= 
	              response.encodeURL(
	            		  rootPath+"desk/marche/algorithme/proposition/gestion/confirmNoMailForm.jsp"
	            		  + "?iIdNextPhaseEtapes=" + iIdNextPhaseEtapes
			              + "&iIdAffaire=" + iIdAffaire
			              + "&sAction=rec") 
	              %>','Confirmer ne pas vouloir prévenir les candidats recevables')" >Confirmer ne pas vouloir prévenir les candidats recevables<%= sAddTxt
	              %></button><br><br>
	    <%
	    }
	    	
	}
	
	//FIXME ? ca sort d'ou ?
	//if(bIsContainsEnveloppeAManagement&&bIsCandidatsNonRecevablesNotifies)bPoursuivreProcedure=true;
	
	if(bPoursuivreProcedure)
	{
		if(iNbCandidaturesNonRecevables == 0){
			if(bIsContainsEnveloppeAManagement) iIdNextPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdNextPhaseEtapes).getId();
			
			marche.setCandidatsNonRecevablesNotifies(true);
			marche.store();
		}
		if(iNbCandidaturesRecevables == 0){
			if(bIsContainsEnveloppeAManagement) iIdNextPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdNextPhaseEtapes).getId();
			
			marche.setMailInvitationPresenterOffreEnvoye(true);
			marche.store();
		}
		if(!bIsContainsEnveloppeAManagement && !bIsInvitationOffreEnvoyee){
			iIdNextPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdNextPhaseEtapes).getId();
		}
			
		
		String sNextURL = response.encodeURL(rootPath 
				+ "desk/marche/algorithme/proposition/gestion/modifierPlanningReceptionOffresForm.jsp"
				+ "?iIdNextPhaseEtapes=" +iIdNextPhaseEtapes
				+ "&iIdAffaire=" + iIdAffaire) ;
		
		if(iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_OUVERTE){
			sNextURL = response.encodeURL(rootPath 
					+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
					+ "?sAction=next"
					+ "&iPreTraitement=" +iIdNextPhaseEtapes 
					+ "&iIdAffaire=" + iIdAffaire );
		}
			
	%>
		<button type="button" 
			name="poursuivre"  
			class="disableOnClick"
			onclick="checkPoursuivre('<%= sNextURL %>');" >Poursuivre la procédure</button>&nbsp;
	<%
	}
%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="mt.modula.servlet.DownloadZipAffaireDceServlet"%>
</html>