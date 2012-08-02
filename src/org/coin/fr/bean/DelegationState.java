/*
* Studio Matamore - France 2008, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBeanComparator;
import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ObjectLocalization;
import org.coin.localization.Language;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class DelegationState extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

    protected String sName;
    protected String sDescription;

    public static Vector<DelegationState> m_vDelegationState = null;
    protected static String[][] s_sarrLocalization;

    public static final int STATE_ACTIVATED = 1;
    public static final int STATE_DESACTIVATED = 2;
    public static final int STATE_ARCHIVED = 3;
    
    public DelegationState() {
        init();
    }

    public DelegationState(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "delegation_state";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
              " name,"
        	+ " description";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
        this.iAbstractBeanIdObjectType = ObjectType.DELEGATION_STATE; 

        super.lId = 0;
        this.sName = "";
        this.sDescription = "";

        super.bUseHttpPrevent = false;
        super.bUseFieldValueFilter = false;
    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vDelegationState = getAllStatic();
    }

    public Vector<DelegationState> getItemMemory() {
        return m_vDelegationState;
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory();
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, this.sName);
        ps.setString(++i, this.sDescription);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sName = rs.getString(++i);
        this.sDescription = rs.getString(++i);
    }

    public static DelegationState getDelegationState(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        DelegationState item = new DelegationState(lId);
        item.load();
        return item;
    }
    
    public static DelegationState getDelegationState(
       		long lId,  
       		boolean bUseHttpPrevent, 
       		Connection conn) 
       throws CoinDatabaseLoadException, SQLException, NamingException {
    	DelegationState DelegationState = new DelegationState(lId);
    	DelegationState.bUseHttpPrevent = bUseHttpPrevent;
    	DelegationState.load(conn);
       	
       	return DelegationState;
       }


    public static DelegationState getDelegationStateMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return getDelegationStateMemory(lId, false, 0);
    }
    public static DelegationState getDelegationStateMemoryLocalized(long lId,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return getDelegationStateMemory(lId, true, lIdLanguage);
    }
    
    public static DelegationState getDelegationStateMemory(long lId,boolean bUseLocalization, long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	for (DelegationState item : getAllStaticMemory(bUseLocalization,lIdLanguage)) {
            if (item.getId()==lId) return item;
        }
        throw new CoinDatabaseLoadException("" + lId, "static");
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
        try {
            this.sDescription = request.getParameter(sFormPrefix + "sDescription");
        } catch(Exception e){}
    }

    public static Vector<DelegationState> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationState item = new DelegationState();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationState> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationState item = new DelegationState();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationState> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationState item = new DelegationState();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<DelegationState> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new DelegationState());
        return m_vDelegationState;
    }
    public static Vector<DelegationState> getAllStaticMemory(boolean bUseLocalisation,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        if(!bUseLocalisation || lIdLanguage == 0)
        	return getAllStaticMemory();
        else{
        	Vector<DelegationState> vBeans = new DelegationState().getAllMemoryLocalized(lIdLanguage);
        	if(bUseLocalisation)
    		{
    			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING));
    		}
        	return vBeans;
        }
    }

    public static Vector<DelegationState> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<DelegationState> vResult = new Vector<DelegationState>();
        /*for (DelegationState item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<DelegationState> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationState item = new DelegationState();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
    	if(this.bUseLocalization)
    	 {
    	   String s = getLocalizedNameWithMatrix(s_sarrLocalization);
    	   if(s == null) return this.sName;
    	     return s;
    	 }
    	 return this.sName;

    }
    public void setName(String sName) {this.sName = sName;}
    
    public String getDescription() {return this.sDescription;}
    public void setDescription(String sDescription) {this.sDescription = sDescription;}
    
    @Override
    public String getLocalizedName(Connection conn) {
     s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
     return s_sarrLocalization[this.iAbstractBeanIdLanguage][(int)this.lId];
    }
       
    @Override
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
    {
     s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrix(this, conn);
    }

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("sName", this.getName());
        item.put("sDescription", this.getDescription());
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        DelegationState item = getDelegationState(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        return getJSONArray(false, 0);
    }
    public static JSONArray getJSONArray(Language language) 
    throws Exception {
        return getJSONArray(language.getId());
    }
    
    public static JSONArray getJSONArray(long lIdLanguage) 
    throws Exception {
     JSONArray items = new JSONArray();
     for (DelegationState item:getAllStaticMemory()) {
       item.setAbstractBeanLocalization(lIdLanguage);
       items.put(item.toJSONObject());
     }
     return items;
    }

    public static JSONArray getJSONArray(boolean bUseLocalization,long lIdLanguage) 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (DelegationState item:getAllStaticMemory(bUseLocalization,lIdLanguage)) {
        	items.put(item.toJSONObject());
        }
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.sName = item.getString("sName");
        } catch(Exception e){}
        try {
            this.sDescription = item.getString("sDescription");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            DelegationState item = null;
            try{
                item = DelegationState.getDelegationState(data.getLong("lId"));
            } catch(Exception e){
                item = new DelegationState();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }

}
