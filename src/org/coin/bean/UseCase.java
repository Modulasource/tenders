/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.bean;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import modula.journal.TypeEvenement;

import org.coin.db.CoinDatabaseAbstractBeanComparator;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ObjectLocalization;
import org.coin.util.EnumeratorString;
import org.coin.util.EnumeratorStringMemory;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@SuppressWarnings("unchecked")
@RemoteProxy
public class UseCase extends EnumeratorStringMemory implements Serializable{    
	private static final long serialVersionUID = 1L;

	public static Vector m_vUC = null;
	public static Vector m_unprevent_vUC = null;
	
	protected static Map<String,String>[] s_sarrLocalization;
	
	private void setConstantes(){
        this.TABLE_NAME = "use_case";
        this.FIELD_ID_NAME = "id_use_case";
        this.SELECT_FIELDS_NAME = this.FIELD_NAME_NAME = "name";
        
        this.iAbstractBeanIdObjectType = ObjectType.USE_CASE;
    }
    
    public UseCase() {
        super();
        setConstantes();
    }
        
    public UseCase(String sId) {
        super(sId);
        setConstantes();
    }
    
    public UseCase(String sId, String sName) {
        super(sId,sName);
        setConstantes();
    }
    
	public UseCase(String sId, String sName,boolean bUseHttpPrevent) {
		super(sId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}
   
	protected EnumeratorString getAll_onNewItem(String sId, String sName)
	{
		return getAll_onNewItem(sId,sName,true);
	}
   
	protected EnumeratorString getAll_onNewItem(String sId, String sName,boolean bUseHttpPrevent)
	{
		return new UseCase(sId, sName,bUseHttpPrevent);
	}

    public static String getUseCasesName(String sId) throws CoinDatabaseLoadException, SQLException, NamingException {
    	UseCase usecase = new UseCase(sId);
    	usecase.load();
    	return usecase.getName();
    }
 
    public static String getUseCasesNameOptional(String sId) {
    	try {
    		return getUseCasesName(sId);
		} catch (Exception e) {
		}
		return "";
    }
    
    public static UseCase getUseCase(String sId) 
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	UseCase usecase = new UseCase(sId);
    	usecase.load();
    	return usecase;
    }

    public static Vector<UseCase> getAllStatic(UseCase item)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY "+ item.FIELD_ID_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }
    
    
    
	public static Vector<UseCase> getAllUseCase(boolean bUseHttpPrevent, Connection conn)
	throws NamingException, SQLException
	{
    	UseCase usecase = new UseCase();
    	usecase.bUseHttpPrevent = bUseHttpPrevent;
		return usecase.getAllOrderById(conn);
	}

	public static Vector<UseCase> getAllUseCase(boolean bUseHttpPrevent)
	throws NamingException, SQLException
	{
    	UseCase usecase = new UseCase();
    	usecase.bUseHttpPrevent = bUseHttpPrevent;
		return usecase.getAllOrderById();
	}
	public static Vector<UseCase> getAllUseCase() throws NamingException, SQLException
	{
		return getAllUseCase(true);
	}

	public static Vector<UseCase> getAllUseCaseWithWhereAndOrderByClauses(String sWhereClause, String sOrderByClause) throws NamingException, SQLException
	{
    	UseCase usecase = new UseCase();
		return usecase.getAllWithWhereAndOrderByClauses(sWhereClause, sOrderByClause);
	}

	public static Vector<UseCase> getAllUseCaseWithPrefix(String sIdPrefix) throws NamingException, SQLException
	{
    	UseCase usecase = new UseCase();
		return usecase.getAllOrderByIdWithPrefix(sIdPrefix);
	}
    
    public void removeWithObjectAttached() throws Exception
	{
		try{
			Habilitation.removeAllFromUseCase(this.sId);
		}catch(Exception e){}
		try{
			Vector<TypeEvenement> vEvt = TypeEvenement.getAllFromUseCaseMemory(this.sId);
			for(TypeEvenement type : vEvt){
				type.setIdUseCase("");
				type.store();
			}
		}catch(Exception e){}

		this.remove();
	}
    
    @RemoteMethod
	public static void removeWithObjectAttachedStatic(String sId) throws Exception
	{
		UseCase item = new UseCase(sId);
		item.removeWithObjectAttached();
	}
	
	public void setFromFormWithObjectAttached(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException {
		String sIdOld = this.sId;
		this.sName= request.getParameter(sFormPrefix + "sName");
		this.sId = request.getParameter(sFormPrefix + "sId");

		try{
			Vector<Habilitation> vHab = Habilitation.getAllFromUseCaseMemory(sIdOld);
			for(Habilitation hab : vHab){
				hab.setIdUseCase(this.sId);
				hab.store();
			}
		}catch(Exception e){}
		try{
			Vector<TypeEvenement> vEvt = TypeEvenement.getAllFromUseCaseMemory(sIdOld);
			for(TypeEvenement type : vEvt){
				type.setIdUseCase(this.sId);
				type.store();
			}
		}catch(Exception e){}
	}
	
    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
    	boolean bPreventOld = this.bUseHttpPrevent;
    	
    	this.bUseHttpPrevent = true;
    	m_vUC = getAllStatic(this);
    	this.bUseHttpPrevent = false;
    	m_unprevent_vUC = getAllStatic(this);
    	
    	this.bUseHttpPrevent = bPreventOld;
    }

	public Vector<UseCase> getItemMemory() {
		return (this.bUseHttpPrevent?m_vUC:m_unprevent_vUC);
	}

    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory(this);
    }

	public static Vector<UseCase> getAllStaticMemory(boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		UseCase item = new UseCase();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	return getAllStaticMemory(item);
    }

	public static Vector<UseCase> getAllStaticMemory(boolean bUseHttpPrevent, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		UseCase item = new UseCase();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.bUseEmbeddedConnection = true;
    	item.connEmbeddedConnection = conn;
    	return getAllStaticMemory(item);
    }
	
    public static Vector<UseCase> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	UseCase item = new UseCase();
    	item.bUseHttpPrevent = true;
    	return getAllStaticMemory(item);
    }
    
    public static Vector<UseCase> getAllStaticMemory(UseCase item)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	reloadMemoryStatic(item);
    	return item.getItemMemory();
    }

    public static Vector<UseCase> getAllStaticOptionalMemory(UseCase item)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	if(!item.bUseLocalization || item.iAbstractBeanIdLanguage == 0){
    		return getAllStaticMemory(item);
    	}
        else{
        	Vector<UseCase> vBeans = item.getAllMemoryLocalized(item.iAbstractBeanIdLanguage);
        	if(item.bUseLocalization)
    		{
    			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_ID_ASCENDING));
    		}
        	return vBeans;
        }
    }
    public static Vector<UseCase> getAllStaticMemory(boolean bUseLocalisation,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	UseCase item = new UseCase();
    	item.bUseLocalization = bUseLocalisation;
    	item.iAbstractBeanIdLanguage = (int)lIdLanguage;
    	return getAllStaticOptionalMemory(item);
    }
    public static Vector<UseCase> getAllStaticMemory(boolean bUseLocalisation,long lIdLanguage, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	UseCase item = new UseCase();
    	item.bUseLocalization = bUseLocalisation;
    	item.iAbstractBeanIdLanguage = (int)lIdLanguage;
    	item.setAbstractBeanConnexion(conn);
    	return getAllStaticOptionalMemory(item);
    }

    public static UseCase getUseCaseMemory(String sId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return getUseCaseMemory(sId,true, false, 0);
    }

    public static UseCase getUseCaseMemoryLocalized(String sId,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return getUseCaseMemory(sId,true, true, lIdLanguage);
    }
    
    public static UseCase getUseCaseMemory(String sId,boolean bUseHttpPrevent, boolean bUseLocalization, long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	for (UseCase item : getAllStaticMemory(bUseLocalization,lIdLanguage)) {
            if (item.getIdString().equalsIgnoreCase(sId)) return item;
        }
        throw new CoinDatabaseLoadException("" + sId, "static",lIdLanguage);
    }
    
    public static UseCase getUseCaseMemory(String sId,boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getUseCaseMemory(sId, bUseHttpPrevent,false,0);
    }
    
    public static UseCase getUseCaseMemory(String sId,boolean bUseHttpPrevent, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	Vector<UseCase> vItems = getAllStaticMemory(bUseHttpPrevent, conn);

    	for (UseCase item : vItems) {
        	if(item.getIdString().equalsIgnoreCase(sId)) return item;
		}

    	throw new CoinDatabaseLoadException("UseCase unknow : " + sId, "getUseCaseMemory");
    }

    
    public static UseCase getUseCaseMemory(String sId,long iIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getUseCaseMemory(sId,true,true,iIdLanguage);
    }
	
    public static String getUseCaseNameMemory(String sId,boolean bUseHttpPrevent, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getUseCaseMemory(sId,bUseHttpPrevent, conn).getName();
    }
	
    public static String getUseCaseNameMemory(String sId,boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getUseCaseMemory(sId,bUseHttpPrevent).getName();
    }
    public static String getUseCaseNameMemory(String sId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getUseCaseNameMemory(sId,true);
    }
    
    public static String getUseCaseNameOptionalMemory(String sId,boolean bUseHttpPrevent) {
    	try {
    		return getUseCaseNameMemory(sId,bUseHttpPrevent);
		} catch (Exception e) {
		}
		return "";
    }
    public static String getUseCasesNameOptionalMemory(String sId) {
    	return getUseCaseNameOptionalMemory(sId,true);
    }
    
    public static Vector<UseCase> getAllUseCaseWithPrefixMemory(String sIdPrefix,boolean bUseHttpPrevent) throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	Vector<UseCase> vItems = getAllStaticMemory();
    	Vector<UseCase> vItemsReturn = new Vector<UseCase>();
    	for (UseCase item : vItems) {
        	if(item.getIdString().startsWith(sIdPrefix))
        		vItemsReturn.add(item);
		}

    	return vItemsReturn;
	}
    public static Vector<UseCase> getAllUseCaseWithPrefixMemory(String sIdPrefix) throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	return getAllUseCaseWithPrefixMemory(sIdPrefix,true);
	}

	public static JSONObject getJSONObject(String sId) throws Exception {
		UseCase item = getUseCaseMemory(sId);
		JSONObject data = item.toJSONObject();
		return data;
	}

	public static JSONArray getJSONArray() throws Exception {
		return getJSONArray(true);
	}
	
	public static JSONArray getJSONArray(boolean bUseHttpPrevent) throws Exception {
		JSONArray items = new JSONArray();
		for (UseCase item:getAllStaticMemory(bUseHttpPrevent)) items.put(item.toJSONObject());
		return items;
	}

	public static boolean storeFromJSONString(String jsonStringData) throws Exception {
		return storeFromJSONObject(new JSONObject(jsonStringData));
	}

	public static boolean storeFromJSONObject(JSONObject data) throws Exception {
		try {
			UseCase item = null;
			try{
				item = UseCase.getUseCaseMemory(data.getString("sId"));
			} catch(Exception e){
				item = new UseCase();
				item.create();
			}
			item.setFromJSONObject(data);
			item.store();
			return true;
		} catch(Exception e){
			return false;
		}
	}
	
    public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("sId", this.sId);
		item.put("sName", this.sName);
		item.put("sLibelle", this.sId + " - " +this.sName);
		return item;
	}
    
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sName;
    		return s;
    	}
        return this.sName;
    }
    
    public String getLocalizedName(Connection conn)
	{
    	s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
    	String sValue = s_sarrLocalization[this.iAbstractBeanIdLanguage].get(this.sId);
		if(Outils.isNullOrBlank(sValue))
			sValue = this.sName;
		return sValue;
	}

    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrixString(this, conn);
	}
}

