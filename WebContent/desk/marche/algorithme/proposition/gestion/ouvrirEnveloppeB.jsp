<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.algorithme.*,org.coin.security.*,modula.graphic.*,org.coin.util.*,modula.*,modula.marche.*, org.coin.fr.bean.*, modula.candidature.*, java.util.* " %>
<%@page import="modula.TypeObjetModula"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%

	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
    int iIdAffaire = lot.getIdMarche();
    Marche marche = Marche.getMarche(lot.getIdMarche());
	
	
	int iIdCandidature = Integer.parseInt(request.getParameter("iIdCandidature"));
	Candidature candidature = Candidature.getCandidature(iIdCandidature);
	Organisation organisationCDT = Organisation.getOrganisation(candidature.getIdOrganisation());
	boolean bIsContainsEnveloppeCManagement = AffaireProcedure.isContainsEnveloppeCManagement(marche.getIdAlgoAffaireProcedure());
	boolean bIsCandidaturePapier = candidature.isCandidaturePapier(false);
	String sTitle = "Ouverture de l'offre pour le lot "+ lot.getNumero() +" de : "+organisationCDT.getRaisonSociale();
	boolean bIsAnonyme = marche.isEnveloppesBAnonyme(false);
	
	if(bIsAnonyme)
		sTitle = "Ouverture de l'offre pour le lot "+ lot.getNumero() +" de : Candidature ORG"+organisationCDT.getId();
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);

	
	String sVaultPath = "";
	try
	{
		sVaultPath = MarcheParametre.getMarcheParametreValue(iIdAffaire,"vault.path");
	}
	catch(Exception e){}
	String sFileSeparator = System.getProperty("file.separator");
	
	boolean bExistVirus = false;
%>
<script type="text/javascript" src="<%= rootPath %>include/verification.js"></script>
<script type="text/javascript" >
function checkForm()
{
	var form = document.formulaire;
	
	if (!checkStatut(form))
		return false;
	
	return true;
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%
if(!bIsCandidaturePapier)
{
	Vector<Validite> vValiditeB = Validite.getAllValiditeEnveloppeBFromAffaire(iIdAffaire);
	for(int i=0;i<vValiditeB.size();i++)
	{
		Validite oValidite = vValiditeB.get(i);
		Vector<EnveloppeB> vEnveloppes = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(candidature.getIdCandidature(), iIdLot,oValidite.getIdValidite());
		Vector<EnveloppeC> vEnveloppesC = EnveloppeC.getAllEnveloppeCFromCandidatureAndLotAndValidite(candidature.getIdCandidature(), iIdLot,oValidite.getIdValidite());

		String sPeriode ="";
		if(vValiditeB.size()>1)
			sPeriode = "pour la "+Outils.sConverionEntierLiterralFeminin[i]+" récéption des offres";
		
		if(vEnveloppesC != null && bIsContainsEnveloppeCManagement)
		{
%>
<%

	/* Traitement des enveloppes C */
	for (int j = 0; j < vEnveloppesC.size(); j++)
	{
		/* Récupération de l'objet Enveloppe C */
		EnveloppeC eEnveloppeC = vEnveloppesC.get(j);
		
		boolean bIsCachetee = eEnveloppeC.isCachetee(false);
		
		if(bIsCachetee)
		{
%>
<table class="pave"  >
	<tr>
		<td class="pave_titre_gauche">
		Liste des pièces de prestation fournies <%= sPeriode %>
		</td>
	</tr>
	<tr>
		<td>
			<table class="liste" >
				<tr>
					<th>Nom du document</th>
					<th style="text-align:right">Téléchargement</th>
				</tr>
<%
		/* Récupération des pièces jointes de l'enveloppe C courante */
		Vector<EnveloppeCPieceJointe> vPiecesJointes = 
			EnveloppeCPieceJointe.getAllEnveloppeCPiecesJointesBeforeDateClotureFromEnveloppe(eEnveloppeC.getIdEnveloppe());

		Vector vPiecesJointesHorsDelais = 
			EnveloppeCPieceJointe.getAllEnveloppeCPiecesJointesHorsDelaisFromEnveloppe(eEnveloppeC.getIdEnveloppe());

		for(int k=0;k<vPiecesJointesHorsDelais.size();k++)
		{
			EnveloppeCPieceJointe envCPJHorsDelais = (EnveloppeCPieceJointe)vPiecesJointesHorsDelais.get(k);
			vPiecesJointes.add(envCPJHorsDelais);
		}
		
		
        if(vPiecesJointes.size() == 0) {
            %>
               <tr>
                   <td class="pave_titre_gauche">Attention</td>
                   <td class="pave_titre_droit"></td>
               </tr>
               <tr>
                   <td class="pave_cellule_gauche" colspan="2">Il n'y a aucune pièce dans l'enveloppe !!</td>
                   
               </tr>
            <%
        }
		
		/* Traitement des pièces jointes de l'enveloppe A courante */
		for (int l = 0; l < vPiecesJointes.size(); l++)
		{
			/* Récupération de l'objet EnveloppeBPieceJointe courant */
			EnveloppeCPieceJointe pieceJointeC = vPiecesJointes.get(l);

			boolean bIsDecacheteLocalement = pieceJointeC.isDecacheteLocal(false);
			boolean bIsVirus = pieceJointeC.isVirus(false);
			
			String sURLFile = "desk/DownloadFileDesk?"
					+ DownloadFile.getSecureTransactionStringFullJspPage(
							request, 
							pieceJointeC.getIdEnveloppePieceJointe() , 
							TypeObjetModula.ENVELOPPE_C );
			
			sURLFile = response.encodeURL(rootPath+ sURLFile);
			String sIconFile = rootPath + Icone.ICONE_DOWNLOAD;
			
			String sNomPJ = pieceJointeC.getNomPieceJointe();
			
			Quarantaine virus = null;
			if(bIsVirus)
			{
				bExistVirus = true;
				try{virus = Quarantaine.getAllQuarantaineFromTypeAndReferenceObjet(org.coin.bean.ObjectType.ENVELOPPE_C_PJ,pieceJointeC.getIdEnveloppePieceJointe()).firstElement();}
				catch(Exception e){}
				
				sNomPJ = "<font class=\"rouge\">" + pieceJointeC.getNomPieceJointe() + " vérolé : "+ClamAV.getVirusFromReport(virus.getRapport())+" *</font>";
				sURLFile = response.encodeURL(rootPath+ "desk/DownloadFileDesk?"
						+ DownloadFile.getSecureTransactionStringFullJspPage(
								request, 
								virus.getId() , 
								TypeObjetModula.QUARANTAINE ));
				
				sIconFile = rootPath + Icone.ICONE_DOWNLOAD_VIRUS;
				
				String sURLRapportFile = response.encodeURL(rootPath+ "desk/DownloadFileDesk?"
						+ DownloadFile.getSecureTransactionStringFullJspPage(
								request, 
								virus.getId() , 
								TypeObjetModula.QUARANTAINE_RAPPORT ));
				
				String sIconRapportFile = rootPath + Icone.ICONE_FICHIER_DEFAULT;
				
				sNomPJ += "&nbsp;&nbsp;<a href=\""+sURLRapportFile+"\">";
				sNomPJ += "<img src=\""+sIconRapportFile+"\"  title=\"Rapport\" alt=\"Rapport\" />";
				sNomPJ += "</a>";
			}
%>
				<tr>
					<td> 
					<%= sNomPJ %>
					</td>
					<td style="text-align:right">
					<%
					if(bIsDecacheteLocalement && !bIsVirus)
					{
						String sFilePath = sVaultPath+sFileSeparator+"mdemat"+iIdAffaire+sFileSeparator
						+eEnveloppeC.getIdCandidature()+sFileSeparator+"C"+eEnveloppeC.getIdEnveloppe()
						+sFileSeparator+pieceJointeC.getIdEnveloppePieceJointe()+"_"+pieceJointeC.getNomPieceJointe();
					%>
					<applet code="org.coin.applet.OpenLocalFile.class" width="70" height="20" 
		  			archive="<%= rootPath + "include/jar/SOpenLocalFile.jar" %>">
		  			<param name="sFilePath" value="<%= sFilePath %>" />
					</applet>
					<%
					}
					%>
					<a href="<%= sURLFile %>">
						<img src="<%= sIconFile %>"  title="Télécharger" alt="Télécharger" />
					</a>
					</td>
				</tr>
<%
		}
%>
			</table>
		</td>
	</tr>
</table>
<%
	if(!eEnveloppeC.getCommentaire().equalsIgnoreCase(""))
	{
	%>
	<br />
	<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">
		Commentaire de l'offre de prestation <%= sPeriode %>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" style="text-align:left;"><%= eEnveloppeC.getCommentaire() %></strong></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<%
	}
		}
		
	}
%>
<br />
<%
}
		
if(vEnveloppes != null )
{
	/* Traitement des enveloppes B */
	for (int j = 0; j < vEnveloppes.size(); j++)
	{
		/* Récupération de l'objet Enveloppe B */
		EnveloppeB eEnveloppe = vEnveloppes.get(j);
		boolean bIsCachetee = eEnveloppe.isCachetee(false);
		
		if(bIsCachetee)
		{
			
			String sTypeOffre = "";
			if(Validite.isFirstValiditeFromAffaire(eEnveloppe.getIdValidite(),iIdAffaire)
			&& bIsContainsEnveloppeCManagement)
				sTypeOffre = " de prix";
%>

<table class="pave" >
	<tr>
		<td class="pave_titre_gauche">
		Liste des pièces<%= sTypeOffre %> fournies <%= sPeriode %>
		</td>
	</tr>
	<tr>
		<td>
			<table class="liste" >
				<tr>
					<th>Nom du document</th>
					<th style="text-align:right">T&eacute;l&eacute;chargement</th>
				</tr>
<%
		/* Récupération des pièces jointes de l'enveloppe B courante */
		Vector<EnveloppeBPieceJointe> vPiecesJointes = 
			EnveloppeBPieceJointe.getAllEnveloppeBPiecesJointesBeforeDateClotureFromEnveloppe(
					eEnveloppe.getIdEnveloppe());

		Vector vPiecesJointesHorsDelais = 
			EnveloppeBPieceJointe.getAllEnveloppeBPiecesJointesHorsDelaisFromEnveloppe(eEnveloppe.getIdEnveloppe());

		for(int k=0;k<vPiecesJointesHorsDelais.size();k++)
		{
			EnveloppeBPieceJointe envBPJHorsDelais = (EnveloppeBPieceJointe)vPiecesJointesHorsDelais.get(k);
			vPiecesJointes.add(envBPJHorsDelais);
		}
		/* Traitement des pièces jointes de l'enveloppe A courante */
		for (int l = 0; l < vPiecesJointes.size(); l++)
		{
			/* Récupération de l'objet EnveloppeBPieceJointe courant */
			EnveloppeBPieceJointe pieceJointe = vPiecesJointes.get(l);
			
			boolean bIsDecacheteLocalement = pieceJointe.isDecacheteLocal(false);
			boolean bIsVirus = pieceJointe.isVirus(false);
			
			String sURLFile = "desk/DownloadFileDesk?"
					+ DownloadFile.getSecureTransactionStringFullJspPage(
							request, 
							pieceJointe.getIdEnveloppePieceJointe()  , 
							TypeObjetModula.ENVELOPPE_B );
			
			sURLFile = response.encodeURL(rootPath+ sURLFile);
			String sIconFile = rootPath + Icone.ICONE_DOWNLOAD;
			
			String sNomPJ = pieceJointe.getNomPieceJointe();
			
			Quarantaine virus = null;
			if(bIsVirus)
			{
				bExistVirus = true;
				try{virus = Quarantaine.getAllQuarantaineFromTypeAndReferenceObjet(org.coin.bean.ObjectType.ENVELOPPE_B_PJ,pieceJointe.getIdEnveloppePieceJointe()).firstElement();}
				catch(Exception e){}
				
				sNomPJ = "<font class=\"rouge\">" + pieceJointe.getNomPieceJointe() + " vérolé : "+ClamAV.getVirusFromReport(virus.getRapport())+" *</font>";
				sURLFile = response.encodeURL(rootPath+ "desk/DownloadFileDesk?"
						+ DownloadFile.getSecureTransactionStringFullJspPage(
								request, 
								virus.getId(), 
								TypeObjetModula.QUARANTAINE ));
				sIconFile = rootPath + Icone.ICONE_DOWNLOAD_VIRUS;
				
				String sURLRapportFile = response.encodeURL(
						rootPath+ "desk/DownloadFileDesk?" 
							+ DownloadFile.getSecureTransactionStringFullJspPage(
								request, 
								virus.getId(), 
								TypeObjetModula.QUARANTAINE_RAPPORT ));
				
				String sIconRapportFile = rootPath + Icone.ICONE_FICHIER_DEFAULT;
				
				sNomPJ += "&nbsp;&nbsp;<a href=\""+sURLRapportFile+"\">";
				sNomPJ += "<img src=\""+sIconRapportFile+"\"  title=\"Rapport\" alt=\"Rapport\" />";
				sNomPJ += "</a>";
			}
%>
				<tr>
					<td> 
					<%= sNomPJ %>
					</td>
					<td style="text-align:right">
					<%
					if(bIsDecacheteLocalement && !bIsVirus)
					{
						String sFilePath = sVaultPath+sFileSeparator+"mdemat"+iIdAffaire
						+sFileSeparator+eEnveloppe.getIdCandidature()+sFileSeparator
						+"B"+eEnveloppe.getIdEnveloppe()+sFileSeparator+pieceJointe.getIdEnveloppePieceJointe()
						+"_"+pieceJointe.getNomPieceJointe();
					%>
					<applet code="org.coin.applet.OpenLocalFile.class" width="70" height="20" 
		  			archive="<%= rootPath + "include/jar/SOpenLocalFile.jar" %>">
		  			<param name="sFilePath" value="<%= sFilePath %>" />
					</applet>
					<%
					}
					%>
					<a href="<%= sURLFile %>">
						<img src="<%= sIconFile %>"  title="Télécharger" alt="Télécharger" />
					</a>
					</td>
				</tr>
<%
		}
%>
			</table>
		</td>
	</tr>
</table>
<%
	if(!eEnveloppe.getCommentaire().equalsIgnoreCase(""))
	{
	%>
	<br />
	<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">
		Commentaire <%= sPeriode %>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" style="text-align:left;"><%= eEnveloppe.getCommentaire() %></strong></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<%
	}
		
	}
	}
%>
<br />
<%
}
}
}
else
{
%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">
		Candidature <%= (bIsAnonyme?"ORG"+organisationCDT.getId():"de l'organisation "
				+organisationCDT.getRaisonSociale()) %>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2"><strong>Information : </strong>Cette candidature a été constituée au format papier. 
		Veuillez consulter le dossier référence <strong>CDT<%= candidature.getIdCandidature() %>.</strong></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<br />
<%
}

String sURLRedirect = response.encodeURL(rootPath +"desk/marche/algorithme/proposition/gestion/afficherLotsEtEnveloppesB.jsp"
		+ "?iIdOnglet=" + lot.getNumero()
		+ "&iIdAffaire="+marche.getIdMarche()
		+ "&iIdLot="+iIdLot
        + "&iIdNextPhaseEtapes="+ iIdNextPhaseEtapes );

%>
<div style="text-align:center">
	<button type="button" name="valider" 
		onclick="closeModalAndRedirectTabActive('<%= sURLRedirect %>')" >Fermer la fenêtre</button>
</div>
<%
if(bExistVirus){
%>
<br/>
<div class="rouge" style="text-align:left;">
* : <b>AVERTISSEMENT SECURITE</b> 
Attention ! Si vous téléchargez un fichier considéré par l'antivirus ClamAV comme vérolé, 
vous risquez de contaminer votre ordinateur. L'ouverture de ce fichier est à vos risques et périls. Matamore décline toute responsabilité quand aux conséquences qui pourraient s'en suivre.
</div>
<%
}
%>
<br />
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>