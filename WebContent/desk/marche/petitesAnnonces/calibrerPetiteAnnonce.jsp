
<%@ page import="modula.ws.spqr.ExportXml.*,modula.ws.spqr.*,modula.ws.boamp.*,java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*,modula.candidature.*,org.coin.util.*" %>
<%@ page import="java.io.*,java.util.*,modula.*, modula.marche.*,org.coin.bean.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Organisation organisation = Organisation.getOrganisation(PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()).getIdOrganisation());
	Marche marche = Marche.getMarche(iIdAffaire);
	Vector<Export> vExports = new Vector<Export>();
	vExports = Export.getAllExportFromSourceAndDestination(marche.getIdMarche(),ObjectType.AFFAIRE,organisation.getIdOrganisation(),ObjectType.ORGANISATION);
	boolean bIsAAPC = false;
	boolean bIsAATR = false;
	try{
		bIsAAPC = marche.isAffaireAAPC();
	}catch(Exception e){}
	
	try{
		bIsAATR = marche.isAffaireAATR();
	}catch(Exception e){}
	
	if (vExports.size()>0){
		Export export = vExports.firstElement();
		PublicationPublissimo publication = new PublicationPublissimo();
		publication.setIdTypeObjet(ObjectType.AFFAIRE);
		publication.setIdReferenceObjet(marche.getIdMarche());
		publication.setIdExport(export.getIdExport());
		publication.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
		publication.setDateEnvoiEffective(new Timestamp(System.currentTimeMillis()));
		publication.setIdPublicationEtat(PublicationEtat.ETAT_ENVOI_ACCEPTE);
		publication.setTitrePDF("");
		publication.setTetePDF("");
		publication.setCorpsPDF(marche.getPetiteAnnonceTexteLibre());
		if(bIsAAPC) publication.setTitrePDF(org.coin.fr.bean.export.PublicationType.getPublicationTypeName(PublicationType.TYPE_AAPC));
		if(bIsAATR) publication.setTitrePDF(org.coin.fr.bean.export.PublicationType.getPublicationTypeName(PublicationType.TYPE_AATR));
		publication.create();
		publication.publish(organisation.getIdOrganisation(),marche.getIdMarche(),PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()),request);
	}
	else{
		Export exportAFF = new Export();
		exportAFF.setName("Transfert vers "+organisation.getRaisonSociale());
		exportAFF.setDateCreation(new Timestamp(System.currentTimeMillis()));
		exportAFF.setIdTypeObjetSource(ObjectType.AFFAIRE);
		exportAFF.setIdTypeObjetDestination(ObjectType.ORGANISATION);
		exportAFF.setIdObjetReferenceSource(marche.getIdMarche());
		exportAFF.setIdObjetReferenceDestination(organisation.getIdOrganisation());
		exportAFF.setIdExportSens(Export.SENS_EXPORT);
		exportAFF.create();

		PublicationPublissimo publication = new PublicationPublissimo();
		publication.setIdTypeObjet(ObjectType.AFFAIRE);
		publication.setIdReferenceObjet(marche.getIdMarche());
		publication.setIdExport(exportAFF.getIdExport());
		publication.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
		publication.setCorpsPDF(marche.getPetiteAnnonceTexteLibre());
		publication.setTitrePDF("");
		publication.setTetePDF("");
		publication.setDateEnvoiEffective(new Timestamp(System.currentTimeMillis()));
		publication.setIdPublicationEtat(PublicationEtat.ETAT_ENVOI_ACCEPTE);
		if(bIsAAPC) publication.setTitrePDF(org.coin.fr.bean.export.PublicationType.getPublicationTypeName(PublicationType.TYPE_AAPC));
		if(bIsAATR) publication.setTitrePDF(org.coin.fr.bean.export.PublicationType.getPublicationTypeName(PublicationType.TYPE_AATR));
		publication.create();
		publication.publish(organisation.getIdOrganisation(),marche.getIdMarche(),PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual()),request); 
	}
	
	String sTitle = "Calibrage de la petite annonce";
%>
<%@ include file="../../include/headerDesk.jspf" %> 
</head>
<body>
<div class="titre_page"><%=sTitle %></div>
	<table class="pave">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Calibrage de votre petite annonce</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">Votre petite annonce a été calibrée avec succès</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table><br /><br />
	<input type="button" value="Retour à la liste des petites annonces" onclick="Redirect('<%=response.encodeRedirectURL("afficherToutesPetitesAnnonces.jsp")%>')" />
<%@include file="../../include/footerDesk.jspf" %>
</body>
</html>