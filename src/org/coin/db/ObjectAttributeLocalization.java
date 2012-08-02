
/*
* Studio Matamore - France 2008, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.db;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.localization.Language;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ObjectAttributeLocalization extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdTypeObject;
    protected long lIdLanguage;
    protected String sAttributeName;
    protected String sAttributeLabel;
    
    /**
     * @see http://blog.publo.fr/post/2008/08/09/jsp:include-et-lencodage
     */
	public String sEncoding;
	public String sDecoding;


    public ObjectAttributeLocalization() {
        init();
    }

    public ObjectAttributeLocalization(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "object_attribute_localization";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_type_object,"
                + " id_language,"
                + " attribute_name,"
                + " attribute_label";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdTypeObject = 0;
        this.lIdLanguage = 0;
        this.sAttributeName = "";
        this.sAttributeLabel = "";

		this.bUseHttpPrevent = false;
		this.bUseFieldValueFilter = false;
		this.sEncoding = "UTF-8";
		this.sDecoding = "ISO-8859-1";

    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdTypeObject);
        ps.setLong(++i, this.lIdLanguage);
        ps.setString(++i, preventStore(this.sAttributeName));
        ps.setString(++i, preventStore(this.sAttributeLabel));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdTypeObject = rs.getLong(++i);
        this.lIdLanguage = rs.getLong(++i);
        this.sAttributeName = preventLoad(rs.getString(++i));
        this.sAttributeLabel = preventLoad(rs.getString(++i));
    }

    public static ObjectAttributeLocalization getObjectAttributeLocalization(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        ObjectAttributeLocalization item = new ObjectAttributeLocalization(lId);
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
            this.sAttributeName = request.getParameter(sFormPrefix + "sAttributeName");
        } catch(Exception e){}
        try {
            this.sAttributeLabel = request.getParameter(sFormPrefix + "sAttributeLabel");
        } catch(Exception e){}
    }

    public static Vector<ObjectAttributeLocalization> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectAttributeLocalization item = new ObjectAttributeLocalization();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<ObjectAttributeLocalization> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectAttributeLocalization item = new ObjectAttributeLocalization();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<ObjectAttributeLocalization> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectAttributeLocalization item = new ObjectAttributeLocalization();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<ObjectAttributeLocalization> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectAttributeLocalization item = new ObjectAttributeLocalization();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
        return "object_attribute_localization_"+this.lId;
    }

    public long getIdTypeObject() {return this.lIdTypeObject;}
    public void setIdTypeObject(long lIdTypeObject) {this.lIdTypeObject = lIdTypeObject;}

    public long getIdLanguage() {return this.lIdLanguage;}
    public void setIdLanguage(long lIdLanguage) {this.lIdLanguage = lIdLanguage;}

    public String getAttributeName() {return this.sAttributeName;}
    public void setAttributeName(String sAttributeName) {this.sAttributeName = sAttributeName;}

    public String getAttributeLabel() {return this.sAttributeLabel;}
    public void setAttributeLabel(String sAttributeLabel) {this.sAttributeLabel = sAttributeLabel;}

	public void setAttributeLabelWithEncoding(String value) throws UnsupportedEncodingException {
		this.sAttributeLabel = value;
		if(this.sAttributeLabel != null)
		{
			this.sAttributeLabel = new String(this.sAttributeLabel.getBytes(this.sDecoding),this.sEncoding);
		}
	}
    
    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdTypeObject", this.lIdTypeObject);
        item.put("lIdLanguage", this.lIdLanguage);
        item.put("sAttributeName", this.sAttributeName);
        item.put("sAttributeLabel", this.sAttributeLabel);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        ObjectAttributeLocalization item = getObjectAttributeLocalization(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (ObjectAttributeLocalization item:getAllStatic()) items.put(item.toJSONObject());
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
            this.sAttributeName = item.getString("sAttributeName");
        } catch(Exception e){}
        try {
            this.sAttributeLabel = item.getString("sAttributeLabel");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            ObjectAttributeLocalization item = null;
            try{
                item = ObjectAttributeLocalization.getObjectAttributeLocalization(data.getLong("lId"));
            } catch(Exception e){
                item = new ObjectAttributeLocalization();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }

    
    public static Vector<ObjectAttributeLocalization> getAllFromIdObjectType(
    		long iAbstractBeanIdObjectType,
    		Connection conn)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	ObjectAttributeLocalization ot = new ObjectAttributeLocalization();
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(iAbstractBeanIdObjectType));
		ot.bUseHttpPrevent = false;
		ot.bUseEmbeddedConnection = true;
		ot.connEmbeddedConnection = conn;
		
		return
			 ot.getAllWithWhereAndOrderByClause(" WHERE id_type_object=?", "", vParam);
		
    }
    
    
	public static Map<String, String>[] generateAttributeLocalizationMatrixString(
			int iAbstractBeanIdObjectType) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Connection conn = ConnectionManager.getConnection();
		
		try {
			return 
			  ObjectAttributeLocalization
				.generateAttributeLocalizationMatrixString(iAbstractBeanIdObjectType,conn);
			
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		
	}   
	
    @SuppressWarnings("unchecked")
	public static Map<String, String>[] generateAttributeLocalizationMatrixString(
			int iIdObjectType,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		
		int iMaxLanguage = 0;
		
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		Vector<ObjectAttributeLocalization> vItem 
			= getAllFromIdObjectType(iIdObjectType, conn);
		
		
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
		for (ObjectAttributeLocalization item : vItem) {
			matrix[(int)item.lIdLanguage]
				.put(item.sAttributeName, item.sAttributeLabel);
		}
		
		return matrix;
	}
    
    @SuppressWarnings("unchecked")
	public static Map<String, ObjectAttributeLocalization>[] generateAttributeLocalizationString(
			int iIdObjectType,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		
		int iMaxLanguage = 0;
		
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		Vector<ObjectAttributeLocalization> vItem 
			= getAllFromIdObjectType(iIdObjectType, conn);
		
		
		/**
		 * Create the matrix
		 */
		Map<String, ObjectAttributeLocalization>[] matrix  
			= new Map [iMaxLanguage + 1];
		
		for (Language lang : vLanguage) {
			matrix[(int)lang.lId]
				= Collections.synchronizedMap(new HashMap<String, ObjectAttributeLocalization>());
		}

		/**
		 * Populate the matrix
		 */
		for (ObjectAttributeLocalization item : vItem) {
			matrix[(int)item.lIdLanguage]
				.put(item.sAttributeName, item);
		}
		
		return matrix;
	}
}
