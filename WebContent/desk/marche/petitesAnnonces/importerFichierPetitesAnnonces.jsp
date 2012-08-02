<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="java.util.*,org.coin.fr.bean.export.*,org.w3c.dom.*,org.coin.util.*,org.coin.fr.bean.*,modula.ws.marco.*,modula.marche.*,modula.algorithme.*,modula.*,org.coin.bean.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sPageUseCaseId = "IHM-DESK-PA-7";
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Import de Petites annonces " ;
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<a name="ancreHP">&nbsp;</a>
	<div class="titre_page"> <%=sTitle%> </div>
<table class="pave" summary="none">
	<tr>
		<td class="pave_cellule_droite">
		<img src="<%= rootPath + modula.graphic.Icone.ICONE_WARNING%>" style="vertical-align:middle" />
		&nbsp;Lecture du fichier XML et création en base, cette opération peut prendre quelques instants, merci de patienter.
		</td>
	</tr>
<%

	String sFileName = request.getParameter("sFilename");
	// TODO : filtrer sur les noms en *.xml
	Document doc = BasicDom.parseXmlFile(sFileName, false);
	// TODO : Ajouter la validation avec le XSD
	if (doc == null)
	{
		return ;
	}
	String sSelectedItems = "";
	try{
		sSelectedItems = request.getParameter("sSelectedItems");
	}
	catch(NullPointerException e){}
	String[] sPAToImport = null;
	try{
		sPAToImport = request.getParameterValues("PAToImport");
	}
	catch(NullPointerException e){}

	Node nodeListePetiteAnnonce = BasicDom.getFirstChildElementNode(doc);
	Vector vPetitesAnnonces = modula.marche.PetiteAnnonceWrapper.getPetitesAnnonces(nodeListePetiteAnnonce);
	Vector<String> vPetitesAnnoncesToImport = new Vector<String>();
	if ((sPAToImport != null) && (sSelectedItems.equalsIgnoreCase("all")))
		for (int i = 0; i<sPAToImport.length ;i++)
			vPetitesAnnoncesToImport.addElement(sPAToImport[i]);
	else
		for (int i = 0; i<vPetitesAnnonces.size() ;i++)
			vPetitesAnnoncesToImport.addElement(""+i);
	for(int i = 0; i < vPetitesAnnoncesToImport.size() ;i++)
	{
		PetiteAnnonceWrapper pa = (PetiteAnnonceWrapper) vPetitesAnnonces.get(Integer.parseInt(vPetitesAnnoncesToImport.get(i)));
%>
		<tr>
			<td class="pave_cellule_droite">
			<img src="<%= rootPath + modula.graphic.Icone.ICONE_SUCCES%>" style="vertical-align:middle" />
			&nbsp;Import de la petite annonce ref.<%=pa.getReference() %>.
			</td>
		</tr>
<%
		out.flush();
		Marche marche = new Marche();
		marche.setAffaireAATR(false);
		marche.setAffaireAAPC(false);
		if (pa.getTypeAnnonce().equals("1") ) marche.setAffaireAAPC(true);
		else if (pa.getTypeAnnonce().equals("2") )
			marche.setAffaireAATR(true);
		else if (pa.getTypeAnnonce().equals("3") ){ 
			marche.setRecapAATR(true);
			marche.setAffaireAATR(true);
		}
		if (pa.getReference() == null)
		{
			java.io.File file = new java.io.File(sFileName );
			pa.setReference("XML-" + file.getName() + "-ref-" + i);
		}
		if (pa.getAvisRectificatif()) marche.setAvisRectifPA(true);
		else marche.setAvisRectifPA(false);
		marche.setIdCreateur( sessionUser.getIdIndividual() );
		marche.setReferenceExterne(""+ pa.getReferenceExterne());
		marche.setReference(""+ pa.getReference());
		try{
			Organisation AP = Organisation.getAllOrganisationByReferenceExterne(pa.getReferenceExterneAP()).firstElement();
			modula.commission.Commission commission = modula.commission.Commission.getAllcommissionWithIdOrganisation(AP.getIdOrganisation()).firstElement();
			marche.setIdCommission(commission.getIdCommission());
		}catch(Exception e){}
		marche.setObjet(""+(pa.getObjet()==null?"":pa.getObjet()));
		String sTexteLibre = pa.getLibelle();
		// il faut recherché : Objet du marché :
		//String sObjet = Outils.getTextBetweenOptionalNewLine(sTexteLibre , "Objet du marché : ");
		//marche.setObjet(sObjet );
		
		// Désormais le flux des PA est en HTML , 
		// il faut tranformer les saut de ligne en <br> et non en <br/> car pas en XHTML pour le moment.
		//sTexteLibre = sTexteLibre.replaceAll("\n", "<br>\n");
		marche.setPetiteAnnonceTexteLibre(sTexteLibre);
		marche.setPetiteAnnonceFormat("libre");
		marche.setPAGrouped(pa.isGrouped());
		if(pa.getPieceJointeName()!=null
		&& !"".equals( pa.getPieceJointeName())) { 
			try{
				String sPathFileFTP = sessionUser.getPath() + "/web/ftp/pa/"; 
				java.io.File file = new java.io.File(sPathFileFTP + pa.getPieceJointeName());
				if (file.exists()){
					marche.setNomAAPC(pa.getPieceJointeName());
					try{
						marche.setAAPC(file);  
						marche.storeAAPC();
					}catch(Exception e){e.printStackTrace();}
				}
				
			}catch(Exception e){}
		}					
		try{
			if (pa.getPassation()!= null) marche.setPetiteAnnoncePassation(Integer.parseInt(pa.getPassation()));
		}
		catch(Exception e){}
		try{
			if (pa.getPrestation()!=null) marche.setIdMarcheType(Integer.parseInt(pa.getPrestation()));
		}
		catch(Exception e){}
		/* initialisation des status */
		marche.setLectureSeule(false);
		marche.setCandidaturesCloses(false);
		marche.setOffresCloses(false);
		marche.setAffaireCloturee(false);
		marche.setAffaireValidee(false);
		marche.setAAPCAutomatique(false);
		marche.setPetiteAnnonceFormat("libre");		

        if(!pa.getCodePostalLieuExecution().equals("")) {
            Adresse adresseLieuExecution = new Adresse();
            adresseLieuExecution.setCodePostal(pa.getCodePostalLieuExecution());
            adresseLieuExecution.create();
            
            marche.setIdLieuExecution(adresseLieuExecution.getIdAdresse());
        }
		
		marche.setIdAlgoAffaireProcedure(AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE);
		PhaseEtapes oPhaseEtapes = AlgorithmeModula.getFirstPhaseEtapesInProcedure(AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdProcedure());
		try
		{
			marche.setIdAlgoPhaseEtapes(oPhaseEtapes.getId());
		}
		catch(Exception e)
		{
			System.out.println("Exception > importerFichierPetitesAnnonces.jsp: "+e.getMessage());
		}
		marche.setDateCreation(new java.sql.Timestamp(System.currentTimeMillis())); 
		marche.setDateModification(new java.sql.Timestamp(System.currentTimeMillis()));
		
		
		
		// Nouveau driver pour contourner les -1;
		/*marche.setIdMarcheSynchro(0);
		marche.setIdMarcheType(0);
		marche.setIdLieuExecution(0);
		marche.setIdLieuLivraison(0);
		marche.setIdMarcheVariantes(0);
		marche.setNbMinCandidats(0);
		marche.setNbMaxCandidats(0);
		marche.setIdMarcheForme(0);
		marche.setPresentationOffre(0);
		marche.setTimingDoubleEnvoi(0);
		marche.setIdAlgoAffaireProcedure(0);
		marche.setIdAlgoPhaseEtapes(0);
		marche.setPetiteAnnoncePassation(0);
		*/
		
		marche.create();
		boolean bAnnonceToValidate = false;
		if( Configuration.isTrueMemory("annonces.validation.automatique", true)) bAnnonceToValidate = true;
		
		if(bAnnonceToValidate){
			marche.setLectureSeule(true);
			marche.setAffaireValidee(true);
			marche.setAffaireEnvoyeePublisher(true);
			marche.store();
		}

        if(!pa.getSecteurActivite().equals("")) {
            int iIdBoampCpfSimplifie = BoampCpfSimplifie.getIdBoampCpfSimplifieFromLibelle(pa.getSecteurActivite());
            if(iIdBoampCpfSimplifie != 0) {
                BoampCPFItem.removeAllFromOwnerObject(TypeObjetModula.AFFAIRE, marche.getIdMarche());
                BoampCPFItem boampCpfItem = new BoampCPFItem();
                boampCpfItem.setIdOwnerTypeObject(TypeObjetModula.AFFAIRE);
                boampCpfItem.setIdOwnedObjet(0);
                boampCpfItem.setIdOwnerReferenceObject(marche.getIdMarche());
                boampCpfItem.setIdBoampCpfSimplifie(iIdBoampCpfSimplifie);
                boampCpfItem.create();
            }
        }
        
        
		Validite oValiditeMarche = new Validite();
		oValiditeMarche.setIdTypeObjetModula(ObjectType.AFFAIRE);
		oValiditeMarche.setIdReferenceObjet(marche.getIdMarche());
		oValiditeMarche.setDateDebut(pa.getDateDebutMiseEnLignePublisher());
		oValiditeMarche.setDateFin(pa.getDateFinMiseEnLignePublisher()); 
		oValiditeMarche.create();

		Vector<String> vSupportsPublication = pa.getSupportsPublication();
		System.out.println("vSupportsPublication"+vSupportsPublication.size());
		for(int j=0;j<vSupportsPublication.size();j++){
			System.out.println("vSupportsPublication.get(j)"+vSupportsPublication.get(j));
			try{
				Organisation organisation = null;
				try{
					organisation = Organisation
						.getAllOrganisationPublicationFromOrganisationParametreAndValue(
								"export.xmedia.publissimo.ws.node.X_MediaSPEF.Import.Media", 
								vSupportsPublication.get(j)).firstElement();
				}
				catch(Exception e){
					/**
					 * Bidouille pour contrecarrer ce Willardon chelou ...
					 */ 
					
					System.out.println("pas d'organisme correspondant");
						organisation = Organisation.getOrganisation(
								PersonnePhysique.getPersonnePhysique(
										sessionUser.getIdIndividual())
										.getIdOrganisation());
					
				
				}
				if (organisation!=null){
					Export exportAFF = new Export(); 
					exportAFF.setName(organisation.getRaisonSociale());
					exportAFF.setDateCreation(new java.sql.Timestamp(System.currentTimeMillis()));
					exportAFF.setIdTypeObjetSource(ObjectType.AFFAIRE);
					exportAFF.setIdTypeObjetDestination(ObjectType.ORGANISATION);
					exportAFF.setIdObjetReferenceSource(marche.getIdMarche());
					exportAFF.setIdObjetReferenceDestination(organisation.getIdOrganisation());
					exportAFF.setIdExportSens(Export.SENS_EXPORT);
					exportAFF.create();
					if(organisation.isClientSPQR())
					{
						PublicationSpqr publication = new PublicationSpqr();
						publication.setIdTypeObjet(ObjectType.AFFAIRE);
						publication.setIdReferenceObjet(marche.getIdMarche());
						publication.setIdExport(exportAFF.getIdExport());
						publication.setIdPublicationType(PublicationType.TYPE_PETITE_ANNONCE);
						publication.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
						publication.setCorpsPDF(marche.getPetiteAnnonceTexteLibre());
						publication.normalize();
						publication.create();
						System.out.println("Une publication SPQR a été créée, "+organisation.getRaisonSociale()+" est le client");
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}
	java.io.File file = new java.io.File(sFileName);
	file.delete();
	String sMessTitle="Succès de l'import des petites annonces";
	String sMess = "L'import s'est effectué correctement.<br />Veuillez vérifier les informations de ces petites annonces avant de les valider.";
	sMess += "<br /><br /><a href='"+response.encodeURL("afficherToutesPetitesAnnonces.jsp")+"'>Retour à la liste des petites annonces</a>";
	String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
%>	
</table>
	<br /><br />
<%@include file="../../../include/message.jspf" %>
<%@ include file="../../include/footerDesk.jspf" %>
</body>

<%@page import="org.coin.bean.boamp.BoampCpfSimplifie"%>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%></html>