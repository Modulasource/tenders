<%@ include file="../../../include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.boamp.BoampException"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="java.sql.*,org.coin.fr.bean.export.*,java.util.*,org.coin.util.*,org.coin.fr.bean.*,modula.marche.*, modula.ws.boamp.*" %>
<%@page import="org.xml.sax.SAXException"%>
<%@page import="modula.journal.Evenement"%>
<% 

    int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	int iIdPublicationType = Integer.parseInt(request.getParameter("iIdPublicationType"));
	boolean bIsPublicationTest = HttpUtil.parseBoolean("bIsPublicationTest", request, false);
	boolean bRemovePreviousPublication = HttpUtil.parseBoolean("bRemovePreviousPublication", request, false);
	Marche marche = Marche.getMarche(iIdAffaire, false);
	marche.bIsPublicationTest = bIsPublicationTest;
	boolean bIsLectureSeule = HttpUtil.parseBoolean("bIsLectureSeule", request, false);
	if(bIsLectureSeule) {
		marche.setLectureSeule(true);
		marche.store();
	}
	String sUrlTraitement = request.getParameter("sUrlTraitement");
	String sIsProcedureLineaire = HttpUtil.parseStringBlank("sIsProcedureLineaire",request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request, 1);
	int iIdFormulaireJoue = HttpUtil.parseInt("iIdFormulaireJoue",request, 0);
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif",request, 0);
	boolean bTestXmlGeneration = HttpUtil.parseBoolean("bTestXmlGeneration", request, false);

	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request, -1);
	
	boolean bSendXml = true;
	
	if(bTestXmlGeneration)  bSendXml = false;
	
	Connection conn = ConnectionManager.getDataSource().getConnection();
	BoampException boampException = null;
	SAXException saxException = null;
	String sXmlToSend = "";
	
	try {
		/**
		 * Génération du flux 
		 */
		sXmlToSend 
			= ConstitutionFichierXMLBoamp.getXml(
				marche,
				iIdPublicationType,
				iIdFormulaireJoue,
				iIdAvisRectificatif,
				false,
				conn);
		
		String sXsdFile = Configuration.getConfigurationValueMemory("boamp.validation.xsd.avis.pathfilename");
		
		if(Configuration.isTrueMemory("boamp.validation.xsd.avis.launch.validation.after.parsing.exception", false))
		{
			try {
				BasicDom.parseAndValidateXmlStream(sXmlToSend, sXsdFile, false); 
			} catch (SAXException e) {
				bSendXml = false;
				saxException = e;
				BasicDom.parseAndValidateXmlStream(sXmlToSend, sXsdFile, true); 
			}
		} else {
			BasicDom.parseAndValidateXmlStream(sXmlToSend, sXsdFile, false); 
			
		}
    	
    	if(iIdFormulaireJoue != -1)
			iIdPublicationType += iIdFormulaireJoue; 
		
	} catch (BoampException e )
	{
		bSendXml = false;
		boampException = e;
	}catch (SAXException ee )
	{
		bSendXml = false;
		saxException = ee;
	}

	ConnectionManager.closeConnection(conn);
	
	PublicationBoamp publi = null;
	Vector vPublicationBoamp = null;
	boolean bPublicationExist = false;
	try {
		vPublicationBoamp = PublicationBoamp.getAllPublicationBoampFromAffaire(marche.getIdMarche()); 
		publi = (PublicationBoamp)vPublicationBoamp.firstElement();
		bPublicationExist = true;
	}
	catch(Exception e){
		publi = new PublicationBoamp();
	}

	try {

		if(bSendXml)
		{
			
            /**
             * Pour supprimer les anciennes publication de Test 
             */
			if(bIsPublicationTest 
			&& bRemovePreviousPublication 
			&& (iIdPublicationType == PublicationType.TYPE_AAPC 
				|| iIdPublicationType == PublicationType.TYPE_AATR
				|| iIdPublicationType > PublicationType.TYPE_JOUE_FORM)
			)
			{
				
				Vector<PublicationBoamp> vPublicationBoampToRemove 
		 			= PublicationBoamp.getAllPublicationBoampWithTestFromAffaire(
		 					marche.getIdMarche(),
		 					iIdPublicationType);
			 	
				for(int k=0;k<vPublicationBoampToRemove.size();k++)
				{
					PublicationBoamp publiBoampToRemove = vPublicationBoampToRemove.get(k);
					publiBoampToRemove.remove();
				}
			}
			
            /**
             * Création de la nouvelle publication 
             */
			publi.setArXml("");
			publi.setFichier(sXmlToSend	);
			int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
			publi.setIdExport(iIdExport);
			publi.setIdReferenceObjet(iIdAffaire);
			publi.setIdPublicationDestinationType(PublicationDestinationType.TYPE_BOAMP);
			
			publi.setDateEnvoi(marche.getDateEnvoiBOAMP()); 
			if(iIdPublicationType == PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AAPC 
			|| iIdPublicationType == PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AATR )
			{
				publi.setDateEnvoi(new Timestamp(System.currentTimeMillis())); 
				
			}
			
			if(marche.isAffaireAATR(false)) {
				
				Vector<Validite> vValiditesAATR = Validite.getAllValiditeAATRFromAffaire(marche.getIdMarche());
				if(vValiditesAATR != null)
				{
					if(vValiditesAATR.size() == 1) 
					{
						Validite oValiditeAATR = vValiditesAATR.firstElement();
						publi.setDateEnvoi( oValiditeAATR.getDateDebut()); 
					}
				}
			}
			
			publi.setIdPublicationType(iIdPublicationType);
			publi.setIdTypeObjet(org.coin.bean.ObjectType.AFFAIRE);
			publi.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
			publi.setFormatWebService(true);
			publi.setFormatPapier(false);
			publi.setStatutPublicationTest(bIsPublicationTest);
				
			String sNomFichier = ConstitutionFichierXMLBoamp.getNextFilename(publi);
			
			publi.setNomFichier(sNomFichier);
			bPublicationExist = false;
			if(bPublicationExist){
				publi.store();
				publi.load();
				Evenement.addEvenement(iIdAffaire, "CU-BOAMP-001", sessionUser.getIdUser(),"Constitution du fichier XML pour envoi au B.O.A.M.P");
			}else{
				publi.create();
				publi.load();
				Evenement.addEvenement(iIdAffaire, "CU-BOAMP-001", sessionUser.getIdUser(),"Constitution du fichier XML pour envoi au B.O.A.M.P");
			}
			/**
			 *
			 * Partie II : envoi
			 * 
			 */
			try{
				ServeurFichiersXMLBoamp.bDisplayTraceOnConsole=true;
				ServeurFichiersXMLBoamp.bSendFile=true;
				ServeurFichiersXMLBoamp.envoyerFluxXML(publi);
			}catch(Exception e){
				
				Organisation boamp = Organisation.getOrganisation(
						PublicationBoamp.getIdOrganisationBoamp()		
				);
				String sURLEnvoiBoamp = "";
				if(bIsPublicationTest) {
					sURLEnvoiBoamp = OrganisationParametre.getOrganisationParametreValue(boamp.getIdOrganisation(),"boamp.url.test");
				} else {
					sURLEnvoiBoamp = OrganisationParametre.getOrganisationParametreValue(boamp.getIdOrganisation(),"boamp.url");
				}
				
				throw new BoampException("Serveur Du Boamp indisponible ("+sURLEnvoiBoamp+")\n" 
						+ ((sessionUserHabilitation.isDebugSession())?e.getMessage():"") );
			}
		
			String sUrlReturn = "";
			
			if(request.getParameter("sUrlReturn") == null)
			{
				sUrlReturn =  
						rootPath+"desk/marche/algorithme/affaire/afficherToutesPublications.jsp?"
						+ "iIdAffaire=" + iIdAffaire
						+ "&iIdOnglet="+iIdOnglet
						+ "&iIdExport="+iIdExport
						+ "&nonce=" + System.currentTimeMillis()
						+ "&sIsProcedureLineaire="+sIsProcedureLineaire
						+ "&sUrlTraitement="+sUrlTraitement
						+ "&iIdNextPhaseEtapes="+iIdNextPhaseEtapes
						+ "#ancreHP";
			} else {
				if(request.getParameter("sUrlReturn").equals("aapc"))
				{
					sUrlReturn =  
						rootPath+"desk/marche/algorithme/affaire/afficherAffaire.jsp?"
						+ "iIdAffaire=" + iIdAffaire
						+ "&nonce=" + System.currentTimeMillis()
						+ "#ancreHP";			
				}
				if(request.getParameter("sUrlReturn").equals("aatr"))
				{
					sUrlReturn =  
						rootPath+"desk/marche/algorithme/affaire/afficherAttribution.jsp?"
						+ "iIdAffaire=" + iIdAffaire
						+ "&nonce=" + System.currentTimeMillis()
						+ "#ancreHP";			
				}
				
			}
			
			response.sendRedirect(
					response.encodeRedirectURL(sUrlReturn));
	
			return;
		} 
	
	} catch (BoampException e )
	{
		bSendXml = false;
		boampException = e;
	}

	
	/**
	 * Ici on affiche le flux et s'il y a eu des erreurs
	 */

	 String sTitle = "Envoi au BOAMP";
	 %>
<script type="text/javascript" src="<%=rootPath%>include/cacherDivision.js"></script>
</head>
<body >
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<br />
<%
	String sXmlState = "";
	if(boampException != null)
	{
		sXmlState 
			= "Flux non correct : <span style='color:red'> " 
			+ Outils.getTextToHtml(boampException.getMessage())
			+ "</span>";	
		marche.setLectureSeule(false);
		marche.store();
	} 
	else 
	{
		if(saxException != null)
		{
			sXmlState 
				= "Flux non correct : <span style='color:red' >" 
				+ Outils.getTextToHtml(saxException.getMessage())
				+ "</span>";
			marche.setLectureSeule(false);
			marche.store();
		} else {
			sXmlState = "Flux OK";
		}
	}	
	
	String sXmlStringIndentToHtml = "";
	try {
		sXmlStringIndentToHtml 
			= Outils
				.getXmlStringIndentToHtml(
						BasicDom.parseXmlStream(
								sXmlToSend, 
								false));
		
	} catch (Exception e) {
		sXmlStringIndentToHtml 
			= "<span style='color:red'>" + e.getMessage() + "</span><br/>"
			+ Outils.getTextToHtml( sXmlToSend );
	}
	
	
%>
<table class="pave" >
	<tr >
		<td class="pave_cellule_gauche" >
		<button onclick="history.go(-1)">Retour</button>
		</td>
		<td class="pave_cellule_droite" >&nbsp;</td> 
	</tr>
	<tr >
		<td class="pave_cellule_gauche" >Etat :</td>
		<td class="pave_cellule_droite" ><%= sXmlState %></td> 
	</tr>
	<tr  >
		<td class="pave_cellule_gauche" >
				<a href="javascript:montrer_cacher('xmlGenerated')">+ Flux XML ... </a>
		</td>
		<td class="pave_cellule_droite" >&nbsp;</td> 
	</tr>
	<tr id="xmlGenerated" style="display : none;">
		<td class="pave_cellule_gauche" >
			&nbsp;
		</td>
		<td class="pave_cellule_droite" ><%= sXmlStringIndentToHtml %></td> 
	</tr>
</table>
</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.Validite"%>
</html>