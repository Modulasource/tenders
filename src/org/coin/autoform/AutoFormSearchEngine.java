package org.coin.autoform;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import modula.graphic.BarBouton;
import modula.graphic.Theme;

import org.coin.autoform.component.AutoFormComponent;
import org.coin.autoform.component.AutoFormCptBlock;
import org.coin.autoform.component.AutoFormCptInputSubmit;
import org.coin.autoform.component.AutoFormCptInputText;
import org.coin.autoform.component.AutoFormCptLabel;
import org.coin.autoform.component.AutoFormCptSelect;
import org.coin.autoform.component.searchengine.AutoFormSEComponent;
import org.coin.autoform.component.searchengine.AutoFormSECptSearchSelection;
import org.coin.autoform.component.searchengine.AutoFormSEMatrixList;
import org.coin.autoform.component.searchengine.AutoFormSEMatrixListLine;
import org.coin.autoform.component.searchengine.AutoFormSENextAndPrevious;
import org.coin.autoform.component.searchengine.AutoFormSEOrderBy;
import org.coin.bean.ObjectType;
import org.coin.bean.User;
import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.db.ConnectionManager;
import org.coin.db.ObjectAttributeLocalization;
import org.coin.localization.Language;
import org.coin.security.DwrSession;
import org.coin.security.PreventInjection;
import org.coin.security.SecureString;
import org.coin.servlet.filter.HabilitationFilterUtil;
import org.coin.util.BeanGenerator;
import org.coin.util.CalendarUtil;
import org.coin.util.JavascriptVersion;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@RemoteProxy
public class AutoFormSearchEngine extends AutoFormObject{
	public static final int TYPE_VARCHAR = 1;
	public static final int TYPE_TEXT = 2;
	
	public static String PARAM_NAME_CURRENT_PAGE = "icp";
	public static String PARAM_NAME_CURRENT_COUNT_PAGE = "icp_count";
	public static String PARAM_NAME_MAX_ELEMENT_COUNT = "iMaxElementsCount";
	public static String PARAM_NAME_MAX_ELEMENT_PER_PAGE = "iMaxElementsPerPage";
	public static String PARAM_NAME_USE_CUT_COUNT = "bMaxElementsCountUsed";
	
	public static final int TYPE_HTML = 1;
	public static final int TYPE_JSON = 2;
	
	public static final String JSON_PREVIOUS_LIMIT = "previous";
	public static final String JSON_NEXT_LIMIT = "next";
	public static final String JSON_CURRENT_LIMIT = "current";
	
	public static final String PARAM_NAME_ID_SECURE = "AF_ID_REDIR_SECURE";

	/**
	 * javascript
	 */
	public String sJavascriptInstanceName = "mySearch";
	public String sJavascriptFlow = "";
	
	
	protected Vector<Object> vParams;
	protected String sRootPath;
	protected String sTitle;
	/**
	 * unique formulaire du moteur
	 */
	protected AutoFormForm afForm;

	/**
	 * adresse de postage du formulaire
	 */
	protected String sURLFormTarget;

	/**
	 * libellé de l'élément au singulier
	 */
	protected String sLabelElementInSingular;

	/**
	 * libellé de l'élément au pluriel
	 */
	protected String sLabelElementInPlurial;

	/**
	 * Composant pour le tri
	 */
	protected AutoFormSEOrderBy afOrderBy;
	protected String sGroupByClause;
	protected String sSelectGroupByClause;

	protected AutoFormCptBlock afBlockSearch;
	protected AutoFormCptBlock afBlockResult;
	protected Vector<AutoFormSEComponent> vSEComponents;
	protected AutoFormSEMatrixList afResult;

	protected String sSelectPart;			// La partie SELECT de la requête
	protected String sMainTable;			// table principale
	protected String sMainAliasTable;		// alias de la table
	protected ArrayList<Hashtable<String, Boolean>> vOtherTables;	// d'autres tables éventuelles ajoutées à la requête
	protected Vector<String[]> vOtherTablesWithLeftJoin;	// d'autres tables éventuelles ajoutées à la requête
	protected Vector<String> vClausesLeftJoin;	// les conditions de left join
	protected Vector<String> vClausesInvariantes;		// liste des clauses
	protected Vector<String> vClausesFromForm;		// liste des clauses
	protected Vector<String> vURLParameters;	// Paramètres de l'URL
	protected Vector<String> vFilters;		// liste des filtres - utilise en AJAX

	protected String sIdInTable;
	protected String sIdInJava;

	public boolean bEnablePagination = true;
	protected int iCurrentPage;		// Page courante (lors de l'affichage page/page)
	protected int iMaxElementsPerPage;	// Nombre d'éléments à afficher par page
	protected int iGroupPerPage;		// Nombre de groupe de page autorisé : 20 [21] 22 23 24 ...
	protected Vector<Hashtable<String,String> > vResults;	// Contient les résultats
	//protected int iTotalCount; //le nombre total de resultats
	protected int iTotalCountCriterias; //le nombre de resultats recherchés

	/**
	 * Si utilisation du max count lors du chargement des items
	 */
	protected boolean bMaxElementsCountUsed = true;
	protected boolean bMaxElementsCountReach = false;
	/**
	 * Nombre maxi d'éléments comptés. Si on dépasse ce nombre la requete est tronquée
	 * pour ne pas baisser les performances
	 */
	protected int iMaxElementsCount = 1000;
	protected int iCurrentPageCount;

	protected Vector<BarBouton> vBarBoutons;

	protected HttpServletResponse hsrResponse;
	
	protected HttpSession httpSession;

	protected boolean bSelectWithDistinct;
	
	protected boolean bUseHttpPrevent = true;
	protected boolean bUseBeanGeneratorConnection = false;
	
	protected static Map<String,String>[] s_sarrLocalizationLabel;
	public int iAbstractBeanIdLanguage;
	protected int iAbstractBeanIdObjectType;

	public static String LABEL_LIST = "LABEL_LIST";
	public static String LABEL_SEARCH = "LABEL_SEARCH";
	public static String LABEL_LIST_UNAMED = "LABEL_LIST_UNAMED";
	public static String LABEL_NO_ITEM = "LABEL_NO_ITEM";
	public static String LABEL_NO_RESULT = "LABEL_NO_RESULT";
	public static String LABEL_ONE_RESULT = "LABEL_ONE_RESULT";
	public static String LABEL_RESULTS = "LABEL_RESULTS";
	public static String LABEL_NEXT = "LABEL_NEXT";
	public static String LABEL_PREV = "LABEL_PREV";
	public static String LABEL_SEARCH_LIMIT = "LABEL_LIMIT";
	public static String LABEL_SEARCH_BUT = "LABEL_SEARCH_BUT";
	public static String LABEL_LIMIT_RESULT = "LABEL_LIMIT_RESULT";
	public static String LABEL_LIMIT_RESULT_YES = "LABEL_LIMIT_RESULT_YES";
	public static String LABEL_LIMIT_RESULT_NO = "LABEL_LIMIT_RESULT_NO";
	public static String LABEL_LIMIT = "LABEL_LIMIT";
	public static String LABEL_NUMBER_RESULT = "LABEL_NUMBER_RESULT";
	public static String LABEL_ADVANCED_FEATURES = "LABEL_ADVANCED_FEATURES";
	public static String LABEL_GENERATE = "LABEL_GENERATE";
	public static String LABEL_KEYWORD = "LABEL_KEYWORD";
	public static String LABEL_FIRST_PAGE = "LABEL_FIRST_PAGE";
	public static String LABEL_PREVIOUS_GROUP_PAGE = "LABEL_PREVIOUS_GROUP_PAGE";
	public static String LABEL_PREVIOUS_PAGE = "LABEL_PREVIOUS_PAGE";
	public static String LABEL_CURRENT_PAGE = "LABEL_CURRENT_PAGE";
	public static String LABEL_NEXT_PAGE = "LABEL_NEXT_PAGE";
	public static String LABEL_NEXT_GROUP_PAGE = "LABEL_NEXT_GROUP_PAGE";
	public static String LABEL_LAST_PAGE = "LABEL_LAST_PAGE";
	public static String LABEL_GET_PAGE = "LABEL_GET_PAGE";

	/**
	 * @param hsrResponse : le response
	 * @param sRootPath : Le rootPath (request.getContextPath()+"/")
	 * @param sTitle : Le titre de la page
	 * @param sURLFormTarget : L'URL du formulaire
	 * @param sMainTable : Table principale sur laquelle les requêtes seront faites
	 * @param sMainAliasTable : Alias de la table principale (ex : "pp" pour personne_physique)
	 * @param sLabelElementInSingular : Le libellé de l'élément au singulier (ex : personne physique)
	 * @param sLabelElementInPlurial : Le libellé de l'élément au pluriel (ex : personnes physiques)
	 * @param sIdInTable : l'id de l'élément dans la table (ex : id_personne_physique)
	 * @param sIdInJava : l'id de l'élément dans l'objet java (ex : iIdPersonnePhysique)
	 */
	public AutoFormSearchEngine(
			HttpServletResponse hsrResponse,
			HttpSession httpSession,
			String sRootPath,
			String sTitle,
			String sURLFormTarget,
			String sMainTable,
			String sMainAliasTable,
			String sLabelElementInSingular,
			String sLabelElementInPlurial,
			String sIdInTable,
			String sIdInJava)
	{
		init();
		
		this.hsrResponse = hsrResponse;
		this.httpSession = httpSession;
		
		this.iAbstractBeanIdLanguage = (int)((Language)httpSession.getAttribute(HabilitationFilterUtil.SESSION_LANGUAGE)).getId();
		
		this.afBlockSearch = new AutoFormCptBlock(getLocalizedLabel(LABEL_SEARCH), "paveRecherche");
		this.afBlockResult = new AutoFormCptBlock(getLocalizedLabel(LABEL_LIST_UNAMED), "paveResultat");
		this.sRootPath = sRootPath;
		this.sTitle = sTitle;
		this.sURLFormTarget = sURLFormTarget;
		this.sMainTable = sMainTable;
		this.sMainAliasTable = sMainAliasTable;
		this.sLabelElementInSingular = sLabelElementInSingular;
		this.sLabelElementInPlurial = sLabelElementInPlurial;
		this.afForm = new AutoFormForm("post", "formulaire", hsrResponse.encodeURL(sURLFormTarget));
		this.afForm.setShowButtons(false);
		this.sIdInTable = sIdInTable;
		this.sIdInJava = sIdInJava;
		this.afOrderBy.afSelectOrder.setOnChange("document.getElementById('"+this.afForm.getId()+"').submit();");
		this.afOrderBy.afSelectWay.setOnChange("document.getElementById('"+this.afForm.getId()+"').submit();");
		this.afBlockResult.setLabelText(getLocalizedLabel(LABEL_LIST)+" "+sLabelElementInPlurial);
		this.afResult = new AutoFormSEMatrixList(sRootPath);
		this.afResult.setAfMoteur(this);
		this.vParams = new Vector<Object>();
	}
	
	public AutoFormSearchEngine() {
		init();
	}
	
	public AutoFormSearchEngine(String sJSON) throws Exception {
		init();
		buildQueryFromJSONObject(new JSONObject((sJSON==null)?"{}":sJSON));
	}

	public void init(){
		super.init();
		this.iAbstractBeanIdLanguage = Language.LANG_FRENCH;
		this.sRootPath = "";
		this.sTitle = "";
		this.sURLFormTarget = "";
		this.sMainTable = "";
		this.sLabelElementInSingular = "";
		this.sLabelElementInPlurial = "";
		this.iGroupPerPage = 10;
		this.iMaxElementsPerPage = 10;
		this.iCurrentPage = 0;
		this.iCurrentPageCount = 0;
		this.afForm = new AutoFormForm("post", "formulaire", "");
		this.afForm.setShowButtons(false);
		this.vBarBoutons = new Vector<BarBouton>();
		this.vOtherTables = new ArrayList<Hashtable<String,Boolean>>();
		this.vOtherTablesWithLeftJoin = new Vector<String[]>();
		this.vClausesLeftJoin = new Vector<String>();
		this.vClausesInvariantes = new Vector<String>();
		this.vFilters = new Vector<String>();
		this.vClausesFromForm = new Vector<String>();
		this.afOrderBy = new AutoFormSEOrderBy();
		this.sIdInTable = "";
		this.sIdInJava = "";
		this.sSelectPart = "";
		this.sMainAliasTable = "";
		this.vSEComponents = new Vector<AutoFormSEComponent>();
		this.vURLParameters = new Vector<String>();
		this.afResult = new AutoFormSEMatrixList();
		this.afResult.setAfMoteur(this);
		this.vResults = new Vector<Hashtable<String,String> >();
		//this.iTotalCount = 0;
		this.iTotalCountCriterias = 0;
		this.hsrResponse = null;
		this.httpSession = null;
		this.bSelectWithDistinct = false;
		this.sGroupByClause = "";
		this.sSelectGroupByClause = "";
		this.iAbstractBeanIdObjectType = ObjectType.AF_SEARCH_ENGINE;
	}

	/*
	 * Setter
	 */
	public void setFromForm(HttpServletRequest request, String sFormPrefix){
		String sVar = "";
		sVar = request.getParameter(PARAM_NAME_CURRENT_COUNT_PAGE);
		if (Outils.isNullOrBlank(sVar)){
			this.iCurrentPageCount = 0;
		}else{
			this.iCurrentPageCount = Integer.parseInt(sVar);
		}
		
		sVar = request.getParameter(PARAM_NAME_MAX_ELEMENT_COUNT);
		if (!Outils.isNullOrBlank(sVar))
			this.iMaxElementsCount = Integer.parseInt(sVar);
		
		sVar = request.getParameter(PARAM_NAME_MAX_ELEMENT_PER_PAGE);
		if (!Outils.isNullOrBlank(sVar))
			this.iMaxElementsPerPage = Integer.parseInt(sVar);
		
		sVar = request.getParameter(PARAM_NAME_USE_CUT_COUNT);
		if (!Outils.isNullOrBlank(sVar))
			this.bMaxElementsCountUsed=Boolean.valueOf(sVar);
			
		
		// Récupération de la valeur de la page courante
		sVar = request.getParameter(PARAM_NAME_CURRENT_PAGE);
		if (Outils.isNullOrBlank(sVar)){
			this.setCurrentPage(0);
		}else{
			this.setCurrentPage(Integer.parseInt(sVar));
		}

		// Récupération des valeurs de tri
		sVar = request.getParameter(this.afOrderBy.getSelectOrder().getName());
		if (Outils.isNullOrBlank(sVar)){
			// Si le champ du select n'est pas vide alors on sélectionne par défaut
			// le premier élément de la liste
			if (this.afOrderBy.getSelectOrder().getOption().size()>0){
				sVar = this.afOrderBy.getSelectOrder().getOption().firstElement().getValue();
				this.afOrderBy.setInitValueForSelectOrder(sVar);
			}else{
				this.afOrderBy.setInitValueForSelectOrder("");
			}
		}else{
			this.afOrderBy.setInitValueForSelectOrder(sVar);
		}


		sVar = request.getParameter(this.afOrderBy.getSelectWay().getName());
		if (Outils.isNullOrBlank(sVar)){
			this.afOrderBy.setInitValueForSelectWay("");
		}else{
			this.afOrderBy.setInitValueForSelectWay(sVar);
		}

		// ajout des paramètres (pour les transporter dans l'url)
		this.addURLParameter(this.afOrderBy.getParametersForURL());

		// Initialisation de composants de recherche :
		for (int i=0;i<this.getSEComponent().size();i++){
			// initialisation du composant
			this.getSEComponent().get(i).setFromForm(request, sFormPrefix);

			// ajout d'un éventuel critère (clause) généré
			if (!Outils.isNullOrBlank(this.getSEComponent().get(i).getClause())){
				this.addClauseFromForm(this.getSEComponent().get(i).getClause());
			}

			// ajout des paramètres (pour les transporter dans l'url)
			this.addURLParameter(this.getSEComponent().get(i).getParametersForURL());
		}
		this.afResult.setFromForm(request, sFormPrefix);
		this.addURLParameter(this.afResult.getParametersForURL());
	}
	public void setRootPath(String sRootPath){
		this.sRootPath = sRootPath;
	}
	public void setTitle(String sTitle){
		this.sTitle = sTitle;
	}
	public void setSelectPart(String sSelectPart){
		this.sSelectPart = sSelectPart;
		
		this.sJavascriptFlow += 
			this.sJavascriptInstanceName + "." + "sSelectPart ="
			+ " \"" +  this.sSelectPart + "\";\n" ;
	}
	public void setForm(AutoFormForm afForm){
		this.afForm = afForm;
	}
	public void setURLFormTarget(String sURLFormTarget){
		this.sURLFormTarget = sURLFormTarget;
	}
	public void setLabelElementInSingular(String sLabelElementInSingular){
		this.sLabelElementInSingular = sLabelElementInSingular;
	}
	public void setLabelElementInPlurial(String sLabelElementInPlurial){
		this.sLabelElementInPlurial = sLabelElementInPlurial;
	}
	/**
	 * Ajoute des critères de tri au champ "OrderBy"
	 * @param sLabelContent : (ex : "date de création")
	 * @param sValue : (ex : "pp.date_creation")
	 */
	public void addItemToOrderBy(String sLabelContent, String sValue){
		this.afOrderBy.addItem(sLabelContent, sValue);
	}
	/**
	 * Définit le nombre d'éléments à afficher par page
	 * @param iMaxElementsPerPage
	 */
	public void setMaxElementsPerPage(int iMaxElementsPerPage){
		this.iMaxElementsPerPage = iMaxElementsPerPage;
	}

	/**
	 * Définit le nombre de groupe de page autorisé : << < 20 [21] 22 23 24 > >>
	 * @param iGroupPerPage
	 */
	public void setGroupPerPage(int iGroupPerPage){
		this.iGroupPerPage = iGroupPerPage;
	}
	public void setBarBoutons(Vector<BarBouton> vBarBouton){
		this.vBarBoutons = vBarBouton;
	}

	public void setMainTable(String sMainTable){
		this.sMainTable = sMainTable;
	}
	public void setMainAliasTable(String sMainAliasTable){
		this.sMainAliasTable = sMainAliasTable;
	}
	/**
	 * Ajoute une table liée en précisant sa jointure
	 * @param sTable : le nom de la table (ex : "categorie c")
	 * @param sJoin : la jointure (ex : "c.id_categorie=pp.id_categorie")
	 */
	public void addOtherTable(String sTable, String sJoin){
		Hashtable<String, Boolean> ht = new Hashtable<String, Boolean>();
		ht.put(sTable, new Boolean(false));
		this.vOtherTables.add(ht);		
		this.addClauseInvariante(sJoin);
	}
	
	/**
	 * Ajoute une table liée en précisant sa jointure
	 * @param sTable : le nom de la table (ex : "categorie c")
	 * @param sJoin : la jointure (ex : "c.id_categorie=pp.id_categorie")
	 * @param bLeftJoin : pour savoir s'il y a un left join
	 */
	public void addOtherTable(String sTable, String sJoin, boolean bLeftJoin){
		Hashtable<String, Boolean> ht = new Hashtable<String, Boolean>();
		ht.put(sTable, new Boolean(bLeftJoin));
		this.vOtherTables.add(ht);
		
		if(bLeftJoin){
			this.vClausesLeftJoin.add(sJoin);
		}
		else{
			this.addClauseInvariante(sJoin);
		}
		
		
		/**
		 * for the javascript generation
		 * 
		 * TODO : use java inspection to generate it
		 */
		String sJS 
			= this.sJavascriptInstanceName + "."
			+ "addOtherTable(\n"
			+ "\t\"" + sTable + "\",\n" 
			+ "\t\"" + sJoin + "\",\n"
			+ "\t" + bLeftJoin + ");\n";
		
		this.sJavascriptFlow += sJS;
	}
	
	

	public void addOtherTableWithLeftJoin(String sTable, String sJoin){
		String[] leftJoin = {sTable, sJoin};
		this.vOtherTablesWithLeftJoin.add(leftJoin);
		
		String sJS 
		= this.sJavascriptInstanceName + "."
		+ "addOtherTableWithLeftJoin(\n"
		+ "\t\"" + sTable + "\",\n" 
		+ "\t\"" + sJoin + "\");\n";
	
		this.sJavascriptFlow += sJS;
	}
	
	public String getJavascriptFlow()
	{
		return this.sJavascriptFlow ;
	}

	public void flushJavascriptFlow()
	{
		this.sJavascriptFlow = "";
	}


	public void setIdInTable(String sIdInTable){
		this.sIdInTable = sIdInTable;
	}
	public void setIdInJava(String sIdInJava){
		this.sIdInJava = sIdInJava;
	}

	public void setCurrentPage(int iCurrentPage){
		this.iCurrentPage = iCurrentPage;
	}

	/**
	 * Ajoute un DISTINCT devant la requete
	 * @param bSelectWithDistinct
	 */
	public void setSelectWithDistinct(boolean bSelectWithDistinct){
		this.bSelectWithDistinct = bSelectWithDistinct;
	}

	/**
	 * 
	 * @param aFields : liste des champ recherches
	 * si size>1 alors on separe les filtres avec un OR
	 * 
	 * @param aValues : valeurs recherchees
	 * si size>1 et !bOptLike alors on utilise un IN
	 * si size>1 et bOptLike alors on separe avec un OR
	 *  
	 * @param bOptLike : filtre de type LIKE
	 * @throws Exception 
	 */
	public void addFilter(
			String[] sarrFields,
			String[] sarrValues,
			boolean bOptLike) 
	throws CoinDatabaseLoadException
	{
		addFilter(sarrFields, sarrValues, bOptLike,false,null);
	}
	public void addFilter(
			String[] sarrFields,
			String[] sarrValues,
			boolean bOptLike,
			boolean bUseVariableValues,
			String sVariableValues) 
	throws CoinDatabaseLoadException
	{
		this.addFilter(
				Outils.toArrayList(sarrFields), 
				Outils.toArrayList(sarrValues), 
				bOptLike,
				bUseVariableValues,
				sVariableValues);
	}
	
	public void addFilter(
			String[] sarrFields,
			String[] sarrValues,
			boolean bOptLike,
			String sCompare,
			boolean bUseVariableValues,
			String sVariableValues) 
	throws CoinDatabaseLoadException
	{
		this.addFilter(
				Outils.toArrayList(sarrFields), 
				Outils.toArrayList(sarrValues), 
				bOptLike,
				sCompare,
				bUseVariableValues,
				sVariableValues);
	}
	
	public void addFilter(
			ArrayList<String> aFields,
			ArrayList<String> aValues,
			boolean bOptLike) 
	throws CoinDatabaseLoadException {
		addFilter(aFields, aValues, bOptLike,false,null);
	}
	
	public void addFilter(
			ArrayList<String> aFields,
			ArrayList<String> aValues,
			boolean bOptLike,
			boolean bUseVariableValues,
			String sVariableValues) 
	throws CoinDatabaseLoadException {
		String sCompare = "=";
		addFilter(aFields, aValues, bOptLike, sCompare, bUseVariableValues, sVariableValues);
	}

	public void addFilter(
			ArrayList<String> aFields,
			ArrayList<String> aValues,
			boolean bOptLike,
			String sCompare,
			boolean bUseVariableValues,
			String sVariableValues) 
	throws CoinDatabaseLoadException {
		this.addFilter(aFields, aValues, bOptLike, sCompare);
		
		String sValues = Outils.toString(aValues);
		if(bUseVariableValues && !Outils.isNullOrBlank(sVariableValues)) sValues = sVariableValues;
		String sJS 
		= this.sJavascriptInstanceName + "."
		+ "addFilter(\n"
		+ "\t" + Outils.toString(aFields) + ",\n" 
		+ "\t" + sValues + ",\n"
		+ "\t" + bOptLike + ","
		+ "\t'" + sCompare + "');\n";
	
		this.sJavascriptFlow += sJS;
	}
	
	public void addFilter(
			ArrayList<String> aFields,
			ArrayList<String> aValues,
			boolean bOptLike,
			String sCompare) 
	throws CoinDatabaseLoadException {
		String sFilter = "(";
		
		if(aFields == null || aFields.size()==0
		|| aValues == null || aValues.size()==0)
		{
			throw new CoinDatabaseLoadException(
					"Filtres mal definis : "
					+ " aFields=" + aFields 
					+ " aValues" + aValues,
					"");
		}
		
		for(int j=0;j<aFields.size();j++){
			String sField = aFields.get(j);
			
			if(sCompare.equalsIgnoreCase("BETWEEN") && aValues.size()==2){
				if(Outils.isNullOrBlank(aValues.get(0))){
					sFilter += sField+" <= "+CoinDatabaseUtil.getSqlDateODBCFunction(aValues.get(1));
				}else if(Outils.isNullOrBlank(aValues.get(1))){
					sFilter += sField+" >= "+CoinDatabaseUtil.getSqlDateODBCFunction(aValues.get(0));
				}else{
					sFilter += sField+" "+sCompare+" "+CoinDatabaseUtil.getSqlDateODBCFunction(aValues.get(0))+" AND "+CoinDatabaseUtil.getSqlDateODBCFunction(aValues.get(1));
				}
			}
			else if(sCompare.equalsIgnoreCase("FREE") || sCompare.equalsIgnoreCase("FREE_UNPREVENT")){
				
				for(int i=0;i<aValues.size();i++){
					String sValue = aValues.get(i);
					if(sCompare.equalsIgnoreCase("FREE"))
						sValue = PreventInjection.preventStore(sValue);
					sFilter += "("+sField + " " + sValue+")";
					
					if(i != aValues.size()-1)
						sFilter += " OR ";
				}
			}
			else if(aValues.size()==1){
				String sValue = PreventInjection.preventStore(aValues.get(0));
				
				/** 
				 * si la valeur est un string 
				 * si on utilise pas le LIKE
				 * si le comparateur est =
				 * alors on met des cotes
				 */
				if(!bOptLike && (sCompare.equalsIgnoreCase("=") || sCompare.equalsIgnoreCase("!="))){
					try{Integer.parseInt(sValue);}
					catch(Exception e){sValue = "'"+sValue+"'";}
				}
				
				sFilter += (bOptLike?(sField+" LIKE '%"+sValue+"%'"):(sField+sCompare+sValue));
				/**
				 * SQL_OPTIMIZE : utiliser la méthode :
				// 
				 * getAllWithSqlQuery(
						String sSQLQuery, 
						CoinDatabaseAbstractBean objTypeToLoad, 
					=>	Vector<Object> vParams,
						Connection conn)
					
					modif à faire :
					//sFilter += (bOptLike?(sField+" LIKE ?"):(sField+sCompare+sValue));
					//vParams.add(sValue);

				 */ 
			}
			else{
				String sINCompare = " IN (";
				if(sCompare.equalsIgnoreCase("!="))
					sINCompare = " NOT IN (";
				
				sFilter += (bOptLike?(""):(sField+sINCompare));
				for(int i=0;i<aValues.size();i++){
					String sValue = PreventInjection.preventStore(aValues.get(i));
					sFilter += (bOptLike?(sField+" LIKE '%"+sValue+"%'"):(sValue));
					
					if(i != aValues.size()-1)
						sFilter += (bOptLike?(" OR "):(","));
				}
				sFilter += (bOptLike?(""):(")"));
			}
			
			if(j != aFields.size()-1)
				sFilter += " OR ";
		}
		/*
		 case AutoFormSearchEngine.TYPE_VARCHAR:
			sSearch = preventStore(this.getInitValueForInputText());
			break;
			
		case AutoFormSearchEngine.TYPE_TEXT:
			sSearch = Outils.addLikeSlashes(preventStore(this.getInitValueForInputText()));
			break;
		} catch(Exception e) {}
		 */
		sFilter += ")\n";
		this.vFilters.add(sFilter);
	}
	
	/**
	 * Ajoute une clause à la requête
	 * @param sClause : exemple "c.id_categorie=55"
	 */
	public void addClauseInvariante(String sClause){
		this.vClausesInvariantes.add(sClause);
	}

	/**
	 * Ajoute une clause à la requête (générée depuis le formulaire)
	 * @param sClause : exemple "c.id_categorie=55"
	 */
	protected void addClauseFromForm(String sClause){
		this.vClausesFromForm.add(sClause);
	}

	/**
	 * Ajoute un composant de recherche au moteur
	 * @param afSECpt
	 */
	public void addSEComponent(AutoFormSEComponent afSECpt){
		this.vSEComponents.add(afSECpt);
	}
	
	/**
	 * Ajoute un paramètre ("c.commentaire=valeurURLEncodee")
	 * @param sParameter
	 */
	public void addURLParameter(String sParameter){
		this.vURLParameters.add(sParameter);
	}
	
	/**
	 * Ajoute une entête pour l'affichage des résultats
	 * @param sHeader
	 */
	public void addHeaderToResultCpt(String sHeader){
		this.afResult.addHeader(sHeader);
	}
	public void addHeaderToResultCpt(String sHeader,String sOrder){
		this.afResult.addHeader(sHeader,sOrder);
	}
	public void addHeaderToResultCpt(String sHeader,String sOrder,String sDirection){
		this.afResult.addHeader(sHeader,sOrder,sDirection);
	}
	/**
	 * Ajoute l'ensemble des entêtes à partir d'une chaine de mots séparés par des points virgule
	 * @param sHeader : exemple : "Numéro;Personne physique;Catégorie"
	 */
	public void setHeaderWithDotComaToResultCpt(String sHeader){
		this.afResult.setHeaderWithDotComa(sHeader);
	}

	/**
	 * Ajout une ligne au résultat
	 * @param afLine
	 */
	public void addLineToResultCpt(AutoFormSEMatrixListLine afLine){
		this.afResult.addLine(afLine);
	}
	
	public void setSelectGroupByClause(String sSelectGroupByClause){
		this.sSelectGroupByClause = sSelectGroupByClause;
	}

	public void setGroupByClause(String sGroupByClause){
		this.sGroupByClause = sGroupByClause;
		
		this.sJavascriptFlow += 
			this.sJavascriptInstanceName + "."
			+ "setGroupByClause(\"" + sGroupByClause + "\");\n";
	}


	/**
	 * TODO
	 * Ajouter une méthode plus complète pour addBoutonToBar
	 */
	/**
	 * Ajoute un bouton à la barre
	 * @param sLabel : Le libellé
	 * @param sTargetURL : Le lien
	 * @param sPathImage : L'image
	 */
	public void addBoutonToBar(String sLabel, String sTargetURL, String sPathImage){
		this.vBarBoutons.add(
				new BarBouton(this.getBarBouton().size(),
					sLabel,
					sTargetURL,
					sPathImage,
					"this.src='"+sPathImage+"'",
					"this.src='"+sPathImage+"'",
					"",
					true) );
	}
	
	/**
	 * Ajoute un champ hidden au formulaire
	 * @param sName : le nom du champ
	 * @param sValue : sa valeur
	 */
	public void addHiddenToForm(String sName, String sValue){
		this.afForm.addHidden(sName, sValue);
	}
	/*
	 * Getter
	 */
	public String getRootPath(){
		return this.sRootPath;
	}
	public String getTitle(){
		return this.sTitle;
	}
	public AutoFormForm getForm() {
		return this.afForm;
	}
	public String getURLFormTarget() {
		return sURLFormTarget;
	}
	
	public int getGroupPerPage() {
		return this.iGroupPerPage;
	}
	public int getMaxElementsPerPage() {
		return this.iMaxElementsPerPage;
	}
	public String getLabelElementInSingular() {
		return sLabelElementInSingular;
	}
	public String getLabelElementInPlurial() {
		return sLabelElementInPlurial;
	}
	public Vector<BarBouton> getBarBouton(){
		return this.vBarBoutons;
	}
	public Vector<String> getOtherTable(){
		// Véro : return this.vOtherTables;
		
		Vector<String> vResult = new Vector<String>();
		
		for(Hashtable<String, Boolean> ht:vOtherTables){
			vResult.add(ht.keys().nextElement());
		}		
		return vResult;
	}
	public ArrayList<Hashtable<String,Boolean>> getOtherTableAsArrayList(){
		return this.vOtherTables;
	}
	public Vector<String[]> getOtherTableWithLeftJoin(){
		return this.vOtherTablesWithLeftJoin;
	}
	public Vector<String> getClausesInvariantes(){
		return this.vClausesInvariantes;
	}
	public Vector<String> getFilters(){
		return this.vFilters;
	}
	public Vector<String> getClausesFromForm(){
		return this.vClausesFromForm;
	}
	public Vector<AutoFormSEComponent> getSEComponent(){
		return this.vSEComponents;
	}
	public Vector<String> getURLParameters(){
		return this.vURLParameters;
	}
	public String getMainTable(){
		return this.sMainTable;
	}
	public String getMainAliasTable(){
		return this.sMainAliasTable;
	}
	public int getCurrentPage(){
		return this.iCurrentPage;
	}
	public String getIdInTable(){
		return this.sIdInTable;
	}
	public String getIdInJava(){
		return this.sIdInJava;
	}
	public AutoFormSEOrderBy getOrderBy(){
		return this.afOrderBy;
	}
	public String getSelectPart(){
		return this.sSelectPart;
	}
	public HttpServletResponse getResponse(){
		return this.hsrResponse;
	}
	public HttpSession getSession(){
		return this.httpSession;
	}
	public boolean isSelectWithDistinct(){
		return this.bSelectWithDistinct;
	}
	public String getGroupByClause(){
		return this.sGroupByClause;
	}
	public int getTotalCountCriterias(){
		return this.iTotalCountCriterias;
	}
	
	/*
	 * Générateurs de la requête
	 */

	/**
	 * Retourne la partie de la requête avec "WHERE ... AND ... AND" pour le compte des éléments
	 */
	public String getWherePartForRequestCount(){
		if (this.getClausesInvariantes().size()==0) return "";
		if (this.getClausesInvariantes().size()==1) return "WHERE "+this.getClausesInvariantes().firstElement();
		String sReq = "WHERE "+this.getClausesInvariantes().firstElement();
		for (int i=1;i<this.getClausesInvariantes().size();i++){
			sReq += " AND "+this.getClausesInvariantes().get(i);
		}
		return sReq;
	}
	
	/**
	 * Retourne la partie de la requête avec "WHERE ... AND ... AND"
	 */
	public String getWherePartForRequest(){
		Vector<String> vClauses = new Vector<String>();
		// Fusion des 2 types de clauses
		for (int i=0;i<this.getClausesInvariantes().size();i++){
			vClauses.add(this.getClausesInvariantes().get(i));
		}
		for (int i=0;i<this.getClausesFromForm().size();i++){
			vClauses.add(this.getClausesFromForm().get(i));
		}
		for (int i=0;i<this.getFilters().size();i++){
			vClauses.add(this.getFilters().get(i));
		}
		
		if (vClauses.size()==0) return "";
		if (vClauses.size()==1) return "WHERE "+vClauses.firstElement();
		String sReq = "WHERE "+vClauses.firstElement();
		for (int i=1;i<vClauses.size();i++){
			sReq += " AND "+vClauses.get(i);
		}
		return sReq;
	}
	
	/**
	 * Retourne la partie "FROM" de la requête "FROM ... "
	 */
	public String getFromPartForRequest(){
		String sReq = "FROM "+this.getMainTable()+" "+this.getMainAliasTable();

		//		 Véro : Ce qu'il y avait avant		
//		for(int i=0;i<this.getOtherTable().size();i++){
//			sReq += ", "+this.getOtherTable().get(i);
//		}
//
//		for(int i=0;i<this.getOtherTableWithLeftJoin().size();i++){
//			String[] leftJoin = this.getOtherTableWithLeftJoin().get(i);
//			sReq += " LEFT JOIN "+leftJoin[0] + " ON (" + leftJoin[1] + ")";
//		}
//		return sReq;
		
		// les left join à ajouter au début
		for(int i=0;i<this.getOtherTableWithLeftJoin().size();i++){
			String[] leftJoin = this.getOtherTableWithLeftJoin().get(i);
			sReq += " LEFT JOIN "+leftJoin[0] + " ON (" + leftJoin[1] + ")\n";
		}

		// Les autres tables, avec peut-être des left join au milieu
		String sNomTable;
		boolean bLeftJoin;
		int iNbLeftJoin = 0;
		for(Hashtable<String, Boolean> htNomTableEtBooleen:this.getOtherTableAsArrayList()){
			sNomTable = (String) htNomTableEtBooleen.keys().nextElement();
	    	bLeftJoin = htNomTableEtBooleen.get(sNomTable);
	    	if(bLeftJoin){
	    		sReq += " LEFT JOIN "+ sNomTable + " ON (" + vClausesLeftJoin.get(iNbLeftJoin) + ")\n";
	    		iNbLeftJoin++;
	    	}else{
	    		sReq += ", "+sNomTable;
	    	}
		}
		return sReq;
	}
	
	/**
	 * Retourne la partie "ORDER BY .... DESC|ASC"
	 */
	public String getOrderByPartForRequest(){
		String sReq = "";
		if (!this.getOrderBy().getInitValueForSelectOrder().equalsIgnoreCase("")){
			sReq = "ORDER BY "+this.getOrderBy().getInitValueForSelectOrder();
			if (!this.getOrderBy().getInitValueForSelectWay().equalsIgnoreCase("")){
				sReq += " "+this.getOrderBy().getInitValueForSelectWay();
			}
		}else{
			sReq = "";
			for (Hashtable<String, String> header : this.afResult.getHeaders()) {
				try{
					String sOrder = header.get("order");
					String sDirection = header.get("direction");
					if(!Outils.isNullOrBlank(sOrder)
					&& !Outils.isNullOrBlank(sDirection)) {
						sReq += sOrder+" "+sDirection+",";
					}
				}catch(Exception e){e.printStackTrace();}
			}
			if(!sReq.equalsIgnoreCase("")){
				sReq = "ORDER BY "+sReq.substring(0, sReq.length()-1) + "\n";
			}
		}
		return sReq;
	}
	
	public String getOrderByDirectionForRequest(){
		if (!this.getOrderBy().getInitValueForSelectOrder().equalsIgnoreCase("")){
			if (!this.getOrderBy().getInitValueForSelectWay().equalsIgnoreCase("")){
				return this.getOrderBy().getInitValueForSelectWay();
			}
		}else{
			for (Hashtable<String, String> header : this.afResult.getHeaders()) {
				try{
					String sOrder = header.get("order");
					String sDirection = header.get("direction");
					if(!Outils.isNullOrBlank(sOrder)
					&& !Outils.isNullOrBlank(sDirection)) {
						return sDirection;
					}
				}catch(Exception e){e.printStackTrace();}
			}
		}
		return "";
	}
	
	public String getOrderByFieldForRequest(){
		if (!this.getOrderBy().getInitValueForSelectOrder().equalsIgnoreCase("")){
			return this.getOrderBy().getInitValueForSelectOrder();
		}else{
			for (Hashtable<String, String> header : this.afResult.getHeaders()) {
				try{
					String sOrder = header.get("order");
					String sDirection = header.get("direction");
					if(!Outils.isNullOrBlank(sOrder)
					&& !Outils.isNullOrBlank(sDirection)) {
						return sOrder;
					}
				}catch(Exception e){e.printStackTrace();}
			}
		}
		return "";
	}

	public String getGroupByPartForRequest(){
		String sReq = "";
		if (!this.getGroupByClause().equalsIgnoreCase("")){
			sReq = "GROUP BY "+this.getGroupByClause() + "\n";
		}
		return sReq;
	}

	/**
	 * Retourne la partie "LIMIT ..,.."
	 */
	public String getLimitForRequest(String sSQL){
		if (this.iMaxElementsCount<0 || !this.bMaxElementsCountUsed) {
			switch(ConnectionManager.getDbType()){
			case ConnectionManager.DBTYPE_SQL_SERVER:
				return sSQL + this.getOrderByPartForRequest();
			case ConnectionManager.DBTYPE_MYSQL:
				return sSQL;
			}
		}
		
		String sOrderByField = this.getOrderByFieldForRequest();
		String sOrderByDirection = this.getOrderByDirectionForRequest();
		sSQL = CoinDatabaseUtil.getSqlSelectWithLimit(
				sSQL, 
				(this.iCurrentPageCount*this.iMaxElementsCount), 
				this.iMaxElementsCount, 
				Outils.isNullOrBlank(sOrderByField)?this.getIdInTable():sOrderByField,
				Outils.isNullOrBlank(sOrderByDirection)?"asc":sOrderByDirection
				);
		
		return sSQL;
	}
	
	/**
	 * Retourne la partie "SELECT..."
	 */
	public String getSelectPartForRequest(){
		if (this.getSelectPart().equalsIgnoreCase("*")){
			return "SELECT "+(this.isSelectWithDistinct()?"DISTINCT ":"")+"*";
		}
		String sReste = "";
		if (!this.getSelectPart().equalsIgnoreCase("")) sReste =", " + this.getSelectPart();
		
		return "SELECT "
					+(this.isSelectWithDistinct()?"DISTINCT ":"")
					+this.getMainAliasTable()
					+"."+this.getIdInTable()
					+sReste;
	}
	
	/**
	 * Retourne la requête construite
	 */
	public String getGeneratedRequest(){
		String sSQL = this.getSelectPartForRequest()
				+" "+this.getFromPartForRequest()
				+" "+this.getWherePartForRequest()
				+" "+this.getGroupByPartForRequest();
		
		switch(ConnectionManager.getDbType()){
		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSQL = this.getLimitForRequest(sSQL);
			break;
		case ConnectionManager.DBTYPE_MYSQL:
			sSQL += " "+this.getOrderByPartForRequest();
			sSQL = this.getLimitForRequest(sSQL);
			break;
		}
				
		return sSQL;
	}
	
	/**
	 * Retourne la requête cryptée construite
	 * @throws InvalidAlgorithmParameterException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchProviderException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 */
	
	public String getGeneratedRequestSecure() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException{
		return SecureString.getSessionSecureString(
				this.getGeneratedRequest(), 
				(this.getSession()!=null?this.getSession():DwrSession.getSession()));
	}
	
	@RemoteMethod
	public static String loadGeneratedRequestSecure(String sJSONSearch) throws JSONException, InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
		AutoFormSearchEngine se = new AutoFormSearchEngine();
		se.hsrResponse = DwrSession.getResponse();
		se.httpSession = DwrSession.getSession();
		se.iAbstractBeanIdLanguage = (int)((Language)se.httpSession.getAttribute(HabilitationFilterUtil.SESSION_LANGUAGE)).getId();
		se.loadFromJSONObject(new JSONObject((sJSONSearch==null)?"{}":sJSONSearch), true);
		return se.getGeneratedRequestSecure();
	}
	
	public String getGeneratedRequestWithoutSelect(){
		String sSQL = this.getFromPartForRequest()
				+" "+this.getWherePartForRequest()
				+" "+this.getGroupByPartForRequest();

		switch(ConnectionManager.getDbType()){
		case ConnectionManager.DBTYPE_SQL_SERVER:
			sSQL = this.getLimitForRequest(sSQL);
			break;
		case ConnectionManager.DBTYPE_MYSQL:
			sSQL += " "+this.getOrderByPartForRequest();
			sSQL = this.getLimitForRequest(sSQL);
			break;
		}
		
		return sSQL;
	}
	
	/**
	 * Retourne la requête construite pour évaluer le nombre d'éléments
	 * trouvé avec les critères
	 */
	public String getGeneratedRequestCountResult(){

		String sGroupSelect = "";
		if(Outils.isNullOrBlank(this.sSelectGroupByClause)){
			sGroupSelect = (this.getGroupByClause().equalsIgnoreCase("")?"":this.getGroupByClause()+", ");
		}else{
			sGroupSelect = this.sSelectGroupByClause+", ";
		}
		String sRequete = "SELECT "+(this.isSelectWithDistinct()?"DISTINCT ":"") + sGroupSelect + "COUNT(*)"
				+" "+this.getFromPartForRequest()
				+" "+this.getWherePartForRequest()
				+" "+this.getGroupByPartForRequest();

		return sRequete;
	}
	
	/**
	 * Retourne la requête pour compter les éléments
	 */
	public String getGeneratedCountRequest(){
		String sGroupSelect = "";
		if(Outils.isNullOrBlank(this.sSelectGroupByClause)){
			sGroupSelect = (this.getGroupByClause().equalsIgnoreCase("")?"":this.getGroupByClause()+", ");
		}else{
			sGroupSelect = this.sSelectGroupByClause+", ";
		}
		String sRequete = "SELECT "+(this.isSelectWithDistinct()?"DISTINCT ":"") + sGroupSelect + "COUNT(*)"
				+" "+this.getFromPartForRequest()
				+" "+this.getWherePartForRequestCount()
				+" "+this.getGroupByPartForRequest();

		return sRequete;
	}
	/**
	 * Retourne une phrase concernant le nombre d'éléments trouvés
	 * @param iCount
	 * @return
	 */
	protected String getLabelCountForSearchBlock(int iCount){
		if (iCount==0) return getLocalizedLabel(LABEL_NO_ITEM);
		if (iCount==1) return "1 "+this.getLabelElementInSingular();
		return iCount+" "+this.getLabelElementInPlurial();
	}
	
	/**
	 * Retourne une phrase concernant le nombre d'éléments trouvés
	 * @param iCount
	 * @return
	 */
	protected String getLabelCountForResultBlock(int iCount){
		if (iCount==0) return getLocalizedLabel(LABEL_NO_RESULT);
		if (iCount==1) return getLocalizedLabel(LABEL_ONE_RESULT);
		return iCount+" "+getLocalizedLabel(LABEL_RESULTS);
	}
	
	/**
	 * @return : les paramètres du GET pour former l'adresse "sel_lenomduchamp=4&txt_lenomduchamp=valeurURLEncodee"
	 */
	public String getGeneratedParametersForURL(){
		if (this.getURLParameters().size()==0) return "";
		if (this.getURLParameters().size()==1) return this.getURLParameters().firstElement();
		String sCh = this.getURLParameters().firstElement();
		for (int i=1;i<this.getURLParameters().size();i++){
			sCh += "&amp;"+this.getURLParameters().get(i);
		}
		sCh += "&amp;"+PARAM_NAME_MAX_ELEMENT_COUNT+"="+this.iMaxElementsCount;
		sCh += "&amp;"+PARAM_NAME_MAX_ELEMENT_PER_PAGE+"="+this.iMaxElementsPerPage;
		sCh += "&amp;"+PARAM_NAME_USE_CUT_COUNT+"="+this.bMaxElementsCountUsed;
		return sCh;
	}
	
	/**
	 * Compte le nombre total d'éléments
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public int getCountElements() throws SQLException, NamingException 
	{
		Connection conn = null;
		try {
			conn = ConnectionManager.getConnection();
			return getCountElements(conn);
		}
		finally{
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public int getCountElements(Connection conn) throws SQLException 
	{
	    String sSqlQuery = this.getGeneratedCountRequest();
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);

		int iCount = 0;
		Statement stat = null;
		ResultSet rs = null;
		
		stat = conn.createStatement();
		rs = stat.executeQuery(sSqlQuery);
		
		while(rs.next()) {
			if(this.getGroupByClause().equalsIgnoreCase(""))
				iCount = rs.getInt(1);
			else
				iCount++;
		}
	
		ConnectionManager.closeConnection(rs,stat);
		return iCount;
	}
	
	/**
	 * Compte le nombre total d'éléments avec critères
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception
	 */
	public int getCountElementsWithCriterias() throws SQLException, NamingException 
	{
		Connection conn = null;
		
		try {
			conn = ConnectionManager.getConnection();
			return getCountElementsWithCriterias(conn);
		}finally{
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public int getCountElementsWithCriterias(Connection conn) throws SQLException 
	{
	    String sSqlQuery = this.getGeneratedRequestCountResult();
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);

	    int iCount = 0;
		Statement stat = null;
		ResultSet rs = null;
		
		stat = conn.createStatement();
		rs = stat.executeQuery(sSqlQuery);
		
		while(rs.next()) {
			if(this.getGroupByClause().equalsIgnoreCase(""))
				iCount = rs.getInt(1);
			else
				iCount++;
		}
		ConnectionManager.closeConnection(rs, stat);
		
		return iCount;
	}
	
	public void load() 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException, 
	SQLException, NamingException  {
		Connection conn =  ConnectionManager.getConnection();
		try {
			load(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public void load(Connection conn)
	throws SQLException, InvalidKeyException, NoSuchAlgorithmException,
	NoSuchProviderException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException,
	InvalidAlgorithmParameterException
	{
		String sSqlQuery = this.getGeneratedRequest();
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);
		ResultSet rs = null;
		PreparedStatement ps = null;
		ResultSetMetaData rsMetaData = null;
		try {
			//stat = conn.createStatement();
			//rs = stat.executeQuery(sSqlQuery);
			
			ps = conn.prepareStatement(sSqlQuery);
			//ps.setFetchSize(Integer.MIN_VALUE);
			//ps.setMaxRows(1000);

			rs = ps.executeQuery();
			
			rsMetaData = rs.getMetaData();
			int i = 0;
			int iCol;
			iCol = rsMetaData.getColumnCount();

			while(rs.next()) {
				i++;
				
		    	if (
		    	!this.bEnablePagination
		    	|| (
		    		((( this.iCurrentPage )* this.iMaxElementsPerPage ) < i)
		    		&& ( i <= ( (this.iCurrentPage + 1) * this.iMaxElementsPerPage)))
		    	)
		    	
		    	{
		    		Hashtable<String,String> h= new Hashtable<String,String>();
					for (int j=1;j<=iCol;j++){
						try{
							String sData = new String(rs.getString(j));
							h.put(
								rsMetaData.getColumnLabel(j),
								PreventInjection.preventLoad(sData,this.bUseHttpPrevent));
							
						}catch(Exception e){
							h.put(
								rsMetaData.getColumnLabel(j),
								"");
						}
					}
					
					if(this.httpSession != null)
					{
						h.put(
							PARAM_NAME_ID_SECURE, 
							SecureString.getSessionSecureString(
									h.get(
										this.sIdInTable),
										this.getSession()));
					}
					
					this.vResults.add(h);
		    	}

		    	if (this.bMaxElementsCountUsed)
		    	{
		    		if(i >= this.iMaxElementsCount){
		    			this.bMaxElementsCountReach = true;
		    			break;
		    		}
			 	}
			}
			if(this.bMaxElementsCountUsed && this.iCurrentPageCount>0){
    			this.bMaxElementsCountReach = true;
    		}
			
			this.iTotalCountCriterias = i; 
		}finally{
			ConnectionManager.closeConnection(rs,ps);
		}
	}
	
	/**
	 * @deprecated use load() instead
	 * @throws Exception
	 */
	public void loadPaginated() throws Exception {
		Connection conn =  ConnectionManager.getDataSource().getConnection();
		try {
			loadPaginated(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	/**
	 * 
	 * @deprecated use load() instead
	 * @param conn
	 * @throws Exception
	 */
	public void loadPaginated(Connection conn) throws Exception{
		
		this.iMaxElementsCount = this.iMaxElementsPerPage;
		
		String sRequete = this.getGeneratedRequest();
		CoinDatabaseAbstractBean.traceQueryStatic(sRequete);
		
		Statement stat = null;
		ResultSet rs = null;
		ResultSetMetaData rsMetaData = null;
		try {
			
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
			rsMetaData = rs.getMetaData();
			int i = 0;
			int iCol;
			iCol = rsMetaData.getColumnCount();

			while(rs.next()) {
				i++;
				
		    	if ( ( ( ( this.iCurrentPage )* this.iMaxElementsPerPage ) < i )
		    	&&   ( i <= ( (this.iCurrentPage+1) * this.iMaxElementsPerPage )  ) )
		    	{
		    		Hashtable<String,String> h= new Hashtable<String,String>();
					for (int j=1;j<=iCol;j++){
						try{
							String sData = rs.getString(j);
							//h.put(rsMetaData.getColumnName(j),PreventInjection.preventLoad(sData,false));
							h.put(rsMetaData.getColumnLabel(j),PreventInjection.preventLoad(sData,false));
						}catch(Exception e){
							//h.put(rsMetaData.getColumnName(j),"");
							h.put(rsMetaData.getColumnLabel(j),"");
						}
					}
					this.vResults.add(h);
		    	}

		    	if (this.bMaxElementsCountUsed)
		    	{
		    		if(i >= this.iMaxElementsCount){
		    			this.bMaxElementsCountReach = true;
		    			break;
		    		}
			 	}
			}
			if(this.bMaxElementsCountUsed && this.iCurrentPageCount>0){
    			this.bMaxElementsCountReach = true;
    		}
			
			this.iTotalCountCriterias = i; 
		}finally{
			ConnectionManager.closeConnection(rs,stat);
		}
	}
	
	/**
	 * @return : les résultats de la requête
	 */
	public Vector<Hashtable<String,String> > getResults(){
		return this.vResults;
	}
	
	/**
	 * @deprecated
	 * @return
	 */
	public String getHeaderDesk() {
		String sHTML = "";

		String sDebugMode = "disabled";
		try{
			sDebugMode = Configuration.getConfigurationValueMemory("debug.session");
		}catch(Exception e){}

		
		String sHotLineNumber = "08 92 23 02 41";
		try {
			sHotLineNumber = Configuration.getConfigurationValueMemory("publisher.portail.hotline.number");
		} catch (Exception e) { }

		String sHotLinePrice = "0,34&euro; /min";
		try {
			sHotLinePrice = Configuration.getConfigurationValueMemory("publisher.portail.hotline.price");
			sHotLinePrice = Outils.replaceAll(sHotLinePrice, "&amp;" , "&");
		} catch (Exception e) {}
		
		sHTML += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"" +
				"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">" + NL +
				"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"fr\" lang=\"fr\">" + NL +
				"<head>" + NL +
				"<meta http-equiv=\"Expires\" content=\"-1\" />" + NL +
				"<meta http-equiv=\"Cache-Control\" content=\"no-cache, must-revalidate\" />" + NL +
				"<meta http-equiv=\"Pragma\" content=\"no-cache\" />" + NL +
				"<title>"+this.getTitle()+"</title>" + NL +
				"<link rel=\"stylesheet\" type=\"text/css\" href=\""+this.getRootPath()+"include/new_style/"+Theme.getDeskCSS()+".css\" media=\"screen\" />" + NL +
				"<link rel=\"stylesheet\" type=\"text/css\" href=\""+this.getRootPath()+"include/component/calendar/calendar.css\" media=\"screen\" />"+NL+
				"<link rel=\"SHORTCUT ICON\" href=\""+this.getRootPath()+"include/modula.ico\" />" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/popup.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/redirection.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/verification.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/js/prototype.js" 
					+ "?v="+ JavascriptVersion.PROTOTYPE_JS + "\" ></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/js/run.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/jsonrpc.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/component/calendar/calendar.js\"></script>"+NL+
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/js/shadedborder.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/js/scriptaculous/effects.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/js/livepipe/dragdrop.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/js/livepipe/livepipe.js\"></script>" + NL +
				"<script type=\"text/javascript\" src=\""+this.getRootPath()+"include/js/livepipe/window.js\"></script>" + NL +
				"<script type=\"text/javascript\">" + NL +
				"var rootPath = \""+this.getRootPath()+"\";" + NL +
				"var debugMode = \""+sDebugMode+"\"" + NL +
				"</script>" + NL +
				"</head>" + NL +
				"<body>" + NL +
				"<a id=\"ancreHP\" name=\"ancreHP\"></a>" + NL +
				"<div id=\"headerMenu\">" + NL +
				"<div id=\"titleCorners\" class=\"sb\" style=\"padding:7px 10px 7px 10px\">" + NL +
					"<div>" + NL +
						"<table class=\"fullWidth\" cellpadding=\"0\" cellspacing=\"0\">" + NL +
						"<tr>" + NL +
							"<td>" + NL +
								"<a href=\""+ this.getResponse().encodeURL(this.getRootPath()+"desk/include/main.jsp")+"\" target=\"main\" class=\"home\">Accueil</a>" + NL +
							"</td>" + NL +
							"<td>" + NL +
								"<span class=\"hotline\">Assistance " 
								+ sHotLineNumber  + "(" + sHotLinePrice + ")</span>" + NL +
							"</td>" + NL +
							"<td>" + NL +
								"<span class=\"hour\">"+ CalendarUtil.getDateWithFormat(new Timestamp(System.currentTimeMillis()),"dd/MM/yyyy HH:mm")+"</span>" + NL +
							"</td>" + NL +
							"<td style=\"text-align:right\">" + NL +
								"<a href=\""+this.getResponse().encodeURL(this.getRootPath()+"desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="+((User)this.getSession().getAttribute("sessionUser")).getIdIndividual())+"\" target=\"main\" class=\"profil\">Mon profil</a>" + NL +
								"<a href=\""+this.getResponse().encodeURL(this.getRootPath()+"desk/logout.jsp")+"\" class=\"logout\">Déconnexion</a>" + NL +
							"</td>" + NL +
						"</tr>" + NL +
						"</table>" + NL +
					"</div>" + NL +
				"</div>" + NL +
				"</div>" + NL +
				"<script>" + NL +
				"var myBorder = RUZEE.ShadedBorder.create({corner:4, border:1});" + NL +
				"Event.observe(window, 'load', function(){" + NL +
					"myBorder.render($('titleCorners'));" + NL +
				"});" + NL +
				"</script>" + NL +
				"<div class=\"ficheTablePadding\">" + NL +
				"<table id=\"ficheTable\" cellspacing=\"0\" cellpadding=\"0\" class=\"fullWidth\">" + NL +
					"<tr>" + NL +
						"<td></td>" + NL +
						"<td class=\"imgTop\"></td>" + NL +
						"<td></td>" + NL +
					"</tr>" + NL +
					"<tr>" + NL +
						"<td class=\"imgCenterLeft\"></td>" + NL +
						"<td>" + NL +
							"<div class=\"ficheFrame\">" + NL +
								"<style>" + NL +
									".sb-inner {background-color:#EAEDF3}" + NL +
									".sb-border {background-color:#A4BCD2}" + NL +
								"</style>" + NL +
								"<table cellspacing=\"0\" cellpadding=\"0\" id=\"pageTitleWrapper\" style=\"margin:0 auto\"><tr><td>" + NL +
									"<div id=\"pageTitleRound\" class=\"roundCorners\" style=\"padding:4px 10px 4px 10px\"><span id=\"pageTitle\">"+this.getTitle()+"</span></div>" + NL +
								"</td></tr></table>" + NL;
		sHTML += "<div style=\"padding:15px\">"+NL;

		return sHTML;
	}
	
	/**
	 * @deprecated
	 * @return
	 */
	public String getHTMLHeaderBar(){
		String sHTML = "";
		if (this.getBarBouton().size()>0){
			
			sHTML += "<div id=\"menuBorder\" class=\"sb\" style=\"padding:3px 10px 3px 10px;margin:0 20px 0 20px;\">"+NL+
				"<div class=\"fullWidth\">" + NL +
					BarBouton.getAllButtonHtmlDesk(vBarBoutons)+
				"</div>" + NL +
			"</div>" + NL +
			"<script>" + NL +
			"var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});" + NL +
			"Event.observe(window, 'load', function(){" + NL +
				"menuBorder.render($('menuBorder'));" + NL +
			"});" + NL +
			"</script>";
		}
		
		sHTML += "<a name=\"ancreError\"></a>"+NL+
				"<div class=\"rouge\" style=\"text-align:left\" id=\"divError\"></div>";
		return sHTML;
	}
	
	/**
	 * @deprecated
	 * @return
	 * @throws CoinDatabaseLoadException
	 * @throws SQLException
	 * @throws NamingException
	 */
	public String getFooterDesk() throws CoinDatabaseLoadException, SQLException, NamingException{
		String sHTML = "";
		sHTML += "</div>" + NL +
				"</td>" + NL +
				"<td class=\"imgCenterRight\"></td>" + NL +
			"</tr>" + NL +
			"<tr>" + NL +
				"<td></td>" + NL +
				"<td class=\"imgBottom\"></td>" + NL +
				"<td></td>" + NL +
			"</tr>" + NL +
		"</table>" + NL +
		"</div> <!-- end ficheTablePadding -->" + NL;
		sHTML += "</div>"+NL;
		sHTML += "</body>"+NL+"</html>"+NL;
		return sHTML;
	}

	public String getLimit(int iTYPE) throws JSONException{
		String sHTML = "";
		JSONArray json = new JSONArray();
		
		if(this.bMaxElementsCountUsed && this.bMaxElementsCountReach){
			if(this.iCurrentPageCount>0){
				if(iTYPE == TYPE_HTML){
					sHTML += "<a href=\""
						+ this.getResponse().encodeURL(
						this.getURLFormTarget()
						+"?"+this.getGeneratedParametersForURL()
						+"&amp;"+AutoFormSearchEngine.PARAM_NAME_CURRENT_COUNT_PAGE
						+"="+(this.iCurrentPageCount-1)
						+"#ancreHP"
						)
						+ "\">"+getLocalizedLabel(LABEL_PREV)+"</a>";
				}else if(iTYPE==TYPE_JSON){
					JSONObject obj = new JSONObject();
					obj.put("name", JSON_PREVIOUS_LIMIT);
					obj.put("value", (this.iCurrentPageCount-1));
					json.put(obj);
				}
			}
			if(iTYPE == TYPE_HTML){
				sHTML += " "+getLocalizedLabel(LABEL_SEARCH_LIMIT)+" : "+(this.iCurrentPageCount*this.iMaxElementsCount)+" > "+((this.iCurrentPageCount+1)*this.iMaxElementsCount);
				
				sHTML += " <a href=\""
					+ this.getResponse().encodeURL(
					this.getURLFormTarget()
					+"?"+this.getGeneratedParametersForURL()
					+"&amp;"+AutoFormSearchEngine.PARAM_NAME_CURRENT_COUNT_PAGE
					+"="+(this.iCurrentPageCount+1)
					+"#ancreHP"
					)
					+ "\">"+getLocalizedLabel(LABEL_NEXT)+"</a>";
			}else if(iTYPE==TYPE_JSON){
				
				JSONObject obj = new JSONObject();
				obj.put("name", JSON_CURRENT_LIMIT);
				obj.put("value", (this.iCurrentPageCount));
				json.put(obj);
				
				JSONObject obj2 = new JSONObject();
				obj2.put("name", JSON_NEXT_LIMIT);
				obj2.put("value", (this.iCurrentPageCount+1));
				json.put(obj2);
			}
		}
		
		String sReturn = "";
		if(iTYPE ==AutoFormSearchEngine.TYPE_HTML){
			sReturn = sHTML;
		}else if(iTYPE == AutoFormSearchEngine.TYPE_JSON){
			sReturn = json.toString();
		}
		return sReturn;
	}
	
	/**
	 * @deprecated
	 * @return
	 * @throws CoinDatabaseLoadException
	 * @throws SQLException
	 * @throws NamingException
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public String getHTML() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		String sHTML = this.getHeaderDesk();
		sHTML += getHTMLBody();
		sHTML += this.getFooterDesk()+NL;
		
		return sHTML;
	}
	
	@SuppressWarnings("unchecked")
	public String getHTMLBody() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		String sHTML = getHTMLHeaderBar();
		sHTML += "<script type=\"text/javascript\">";
		for(int i=0;i<this.getSEComponent().size();i++){
			sHTML += this.getSEComponent().get(i).getJavascriptControlCode()+ NL ;
		}
		sHTML += this.afResult.getJavascriptControlCode();
		sHTML += "</script>";
		
		try{this.afBlockSearch.setLabelTextBis(getLimit(TYPE_HTML));}
		catch(Exception e){}

		AutoFormSENextAndPrevious afNP = null;
		if (this.iTotalCountCriterias>0){

			afNP = new AutoFormSENextAndPrevious(
							this.iTotalCountCriterias,
							this.getCurrentPage(),
							this.getMaxElementsPerPage(),
							this.getGroupPerPage(),
							this.getURLFormTarget(),
							this.getGeneratedParametersForURL(),
							this.getRootPath(),
							this.getResponse());
			this.afBlockResult.addComponent(afNP);
		}

		// Ajout des composants de recherche au bloc :
		for(int i=0;i<this.getSEComponent().size();i++){
			AutoFormSEComponent item = this.getSEComponent().get(i);
			if(item instanceof AutoFormSECptSearchSelection && !((AutoFormSECptSearchSelection)item).isInSearchBlock())
			{
				//if (iTotalCountCriterias>0){
				((AutoFormSECptSearchSelection)item).afSelect.setOnChange("document.getElementById('"+this.afForm.getId()+"').submit();");
				this.afBlockResult.addComponent(item);
				//}
			}
			else
				this.afBlockSearch.addComponent(this.getSEComponent().get(i));
		}
		AutoFormCptInputSubmit submit = new AutoFormCptInputSubmit("butSubmit", getLocalizedLabel(LABEL_SEARCH_BUT));
		//if(this.getSEComponent() != null && this.getSEComponent().size()>0)
			//submit.setClassName(this.afBlockSearch.getComponent().lastElement().sClassName);
		this.afBlockSearch.addComponent(submit);
		
		HashMap<String, Object> mapAdvancedFunction 
			= getAdvancedFunction(
					this.bMaxElementsCountUsed, 
					this.iMaxElementsCount, 
					this.iMaxElementsPerPage, 
					this.getGeneratedRequest(), 
					this.iAbstractBeanIdLanguage);
		
		Vector<AutoFormComponent> vCpt = (Vector<AutoFormComponent>)mapAdvancedFunction.get("autoformComponents");
		String sAddJavascript = (String)mapAdvancedFunction.get("javascriptCode");
		
		for(AutoFormComponent cpt : vCpt){
			this.afBlockSearch.addComponent(cpt);
		}
		
		this.afForm.addComponent(this.afBlockSearch);
		this.afBlockResult.setLabelTextBis(this.getLabelCountForResultBlock(this.iTotalCountCriterias));

		if (iTotalCountCriterias>0){
			this.afBlockResult.addComponent(this.afOrderBy);
			this.afBlockResult.addComponent(this.afResult);
			this.afBlockResult.addComponent(afNP);
		}

		this.afForm.addComponent(this.afBlockResult);
		
		sHTML += "<script type=\"text/javascript\">"+sAddJavascript+"</script>"+NL;
		sHTML += this.afForm.getHTML()+NL;

		return sHTML;
	}
	
	public static HashMap<String, Object> getAdvancedFunction(boolean bMaxElementsCountUsed,int iMaxElementsCount, int iMaxElementsPerPage) throws SQLException, NamingException, InstantiationException, IllegalAccessException{
		return getAdvancedFunction(bMaxElementsCountUsed, iMaxElementsCount, iMaxElementsPerPage, "", Language.LANG_FRENCH);
	}
	
	public static HashMap<String, Object> getAdvancedFunction(boolean bMaxElementsCountUsed,int iMaxElementsCount, int iMaxElementsPerPage,String sRequest, int iLanguage) throws SQLException, NamingException, InstantiationException, IllegalAccessException{
		HashMap<String, Object> mapAdvancedFunction = new HashMap<String, Object>();
		Vector<AutoFormComponent> vCpt = new Vector<AutoFormComponent>();
		AutoFormCptLabel advancedFunction = new AutoFormCptLabel(){
			public String getJavascriptControlCode(){
				String sHTML = "";
				
				sHTML += this.afLabel.getJavascriptControlCode()+NL;
				return sHTML;
			}
		};
		advancedFunction.afLabel.setValue("<a href=\"javascript:showAdvancedFunctions()\">"+getLocalizedLabel(LABEL_ADVANCED_FEATURES,iLanguage)+"</a>");
		vCpt.add(advancedFunction);
		
		AutoFormCptSelect selectCutCount = new AutoFormCptSelect(getLocalizedLabel(LABEL_LIMIT_RESULT, iLanguage),PARAM_NAME_USE_CUT_COUNT,bMaxElementsCountUsed+"",false);
		selectCutCount.addItem(getLocalizedLabel(LABEL_LIMIT_RESULT_YES, iLanguage), true+"");
		selectCutCount.addItem(getLocalizedLabel(LABEL_LIMIT_RESULT_NO, iLanguage), false+"");
		vCpt.add(selectCutCount);
		AutoFormCptInputText inputCutCount = new AutoFormCptInputText(getLocalizedLabel(LABEL_LIMIT, iLanguage),PARAM_NAME_MAX_ELEMENT_COUNT,iMaxElementsCount+"",false,-1);
		vCpt.add(inputCutCount);
		AutoFormCptInputText inputNbResult = new AutoFormCptInputText(getLocalizedLabel(LABEL_NUMBER_RESULT, iLanguage),PARAM_NAME_MAX_ELEMENT_PER_PAGE,iMaxElementsPerPage+"",false,-1);
		vCpt.add(inputNbResult);
		
		boolean bIsDebug = Configuration.isEnabledMemory("debug.session",false);
		if(bIsDebug){
			AutoFormCptLabel labelRequest = new AutoFormCptLabel(sRequest,"debug_request");
			vCpt.add(labelRequest);
		}
		
		String sAddJavascript = "var advancedFunctions = \"\";"+NL
		+ "function showAdvancedFunctions()"+NL
		+ "{"+NL
		+ "if(advancedFunctions == \"\"){"
		+ "advancedFunctions = \"none\";"
		+ "}else{"
		+ "advancedFunctions = \"\";"
		+ "}"
		+ "$(\""+ advancedFunction.PREFIX+"_"+ AutoFormSearchEngine.PARAM_NAME_MAX_ELEMENT_COUNT+"\").style.display = advancedFunctions;"+NL
		+ "$(\""+ advancedFunction.PREFIX+"_"+ AutoFormSearchEngine.PARAM_NAME_USE_CUT_COUNT+"\").style.display = advancedFunctions;"+NL
		+ "$(\""+ advancedFunction.PREFIX+"_"+ AutoFormSearchEngine.PARAM_NAME_MAX_ELEMENT_PER_PAGE+"\").style.display = advancedFunctions;"+NL
		+ (bIsDebug?"$(\""+ advancedFunction.PREFIX+"_"+ "debug_request" +"\").style.display = advancedFunctions;"+NL:"")
		+ "}"+AutoFormSearchEngine.NL;
		sAddJavascript += "Event.observe(window, 'load', function(){"+NL;
		sAddJavascript += "showAdvancedFunctions();"+NL;
		sAddJavascript += "});"+NL;
		
		mapAdvancedFunction.put("autoformComponents", vCpt);
		mapAdvancedFunction.put("javascriptCode", sAddJavascript);
		
		return mapAdvancedFunction;
	}
	
	public AutoFormSEOrderBy getAfOrderBy() {
		return afOrderBy;
	}
	public void setAfOrderBy(AutoFormSEOrderBy afOrderBy) {
		this.afOrderBy = afOrderBy;
	}
	public AutoFormSEMatrixList getAfResult() {
		return afResult;
	}
	public AutoFormCptBlock getAfBlockResult() {
		return afBlockResult;
	}
	public void setAfBlockResult(AutoFormCptBlock afBlockResult) {
		this.afBlockResult = afBlockResult;
	}

	public void setMaxElementsCountUsed(boolean maxElementsCountUsed) {
		this.bMaxElementsCountUsed = maxElementsCountUsed;
	}

	public void setMaxElementsCount(int maxElementsCount) {
		iMaxElementsCount = maxElementsCount;
	}
	
	public JSONArray getResultToJSONArray() 
	throws JSONException, CoinDatabaseLoadException, SQLException, NamingException{
		JSONArray json = new JSONArray();
		for(Hashtable<String, String> result : this.vResults){
			JSONObject obj = new JSONObject();
			for(String key : result.keySet()){
				obj.put(key, result.get(key));
			}
			json.put(obj);
		}
		
		AutoFormSENextAndPrevious afNP = new AutoFormSENextAndPrevious(
				this.iTotalCountCriterias,
				this.getCurrentPage(),
				this.getMaxElementsPerPage(),
				this.getGroupPerPage(),
				this.getURLFormTarget(),
				this.getGeneratedParametersForURL(),
				this.getRootPath(),
				this.getResponse(),
				this.iAbstractBeanIdLanguage);
		String sPagination = afNP.getPagination(TYPE_JSON);

		if(!Outils.isNullOrBlank(sPagination)){
			JSONObject objPagination = new JSONObject();
			objPagination.put("sPagination", sPagination);
			json.put(objPagination);
		}
		
		JSONObject objCount = new JSONObject();
		objCount.put("iTotalCountCriterias", this.iTotalCountCriterias);
		json.put(objCount);
		
		JSONObject objCountLimit = new JSONObject();
		objCountLimit.put("iCurrentPageCount", this.iCurrentPageCount);
		json.put(objCountLimit);
		
		JSONObject objReachLimit = new JSONObject();
		objReachLimit.put("bMaxElementsCountReach", this.bMaxElementsCountReach);
		json.put(objReachLimit);
		
		try{
			if(Configuration.isEnabledMemory("debug.session")){
				JSONObject obj= new JSONObject();
				obj.put("sGeneratedRequest", this.getGeneratedRequest());
				json.put(obj);
			}
			JSONObject objGeneratedRequest= new JSONObject();
			objGeneratedRequest.put("sGeneratedRequestSecure", this.getGeneratedRequestSecure());
			json.put(objGeneratedRequest);
		}catch(Exception e){}
		
		return json;
	}
	
	@RemoteMethod
	public static String getJSONArrayResult(String sJSONSearch) throws Exception {
		JSONArray json = new JSONArray();
		Connection conn = null; 
		AutoFormSearchEngine se = new AutoFormSearchEngine();
		try{
			se.hsrResponse = DwrSession.getResponse();
			se.httpSession = DwrSession.getSession();
			se.iAbstractBeanIdLanguage = (int)((Language)se.httpSession.getAttribute(HabilitationFilterUtil.SESSION_LANGUAGE)).getId();
			se.loadFromJSONObject(new JSONObject((sJSONSearch==null)?"{}":sJSONSearch), true);
			if(se.bUseBeanGeneratorConnection){
				conn = BeanGenerator.getConnection();
			} else {
				conn = ConnectionManager.getConnection();
			}
			
			if(TRACE_QUERY)
			{
				System.out.println("/**");
				System.out.println(" * REQUEST TO TREAT : \n" + se.getGeneratedRequest());
				System.out.println(" */");
			}
			se.load(conn);
			json = se.getResultToJSONArray();
		} catch(Exception e){
			if(se != null) {
				System.out.println("/**");
				System.out.println(" * REQUEST FAILED : \n" + se.getGeneratedRequest());
				System.out.println(" */");
				e.printStackTrace();
			}
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		return json.toString();
	}
	
	/*
	@RemoteMethod
	public static String getJSONArrayResultFromEngine(int iIdEngine, String sJSONSearch) throws Exception {
		JSONArray json = new JSONArray();
		try{
			AutoFormSearchEngine se = Query.getSearchEngine(iIdEngine);
			
			JSONObject queryObj = new JSONObject(sJSONSearch);
			se.loadFromJSONObject(queryObj, false);
			if (queryObj.getBoolean("loadPaginated")) {
				se.loadPaginated();
			} else {
				se.load();
			}
			json = se.getResultToJSONArray();
		}catch(Exception e){e.printStackTrace();}
		return json.toString();
	}
	*/
	
	private void loadFromJSONObject(JSONObject jsonObj, boolean bFullQuery) throws JSONException {
		
		try{
			this.bUseBeanGeneratorConnection = jsonObj.getBoolean("bUseBeanGeneratorConnection");
		}catch (Exception e) {}
		
		try{
			this.bUseHttpPrevent = jsonObj.getBoolean("bUseHttpPrevent");
		}catch (Exception e) {}
		
		if (bFullQuery) {
			this.sIdInTable = jsonObj.getString("sIdInTable");
			this.sMainTable = jsonObj.getString("sMainTable");
			this.sMainAliasTable = jsonObj.getString("sMainAliasTable");
			this.sSelectPart = "";
			try{this.sSelectPart = jsonObj.getString("sSelectPart");}
			catch(Exception e){}
			
			this.sSelectPart = "";
			try{this.sSelectPart 
				= SecureString.getSessionPlainString(
						jsonObj.getString("sSelectPart"), 
						(this.getSession()!=null?this.getSession():DwrSession.getSession()));}
			catch(Exception e){}
		}
			
		try {
			JSONArray otherTables = jsonObj.getJSONArray("vOtherTables");
			for(int i=0; i<otherTables.length(); i++) {			
				JSONObject table = otherTables.getJSONObject(i);
				boolean bLeftJoin = false;
				try {
					bLeftJoin= table.getBoolean("leftJoin");
				}  catch(Exception e) {}
				this.addOtherTable(table.getString("tableName"), table.getString("jointure"), bLeftJoin);
			}
		} catch(Exception e) {}
		
		try {
			JSONArray otherTablesWithLeftJoin = jsonObj.getJSONArray("vOtherTablesWithLeftJoin");
			for(int i=0; i<otherTablesWithLeftJoin.length(); i++) {			
				JSONObject table = otherTablesWithLeftJoin.getJSONObject(i);
				this.addOtherTableWithLeftJoin(table.getString("tableName"), table.getString("jointure"));
			}
		} catch(Exception e) {}
		
		
		try {
			JSONArray filters = jsonObj.getJSONArray("vFilter");
			for(int i=0; i<filters.length(); i++) {
				JSONObject filter = filters.getJSONObject(i);
				
				ArrayList<String> aFields = new ArrayList<String>();
				JSONArray jsonFields = filter.getJSONArray("fields");
				for(int j=0; j<jsonFields.length(); j++) {	
					aFields.add(jsonFields.getString(j));
				}
				
				ArrayList<String> aValues = new ArrayList<String>();
				JSONArray jsonValues = filter.getJSONArray("values");
				for(int j=0; j<jsonValues.length(); j++) {	
					aValues.add(jsonValues.getString(j));
				}
				
				this.addFilter(aFields,
						aValues,
						filter.getBoolean("optLike"),
						filter.getString("compareFilter"));
			}
		} catch(Exception e) {e.printStackTrace();}
		
		try {
			JSONArray headers = jsonObj.getJSONArray("vHeaders");
			this.afResult.vHeaders = new ArrayList<Hashtable<String, String>>();
			for(int i=0; i<headers.length(); i++) {			
				JSONObject header = headers.getJSONObject(i);
				
				String sTitle = "";
				try{sTitle = header.getString("title");}catch(Exception e){}
				
				String sOrder = "";
				try{sOrder = header.getString("order");}catch(Exception e){}
				
				String sDirection = "";
				try{sDirection = header.getString("direction");}catch(Exception e){}
				
				this.addHeaderToResultCpt(sTitle,sOrder,sDirection );
			}
		} catch(Exception e) {}
		
		if (bFullQuery) {
			try {
				this.setGroupByClause(jsonObj.getString("sGroupByClause"));
			} catch(Exception e) {}
		}
		
		/** PAGINATION */
		try {
			this.bMaxElementsCountUsed = jsonObj.getBoolean("bMaxElementsCountUsed");
		} catch(Exception e) {}
		try {
			this.iMaxElementsPerPage = jsonObj.getInt("iMaxElementsPerPage");
		} catch(Exception e) {}
		try {
			this.iGroupPerPage = jsonObj.getInt("iGroupPerPage");
		} catch(Exception e) {}
		try {
			this.iMaxElementsCount = jsonObj.getInt("iMaxElementsCount");
		} catch(Exception e) {}
		try {
			this.iCurrentPageCount = jsonObj.getInt("iCurrentPageCount");
		} catch(Exception e) {}
		try {
			this.iCurrentPage = jsonObj.getInt("iCurrentPage");
		} catch(Exception e) {}
	}
	
	private void buildQueryFromJSONObject(JSONObject jsonObj) throws JSONException {		
		this.sIdInTable = jsonObj.getString("idInTable");
		this.sMainTable = jsonObj.getString("mainTable");
		this.sMainAliasTable = jsonObj.getString("mainTableAlias");
		this.sSelectPart = "";
		try{this.sSelectPart = jsonObj.getString("selectPart");}
		catch(Exception e){}
		
		try {
			this.setMaxElementsPerPage(jsonObj.getInt("offset"));
		} catch(Exception e) {}
		
		try {
			this.setCurrentPage(jsonObj.getInt("index")/this.getMaxElementsPerPage());
		} catch(Exception e) {}
		
		try {
			JSONArray otherTables = jsonObj.getJSONArray("otherTables");
			for(int i=0; i<otherTables.length(); i++) {			
				JSONObject table = otherTables.getJSONObject(i);
				boolean bLeftJoin = false;
				try {
					bLeftJoin= table.getBoolean("leftJoin");
				}  catch(Exception e) {}
				this.addOtherTable(table.getString("tableName"), table.getString("jointure"), bLeftJoin);
			}
		} catch(Exception e) {}
		
		try {
			JSONArray otherTablesWithLeftJoin = jsonObj.getJSONArray("otherTablesWithLeftJoin");
			for(int i=0; i<otherTablesWithLeftJoin.length(); i++) {			
				JSONObject table = otherTablesWithLeftJoin.getJSONObject(i);
				this.addOtherTableWithLeftJoin(table.getString("tableName"), table.getString("jointure"));
			}
		} catch(Exception e) {}
		
		try {
			JSONArray filters = jsonObj.getJSONArray("filters");
			for(int i=0; i<filters.length(); i++) {
				this.addClauseInvariante(filters.getString(i));
			}
		} catch(Exception e) {}
		
		try {
			JSONObject order = jsonObj.getJSONObject("orderBy");
			this.afOrderBy.setInitValueForSelectOrder(order.getString("name"));
			try {
				this.afOrderBy.setInitValueForSelectWay(order.getString("direction"));
			}  catch(Exception e) {}
		} catch(Exception e) {}
		
		try {
			this.setGroupByClause(jsonObj.getString("groupBy"));
		} catch(Exception e) {}
		
	}

	/**
	 * Compte le nombre total d'éléments avec critères
	 * @throws Exception 
	 */
	 public int getTotalCount() throws Exception{
		Connection conn =  ConnectionManager.getDataSource().getConnection();
		try {
			return getTotalCount(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public int getTotalCount(Connection conn) throws Exception{
	    String sRequete = this.getGeneratedRequestCountResult();
	    
	    int iCount = 0;		
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
			
			while(rs.next()) {
				if(this.getGroupByClause().equalsIgnoreCase(""))
					iCount = rs.getInt(1);
				else
					iCount++;
			}
		}finally{
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		return iCount;
	}
	
	public static String getLocalizedLabel(String sFieldName, int iLanguage) {
		AutoFormSearchEngine af = new AutoFormSearchEngine();
		af.iAbstractBeanIdLanguage = iLanguage;
		s_sarrLocalizationLabel = af.getLocalizationLabel(s_sarrLocalizationLabel);
		return s_sarrLocalizationLabel[iLanguage].get(sFieldName);
	}
	
	public String getLocalizedLabel(String sFieldName) {
		return getLocalizedLabel(sFieldName, "");
	}
	
	public String getLocalizedLabel(String sFieldName,String sDefaultValue) {
		s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel);
		String sValue = sDefaultValue;
		try{sValue = s_sarrLocalizationLabel[this.iAbstractBeanIdLanguage].get(sFieldName);}
		catch(Exception e){sValue = sDefaultValue;}
		if(Outils.isNullOrBlank(sValue))
			sValue = sDefaultValue;
		
		return sValue;
	}
	
	public void updateLocalization() 
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{

		Connection conn = ConnectionManager.getConnection();
		try {
			updateLocalization( conn);
		}  finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
	
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel, true);
	}
    
    public Map<String,String>[]  getLocalizationLabel(
			Map<String,String>[] sarrLocalizationLabel) {
		return getLocalizationLabel(sarrLocalizationLabel, false);
	}
	
	public Map<String,String>[]  getLocalizationLabel(
			Map<String,String>[] sarrLocalizationLabel,
			boolean bForceReload) {
		
		if(sarrLocalizationLabel != null && !bForceReload) return sarrLocalizationLabel;
		
		try {
			
			sarrLocalizationLabel 
				= ObjectAttributeLocalization
					.generateAttributeLocalizationMatrixString(this.iAbstractBeanIdObjectType);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sarrLocalizationLabel; 
	}
}
