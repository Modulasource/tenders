package org.coin.fr.bean;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Vector;

import javax.naming.NamingException;
import javax.xml.parsers.ParserConfigurationException;

import modula.commission.Commission;
import modula.marche.VeilleMarcheAbonnes;
import mt.common.addressbook.AddressBookMerger;
import mt.modula.affaire.cpf.CodeCpfGroup;
import mt.modula.affaire.cpf.CodeCpfSwitcher;
import mt.modula.batch.RemoteControlServiceConnection;
import mt.modula.tender.subscription.TenderSubscriptionPack;

import org.apache.commons.lang.StringUtils;
import org.coin.bean.Group;
import org.coin.bean.ObjectType;
import org.coin.bean.User;
import org.coin.bean.UserGroup;
import org.coin.bean.UserType;
import org.coin.bean.conf.Configuration;
import org.coin.bean.cron.CoinAbstractJob;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
import org.coin.util.BasicDom;
import org.coin.util.CalendarUtil;
import org.coin.util.FileUtil;
import org.coin.util.Outils;
import org.quartz.JobExecutionException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

public class CarnetAdresseWrapper {

	String sPath;
	public boolean bDebug = false;
	public boolean bArchiveFile = true;
	
	
	public static final String CONFIGURATION_PARAM_USE_PRETRAITMENT_MERGER =  "modula.synchro.use.pretraitment.merger";
	public static final String CONFIGURATION_PARAM_SYNCHRO_AUTHORIZE_REMOVE =  "modula.synchro.authorize.remove";
	public static final String CONFIGURATION_PARAM_SYNCHRO_GROUP_FAMILLE =  "modula.synchro.group.famille";
	public static final String CONFIGURATION_PARAM_SYNCHRO_AUTHORIZE_INACTIVATE =  "modula.synchro.authorize.inactivate";
	public static final String CONFIGURATION_PARAM_SYNCHRO_REMOVE_TREATMENT =  "modula.synchro.remove.treatment";
	public static final String[] g_sSynchronizeGroupWithReferencePrefix = {"FAM-","ABO-"};
	
	/** récupération de toutes les organisations du fichier */
	int iOrganizationCount = 0;
	int iOrganizationCountInFile = 0;
	int iIndividualGlobalCountInFile = 0;
	int iIndividualGlobalCount = 0;
	int iUserGlobalCount = 0;

	
	String sFileName;
	String sRefExtOrg;
	boolean bAuthorizeRemove;
	boolean bAuthorizeInactivate;
	boolean bRemoveTreatment ;
	boolean bUsePreTreatmentMerger ;
	
	
	Vector<JobExecutionException> vException;
	String sFamilleGroup ;
	Vector<Group> vGroup;
	Vector<User> vUser = null;
	Vector<UserGroup> vUserGroup = null;
	Vector<TenderSubscriptionPack> tsPack;
	
	/**
	 * mettre en table conf
	 */
	public boolean bCreateOrganizationCheckDuplicate = true;
	public boolean bCreateIndividualCheckDuplicate = true;
	public boolean bCreateParamWebServiceSync = false;

	public CarnetAdresseWrapper(String sPath)
	{
		this.sPath = sPath;
	}

	public static String[] getFiles(String sPath) {
		
		System.out.println("getFiles sPath : '" + sPath + "'");
		
		FilenameFilter filter = new FilenameFilter() {
			public boolean accept(File dir, String name) {
				System.out.println("name : " + name);
				boolean bAccept = name.toLowerCase().endsWith(".xml");
				return bAccept ;
			}
		};

		File file = new File(sPath);
		return file.list(filter);

	}

	public Vector<JobExecutionException> synchroniserTousFichiers(Connection conn) throws IOException
	{

		Vector<JobExecutionException> vException = new Vector<JobExecutionException>();
		System.out.println("this.sPath" + this.sPath);
		String paListeFichiers[] = CarnetAdresseWrapper.getFiles(this.sPath);
		
		if(paListeFichiers != null)
		{
			System.out.println("File count : " + paListeFichiers.length);
		} else {
			System.out.println("NO FILE in the PATH : " + this.sPath);
		}
		
		if (paListeFichiers != null) 
			for(int i = 0 ; i < paListeFichiers.length  ; i++)
			{	
				long lStart = System.currentTimeMillis();
				String sFileName = paListeFichiers[i];
				System.out.println("sFileName : " + sFileName);
				System.out.println("this.bArchiveFile : " + this.bArchiveFile);
				Vector<JobExecutionException> vExceptionFile = null;
				try{
					/**
					 * petite feinte pour être sûr qu'on synchronise le bon fichier
					 * car par exemple pour le cas des affiches de grenoble
					 * il y a 2 flux de carnet d'adresses, et un seul doit être sync 
					 * par les WS.
					 * Et on a une chance de les distinguer car ils ne portent pas le même nom
					 */
					
					String sFilenameAllowed 
						= Configuration.getConfigurationValueMemory(
								"system.ws.addressbook.filename.allowed", 
								"", 
								conn);
					
					this.bCreateParamWebServiceSync = false;
					if(!sFilenameAllowed.equals(""))
					{
						if(sFileName.contains(sFilenameAllowed ))
						{
							this.bCreateParamWebServiceSync = true;
						}
					}
					
					vExceptionFile = synchroniserFichier(sFileName,conn);
					vException.addAll(vExceptionFile);
				}catch(Exception e){
					e.printStackTrace();
					vException.add(new JobExecutionException(e));
				}
				long lStop = System.currentTimeMillis();
				
				File tmp = File.createTempFile("import_ca_" + sFileName + "_", ".log");
				System.out.println("log : " + tmp);
				PrintStream ps = new PrintStream(tmp);
				ps.println("File : " + sFileName);
				ps.println("Execution time : " + (lStop - lStart) + " ms");
				ps.println("bArchiveFile : " + this.bArchiveFile);
				ps.println("bDebug : " + this.bDebug);
				ps.println("sPath : " + this.sPath);
				if(vExceptionFile != null){
					ps.println("Exception count : " + vExceptionFile.size());
				}
				
				ps.println(getImportFileReport());
				if(vExceptionFile != null){
					CoinAbstractJob.writeException(vException, false, ps);	
				}
				ps.close();
				
				displayImportFileReport();
				System.out.println("Exception count : " + vException.size());
			}
		return vException;
	}

	public static int getNbOrganismesAImporter(Node nodeOrganisme) {
		int nbOrganismesAImporter = 0;

		for (Node child = BasicDom.getFirstChildElementNode(nodeOrganisme); 
		child != null; 
		child = BasicDom.getNextSiblingElementNode(child)) {
			nbOrganismesAImporter++;
		}
		return nbOrganismesAImporter-1;

	}
	
	/**
	 * Merger in pre traitment
	 * 
	 * @param doc
	 * @param conn
	 * @return
	 * @throws CoinDatabaseLoadException
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws SAXException
	 * @throws IOException
	 * @throws ParserConfigurationException
	 */
	public Vector<JobExecutionException> mergeTreatment(
			Document doc,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
	IllegalAccessException, SAXException, IOException, ParserConfigurationException 
	{
		Node nodeOrganismesAImporter = BasicDom.getFirstChildElementNode(BasicDom.getFirstChildElementNode(doc));
		Node childFirstOrganisme = BasicDom.getFirstChildElementNode(nodeOrganismesAImporter);
		for (Node childOrganisme = childFirstOrganisme ; 
		childOrganisme != null; 
		childOrganisme = BasicDom.getNextSiblingElementNode(childOrganisme)) 
		{
			try{
				
				/** 
				 * treat organisation 
				 * 
				 */
				
				
				/**
				 * verify prefix
				 */
				String sReferenceExterne 
					= BasicDom.getChildNodeValueByNodeName(childOrganisme, "referenceExterne");
				
				String sPrefix = "SQL-AFF";
				if(sReferenceExterne == null
				|| sReferenceExterne.startsWith(sPrefix) ) {
					continue;
				}
				
				
				
				Organisation organisationAImporter
					= Organisation.getOrganisationByReferenceExterne(childOrganisme, null, conn);
				
				if(organisationAImporter != null){
					/**
					 * merge orga
					 */
					AddressBookMerger.mergeOrganisationByAddress(organisationAImporter, conn);
					
					/**
					 * merge individual
					 */
					mergeTreatmentAllPersonnePhysique(organisationAImporter, childOrganisme, conn);
					
					
				} else {
					/**
					 * nothing to merge
					 */
				}
				
			} catch (Exception e) {
				addException(e);
			}

		}
		
		return this.vException;
	}
	
	
	private void mergeTreatmentAllPersonnePhysique(
			Organisation organisation,
			Node childOrganisme,
			Connection conn) 
	throws SAXException, NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Node nodePersonnesPhysiques
		= BasicDom.getChildNodeByNodeNameOrNull(childOrganisme, "personnesPhysiques");

		if(nodePersonnesPhysiques == null) return;

		
		Vector<PersonnePhysique> vPersonne 
			= PersonnePhysique.getAllFromIdOrganisation(organisation.getIdOrganisation(), false, conn);
		
		for(Node childPersonnePhysique = BasicDom.getFirstChildElementNode(nodePersonnesPhysiques); 
		childPersonnePhysique != null; 
		childPersonnePhysique = BasicDom.getNextSiblingElementNode(childPersonnePhysique))
		{
			PersonnePhysique personnePhysique = null ;
			
			try{
				personnePhysique = null;
				AddressBookMerger.mergePersonnePhysiqueByName(personnePhysique, vPersonne, conn);	


			} catch(Exception e){
				if(this.bDebug) e.printStackTrace();
				addException(e);
			}
		}

	}
	
	
	/**
	 * BUG #1690
	 * traitement du fichier XML :
		- synchro des Organisations
		- synchro des Personnes
		- synchro des USERs
		- synchro des rôles : nom de la famille = nom du rôle dans Modula

		Règles de gestion : 
		- Une adresse ou contact peut être supprimé, pour répercuter cela
		dans Modula, la règle de gestion lors de la synchro est de supprimer une
		organisation (ou personne) dans Modula uniquement si elle n’apparait plus dans
		le fichier XML et qu’elle a une référence externe : on utilise un
		paramètre en table de conf pour autoriser la suppression ou non (modula.synchro.authorize.remove).

		Pour éviter de faire des erreurs irréversibles on ajoute un autre paramètre qui désactive
		seulement les users si le param de suppression est désactivé (modula.synchro.authorize.inactivate)

		modula.synchro.remove.treatment : active ou non le traitement de suppression lors de la synchro

		- Lors de la synchro des groupes, 
		on ne traite que les groupes qui appartiennent à la famille "Droits Plateforme DEMAT" (modula.synchro.group.famille)
		on ne traite pas les groupes qui n'existent pas dans le système (throw Exception)

		- synchro des user :
		ON NE CREE PAS DE USER SI LE NOEUD N'EXISTE PAS
		s'il y a un noeud user on le synchronise via l'attribut login

	 * @param sFileName
	 * @param conn
	 * @return
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws ParserConfigurationException 
	 * @throws IOException 
	 * @throws SAXException 
	 * @throws Exception
	 */
	public Vector<JobExecutionException> synchroniserFichier(
			String sFileName,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
	IllegalAccessException, SAXException, IOException, ParserConfigurationException 
	{
		this.sFileName = sFileName;
		
		if(this.bDebug) System.out.println("synchroniser Fichier : " + sFileName);

		
		
		this.vException = new Vector<JobExecutionException>();
		this.bUsePreTreatmentMerger = Configuration.isEnabledMemory(CONFIGURATION_PARAM_USE_PRETRAITMENT_MERGER,false,conn);
		this.bAuthorizeRemove = Configuration.isEnabledMemory(CONFIGURATION_PARAM_SYNCHRO_AUTHORIZE_REMOVE,false,conn);
		this.sFamilleGroup = Configuration.getConfigurationValueMemory(CONFIGURATION_PARAM_SYNCHRO_GROUP_FAMILLE,"",conn);
		this.bAuthorizeInactivate = Configuration.isEnabledMemory(CONFIGURATION_PARAM_SYNCHRO_AUTHORIZE_INACTIVATE,false,conn);
		this.bRemoveTreatment = Configuration.isEnabledMemory(CONFIGURATION_PARAM_SYNCHRO_REMOVE_TREATMENT,false,conn);
		this.vGroup = Group.getAllStaticMemory(false, conn);
		this.tsPack = TenderSubscriptionPack.getAllStaticMemory(false, conn);
		this.iOrganizationCount = 0;
		this.iIndividualGlobalCount = 0;
		this.iUserGlobalCount = 0;
		
		
		/** parse xml */
		Document doc = BasicDom.parseXmlFileWithException(this.sPath + sFileName, false);
		
		if(this.bUsePreTreatmentMerger){
			mergeTreatment(doc, conn);
		}
		
		Node nodeOrganismesAImporter = BasicDom.getFirstChildElementNode(BasicDom.getFirstChildElementNode(doc));
		Node childFirstOrganisme = BasicDom.getFirstChildElementNode(nodeOrganismesAImporter);

		Vector<Organisation> vOrganisation = null;
		Vector<Adresse> vAdresseOrganisation = null;
		Vector<PersonnePhysique> vPersonne = null;
		Vector<Adresse> vAdressePersonne = null;
		Vector<Commission> vCommissionOrganisation = null;

		int iSizeBuffer = Configuration.getIntValueMemory("modula.system.cron.ImportCAJob.size.buffer", 100, conn);
		int iSizeCut = 3; 
		//iSizeBuffer = 1000;
		iSizeBuffer = 10;
		int j = iSizeBuffer ;

		long lCountOrga = 0;
		for (Node childOrganisme = childFirstOrganisme ; 
		childOrganisme != null; 
		childOrganisme = BasicDom.getNextSiblingElementNode(childOrganisme)) 
		{
			lCountOrga++ ;
		}
		
		System.out.println("iSizeBuffer : "   + iSizeBuffer);
		
		for (Node childOrganisme = childFirstOrganisme ; 
		childOrganisme != null; 
		childOrganisme = BasicDom.getNextSiblingElementNode(childOrganisme)) 
		{

			/**
			 * Pour les tests
			 */
			System.out.println("this.iOrganizationCount " + this.iOrganizationCount );
			System.out.println( this.iOrganizationCountInFile + " / " + lCountOrga );
			//if(this.iOrganizationCount > iSizeCut ) { break; }
			
		
			/**
			 * Optimisation : au lieu de faire une requete à chaque coup à la bdd 
			 * on crée un buffer de n organisations qui correspondent aux n reference_externe
			 * 
			 * on stocke les iSizeBuffer premières organisations du fichiers
			 * une fois ces iSizeBuffer organisations traitées,
			 * on re rempli le buffer avec les iSizeBuffer organisation suivantes
			 * 
			 * on crée un buffer de n personnes qui correspondent aux n reference_externe
			 * des personnes de chaque organisation
			 * 
			 * on crée un buffer de n user qui correspondent aux user
			 * de chaque personne
			 */
			CoinDatabaseWhereClause wc_pp =
				new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_STRING);
			CoinDatabaseWhereClause wc_org =
				new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_STRING);
			CoinDatabaseWhereClause wc_user =
				new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_STRING);
			CoinDatabaseWhereClause wc_com =
				new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_STRING);
			String sReferenceExterneOrg = "";
			j--;

			if(j <= 0 || vOrganisation == null)
			{
				j = iSizeBuffer ;
				int k = 0;
				for (Node childOrg = childOrganisme ; 
				childOrg != null; 
				childOrg = BasicDom.getNextSiblingElementNode(childOrg)) 
				{
					if(k++ > iSizeBuffer)  break;
					sReferenceExterneOrg = BasicDom.getChildNodeValueByNodeName(childOrg, "referenceExterne");
					wc_org.add(sReferenceExterneOrg );
					if(this.bDebug) System.out.println("sReferenceExterneOrg : " + sReferenceExterneOrg);
					
					if(sReferenceExterneOrg ==null){
						SAXException e = new SAXException("la référence externe est obligatoire pour l'organisation : "
								+ BasicDom.getChildNodeValueByNodeNameOptional(childOrg, "raisonSociale"));
						
						if(this.bDebug) e.printStackTrace();
						addException(e);
						continue;
					}
					
					try{
						Node nodePersonnesPhysiques
							= BasicDom.getChildNodeByNodeName(childOrg, "personnesPhysiques");
						
						for (
						Node childPers = BasicDom.getFirstChildElementNode(nodePersonnesPhysiques) ; 
						childPers != null; 
						childPers = BasicDom.getNextSiblingElementNode(childPers)) 
						{
							String sReferenceExternePP = BasicDom.getChildNodeValueByNodeName(childPers, "referenceExterne");
							if(sReferenceExternePP == null )
							{
								SAXException e = new SAXException("la référence externe de personnePhysique est obligatoire"
										+ " pour l'organisation ref : " + sReferenceExterneOrg);
								if(this.bDebug) e.printStackTrace();
								addException(e);
								continue;
							}
							
							wc_pp.add(sReferenceExternePP);
							try{
								Node nodeUser = BasicDom.getChildNodeByNodeName(childPers, "user");
								String sLogin = BasicDom.getChildNodeValueByNodeName(nodeUser, "login");
								wc_user.add(sLogin);
							}catch(SAXException se){/*pas de node user*/}

						} 
					}catch(SAXException se){/*pas de node personnesPhysiques*/}

					try{
						Node nodeCommissions = BasicDom.getChildNodeByNodeName(childOrg, "commissions");
						for (Node childCom = BasicDom.getFirstChildElementNode(nodeCommissions) ; 
						childCom != null; 
						childCom = BasicDom.getNextSiblingElementNode(childCom)) 
						{
							String sReferenceExterneCom = BasicDom.getChildNodeValueByNodeName(childCom, "referenceExterne");
							wc_com.add(sReferenceExterneCom);
						} 
					}catch(SAXException se){/*pas de node commissions*/}
				}



				/** 
				 * Optimisation 
				 */
				vOrganisation = optimizeOrganisation(wc_org, conn);
				vAdresseOrganisation = optimizeAdresse(wc_org, conn);

				vPersonne = optimizePersonnePhysique(wc_pp, conn);
				vAdressePersonne = optimizeAdressePersonne(wc_pp, conn);

				CoinDatabaseWhereClause wc_pp_id =
					new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
				wc_pp_id.addAll(vPersonne);

				/**
				 * BUG there is missing values in this list  @see #BUG_AG_IMPORT_CA_1#
				 * but ... I dont know if its a real bug
				 */
				this.vUser = optimizeUser(wc_user, wc_pp_id, vPersonne, conn);
				this.vUserGroup = optimizeUserGroup(this.vUser, conn);
				vCommissionOrganisation = optimizeCommission(wc_com, conn);

				/**
				 * Add also commission without ref ext
				 */
				
				Vector<Commission> vCommissionTotal = null;
				CoinDatabaseWhereClause wcCommission = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
				for (Organisation organisation : vOrganisation) {
					wcCommission.add(organisation.getId());
				}
				Commission comTotal = new Commission();
				vCommissionTotal = comTotal
					.getAllWithWhereAndOrderByClause(
							" WHERE " + wcCommission.generateWhereClause("id_organisation"),
							"",
							conn);
				
				vCommissionOrganisation.addAll(vCommissionTotal);
				
				
				if(this.bRemoveTreatment){
					removeItems(
							wc_org, 
							wc_pp_id, 
							wc_com, 
							conn);
				}
			}
			this.iOrganizationCountInFile++; 

			

			/** SYNCHRO */
			try{
				this.sRefExtOrg  = BasicDom.getChildNodeValueByNodeName(childOrganisme, "referenceExterne");
				
				if(this.bDebug) System.out.println("sRefExtOrg : " + sRefExtOrg);

				
				/**
				 * TODO_AG : its a rule for the affiches de grenoble
				 */
				String sIdOrganisationType
					= BasicDom.getChildNodeValueByNodeNameOptional(childOrganisme, "idOrganisationType");
				
				
				if(sIdOrganisationType != null )
				{
					if(sIdOrganisationType.equals("E"))
					{
						/**
						 * dont import the Entreprise with E code
						 */
						System.out.println("this.sRefExtOrg is E so continue : " + this.sRefExtOrg);
						continue;
					}
				} else {
				}
				
				/** organisation */
				Organisation organisationAImporter
					= synchronizeOrganisation(
							childOrganisme, 
							vOrganisation, 
							conn);
				
				this.iOrganizationCount++; 

				synchronizeAdresse(childOrganisme, organisationAImporter, vAdresseOrganisation, conn);
				synchronizeCommission(childOrganisme, organisationAImporter, vCommissionOrganisation, conn);

				synchronizeAllPersonnePhysique(
						organisationAImporter, 
						childOrganisme, 
						vPersonne, 
						vAdressePersonne, 
						conn);
					
				

				
			}catch(Exception e){
				if(this.bDebug) e.printStackTrace();
				addException(e);
			}
		}

		/** archivage */
		if(this.bArchiveFile && vException.size()==0 ){
			archiveFile(sFileName);
		}

		if(this.bDebug){
			displayImportFileReport();
		}

		return this.vException;
	}

	
	public String getImportFileReport()
	{
		return "\n\nImport report : "  + "\n"
			+ "iOrganizationCount                  : " + this.iOrganizationCount + "\n"
			+ "iOrganizationCountInFile            : " + this.iOrganizationCountInFile + "\n"
			+ "iIndividualGlobalCount              : " + this.iIndividualGlobalCount + "\n"
			+ "iIndividualGlobalCountInFile        : " + this.iIndividualGlobalCountInFile + "\n"
			+ "iUserGlobalCount                    : " + this.iUserGlobalCount + "\n";
	}
	
	public void displayImportFileReport()
	{
		System.out.println(getImportFileReport());
		System.out.flush();
	}
	
	private void addException(
			Exception e)
	{
		this.vException.add(new JobExecutionException("synchroniserFichier ("+this.sFileName
				+") : Import de l'organisation (ref. externe : "+ this.sRefExtOrg
				+") : "+e.getMessage()));
	}

	
	private void synchronizeAllPersonnePhysique(
			Organisation organisationAImporter,
			Node childOrganisme,
			Vector<PersonnePhysique> vPersonne ,
			Vector<Adresse> vAdressePersonne ,
			Connection conn) throws SAXException
	{
			Node nodePersonnesPhysiquesAImporter 
				= BasicDom.getChildNodeByNodeNameOrNull(childOrganisme, "personnesPhysiques");

			int iIndividualCount = 0;
			if(nodePersonnesPhysiquesAImporter == null) return;
			
			for(Node childPersonnePhysique = BasicDom.getFirstChildElementNode(nodePersonnesPhysiquesAImporter); 
			childPersonnePhysique != null; 
			childPersonnePhysique = BasicDom.getNextSiblingElementNode(childPersonnePhysique))
			{
				/** synchro personne */
				PersonnePhysique personnePhysiqueAImporter = null ;
				this.iIndividualGlobalCountInFile++;
				
				try{
					personnePhysiqueAImporter 
						= synchronizePersonnePhysique(
							childPersonnePhysique, 
							vPersonne, 
							conn);

					/**
					 * control if civilité exists
					 */
					try{
						personnePhysiqueAImporter.getCivilite(conn);
					} catch (CoinDatabaseLoadException e) {
						CoinDatabaseLoadException ee
							= new CoinDatabaseLoadException("Erreur dans la liste des personnes "
								+ "invalide civilité : '" + personnePhysiqueAImporter.getIdPersonnePhysiqueCivilite() + "'" 
								+ " pour : " + personnePhysiqueAImporter.getPrenomNom()
									+ " / " + personnePhysiqueAImporter.getEmail(), "");	
						
						addException(ee);
					}


					iIndividualCount++;
					this.iIndividualGlobalCount++;
					if(this.bDebug) System.out.println("personnePhysiqueAImporter : " 
							+ personnePhysiqueAImporter.getPrenomNom() 
							+ " " + personnePhysiqueAImporter.getEmail());

					/** synchro adresse */
					synchronizeAdresse(
							childPersonnePhysique, 
							personnePhysiqueAImporter, 
							organisationAImporter, 
							vAdressePersonne, 
							conn);

					
					synchroUser(
							childPersonnePhysique, 
							personnePhysiqueAImporter, 
							organisationAImporter, 
							conn);


				} catch(Exception e){
					if(this.bDebug) e.printStackTrace();
					addException(e);
				}
			}
			if(this.bDebug) System.out.println("iIndividualCount : " + iIndividualCount);

		
	}
	
	/**
	 * Règles de suppression : 
		- Une adresse ou contact peut être supprimé, pour répercuter cela
		dans Modula, la règle de gestion lors de la synchro est de supprimer une
		organisation (ou personne) dans Modula uniquement si elle n’apparait plus dans
		le fichier XML et qu’elle a une référence externe : on utilise un
		paramètre en table de conf pour autoriser la suppression ou non (modula.synchro.authorize.remove).

		Pour éviter de faire des erreurs irréversibles on ajoute un autre paramètre qui désactive
		seulement les users si le param de suppression est désactivé (modula.synchro.authorize.inactivate)
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 */
	private void removeItems(
			CoinDatabaseWhereClause wc_org,
			CoinDatabaseWhereClause wc_pp_id,
			CoinDatabaseWhereClause wc_com,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException
	{
		/**
		 * supression des organisations
		 * récupération des Organisation apparaissant dans le XML : wc_org
		 * récupération des Organisation apparaissant dans la bdd mais pas dans le XML
		 */
		this.removeOrganization(wc_org, this.bAuthorizeRemove, this.bAuthorizeInactivate, conn);

		/**
		 * supression des personnes
		 * récupération des PersonnePhysique apparaissant dans le XML : wc_pp
		 * récupération des PersonnePhysique apparaissant dans la bdd mais pas dans le XML
		 */
		this.removePersonnePhysique(wc_pp_id, this.bAuthorizeRemove, this.bAuthorizeInactivate, conn);

		/**
		 * supression des commissions
		 * récupération des PersonnePhysique apparaissant dans le XML : wc_pp
		 * récupération des PersonnePhysique apparaissant dans la bdd mais pas dans le XML
		 */
		this.removeCommission(wc_com, this.bAuthorizeRemove, conn);

		/**
		 * pas de supression des user
		 * il n'y a pas de ref_externe dans user
		 * on utilise le login pour la synchro
		 * 
		 * on ne peut donc pas se permettre 
		 * de supprimer tout les user qui ont un login qui n'est pas dans le fichier XML
		 */
	}

	
	private void synchroUser(
			Node childPersonnePhysique,
			PersonnePhysique personnePhysiqueAImporter,
			Organisation organisationAImporter,
			Connection conn)
	throws CoinDatabaseDuplicateException, CoinDatabaseCreateException, CoinDatabaseLoadException,
	NamingException, SQLException, InstantiationException, IllegalAccessException, 
	CoinDatabaseStoreException, CloneNotSupportedException
	{
		/** synchro user */
		User userAImporter = null;
		try{
			userAImporter = synchronizeUser(
					childPersonnePhysique, 
					personnePhysiqueAImporter, 
					organisationAImporter, 
					conn);

			/**
			 * No user in the XML
			 */
			if(userAImporter == null) return;
			
			/** 
			 * synchro famille et abonnements (a traiter comme les familles)
			 * 
			 * - Lors de la synchro des groupes, 
			 * on ne traite que les groupes qui appartiennent à la famille "Droits Plateforme DEMAT" (modula.synchro.group.famille)
			 * on ne traite pas les groupes qui n'existent pas dans le système (throw Exception)
			 * 		
			 * */
			if(this.bDebug) System.out.println("userAImporter : " + userAImporter.getLogin());
			this.iUserGlobalCount++;

			Vector<UserGroup> vUserGroupItem = UserGroup.getAllFromUser(userAImporter.getId(), this.vUserGroup);
			Vector<Group> vGroupImport = new Vector<Group>();

			/**
			 * Famille = coin_group dans Modula
			 * 
			 * 
			 */
			try{
				synchronizeFamille(
						childPersonnePhysique, 
						vGroupImport,
						this.vGroup);
			}catch (Exception e) {
				addException(e);
			}

			/**
			 * Abonnement = coin_group dans Modula
			 */
			try{
				synchronizeAbonnement(
						childPersonnePhysique, 
						vGroupImport,
						this.vGroup);
			}catch (Exception e) {
				addException(e);
			}
			
			/**
			 * presse
			 */
			try{
				synchronizePresse(
						childPersonnePhysique,
						personnePhysiqueAImporter,
						this.tsPack,
						conn);
			}catch (Exception e) {
				addException(e);
			}
			

			
			/**
			 * veille de marchés
			 */
			try{
				synchronizeVeilleMarche(
						childPersonnePhysique,
						personnePhysiqueAImporter,
						conn);
			}catch (Exception e) {
				e.printStackTrace();
				addException(e);
			}
			
			/** 
			 * il faut supprimer les groupes qui n'existent plus dans le fichier 
			 * on ne traite que ceux qui ont une reference externe
			 * on ne traite que ceux dont la référence contient : 
			 * 	FAM-
			 * 	ABO-
			 */
			
			boolean bSynchronizeGroupWithoutExternalReference = false;
			synchronizeGroup(
					userAImporter, 
					vUserGroupItem, 
					vGroupImport, 
					g_sSynchronizeGroupWithReferencePrefix, 
					bSynchronizeGroupWithoutExternalReference, 
					conn);

			
			if(organisationAImporter.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC)
			{
				/**
				 * add the basic roles
				 * 
				 * 31 : G-Gestionnaire des aides rédactionnelles de son organisme
 				 * 25 : P-AP-Gestionnaire de l'acheteur public (Niveau2)
				 * 1  : Utilisateur du DESK

				 */
				int[] larrBasicGroup = new int[] {1, 25, 31};

				for (int i = 0; i < larrBasicGroup.length; i++) {
					boolean bGroupExist = false;
					for(UserGroup ugrp : vUserGroupItem){
						Group gp = (Group)Group.getCoinDatabaseAbstractBeanFromId(ugrp.getIdCoinGroup(), this.vGroup);
						if(gp.getId() == larrBasicGroup[i]) {
							bGroupExist = true;
						}
					}
					
					if(!bGroupExist)
					{
						UserGroup ug = new UserGroup();
						ug.setIdCoinUser(userAImporter.getId());
						ug.setIdCoinGroup(larrBasicGroup[i]);
						ug.create(conn);
						
						vUserGroupItem.add(ug);
					}
					
				}
				
			}
			
		} catch (SAXException e) {
			addException(e);
		}
	}
	private void removeOrganization(
			CoinDatabaseWhereClause wc_org,
			boolean bAuthorizeRemove,
			boolean bAuthorizeInactivate,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException{
		Vector<Organisation> vOrganisation_not_in = null;
		String sWhereClause = " WHERE reference_externe IS NOT NULL" +
		" AND TRIM(reference_externe) <> ''"+
		" AND "+ wc_org.generateWhereNotClause("reference_externe");

		Organisation org_not_in = new Organisation();
		org_not_in.bUseHttpPrevent = false;
		vOrganisation_not_in = org_not_in.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);

		for (Organisation org_del : vOrganisation_not_in) {
			if (bAuthorizeRemove){
				System.out.println("remove organisation (ref externe):" + org_del.getReferenceExterne());
				//org_del.removeWithObjectAttached();
			}else if(bAuthorizeInactivate){
				System.out.println("inactivate organisation (ref externe):" + org_del.getReferenceExterne());
				User.updateAllInactiveFromNotOrganisation(wc_org, conn);
			}
		}
	}

	private void removePersonnePhysique(
			CoinDatabaseWhereClause wc_pp,
			boolean bAuthorizeRemove,
			boolean bAuthorizeInactivate,
			Connection conn) 
	throws SQLException, InstantiationException, IllegalAccessException{
		Vector<PersonnePhysique> vPersonne_not_in = null;
		String sWhereClause = " WHERE reference_externe IS NOT NULL" +
		" AND TRIM(reference_externe) <> ''"+
		" AND "+ wc_pp.generateWhereNotClause("reference_externe");

		PersonnePhysique pp_not_in = new PersonnePhysique();
		pp_not_in.bUseHttpPrevent = false;
		vPersonne_not_in = pp_not_in.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);

		for (PersonnePhysique pp_del : vPersonne_not_in) {
			if (bAuthorizeRemove){
				System.out.println("remove personne (ref externe):" + pp_del.getReferenceExterne());
				//pp_del.removeWithObjectAttached();
			}else if(bAuthorizeInactivate){
				System.out.println("inactivate personne (ref externe):" + pp_del.getReferenceExterne());
				User.updateAllInactiveFromNotPersonne(wc_pp, conn);
			}
		}
	}

	private void removeCommission(
			CoinDatabaseWhereClause wc_com,
			boolean bAuthorizeRemove,
			Connection conn) 
	throws SQLException, InstantiationException, IllegalAccessException{
		Vector<Commission> vCommission_not_in = null;
		String sWhereClause = " WHERE reference_externe IS NOT NULL" +
		" AND TRIM(reference_externe) <> ''"+
		" AND "+ wc_com.generateWhereNotClause("reference_externe");

		Commission com_not_in = new Commission();
		com_not_in.bUseHttpPrevent = false;
		vCommission_not_in = com_not_in.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);

		for (Commission com_del : vCommission_not_in) {
			if (bAuthorizeRemove){
				System.out.println("remove commission (ref externe):" + com_del.getReferenceExterne());
				//com_del.removeWithObjectAttached();
			}
		}
	}

	
	/**
	 *     
	 *     <familles>
                <famille name="Droits Plateforme DEMAT">
                    <famille name="RA" code="RA" />
                </famille>
            </familles>
	 * 
	 * 
	 * @param childPersonnePhysique
	 * @param vGroupImport
	 * @param vGroupAll
	 * @throws CoinDatabaseLoadException
	 * @throws SAXException
	 */
	private void synchronizeFamille(
			Node childPersonnePhysique,
			Vector<Group> vGroupImport,
			Vector<Group> vGroupAll) 
	throws CoinDatabaseLoadException, SAXException{
		Node nodeFamilles = BasicDom.getChildNodeByNodeNameOrNull(childPersonnePhysique, "familles");
		
		if(nodeFamilles == null) return ;
		
		for(Node childFamilleGroup = BasicDom.getFirstChildElementNode(nodeFamilles);
		childFamilleGroup!=null;
		childFamilleGroup= BasicDom.getNextSiblingElementNode(childFamilleGroup))
		{
			if(this.bDebug) System.out.println("synchronizeFamille: start");
			
			/**
			 * For example "Droits Plateforme DEMAT"
			 */
			String sFamilleGroupName 
				= BasicDom.getChildNodeAttributeValueByAttributeName(childFamilleGroup, "name");
			
			
			if (sFamilleGroupName.equalsIgnoreCase(this.sFamilleGroup)){
				
				for(Node childFamille = BasicDom.getFirstChildElementNode(childFamilleGroup);
				childFamille!=null;
				childFamille= BasicDom.getNextSiblingElementNode(childFamille))
				{
					String sRefExterne = BasicDom.getChildNodeAttributeValueByAttributeName(childFamille, "code");
					String sName = BasicDom.getChildNodeAttributeValueByAttributeName(childFamille, "name");
					if(this.bDebug) System.out.println("sRefExterne Famille : " + sRefExterne);
					
					if(sRefExterne == null 
					|| sRefExterne.equals("")) 
					{
						BasicDom.getChildNodeByNodeNameOrNull(childPersonnePhysique, "familles");
						
						PersonnePhysique personne = new PersonnePhysique();
						personne.deserialize(childPersonnePhysique);
						
						
						CoinDatabaseLoadException le = new CoinDatabaseLoadException(
								" for indidivual " 
								+ personne.getPrenomNom() + " / " + personne.getEmail() 
								+ " code famille cannot be null or empty for famille name='" + sName + "'","");
						addException(le);
						continue;
					}
					
					try{
						Group group = Group.getGroupFromReferenceExterne(sRefExterne,this.vGroup);
						if(this.bDebug) System.out.println("Group:"+group.getName());
						vGroupImport.add(group);
					}catch(CoinDatabaseLoadException le){
						addException(le);
					}
				}
			}
			
		}
	}

	/**
	 * 
	 *  <presse>
			<edition>D</edition>
		</presse>                         

	 * 
	 * 
	 * 
	 * @param childPersonnePhysique
	 * @param vGroupImport
	 * @throws SAXException
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws CoinDatabaseDuplicateException 
	 * @throws CoinDatabaseCreateException 
	 * @throws CoinDatabaseLoadException 
	 * @throws CoinDatabaseStoreException 
	 */
	private void synchronizePresse(
			Node childPersonnePhysique,
			PersonnePhysique personnePhysiqueAImporter,
			Vector<TenderSubscriptionPack> vPack,
			Connection conn)
	throws SAXException, CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException,
	SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseStoreException{
		if(this.bDebug) System.out.println("synchronizePresse: start");
		Node nodePresse = BasicDom.getChildNodeByNodeNameOrNull(childPersonnePhysique, "presse");
		if(nodePresse == null) return;
		Node nodeEdition = BasicDom.getChildNodeByNodeName(nodePresse, "edition");
		
		String sCodeEdition = BasicDom.getElementValue(nodeEdition);
		TenderSubscriptionPack pack 
			= TenderSubscriptionPack.getTenderSubscriptionPackFromReference(sCodeEdition, vPack);
		
		PersonnePhysiqueParametre.updateValue(
				personnePhysiqueAImporter.getId(),
				VeilleMarcheAbonnes.INDIVIDUAL_PARAM_VEILLE_DEPARTEMENT_COUNT, 
				""+pack.getMarketWatchRegionCountMax(), 
				conn);
		
		PersonnePhysiqueParametre.updateValue(
				personnePhysiqueAImporter.getId(),
				VeilleMarcheAbonnes.INDIVIDUAL_PARAM_DISPLAY_DEPARTEMENT_COUNT, 
				""+pack.getMarketViewRegionCountMax(), 
				conn);
		
		
		
		
		PersonnePhysiqueParametre.updateValue(
				personnePhysiqueAImporter.getId(),
				VeilleMarcheAbonnes.INDIVIDUAL_PARAM_VEILLE_ACTIVITY_COUNT,
				""+pack.getMarketWatchActivityCountMax(), 
				conn);
		
		PersonnePhysiqueParametre.updateValue(
				personnePhysiqueAImporter.getId(),
				VeilleMarcheAbonnes.INDIVIDUAL_PARAM_DISPLAY_ACTIVITY_COUNT,
				""+pack.getMarketViewActivityCountMax(), 
				conn);
	}

	
	/**
	 * 
	 * 	<veilleMarche>
			<listeDepartement>
				<departement>12</departement>
				<departement>83</departement>
			</listeDepartement>
			<listeCodeAffichesGrenoble>
				<code>12</code>
				<code>83</code>
			</listeCodeAffichesGrenoble>
			<listeCodeCPF>
				<code>22</code>
				<code>45</code>
			</listeCodeCPF>
			<listeEmail>
				<email>david@leboulet.c.balo</email>
				<email>david@c.balo</email>
			</listeEmail>
			<listeMotCle operand="and">
				<motCle>sidérurgie</motCle>
				<motCle>ravalement</motCle>
			</listeMotCle>
		</veilleMarche>

	 * 
	 * 
	 * @param childPersonnePhysique
	 * @param vGroupImport
	 * @throws SAXException
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws CoinDatabaseDuplicateException 
	 * @throws CoinDatabaseLoadException 
	 * @throws CoinDatabaseCreateException 
	 * @throws CoinDatabaseStoreException 
	 */
	private void synchronizeVeilleMarche(
			Node childPersonnePhysique,
			PersonnePhysique personnePhysiqueAImporter,
			Connection conn)
	throws SAXException, CoinDatabaseDuplicateException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException, CoinDatabaseCreateException, CoinDatabaseLoadException, CoinDatabaseStoreException{
		if(this.bDebug) System.out.println("synchronizeVeilleMarche: start");
		
		PersonnePhysique personne = new PersonnePhysique();
		personne.deserialize(childPersonnePhysique);
		
		Node nodeVeilleMarche = BasicDom.getChildNodeByNodeNameOrNull(childPersonnePhysique, "veilleMarche");
		if(nodeVeilleMarche == null) return;

		Node nodeListeDepartement = BasicDom.getChildNodeByNodeNameOrNull(nodeVeilleMarche, "listeDepartement");
		Node nodeListeCodeAffichesGrenoble = BasicDom.getChildNodeByNodeNameOrNull(nodeVeilleMarche, "listeCodeAffichesGrenoble");
		Node nodeListeCodeCPF = BasicDom.getChildNodeByNodeNameOrNull(nodeVeilleMarche, "listeCodeCPF");
		Node nodeListeEmail = BasicDom.getChildNodeByNodeNameOrNull(nodeVeilleMarche, "listeEmail");
		Node nodeListeMotCle = BasicDom.getChildNodeByNodeNameOrNull(nodeVeilleMarche, "listeMotCle");
		
		VeilleMarcheAbonnes veilleMarcheAbonnes = null;
		boolean bVeilleMarche = false;
		try{
			veilleMarcheAbonnes 
				= VeilleMarcheAbonnes.getVeilleMarcheAbonnesFromPersonnePhysique(
						personnePhysiqueAImporter.getIdPersonnePhysique(),
						conn);
			bVeilleMarche = true;
		}catch(CoinDatabaseLoadException e){
			veilleMarcheAbonnes = new VeilleMarcheAbonnes();
			veilleMarcheAbonnes.setIdPersonnePhysique(personnePhysiqueAImporter.getIdPersonnePhysique());
		}
		
		if(this.bDebug) System.out.println("veilleMarcheAbonnes id :"+veilleMarcheAbonnes.getId());
		/**
		 * Departement
		 */
		if(nodeListeDepartement != null)
		{
			ArrayList<String> listeDepartement = new ArrayList<String>();
			for(Node item = BasicDom.getFirstChildElementNode(nodeListeDepartement);
			item!=null;
			item = BasicDom.getNextSiblingElementNode(item))
			{
				String sValDept = BasicDom.getElementValue(item);
				if(sValDept.length() == 1) sValDept = "0" + sValDept; 
				listeDepartement.add(sValDept);
			}
			
			if(this.bDebug){
				System.out.print("listeDepartement : ");
				for (String i : listeDepartement) {
					System.out.print( i + ",");
				}
				System.out.println();
			}
			
			veilleMarcheAbonnes.updateDepartement(listeDepartement,true,conn);
		}
		
		
		/**
		 * Traitement global des codes de compétences
		 */
		CodeCpfSwitcher cpfSwitcher = new CodeCpfSwitcher(
				ObjectType.PERSONNE_PHYSIQUE,
				personnePhysiqueAImporter.getIdPersonnePhysique(),
				conn);
		
		/**
		 * Code Affiches Grenoble
		 */
		int [] listeGroupCompetences = null;
		try{
			listeGroupCompetences 
				= getListIdCodeCpfGroup(
						nodeListeCodeAffichesGrenoble, 
						conn);
			
			cpfSwitcher.updateGroupCPFSelectedItems(listeGroupCompetences, conn);

			if(this.bDebug)
			{
				System.out.print("listeGroupCompetences : ");
				for (int i : listeGroupCompetences) {
					System.out.print( i + ",");
				}
				System.out.println();

			}
			


		} catch (Exception e) {
			CoinDatabaseCreateException ce 
				= new CoinDatabaseCreateException(
					" pour " + personne.getPrenomNom() 
					+ " / " + personne.getEmail() 
					+ " / " + personne.getReferenceExterne()
					+ e.getMessage());
			
			addException(ce);
		}

		/**
		 * Code CPF
		 */
		if(nodeListeCodeCPF != null)
		{
			int iLenMax = 100; 
			int[] listeListeCodeCPFTemp = new int[iLenMax];
			int iIdxComp = 0;
			for(Node item = BasicDom.getFirstChildElementNode(nodeListeCodeCPF);
			item!=null;
			item = BasicDom.getNextSiblingElementNode(item))
			{
				listeListeCodeCPFTemp[iIdxComp] = Integer.parseInt(BasicDom.getElementValue(item));
				iIdxComp++;
			}
			
			/**
			 * put in a good length array
			 */
			int[] listeListeCodeCPF = new int[iIdxComp];
			for (int i =0 ; i < listeGroupCompetences.length; i++) {
				listeListeCodeCPF [i] = listeListeCodeCPFTemp[i];
			}
			
			if(this.bDebug){
				System.out.print("listeListeCodeCPF : ");
				for (int i : listeListeCodeCPF) {
					System.out.print( i + ",");
				}
				System.out.println();
			}
			
			

			
			if (listeListeCodeCPF != null && listeListeCodeCPF.length>0)
			{ 
				if(cpfSwitcher.isUseCPFGroup()){
					if(listeListeCodeCPF == null || listeListeCodeCPF.length<=0){
						/**
			             * on les supprime tous
			             */
			             cpfSwitcher.removeAllGroupCPFItems();
					}
				}
				
				cpfSwitcher.updateCPFSelectedItems(listeGroupCompetences,listeListeCodeCPF, conn);
			}else{
	            /**
	             * on les supprime tous
	             */
	             cpfSwitcher.removeAllBoampCPFItems();
	        }
		}		
		
		
		
		/**
		 * Email
		 */
		if(nodeListeEmail != null)
		{
			ArrayList<String> listeEmail = new ArrayList<String>();
			for(Node item = BasicDom.getFirstChildElementNode(nodeListeEmail);
			item!=null;
			item = BasicDom.getNextSiblingElementNode(item))
			{
				listeEmail.add(BasicDom.getElementValue(item));
			}
			if(this.bDebug){
				System.out.print("listeEmail : ");
				for (String i : listeEmail) {
					System.out.print( i + ",");
				}
				System.out.println();

			}
			
			veilleMarcheAbonnes.updateMail(listeEmail,true,conn);
		}
		
		boolean bEquals = true;
		/**
		 * Mot cle
		 */
		if(nodeListeMotCle != null)
		{
			String sTypeKeyWord = BasicDom.getChildNodeAttributeValueByAttributeName(nodeListeMotCle, "operand");
			veilleMarcheAbonnes.updateKeyWordSearchType(sTypeKeyWord.toLowerCase(),true, conn);
			if(this.bDebug) System.out.println("sTypeKeyWord : "+sTypeKeyWord);
			
			String sKeyWord = "";
			for(Node item = BasicDom.getFirstChildElementNode(nodeListeMotCle);
			item!=null;
			item = BasicDom.getNextSiblingElementNode(item))
			{
				sKeyWord += BasicDom.getElementValue(item)+" ";
			}
		    if(this.bDebug) System.out.println("sKeyWord : "+sKeyWord);

		    /**
		     * control if update is really needed
		     */
		    VeilleMarcheAbonnes veilleMarcheAbonnesTmp = new VeilleMarcheAbonnes();
		    veilleMarcheAbonnesTmp.setKeyWord(sKeyWord);
		    veilleMarcheAbonnesTmp.cleanKeyWord();

		    if(!veilleMarcheAbonnesTmp.getKeyWord().equals(veilleMarcheAbonnesTmp.getKeyWord()))
		    {
		    	bEquals = false;
		    }
		    veilleMarcheAbonnesTmp.setKeyWord(sKeyWord);
		    veilleMarcheAbonnesTmp.cleanKeyWord();

		}
		
	    /**
	     * update
	     */
		try{
			if(bVeilleMarche){
				if(!bEquals){
					veilleMarcheAbonnes.store(conn);
				}
			}else{
				veilleMarcheAbonnes.create(conn);
			}
		} catch (Exception e) {
			CoinDatabaseCreateException ee =
				new CoinDatabaseCreateException("Impossible d'enregister cette veille de marchés"
					+ " keyword : \"" + veilleMarcheAbonnes.getKeyWord() + "\"" ,"");
			addException(ee);
		}
		
	}
	
	public static int[] getListIdCodeCpfGroup(
			Node nodeListeCodeAffichesGrenoble,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		
		//System.out.println("nodeListeCodeAffichesGrenoble : " + BasicDom.getXML(nodeListeCodeAffichesGrenoble));

		int[] listeGroupCompetences = null;
		if(nodeListeCodeAffichesGrenoble != null)
		{
			int iLenMax = 100; 
			int[] listeGroupCompetencesTemp = new int[iLenMax];
			
			Vector<CodeCpfGroup> vCodeCpfGroup = CodeCpfGroup.getAllStaticMemory(false, true, conn) ;
			int iIdxGroupComp = 0;
			for(Node item = BasicDom.getFirstChildElementNode(nodeListeCodeAffichesGrenoble);
			item!=null;
			item = BasicDom.getNextSiblingElementNode(item))
			{
				String sVal = BasicDom.getElementValue(item).trim();
				try{
					CodeCpfGroup codeCpfGroup = CodeCpfGroup.getCodeCpfGroupFromReferenceExterne(sVal, vCodeCpfGroup);
					listeGroupCompetencesTemp[iIdxGroupComp] = (int)codeCpfGroup.getId();
					iIdxGroupComp++;
				} catch (NumberFormatException e) {
					//e.printStackTrace();
					
					
					throw new CoinDatabaseLoadException(
							" la balise listeCodeAffichesGrenoble/code doit être un nombre"
							+ " ou n'est pas connue du système : "
							+ sVal, sVal)
							;
					
				}
			}
			
			/**
			 * put in a good length array
			 */
			listeGroupCompetences = new int[iIdxGroupComp];
			for (int i =0 ; i < listeGroupCompetences.length; i++) {
				listeGroupCompetences [i] = listeGroupCompetencesTemp[i];
			}

		}
		
		return listeGroupCompetences;
	}
	
	private void synchronizeAbonnement(
			Node childPersonnePhysique,
			Vector<Group> vGroupImport,
			Vector<Group> vGroupAll)
	throws SAXException{
		if(this.bDebug) System.out.println("synchronizeAbonnement: start");
		Node nodeAbonnements = BasicDom.getChildNodeByNodeNameOrNull(childPersonnePhysique, "abonnements");
		
		if(nodeAbonnements == null) return;
		
		for(Node childAbonnement = BasicDom.getFirstChildElementNode(nodeAbonnements);
		childAbonnement!=null;
		childAbonnement = BasicDom.getNextSiblingElementNode(childAbonnement))
		{

			String sRefExterne = BasicDom.getChildNodeAttributeValueByAttributeName(childAbonnement, "codeTitre");
			Timestamp tsDateDebut = BasicDom.getChildNodeValueXmlDateStampByNodeName(childAbonnement, "dateDebut");
			Timestamp tsDateFin = BasicDom.getChildNodeValueXmlDateStampByNodeName(childAbonnement, "dateFin");
			Timestamp tsNow = CalendarUtil.now();
			if(tsNow.after(tsDateDebut) && tsNow.before(tsDateFin)){
				try{
					Group group = Group.getGroupFromReferenceExterne(sRefExterne,vGroupAll);
					vGroupImport.add(group);
				}catch(CoinDatabaseLoadException le){
					/*le groupe spécifié est inconnu*/
					addException(le);
				}
			}
		}
	}

	/**
	 * 
	 * ajout/modif/suppression des groups
	 * 
	 * 
	 * @param userAImporter
	 * @param vUserGroupItem
	 * @param vGroupImport
	 * @param sSynchronizeGroupWithReferencePrefix
	 * @param bSynchronizeGroupWithoutExternalReference
	 * @param conn
	 * @throws SQLException
	 * @throws NamingException
	 * @throws CoinDatabaseCreateException
	 * @throws CoinDatabaseDuplicateException
	 * @throws CoinDatabaseLoadException
	 */
	private void synchronizeGroup(
			User userAImporter,
			Vector<UserGroup> vUserGroupItem,
			Vector<Group> vGroupImport,
			String[] sSynchronizeGroupWithReferencePrefix,
			boolean bSynchronizeGroupWithoutExternalReference,
			Connection conn
	) 
	throws SQLException, NamingException, CoinDatabaseCreateException, CoinDatabaseDuplicateException,
	CoinDatabaseLoadException{

		/**
		 * on traite les suppressions de groupe 
		 */
		for(UserGroup ugrp : vUserGroupItem){
			boolean bGroupExist = false;
			Group gp = (Group)Group.getCoinDatabaseAbstractBeanFromId(ugrp.getIdCoinGroup(), this.vGroup);

			/** 
			 * on ne supprime pas les groupes qui n'ont pas de référence externe 
			 * 
			 * c'est par défaut les groupes de Modula qui ne sont pas synchronisé avec une
			 * autre BDD
			 */
			if(!bSynchronizeGroupWithoutExternalReference 
			&& Outils.isNullOrBlank(gp.getReferenceExterne()))
				bGroupExist = true;

			/** 
			 * on ne supprime que les groupes qui ont une référence contenue dans la liste en paramètre 
			 */
			if(!bGroupExist
			&& sSynchronizeGroupWithReferencePrefix != null
			&& sSynchronizeGroupWithReferencePrefix.length > 0
			&& StringUtils.indexOfAny(gp.getReference(), sSynchronizeGroupWithReferencePrefix)<0)
				bGroupExist = true;

			if(!bGroupExist){
				for(Group grp : vGroupImport){
					if(ugrp.getIdCoinGroup()==grp.getId())
						bGroupExist = true;
				}
			}

			if(!bGroupExist)
				ugrp.remove(conn);
		}
		
		/**
		 * on traite les ajouts
		 */
		for(Group grp : vGroupImport){
			/**
			 * si groupe existe alors on ne fait rien
			 * si groupe n'existe pas on l'ajoute
			 */
			boolean bGroupExist = false;
			for(UserGroup ugrp : vUserGroupItem){
				if(ugrp.getIdCoinGroup()==grp.getId())
					bGroupExist = true;
			}
			if(!bGroupExist){
				UserGroup ugrp = new UserGroup();
				ugrp.setIdCoinGroup(grp.getId());
				ugrp.setIdCoinUser(userAImporter.getId());
				ugrp.create(conn);
			}
		}
	}

	private Organisation synchronizeOrganisation(
			Node childOrganisme,
			Vector<Organisation> vOrganisation,
			Connection conn) 
	throws CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, 
	SAXException, InstantiationException, IllegalAccessException, NamingException, SQLException,
	CoinDatabaseStoreException, CloneNotSupportedException 
	{
		return Organisation.synchronize(
				childOrganisme,
				this.sPath, 
				vOrganisation,
				this.bCreateOrganizationCheckDuplicate,
				this.bCreateParamWebServiceSync,
				conn);
	}

	private void synchronizeAdresse(
			Node childOrganisme,
			Organisation organisationAImporter,
			Vector<Adresse> vAdresseOrganisation,
			Connection conn
	) 
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException,
	SQLException, NamingException, SAXException, CoinDatabaseStoreException 
	{
		Node nodeAdresseOrganisme = BasicDom.getChildNodeByNodeName(childOrganisme, "adresse");
		Adresse adresse = Adresse.synchroniser(
				nodeAdresseOrganisme, 
				organisationAImporter.getIdAdresse(),
				vAdresseOrganisation,
				conn);
		
		if(organisationAImporter.getIdAdresse() != adresse.getIdAdresse()){
			organisationAImporter.setIdAdresse(adresse.getIdAdresse());
			organisationAImporter.store(conn);
		}
	}

	private void synchronizeCommission(
			Node childOrganisme,
			Organisation organisationAImporter,
			Vector<Commission> vCommissionOrganisation,
			Connection conn)
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException,
	SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseStoreException,
	SAXException 
	{
		
		/**
		 * Create a first commission if necessary
		 */
		
		Vector<Commission> vCommission = 
			Commission.getAllcommissionWithIdOrganisation(
					organisationAImporter.getIdOrganisation(), 
					vCommissionOrganisation);
		
		
		if(organisationAImporter.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC
		&& vCommission.size() == 0)
		{
			/**
			 * Create a commission
			 * 
			 */
			Commission commission = new Commission();
			commission.setNom("Commission d'Appel d'Offres");
			commission.setIdOrganisation(organisationAImporter.getIdOrganisation());
			commission.create(conn);
			vCommissionOrganisation.add(commission);
		}
		
		
		
		Node nodeCommissionsAImporter = BasicDom.getChildNodeByNodeNameOrNull(childOrganisme, "commissions");

		if(nodeCommissionsAImporter == null) return;

		if(organisationAImporter.getIdOrganisationType() != OrganisationType.TYPE_ACHETEUR_PUBLIC)
		{
			throw new CoinDatabaseCreateException(
					"Il ne peut pas exister de noeud commissions pour ce type d'organisation : "
					+ organisationAImporter.getRaisonSociale() 
					+ " ref " + organisationAImporter.getReferenceExterne() ,"");
		}


		
		
		
		
		for(Node childCommission = BasicDom.getFirstChildElementNode(nodeCommissionsAImporter); 
		childCommission != null; 
		childCommission = BasicDom.getNextSiblingElementNode(childCommission))
		{
			Commission commissionAImporter 
				= Commission.synchroniser(
					childCommission,
					organisationAImporter.getIdOrganisation(),
					vCommission,
					conn); 
			
			if(commissionAImporter.getIdOrganisation() != organisationAImporter.getIdOrganisation()){
				commissionAImporter.setIdOrganisation(organisationAImporter.getIdOrganisation());
				commissionAImporter.store(conn);
			}	
		}
	}

	private PersonnePhysique synchronizePersonnePhysique(
			Node childPersonnePhysique,
			Vector<PersonnePhysique> vPersonne,
			Connection conn)
	throws CoinDatabaseDuplicateException, CoinDatabaseLoadException, CoinDatabaseCreateException,
	InstantiationException, NamingException, SAXException, IllegalAccessException, SQLException,
	CoinDatabaseStoreException, CloneNotSupportedException{
		return PersonnePhysique.synchroniser(
				childPersonnePhysique,
				vPersonne,
				this.bCreateIndividualCheckDuplicate,
				this.bCreateParamWebServiceSync,
				conn);
	}

	private void synchronizeAdresse(
			Node childPersonnePhysique,
			PersonnePhysique personnePhysiqueAImporter,
			Organisation organisationAImporter,
			Vector<Adresse> vAdressePersonne,
			Connection conn) 
	throws SAXException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException,
	SQLException, NamingException, CoinDatabaseStoreException{
		Node nodeAdressePersonnePhysique = BasicDom.getChildNodeByNodeName(childPersonnePhysique, "adresse");
		Adresse adressePP = Adresse.synchroniser(
				nodeAdressePersonnePhysique, 
				personnePhysiqueAImporter.getIdAdresse(),
				vAdressePersonne,
				conn);

		/** on met à jour la personne */
		if(personnePhysiqueAImporter.getIdAdresse() != adressePP.getIdAdresse()
		|| personnePhysiqueAImporter.getIdOrganisation() != organisationAImporter.getIdOrganisation())
		{
			personnePhysiqueAImporter.setIdOrganisation(organisationAImporter.getIdOrganisation());
			personnePhysiqueAImporter.setIdAdresse(adressePP.getIdAdresse());
			personnePhysiqueAImporter.store(conn);	
		}
	}

	private User synchronizeUser(
			Node childPersonnePhysique,
			PersonnePhysique personnePhysiqueAImporter,
			Organisation organisationAImporter,
			Connection conn)
	throws SAXException, CoinDatabaseDuplicateException, CoinDatabaseCreateException,
	CoinDatabaseLoadException, NamingException, SQLException, InstantiationException,
	IllegalAccessException, CoinDatabaseStoreException, CloneNotSupportedException
	{
		Node nodeUserPersonnePhysique = BasicDom.getChildNodeByNodeNameOrNull(childPersonnePhysique, "user");

		
		/**
		 * No user tag
		 */
		if(nodeUserPersonnePhysique == null) return null;
		
		User userAImporter = User.synchronize(
				nodeUserPersonnePhysique,
				this.vUser,
				personnePhysiqueAImporter.getId(),
				conn); 
		
		if(userAImporter.getIdIndividual() != personnePhysiqueAImporter.getId()){
			userAImporter.setIdIndividual((int)personnePhysiqueAImporter.getId());
		}
		
		boolean bEquals = true;
		switch (organisationAImporter.getIdOrganisationType()) {
		case OrganisationType.TYPE_ACHETEUR_PUBLIC:
			if(userAImporter.getIdUserType() != UserType.TYPE_PRM)
			{
				userAImporter.setIdUserType(UserType.TYPE_PRM);
				bEquals = false;
			}
			break;
		case OrganisationType.TYPE_CANDIDAT:
			if(userAImporter.getIdUserType() != UserType.TYPE_CANDIDAT)
			{
				userAImporter.setIdUserType(UserType.TYPE_CANDIDAT);
				bEquals = false;
			}
			break;

		default:
			break;
		}
		if(!bEquals ) userAImporter.store(conn);
		

		return userAImporter;
	}

	private Vector<Organisation> optimizeOrganisation(
			CoinDatabaseWhereClause wc_org,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException{
		String sWhereClause = " WHERE " + wc_org.generateWhereClause("reference_externe") ;
		Organisation org = new Organisation();
		org.bUseHttpPrevent = false;
		return org.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);
	}

	private Vector<Adresse> optimizeAdresse(
			CoinDatabaseWhereClause wc_org,
			Connection conn)
			throws SQLException, InstantiationException, IllegalAccessException{
		Adresse adrorg = new Adresse();
		adrorg.bUseHttpPrevent = false;
		return adrorg.getAllWithWhereAndOrderByClause(
				"adresse.", 
				",organisation"+
				" WHERE organisation.id_adresse = adresse.id_adresse"+
				" AND "+wc_org.generateWhereClause("organisation.reference_externe") , 
				"", 
				conn);
	}

	private Vector<PersonnePhysique> optimizePersonnePhysique(
			CoinDatabaseWhereClause wc_pp,
			Connection conn) 
			throws SQLException, InstantiationException, IllegalAccessException{
		String sWhereClause = " WHERE " + wc_pp.generateWhereClause("reference_externe") ;
		PersonnePhysique pers = new PersonnePhysique();
		pers.bUseHttpPrevent = false;
		return pers.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);	
	}

	private Vector<Adresse> optimizeAdressePersonne(
			CoinDatabaseWhereClause wc_pp,
			Connection conn) 
			throws SQLException, InstantiationException, IllegalAccessException{
		Adresse adrpp = new Adresse();
		adrpp.bUseHttpPrevent = false;
		return adrpp.getAllWithWhereAndOrderByClause(
				"adresse.", 
				",personne_physique"+
				" WHERE personne_physique.id_adresse = adresse.id_adresse"+
				" AND "+wc_pp.generateWhereClause("personne_physique.reference_externe") , 
				"", 
				conn);
	}

	private Vector<User> optimizeUser(
			CoinDatabaseWhereClause wc_user,
			CoinDatabaseWhereClause wc_pp_id,
			Vector<PersonnePhysique> vPersonne,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException
	{
		String sWhereClause = " WHERE " + wc_user.generateWhereClause("login") ;
		User user = new User();
		user.bUseHttpPrevent = false;
		
		Vector<User> vUser = user.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);	

		sWhereClause = " WHERE " + wc_pp_id.generateWhereClause("id_individual") ;
		Vector<User> vUserId = user.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);	
		CoinDatabaseUtil.merge(vUserId, vUser);

		return vUser;
	}

	private Vector<UserGroup> optimizeUserGroup(
			Vector<User> vUser,
			Connection conn) 
			throws SQLException, InstantiationException, IllegalAccessException{
		CoinDatabaseWhereClause wc_user_id =
			new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		wc_user_id.addAll(vUser);
		String sWhereClause = " WHERE " + wc_user_id.generateWhereClause("id_coin_user") ;
		UserGroup grp = new UserGroup();
		grp.bUseHttpPrevent = false;
		return grp.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);	
	}

	private Vector<Commission> optimizeCommission(
			CoinDatabaseWhereClause wc_com,
			Connection conn) 
	throws SQLException, InstantiationException, IllegalAccessException{
		String sWhereClause = " WHERE " + wc_com.generateWhereClause("reference_externe") ;
		Commission com = new Commission();
		com.bUseHttpPrevent = false;
		return com.getAllWithWhereAndOrderByClause(
				sWhereClause,
				"",
				conn);	
	}

	private void archiveFile(String sFileName)
	throws IOException{
		File file = new File(this.sPath + sFileName);
		new File(this.sPath + "archive/" ).mkdirs();
		File fileDest 
		= new File(this.sPath
				+ "archive/" + sFileName 
				+ "_" + CalendarUtil.getDateWithFormat(new Timestamp(System.currentTimeMillis()), "yyyyMMdd")
				+ "_" + System.currentTimeMillis() + ".xml");
		FileUtil.deplacer(file,fileDest);
	}

	public static void main(String[] args) throws Exception {
		RemoteControlServiceConnection a = new RemoteControlServiceConnection("jdbc:mysql://serveur8.matamore.com:3306/modula_test?","dba_account", "dba_account" );
		Connection conn = a.getConnexionMySQL();

		//CarnetAdresseWrapper caw = new CarnetAdresseWrapper("D:\\developpement\\sources\\modula_wtp_head\\config\\xml\\");
		CarnetAdresseWrapper caw = new CarnetAdresseWrapper("D:\\developpement\\sources\\modula\\config\\xml\\");
		caw.bDebug = true;
		Vector<JobExecutionException> vException = caw.synchroniserFichier("synchro_CA.xml", conn);
		CoinAbstractJob.displayOnConsoleException(vException);

		ConnectionManager.closeConnection(conn);
	}

}