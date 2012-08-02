
/*
* Studio Matamore - France 2008, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.db;


import org.coin.localization.Language;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class ObjectMethodLocalization extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdTypeObject;
    protected long lIdLanguage;
    protected String sMethodName;
    protected String sMethodLabel;

    /**
     * @see http://blog.publo.fr/post/2008/08/09/jsp:include-et-lencodage
     */
	public String sEncoding;
	public String sDecoding;
	
	
    public ObjectMethodLocalization() {
        init();
    }

    public ObjectMethodLocalization(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "object_method_localization";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_type_object,"
                + " id_language,"
                + " method_name,"
                + " method_label";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdTypeObject = 0;
        this.lIdLanguage = 0;
        this.sMethodName = "";
        this.sMethodLabel = "";

    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdTypeObject);
        ps.setLong(++i, this.lIdLanguage);
        ps.setString(++i, preventStore(this.sMethodName));
        ps.setString(++i, preventStore(this.sMethodLabel));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdTypeObject = rs.getLong(++i);
        this.lIdLanguage = rs.getLong(++i);
        this.sMethodName = preventLoad(rs.getString(++i));
        this.sMethodLabel = preventLoad(rs.getString(++i));
    }

    public static ObjectMethodLocalization getObjectMethodLocalization(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        ObjectMethodLocalization item = new ObjectMethodLocalization(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdTypeObject = Long.parseLong(request.getParameter(sFormPrefix + "lIdTypeObject"));
        } catch(Exception e){}
        try {
            this.lIdLanguage = Long.parseLong(request.getParameter(sFormPrefix + "lIdLanguage"));
        } catch(Exception e){}
        try {
            this.sMethodName = request.getParameter(sFormPrefix + "sMethodName");
        } catch(Exception e){}
        try {
            this.sMethodLabel = request.getParameter(sFormPrefix + "sMethodLabel");
        } catch(Exception e){}
    }

    public static Vector<ObjectMethodLocalization> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectMethodLocalization item = new ObjectMethodLocalization();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<ObjectMethodLocalization> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectMethodLocalization item = new ObjectMethodLocalization();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<ObjectMethodLocalization> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectMethodLocalization item = new ObjectMethodLocalization();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<ObjectMethodLocalization> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectMethodLocalization item = new ObjectMethodLocalization();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
        return "object_method_localization_"+this.lId;
    }

    public long getIdTypeObject() {return this.lIdTypeObject;}
    public void setIdTypeObject(long lIdTypeObject) {this.lIdTypeObject = lIdTypeObject;}

    public long getIdLanguage() {return this.lIdLanguage;}
    public void setIdLanguage(long lIdLanguage) {this.lIdLanguage = lIdLanguage;}

    public String getMethodName() {return this.sMethodName;}
    public void setMethodName(String sMethodName) {this.sMethodName = sMethodName;}

    public String getMethodLabel() {return this.sMethodLabel;}
    public void setMethodLabel(String sMethodLabel) {this.sMethodLabel = sMethodLabel;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdTypeObject", this.lIdTypeObject);
        item.put("lIdLanguage", this.lIdLanguage);
        item.put("sMethodName", this.sMethodName);
        item.put("sMethodLabel", this.sMethodLabel);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        ObjectMethodLocalization item = getObjectMethodLocalization(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (ObjectMethodLocalization item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdTypeObject = item.getLong("lIdTypeObject");
        } catch(Exception e){}
        try {
            this.lIdLanguage = item.getLong("lIdLanguage");
        } catch(Exception e){}
        try {
            this.sMethodName = item.getString("sMethodName");
        } catch(Exception e){}
        try {
            this.sMethodLabel = item.getString("sMethodLabel");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            ObjectMethodLocalization item = null;
            try{
                item = ObjectMethodLocalization.getObjectMethodLocalization(data.getLong("lId"));
            } catch(Exception e){
                item = new ObjectMethodLocalization();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public static Vector<ObjectMethodLocalization> getAllFromIdObjectType(
    		long iAbstractBeanIdObjectType,
    		Connection conn)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	ObjectMethodLocalization ot = new ObjectMethodLocalization();
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(iAbstractBeanIdObjectType));
		ot.bUseHttpPrevent = false;
		ot.bUseEmbeddedConnection = true;
		ot.connEmbeddedConnection = conn;
		
		return
			 ot.getAllWithWhereAndOrderByClause(" WHERE id_type_object=?", "", vParam);

	
		
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, String>[] generateMethodLocalizationMatrixString(
			CoinDatabaseAbstractBean bean,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		
		int iMaxLanguage = 0;
		
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		Vector<ObjectMethodLocalization> vItem 
			= getAllFromIdObjectType(bean.iAbstractBeanIdObjectType, conn);
		
		
		/**
		 * Create the matrix
		 */
		Map<String, String>[] matrix  
			= new Map [iMaxLanguage + 1];
		
		for (Language lang : vLanguage) {
			matrix[(int)lang.lId]
				= Collections.synchronizedMap(new HashMap<String, String>());
		}

		/**
		 * Populate the matrix
		 */
		for (ObjectMethodLocalization item : vItem) {
			matrix[(int)item.lIdLanguage]
				.put(item.sMethodName, item.sMethodLabel);
		}
		
		return matrix;
	}
    
}
	
	