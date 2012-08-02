/*
* Studio Matamore - France 2007, tous droits reserves
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.bean;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.fr.bean.Organisation;
import org.coin.fr.bean.OrganisationService;
import org.coin.fr.bean.PersonnePhysique;
import org.coin.util.BasicDom;
import org.coin.util.BeanGenerator;
import org.coin.util.JavaUtil;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Node;

@RemoteProxy
public class ObjectType extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

	public static final int SYSTEME = 0;
	public static final int AFFAIRE = 1;
	public static final int COMMISSION = 2;
	public static final int ORGANISATION = 3;
	public static final int PERSONNE_PHYSIQUE = 4;
	public static final int ENVELOPPE_A = 5;
	public static final int ENVELOPPE_B = 6;
	public static final int AAPC = 7;
	public static final int AATR = 8;
	public static final int INVITATION_OFFRE = 9;
	public static final int AVIS_RECTIFICATIF = 10;
	public static final int CANDIDATURE = 11;
	public static final int DOCUMENT = 12;
	public static final int MARCHE_PIECE_JOINTE = 13;
	public static final int MULTIMEDIA = 14;
	public static final int ENVELOPPE_A_PJ = 15;
	public static final int ENVELOPPE_B_PJ = 16;
	public static final int QUARANTAINE = 17;
	public static final int QUARANTAINE_RAPPORT = 18;
	public static final int ENVELOPPE_C_PJ = 19;
	public static final int ANCIEN_AVIS = 20;
	public static final int ENVELOPPE_C = 21;
	public static final int ENVELOPPE_A_PJ_CERT = 22;
	public static final int ENVELOPPE_B_PJ_CERT = 23;
	public static final int ENVELOPPE_C_PJ_CERT = 24;
	public static final int PAYS = 50;
	public static final int CIVILITE = 51;
	public static final int TREEVIEW_NODE = 52;
	public static final int TREEVIEW = 53;
	public static final int ADRESSE = 54;
	public static final int ORGANISATION_TYPE = 55;
	public static final int USER = 56;
	public static final int OBJECT_TYPE = 57;
	public static final int HABILITATION = 58;
	public static final int LANGUAGE = 59;
	public static final int AF_SEARCH_ENGINE = 60;
	public static final int SEARCH_ENGINE = 61;
	public static final int USER_TAB = 62;
	public static final int EVENEMENT = 63;
	public static final int TYPE_EVENEMENT = 64;
	public static final int CONFIGURATION = 65;
	public static final int USE_CASE = 66;
	public static final int MULTIMEDIA_TYPE = 67;
	public static final int USER_STATUS = 68;
	public static final int DELEGATION_TYPE = 69;
	public static final int GROUP = 70;
	public static final int DELEGATION_STATE = 71;
	public static final int DELEGATION = 72;
	
	
	public static final int WORKFLOWDEFINITION_WORKFLOW = 100;
	public static final int WORKFLOWDEFINITION_STATE = 101;
	public static final int WORKFLOWDEFINITION_TRANSITION = 102;
	public static final int WORKFLOWDEFINITION_TRANSITION_CONDITION = 103;

	public static final int WORKFLOW_WORKFLOW = 200;
	public static final int WORKFLOW_STACK = 201;
	public static final int WORKFLOW_PATH_EVENT = 202;
	public static final int WORKFLOW_FOLDER = 203;
	public static final int WORKFLOW_DOCUMENT = 204;
	public static final int WORKFLOW_TIMER = 205;

	public static final int ORGANIGRAM = 300;
	public static final int ORGANIGRAM_NODE = 301;
	public static final int ORGANIGRAM_NODE_TYPE = 302;
	public static final int ORGANIGRAM_NODE_STATE = 303;
	
	public static final int OBJECT_GROUP = 400;
	public static final int ORGANISATION_SERVICE = 401;
	public static final int ORGANISATION_DEPOT = 402;
	public static final int ORGANISATION_SERVICE_STATE = 403;
	
	public static final int PLANIFICATION = 500;
	public static final int PLANIFICATION_TYPE = 501;
	public static final int PLANIFICATION_STATE = 503;
	public static final int PLANIFICATION_CONTRACT_TYPE = 504;
	public static final int PLANIFICATION_CONTRACT = 505;
	public static final int PLANIFICATION_VEHICLE = 506;
	public static final int PLANIFICATION_VEHICLE_REPLACEMENT = 507;
	public static final int PLANIFICATION_VEHICLE_STATE = 508;
	public static final int PLANIFICATION_VEHICLE_TYPE = 509;

	public static final int VEHICLE = 600;
	public static final int VEHICLE_BODY_TYPE = 601;
	public static final int VEHICLE_COMPONENT_MODEL = 602;
	public static final int VEHICLE_OLDNEST_TYPE = 603;
	public static final int VEHICLE_STATE = 604;
	public static final int VEHICLE_MODEL = 605;
	public static final int VEHICLE_REPLACEMENT = 606;
	public static final int VEHICLE_CHARACTERISTIC_TYPE = 607;
	public static final int VEHICLE_TYPE = 608;
	public static final int VEHICLE_COMPONENT_TYPE = 609;
	public static final int VEHICLE_PURCHASE_TYPE = 610;
	public static final int VEHICLE_CHARACTERISTIC_TYPE_VALUE = 611;
	public static final int VEHICLE_COMPONENT_MODEL_TYPE = 612;
	public static final int VEHICLE_COMPONENT_MODEL_STATE = 613;
	public static final int VEHICLE_CHARACTERISTIC = 614;
	public static final int VEHICLE_STATISTICS = 615;
	public static final int VEHICLE_HISTORY = 616;

	public static final int CONTRACT = 700;
	public static final int CONTRACT_TYPE = 701;
	public static final int CONTRACT_VEHICLE = 702;
	public static final int CONTRACT_CATEGORY = 703;
	public static final int CONTRACT_SERVICE_TYPE = 704;
	public static final int CONTRACT_STATE = 705;
	public static final int CONTRACT_VEHICLE_TYPE = 706;
	public static final int CONTRACT_SPECIFIC_DATA = 707;
	public static final int CONTRACT_LIST = 708;
	public static final int CONTRACT_LIST_TYPE = 709;
	
	public static final int CURRENCY = 800;
	
	public static final int ALGO_ETAPE = 900;
	public static final int ALGO_PHASE = 901;
	public static final int ALGO_PROCEDURE = 902;
	public static final int ALGO_CONDITION = 903;

	public static final int GED_DOCUMENT = 1000;
	public static final int GED_DOCUMENT_REVISION = 1001;
	public static final int GED_FOLDER = 1002;
	public static final int GED_DOCUMENT_ANNOTATION = 1003;
	public static final int GED_DOCUMENT_REVISION_SEAL = 1004;
	public static final int GED_DOCUMENT_ENTITY_TYPE = 1005;
	public static final int GED_DOCUMENT_ANNOTATION_TYPE = 1006;
	public static final int GED_FOLDER_STATE = 1007;
	public static final int GED_DOCUMENT_STATE = 1008;
	public static final int GED_DOCUMENT_CONTENT_TYPE = 1009;
	public static final int GED_CATEGORY = 1010;
	public static final int GED_DOCUMENT_TYPE = 1011;
	
	public static final int WEBSITE_PUBLICATION = 1100;
	
	public static final int FONDATION_LECLERC_GUESTBOOK = 1200;
	public static final int FONDATION_LECLERC_BIBLIOGRAPHY = 1201;
	public static final int FONDATION_LECLERC_PHOTOGRAPHY = 1202;
	public static final int FONDATION_LECLERC_GLOSSARY = 1203;
	public static final int FONDATION_LECLERC_ELECTRONIC_EDITION = 1204;
	public static final int FONDATION_LECLERC_STREET_MONUMENT = 1205;
	
	public static final int PARAPH_FOLDER_TYPE 		= 2000;
	public static final int PARAPH_SIGNATURE_TYPE 	= 2001; 
	public static final int PARAPH_FOLDER 			= 2002;
	public static final int PARAPH_FOLDER_STATE 	= 2003;
	public static final int PARAPH_FOLDER_KIND 		= 2004;	
	public static final int PARAPH_FOLDER_WORKFLOW_NODE_STATE 	= 2005;
	public static final int PARAPH_BINDER 	= 2006;	
	public static final int PARAPH_FOLDER_CLASS 	= 2007;
	public static final int PARAPH_FOLDER_NOTIFICATION_TYPE 	= 2008;
	public static final int PARAPH_FOLDER_OPTION_TYPE 	= 2009;
	public static final int PARAPH_FOLDER_WORKFLOW_TYPE 	= 2010;
	public static final int PARAPH_FOLDER_ENTITY_TYPE 	= 2011;
	
	public static final int PKI_CERTIFICATE_SIGNATURE	= 3000;
	
    protected String sLibelle;
    protected String sTableObjet;
    protected String sChampIdObjet;
    protected String sClass;

    public static Vector<ObjectType> m_vObjectType = null;
    
    protected static String[][] s_sarrLocalizationLabel;
 
    public static String[] sObjectFieldException = {"serialVersionUID",
    												"s_sarrLocalizationLabel"};

    public ObjectType() {
        init();
    }

    public ObjectType(long lId) {
        init();
        this.lId = lId;
    }


    public ObjectType(long lId, String sName) {
        init();
        this.lId = lId;
        this.sLibelle = sName;
    }
    
	public Vector<ObjectType> getAllOrderById() throws SQLException, NamingException
	, InstantiationException, IllegalAccessException{
		String sOrderByClause  = " ORDER BY " + this.FIELD_ID_NAME + " ASC";
		return getAllWithWhereAndOrderByClauseStatic("", sOrderByClause) ;
	}
	
    
    public void init() {
        super.TABLE_NAME = "type_objet_modula";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " libelle,"
                + " table_objet,"
                + " champ_id_objet,"
                + " class";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
		super.iAbstractBeanIdObjectType = ObjectType.OBJECT_TYPE;

        this.lId = 0;
        this.sLibelle = "";
        this.sTableObjet = "";
        this.sChampIdObjet = "";
        this.sClass = "";
      
        this.bAutoIncrement = false;
        this.bIsAutoIncrementTable = false;
    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vObjectType = getAllStatic(this);
    }

    public Vector<ObjectType> getItemMemory() {
        return m_vObjectType;
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory(this);
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, this.sLibelle);
        ps.setString(++i, this.sTableObjet);
        ps.setString(++i, this.sChampIdObjet);
        ps.setString(++i, this.sClass);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sLibelle = rs.getString(++i);
        this.sTableObjet = rs.getString(++i);
        this.sChampIdObjet = rs.getString(++i);
        this.sClass = rs.getString(++i);
    }

    public static ObjectType getObjectType(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException  {
        ObjectType item = new ObjectType(lId);
        item.load();
        return item;
    }
    
    public static ObjectType getObjectType(
    		long lId,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException  {
        ObjectType item = new ObjectType(lId);
        item.bUseHttpPrevent = bUseHttpPrevent;
        item.load(conn);
        return item;
    }
    
    public static ObjectType getObjectTypeMemory(long lId, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	ObjectType item = new ObjectType(lId);
    	item.bUseEmbeddedConnection = true;
    	item.connEmbeddedConnection = conn;
    	return getObjectTypeMemory(item);
    }
    
    public static ObjectType getObjectTypeMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	ObjectType item = new ObjectType(lId);
    	return getObjectTypeMemory(item);
    }

    public static ObjectType getObjectTypeMemory(ObjectType loader)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (ObjectType item : getAllStaticMemory(loader)) {
            if (item.getId()==loader.getId()) return item;
        }
        throw new CoinDatabaseLoadException("" + loader.getId(), "static");
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sLibelle = request.getParameter(sFormPrefix + "sLibelle");
        } catch(Exception e){}
        try {
            this.sTableObjet = request.getParameter(sFormPrefix + "sTableObjet");
        } catch(Exception e){}
        try {
            this.sChampIdObjet = request.getParameter(sFormPrefix + "sChampIdObjet");
        } catch(Exception e){}
        try {
            this.sClass = request.getParameter(sFormPrefix + "sClass");
        } catch(Exception e){}
        try {
            this.lId = Long.parseLong(request.getParameter(sFormPrefix + "lId"));
        } catch(Exception e){}
    }

    public static Vector<ObjectType> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectType item = new ObjectType();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<ObjectType> getAllStatic(ObjectType item)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY libelle";
        return getAllWithSqlQuery(sSQLQuery, item);
    }
    
    public static Vector<ObjectType> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectType item = new ObjectType();
        return getAllStatic(item);
    }

    public static Vector<ObjectType> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectType item = new ObjectType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY libelle";
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }
    
    public static Vector<ObjectType> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	ObjectType item = new ObjectType();
    	return getAllStaticMemory(item);
    }

    public static Vector<ObjectType> getAllStaticMemory(ObjectType item)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(item);
        return m_vObjectType;
    }

    public static Vector<ObjectType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectType item = new ObjectType();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    
    
    /**
	 * @param sObjet - the name of the node
	 */
	public String serialize(String sObjet)
	{
		 String sEnumerator 
		 	= "<"+sObjet+">\n"
		 	+ "<id>" +  this.lId + "</id>\n" 
		 	+ "<name>" +  this.sLibelle + "</name>\n" 
			+ "</"+sObjet+">\n";
		 
		 return sEnumerator;
	
	}
	
	public void deserialize (Node node) throws Exception{
		try{
			this.lId = Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "id"));
		}
		catch(Exception e){}
		try{
			this.sLibelle = BasicDom.getChildNodeValueByNodeName(node, "name");
		}
		catch(Exception e){}
	}

	public void synchroniser(Node node) throws Exception{
		deserialize(node);
		if(this.lId !=-1) 
		{
			try {
				store();
			}
			catch(Exception e){
				create();
				e.getMessage();
			}
		}
		else create();
		
	}
    
    @Override
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalizationLabel==null));
    		if(s == null) return this.sLibelle;
    		return s;
    	}
        return this.sLibelle;
    }
    
    public String getLibelle() {return this.sLibelle;}
    public void setLibelle(String sLibelle) {this.sLibelle = sLibelle;}

    public String getTableObjet() {return this.sTableObjet;}
    public void setTableObjet(String sTableObjet) {this.sTableObjet = sTableObjet;}

    public String getChampIdObjet() {return this.sChampIdObjet;}
    public void setChampIdObjet(String sChampIdObjet) {this.sChampIdObjet = sChampIdObjet;}

    public String getClassName() {return this.sClass;}
    public void setClass(String sClass) {this.sClass = sClass;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("sLibelle", this.sLibelle);
        item.put("sTableObjet", this.sTableObjet);
        item.put("sChampIdObjet", this.sChampIdObjet);
        item.put("sClass", this.sClass);
        
        item.put("data", this.lId);
        item.put("value", this.sLibelle);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws Exception {
        ObjectType item = getObjectType(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }
    
    public static JSONArray getJSONArray() throws Exception {
    	return getJSONArray(null,false);
    }

    public static JSONArray getJSONArray(JSONObject jsonObj, boolean bAddColumn) throws Exception {
    	return getJSONArray(null,bAddColumn,false);
    }
    
    public static JSONArray getJSONArray(JSONObject jsonObj, boolean bAddColumn, boolean bAddMethods) throws Exception {
        JSONArray items = new JSONArray();
        if(jsonObj != null)
        	items.put(jsonObj);
        for (ObjectType item:getAllStaticMemory()){
        	JSONObject obj = item.toJSONObject();
        	
        	if(bAddColumn){
        		try{obj.put("columns", BeanGenerator.getFieldsFromTableName(item.getTableObjet()));}
        		catch(Exception e){}
        	}
        	if(bAddMethods && !Outils.isNullOrBlank(item.getClassName())){
        		Method[] methods = JavaUtil.getMethods(item.getClassName());
        		JSONArray jsonMethods = new JSONArray();		
        		for(Method method : methods){
        			JSONObject jsonMethod = new JSONObject();
        			jsonMethod.put("value", method.getName());
        			jsonMethod.put("data", method.getName());
        			jsonMethods.put(jsonMethod);		
        		}
        		try{obj.put("methods", jsonMethods);}
        		catch(Exception e){}
        	}
        	items.put(obj);
        }
        return items;
    }
    
    /**
     * load an instance of this object class and execute the CoinDatabaseAbstractBean method getJSONArray 
     * @return JSONArray
     * @throws IllegalArgumentException
     * @throws SecurityException
     * @throws ClassNotFoundException
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     * @throws NoSuchMethodException
     */
	@SuppressWarnings("unchecked")
	public JSONArray getJSONArrayDynamic()
    throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, 
    InvocationTargetException, NoSuchMethodException{
    	return getJSONArrayDynamic(new ArrayList());
    }
	@SuppressWarnings("unchecked")
	public JSONArray getJSONArrayDynamic(ArrayList args)
    throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, 
    InvocationTargetException, NoSuchMethodException{
    	JSONArray json = (JSONArray)invokeObjectMethod("getJSONArray",args );
    	return json;
    }
	
	@SuppressWarnings("unchecked")
	public Object invokeObjectMethod(Object o,String sMethod, ArrayList args) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InvocationTargetException, NoSuchMethodException {
    	return JavaUtil.invokeMethod(o, this.sClass, sMethod,args );
    }
	
	@SuppressWarnings("unchecked")
	public Object invokeObjectConstructor() throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InstantiationException, NoSuchMethodException, InvocationTargetException {
    	return invokeObjectConstructor(new ArrayList());
    }
	
	@SuppressWarnings("unchecked")
	public Object invokeObjectConstructor(ArrayList args) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InstantiationException, NoSuchMethodException, InvocationTargetException {
    	return JavaUtil.invokeConstructor(this.sClass, args);
    }
	
	public Object getObjectPublicField(Object o,String sField) throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
    	return JavaUtil.getPublicFieldValue(o, this.sClass, sField);
    }
	
	public String[] getObjectFieldNames() throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
    	return JavaUtil.getDeclaredFieldNames(this.sClass,sObjectFieldException);
    }
	
	@SuppressWarnings("unchecked")
	public Object invokeObjectInstanceMethod(String sMethod) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InvocationTargetException, NoSuchMethodException, InstantiationException {
    	Object o = this.invokeObjectConstructor();
		return invokeObjectMethod(o,sMethod, new ArrayList());
    }
	
	public CoinDatabaseAbstractBean getCoinDatabaseAbstractBeanInstance(String sId) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InvocationTargetException, NoSuchMethodException, InstantiationException, SQLException, CoinDatabaseLoadException, NamingException {
		return getCoinDatabaseAbstractBeanInstance(sId, null);
	}
	public CoinDatabaseAbstractBean getCoinDatabaseAbstractBeanInstance(String sId,Connection conn) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InvocationTargetException, NoSuchMethodException, InstantiationException, SQLException, CoinDatabaseLoadException, NamingException {
		CoinDatabaseAbstractBean o = (CoinDatabaseAbstractBean)this.invokeObjectConstructor();
		
		switch(o.getPrimaryKeyType())
		{
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
			o.setId(Long.parseLong(sId));
			break;
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_INTEGER:
			o.setId(Integer.parseInt(sId));
			break;
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
			o.setId(sId);
			break;
			
		}
    	o.setAbstractBeanConnexion(conn);
    	o.load();
    	
    	return o;
    }
	
	
	@SuppressWarnings("unchecked")
	public Object invokeObjectMethod(String sMethod) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InvocationTargetException, NoSuchMethodException {
    	return invokeObjectMethod(sMethod, new ArrayList());
    }
	
	@SuppressWarnings("unchecked")
	public Object invokeObjectMethod(Object o, String sMethod) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InvocationTargetException, NoSuchMethodException {
    	return invokeObjectMethod(o, sMethod, new ArrayList());
    }
	
	@SuppressWarnings("unchecked")
	public Object invokeObjectMethod(String sMethod, ArrayList args) throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException, InvocationTargetException, NoSuchMethodException {
    	return invokeObjectMethod(null, sMethod, args);
    }
	
	public Method getObjectMethod(String sMethod) throws SecurityException, IllegalArgumentException, NoSuchMethodException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException{
    	return JavaUtil.getMethod(this.sClass, sMethod );
    }
	
	public Method getObjectMethod(String sMethod, int iNumParams) throws SecurityException, IllegalArgumentException, NoSuchMethodException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException{
    	return JavaUtil.getMethod(this.sClass, sMethod, iNumParams );
    }
	
	public Method getObjectMethod(String sMethod, ArrayList<?> paramList) throws SecurityException, IllegalArgumentException, NoSuchMethodException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException{
    	return JavaUtil.getMethod(this.sClass, sMethod, paramList );
    }
    
    public void setFromJSONObject(JSONObject item) throws Exception {
        try {
            this.sLibelle = item.getString("sLibelle");
        } catch(Exception e){}
        try {
            this.sTableObjet = item.getString("sTableObjet");
        } catch(Exception e){}
        try {
            this.sChampIdObjet = item.getString("sChampIdObjet");
        } catch(Exception e){}
        try {
            this.sClass = item.getString("sClass");
        } catch(Exception e){}
    }

    public static long storeFromJSONString(String jsonStringData) throws Exception {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static long storeFromJSONObject(JSONObject data) throws Exception {
        try {
            ObjectType item = null;
            try{
                item = ObjectType.getObjectTypeMemory(data.getLong("lId"));
            } catch(Exception e){
                item = new ObjectType();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return item.getId();
        } catch(Exception e){
            return 0;
        }
    }

    @RemoteMethod
    public static void removeFromId(long lId) throws Exception {
        new ObjectType(lId).remove();
    }

    public static CoinDatabaseAbstractBean getObjetReference(int iIdObjectType, int iIdObjetReference) 
    throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	CoinDatabaseAbstractBean object = null;

    	switch (iIdObjectType) {
		case ORGANISATION:
			object = Organisation.getOrganisation(iIdObjetReference);

			break;
		case PERSONNE_PHYSIQUE:
			object = PersonnePhysique.getPersonnePhysique(iIdObjetReference);
			break;

		default:
			break;
		}

    	return object ;
    }
    public static String getIdObjetReferenceName(
    		long lIdObjectType, 
    		long lIdObjetReference) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
    IllegalAccessException 
    {
    	Connection conn = ConnectionManager.getConnection();
    	
    	try {
    		return getIdObjetReferenceName(lIdObjectType, lIdObjetReference, false, conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    	
    }
    
    public static String getIdObjetReferenceName(
    		long lIdObjectType, 
    		long lIdObjetReference,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
    IllegalAccessException 
    {
    	String sReferenceName = "";

    	switch ((int)lIdObjectType) {
		case ORGANISATION:
			Organisation organisation = Organisation.getOrganisation(lIdObjetReference, bUseHttpPrevent, conn);
			sReferenceName = organisation.getRaisonSociale()
				+ " (" + organisation.getIdOrganisation()+ ")";

			break;
		case PERSONNE_PHYSIQUE:
			PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(lIdObjetReference, bUseHttpPrevent, conn);
			sReferenceName
				= personne.getCivilitePrenomNom(conn)
				+ " (" + personne.getIdPersonnePhysique() + ")";

			break;

		case ORGANISATION_SERVICE:
			OrganisationService os = OrganisationService.getOrganisationService (lIdObjetReference, bUseHttpPrevent, conn);
			sReferenceName
				= os.getName();

			break;


		default:
			break;
		}

    	return sReferenceName;
    }

    public static String getLocalizedLabel(long lId, long lIdLanguage) {
    	ObjectType type = new ObjectType(lId);
    	
    	type.setAbstractBeanLocalization(lIdLanguage) ;
    	return type.getLocalizedLabel();
	}
    
    public String getLocalizedLabel() {
    	String sLabel = this.sLibelle;
    	s_sarrLocalizationLabel = getLocalizationMatrix(s_sarrLocalizationLabel);
		try{sLabel = s_sarrLocalizationLabel[this.iAbstractBeanIdLanguage][(int)this.lId];}
		catch(Exception e){sLabel = this.sLibelle;}
		
		return sLabel;
	}
    
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalizationLabel = getLocalizationMatrix(s_sarrLocalizationLabel, true, conn);
	}
    
    public static void main(String[] args) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, IllegalArgumentException, SecurityException, ClassNotFoundException, NoSuchMethodException, InvocationTargetException {
    	RemoteControlServiceConnection a = new RemoteControlServiceConnection("jdbc:mysql://serveur24.matamore.com:3306/modula_test?","dba_account", "dba_account");
		Connection conn = a.getConnexionMySQL();
    	
    	long lIdObjectType = ObjectType.PERSONNE_PHYSIQUE;
    	long lIdObjectReference = 2;

    	ObjectType objType = ObjectType.getObjectTypeMemory(lIdObjectType,conn);
    	
    	CoinDatabaseAbstractBean o = objType.getCoinDatabaseAbstractBeanInstance(""+lIdObjectReference,conn);
    	System.out.println(o.getName());
    	
    	ConnectionManager.closeConnection(conn);
	}
    
}
