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

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBeanComparator;
import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.db.ObjectLocalization;
import org.coin.localization.Language;
import org.coin.util.HttpUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class DelegationType extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

    protected String sName;
    protected int iOrder;

    public static Vector<DelegationType> m_vDelegationType = null;
    protected static String[][] s_sarrLocalization;
    
    /**
     * per procurationem = pour ordre
     */
    public static final int TYPE_PP = 1;
    
    /**
     * pour lecture
     */
    public static final int TYPE_READ = 2;
    
    /**
     * pour approbation
     */
    public static final int TYPE_APPROVAL = 3;
    
    /**
     * pour absence
     */
    public static final int TYPE_VACATION = 4;


    public DelegationType() {
        init();
    }

    public DelegationType(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "delegation_type";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " name,"
        	  + " order_index";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
        this.iAbstractBeanIdObjectType = ObjectType.DELEGATION_TYPE; 

        super.lId = 0;
        this.sName = "";
        this.iOrder = 0;

        super.bUseHttpPrevent = false;
        super.bUseFieldValueFilter = false;
    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vDelegationType = getAllStatic();
    }

    public Vector<DelegationType> getItemMemory() {
        return m_vDelegationType;
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory();
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, this.sName);
        ps.setInt(++i, this.iOrder);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sName = rs.getString(++i);
        this.iOrder = rs.getInt(++i);
    }

    public static DelegationType getDelegationType(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        DelegationType item = new DelegationType(lId);
        item.load();
        return item;
    }
    
    public static DelegationType getDelegationType(
       		long lId,  
       		boolean bUseHttpPrevent, 
       		Connection conn) 
       throws CoinDatabaseLoadException, SQLException, NamingException {
    	DelegationType delegationType = new DelegationType(lId);
    	delegationType.bUseHttpPrevent = bUseHttpPrevent;
    	delegationType.load(conn);
       	
       	return delegationType;
       }


    public static DelegationType getDelegationTypeMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return getDelegationTypeMemory(lId, false, 0);
    }
    public static DelegationType getDelegationTypeMemoryLocalized(long lId,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return getDelegationTypeMemory(lId, true, lIdLanguage);
    }
    
    public static DelegationType getDelegationTypeMemory(long lId,boolean bUseLocalization, long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	for (DelegationType item : getAllStaticMemory(bUseLocalization,lIdLanguage)) {
            if (item.getId()==lId) return item;
        }
        throw new CoinDatabaseLoadException("" + lId, "static");
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
        try {
            this.iOrder = HttpUtil.parseInt("iOrder", request,0);
        } catch(Exception e){}
    }

    public static Vector<DelegationType> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationType item = new DelegationType();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationType> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationType item = new DelegationType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationType> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationType item = new DelegationType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<DelegationType> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new DelegationType());
        return m_vDelegationType;
    }
    public static Vector<DelegationType> getAllStaticMemory(boolean bUseLocalisation,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        if(!bUseLocalisation || lIdLanguage == 0)
        	return getAllStaticMemory();
        else{
        	Vector<DelegationType> vBeans = new DelegationType().getAllMemoryLocalized(lIdLanguage);
        	if(bUseLocalisation)
    		{
    			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING));
    		}
        	return vBeans;
        }
    }

    public static Vector<DelegationType> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<DelegationType> vResult = new Vector<DelegationType>();
        /*for (DelegationType item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<DelegationType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationType item = new DelegationType();
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
    
    public int getOrder() {return this.iOrder;}
    public void setOrder(int iOrder) {this.iOrder = iOrder;}
    
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
        item.put("iOrder", this.getOrder());
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        DelegationType item = getDelegationType(lId);
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
     for (DelegationType item:getAllStaticMemory()) {
       item.setAbstractBeanLocalization(lIdLanguage);
       items.put(item.toJSONObject());
     }
     return items;
    }

    public static JSONArray getJSONArray(boolean bUseLocalization,long lIdLanguage) 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (DelegationType item:getAllStaticMemory(bUseLocalization,lIdLanguage)) {
        	items.put(item.toJSONObject());
        }
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.sName = item.getString("sName");
        } catch(Exception e){}
        try {
            this.iOrder = item.getInt("iOrder");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            DelegationType item = null;
            try{
                item = DelegationType.getDelegationType(data.getLong("lId"));
            } catch(Exception e){
                item = new DelegationType();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public static void main(String[] args)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
     RemoteControlServiceConnection a = new RemoteControlServiceConnection(
         "jdbc:mysql://serveur8.matamore.com:3306/modula_test?","dba_account", "dba_account" );
     Connection conn = a.getConnexionMySQL();
     DelegationType item = DelegationType.getDelegationType(1, false, conn);
     item.bUseEmbeddedConnection=true;
     item.connEmbeddedConnection=conn;
     item.setAbstractBeanIdLanguage(Language.LANG_FRENCH);
     System.out.println(item.getName());
     System.out.println(item.getLocalizedName(conn));
     item.setAbstractBeanIdLanguage(Language.LANG_SPANISH);
     System.out.println(item.getName());
     System.out.println(item.getLocalizedName(conn));
     item.bUseLocalization = true;
     System.out.println(item.getName());
     System.out.println(item.getLocalizedName(conn));
     System.out.println( item.getAllInHtmlSelect());
     ConnectionManager.closeConnection(conn);
    }



}
