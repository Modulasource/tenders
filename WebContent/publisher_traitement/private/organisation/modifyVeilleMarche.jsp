
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfSwitcher"%><%@page import="org.coin.mail.mailtype.MailUser"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>

<%@ page import="org.coin.util.*,java.sql.*,org.coin.fr.bean.*,modula.graphic.*,org.coin.bean.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*,modula.marche.*" %> 
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf" %> 

<%
    String rootPath = request.getContextPath()+"/";
    
    Connection conn = ConnectionManager.getConnection();
    boolean bVeilleMarche = false;
    VeilleMarcheAbonnes veilleMarcheAbonnes = null;
    try{
        veilleMarcheAbonnes 
            = VeilleMarcheAbonnes.getVeilleMarcheAbonnesFromPersonnePhysique(
                    candidat.getIdPersonnePhysique());
        bVeilleMarche = true;
    }catch(CoinDatabaseLoadException e){
        veilleMarcheAbonnes = new VeilleMarcheAbonnes();
    }
    
    veilleMarcheAbonnes.setFromForm(request, "");
    veilleMarcheAbonnes.cleanKeyWord();
    
    int IdMailTypeEtatInscriptionVeilleMarche = -1;

    boolean bVeilleMarcheChecked = HttpUtil.parseBoolean("bVeilleMarche", request, false);
    String sCriteresSelectionnes = "";
    String sTypeKeyWord = HttpUtil.parseString("typeKeyWord", request, "or");
    
    try{
    	
    CodeCpfSwitcher cpfSwitcher = new CodeCpfSwitcher(ObjectType.PERSONNE_PHYSIQUE,candidat.getIdPersonnePhysique());
    if(bVeilleMarcheChecked)
    {

    	/** 
         * Mail servant pour l'ajout et la modification de la veille de marché
         */
        IdMailTypeEtatInscriptionVeilleMarche = MailConstant.MAIL_PUBLISHER_INSCRIPTION_VEILLE_MARCHES;
               
        if(!bVeilleMarche)
        {
            /**
             * la veille de marché n'existe pas encore
             */
            veilleMarcheAbonnes.setIdPersonnePhysique(candidat.getIdPersonnePhysique());
           	try{
           		veilleMarcheAbonnes.setIdOrganisation(Integer.parseInt(
           			""+session.getAttribute( CSS.DESIGN_USE_ORGANISATION_ID)));
			}catch (Exception e) {}
           	if(veilleMarcheAbonnes.getIdOrganisation() < 0 )
           		veilleMarcheAbonnes.setIdOrganisation(0);
            veilleMarcheAbonnes.create(conn);
            
        } else {
            /**
             * la veille de marché existe déjà
             */ 
            veilleMarcheAbonnes.store(conn);
        }
        
        /**
         * Récupération des adresses mail
         */
        veilleMarcheAbonnes.updateMail(request);
        
        /**
        * Récupère la liste des compétences sélectionnées et les associes au candidat
        */
        if(request.getParameter("iIdCompetenceSelectionListe") != null)
		{
			try{
				int[] listeGroupCompetences = null;
				int[] listeCompetences = Outils.parserChaineVersEntier(request.getParameter("iIdCompetenceSelectionListe"),"|");
				if (listeCompetences != null)
				{ 
					if(cpfSwitcher.isUseCPFGroup()){
						listeGroupCompetences = Outils.parserChaineVersEntier(request.getParameter("iIdGroupCompetenceSelectionListe"),"|");
						if(listeGroupCompetences == null){
							/**
				             * on les supprime tous
				             */
				             cpfSwitcher.removeAllGroupCPFItems();
						}
					}
					
					cpfSwitcher.updateCPFSelectedItems(listeGroupCompetences,listeCompetences, conn);
				}else{
		            /**
		             * on les supprime tous
		             */
		             cpfSwitcher.removeAllBoampCPFItems();
		        }
			}
			catch(Exception e){e.printStackTrace();}
		
            if(cpfSwitcher.isUseCPFGroup()){
            	Vector<CodeCpfGroup> vCPFGroupCandidat = cpfSwitcher.getGroupCPFSelected();
            	sCriteresSelectionnes += "<br/>\nGroupes de secteurs d'activité :<br/>\n";
            	for(CodeCpfGroup itemCPFGroup : vCPFGroupCandidat){
                    sCriteresSelectionnes += itemCPFGroup.getName()+"<br/>\n";
                }
            }
        	Vector<BoampCPF> vCPFCandidat = cpfSwitcher.getBoampCPFSelected();
        	sCriteresSelectionnes += "<br/>\nSecteurs d'activité :<br/>\n";
            for(BoampCPF itemCPF : vCPFCandidat){
                sCriteresSelectionnes += itemCPF.getName()+"<br/>\n";
            }
        }
        
        /**
         * MAJ KeyWord
         */
        veilleMarcheAbonnes.updateKeyWordSearchType(sTypeKeyWord);
        
        /**
         * MAJ Departement
         */
         veilleMarcheAbonnes.updateDepartement(request);
    }
    else {
        /**
         * Suppression de la veille de marché
         */
        IdMailTypeEtatInscriptionVeilleMarche = MailConstant.MAIL_PUBLISHER_DESINSCRIPTION_VEILLE_MARCHES;
        veilleMarcheAbonnes.remove();
        cpfSwitcher.removeAllBoampCPFItems();
        if(cpfSwitcher.isUseCPFGroup()){
        	cpfSwitcher.removeAllGroupCPFItems();
        }
    }
    } catch (Exception e) {
    	e.printStackTrace();
    }
    
    Vector<PersonnePhysiqueParametre> vParams = PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(candidat.getId());
    
    String sUrlRebond = "";
    try{
        Organisation oProprietaireModula = null;
        oProprietaireModula = Organisation.getOrganisation(Integer.parseInt(""+session.getAttribute(modula.graphic.CSS.DESIGN_USE_ORGANISATION_ID)));
        sUrlRebond = OrganisationParametre.getOrganisationParametreValue(oProprietaireModula.getIdOrganisation(),"organisation.portail.url");
    }catch(Exception e){
        sUrlRebond = Configuration.getConfigurationValueMemory("publisher.url");
    }
  
    
    Courrier courrier = Courrier.newCourrierCron(
                MailType.getMailTypeMemory(IdMailTypeEtatInscriptionVeilleMarche,false, conn));
    PersonnePhysique personnePhysiqueVeille = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn);
    
    MailUser.populateCourrierPersonnePhysiqueWithObjectAttached(
            courrier, 
            personnePhysiqueVeille,
            conn);
    
    if(sCriteresSelectionnes.equals("")) sCriteresSelectionnes="néant";
    
    //courrier.replaceAllMessageAndSubjectKeyWord("[provider_publisher_url]",sUrlRebond);
    courrier.replaceAllMessageAndSubjectKeyWord("[publisher_url]", Configuration.getConfigurationValueMemory("publisher.url"));
    courrier.replaceAllMessageAndSubjectKeyWord("[veille_marche_criteres_selectionnes]", sCriteresSelectionnes );
    
    /** 
     * traitement mail des keyword 
     */

    String sKeyWord = veilleMarcheAbonnes.getKeyWord();
    if(sTypeKeyWord.equalsIgnoreCase("or")){
    	sKeyWord += " (Rechercher n'importe lequel de ces termes)";
    }else{
    	sKeyWord += " (Rechercher tous les termes)";
    }
    courrier.replaceAllMessageAndSubjectKeyWord("[veille_marche_keyword]",sKeyWord);

    /** traitement mail des departements */
    Vector<Departement> vDept = Departement.getAllStaticMemory(false);
    Vector<Departement> vDeptSelected = VeilleMarcheAbonnes.getAllDepartement(candidat.getId(), vParams,vDept);
    String sCriteresDepartement = "";
    for(Departement dept : vDeptSelected){
    	sCriteresDepartement += dept.getIdString()+". "+dept.getName()+"<br/>\n";
    }
    courrier.replaceAllMessageAndSubjectKeyWord("[veille_marche_departement]",sCriteresDepartement);
    
    /** traitement des adresses mail */
    ArrayList<String> sMailList = veilleMarcheAbonnes.getAllMail(personnePhysiqueVeille, false, conn);
    MailModula mail = null;
   	for(String sMail : sMailList){
   		courrier.setTo(sMail);
   		mail = new MailModula();
   		try{courrier.send(mail, conn);}
   	    catch (Exception e) {
   	        e.printStackTrace();
   	    }
   	}

    ConnectionManager.closeConnection(conn);
        
   response.sendRedirect(
		   response.encodeRedirectURL(
			   rootPath + sPublisherPath
	           + "/private/organisation/displayVeilleMarche.jsp"));

%>