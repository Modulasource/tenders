package org.coin.db;


/*
* Studio Matamore - France 2008, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/


import org.coin.localization.Language;
import org.json.*;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import java.io.UnsupportedEncodingException;
import java.sql.*;
import java.util.*;

public class ObjectLocalization extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdLanguage;
    protected long lIdTypeObject;
    protected long lIdReferenceObject;
    protected String sIdReferenceObjectString;
    protected String sValue;

    
    /**
     * @see http://blog.publo.fr/post/2008/08/09/jsp:include-et-lencodage
     */
	public String sEncoding;
	public String sDecoding;
	
    public ObjectLocalization() {
        init();
    }

    public ObjectLocalization(long lId) {
        init();
        this.lId = lId;
    }
    
    public ObjectLocalization(long lIdLanguage, long lIdTypeObject, long lIdReferenceObject) {
        init();
        this.lIdLanguage = lIdLanguage;
        this.lIdTypeObject = lIdTypeObject;
        this.lIdReferenceObject = lIdReferenceObject;
    }
    
    public ObjectLocalization(long lIdLanguage, long lIdTypeObject, String sIdReferenceObjectString) {
        init();
        this.lIdLanguage = lIdLanguage;
        this.lIdTypeObject = lIdTypeObject;
        this.sIdReferenceObjectString = sIdReferenceObjectString;
    }

    public void init() {
        super.TABLE_NAME = "object_localization";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_language,"
                + " id_type_object,"
                + " id_reference_object,"
                + " id_reference_object_string,"
                + " value";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdLanguage = 0;
        this.lIdTypeObject = 0;
        this.lIdReferenceObject = 0;
        this.sIdReferenceObjectString = "";
        this.sValue = "";
        
        this.bUseHttpPrevent = false;
        this.bUseFieldValueFilter = false;
		this.sEncoding = "UTF-8";
		this.sDecoding = "ISO-8859-1";
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdLanguage);
        ps.setLong(++i, this.lIdTypeObject);
        ps.setLong(++i, this.lIdReferenceObject);
        ps.setString(++i, preventStore(this.sIdReferenceObjectString));
        ps.setString(++i, this.sValue);
        //ps.setString(++i, preventStore(this.sValue));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdLanguage = rs.getLong(++i);
        this.lIdTypeObject = rs.getLong(++i);
        this.lIdReferenceObject = rs.getLong(++i);
        this.sIdReferenceObjectString = preventLoad(rs.getString(++i));
        //this.sValue = preventLoad(rs.getString(++i));
        this.sValue = rs.getString(++i);
    }

    public static ObjectLocalization getObjectLocalization(long lId) 
    throws CoinDatabaseLoadException, SQLException, NamingException {
        ObjectLocalization item = new ObjectLocalization(lId);
        item.load();
        return item;
    }

    
    public static ObjectLocalization getObjectLocalization(
    		long lId,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException {
        ObjectLocalization item = new ObjectLocalization(lId);
        item.bUseHttpPrevent = bUseHttpPrevent ;
        item.load(conn);
        return item;
    }
    
    
    public static ObjectLocalization getObjectLocalization(
    		long lIdLanguage,
    		long lIdTypeObject,
    		long lIdReferenceObject) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
    IllegalAccessException, CoinDatabaseDuplicateException 
    {
    	Connection conn = ConnectionManager.getConnection();
    	try{
    		return getObjectLocalization(
    				lIdLanguage, 
    				lIdTypeObject, 
    				lIdReferenceObject, 
    				false, 
    				conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    }
    
    public static ObjectLocalization getObjectLocalization(
    		long lIdLanguage,
    		long lIdTypeObject,
    		long lIdReferenceObject,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
    IllegalAccessException, CoinDatabaseDuplicateException {
        ObjectLocalization item = new ObjectLocalization();
        Vector<Object> vParam = new Vector<Object>();
        vParam.add(new Long(lIdLanguage));
        vParam.add(new Long(lIdTypeObject));
        vParam.add(new Long(lIdReferenceObject));
        
        item.setEmbeddedConnection(conn);
        item.bUseHttpPrevent = bUseHttpPrevent;
        return (ObjectLocalization) item.getAbstractBeanWithWhereAndOrderByClause(
        			" WHERE id_language=? AND id_type_object=? AND id_reference_object=?", 
        			"",
        			vParam,
        			true);
    }

    public static void setObjectLocalization(
    		String sValue,
    		long lIdLanguage,
    		long lIdTypeObject,
    		long lIdReferenceObject,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException,
    IllegalAccessException, CoinDatabaseDuplicateException {
        ObjectLocalization item = new ObjectLocalization();
        Vector<Object> vParam = new Vector<Object>();
        vParam.add(sValue);
        vParam.add(new Long(lIdLanguage));
        vParam.add(new Long(lIdTypeObject));
        vParam.add(new Long(lIdReferenceObject));
        
        item.setEmbeddedConnection(conn);
        item.bUseHttpPrevent = bUseHttpPrevent;
        
        ConnectionManager.executeUpdate(
        		"UPDATE object_localization "
        		+ " SET value=?"
        		+ " WHERE id_language=? AND id_type_object=? AND id_reference_object=?", 
    			vParam, 
        		conn);
        
    }

    

    public static ObjectLocalization getObjectLocalization(
    		long lIdLanguage,
    		long lIdTypeObject,
    		String sIdReferenceObjectString) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, 
    IllegalAccessException, CoinDatabaseDuplicateException {
        ObjectLocalization item = new ObjectLocalization();
        Vector<Object> vParam = new Vector<Object>();
        vParam.add(new Long(lIdLanguage));
        vParam.add(new Long(lIdTypeObject));
        vParam.add(sIdReferenceObjectString);
        return (ObjectLocalization) item.getAbstractBeanWithWhereAndOrderByClause(
        			" WHERE id_language=? AND id_type_object=? AND id_reference_object_string=?", 
        			"",
        			vParam,
        			true);
    }

    public static ObjectLocalization getOrNewObjectLocalization(
    		long lIdLanguage,
    		long lIdTypeObject,
    		long lIdReferenceObject) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException {
        try {
			return getObjectLocalization(lIdLanguage, lIdTypeObject, lIdReferenceObject);
		} catch (CoinDatabaseLoadException e) {
			return new ObjectLocalization(lIdLanguage, lIdTypeObject, lIdReferenceObject);
		}
    }
    
    public static ObjectLocalization getOrNewObjectLocalization(
    		long lIdLanguage,
    		long lIdTypeObject,
    		String sIdReferenceObjectString) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException {
        try {
			return getObjectLocalization(lIdLanguage, lIdTypeObject, sIdReferenceObjectString);
		} catch (CoinDatabaseLoadException e) {
			return new ObjectLocalization(lIdLanguage, lIdTypeObject, sIdReferenceObjectString);
		}
    }


    
    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdLanguage = Long.parseLong(request.getParameter(sFormPrefix + "lIdLanguage"));
        } catch(Exception e){}
        try {
            this.lIdTypeObject = Long.parseLong(request.getParameter(sFormPrefix + "lIdTypeObject"));
        } catch(Exception e){}
        try {
            this.lIdReferenceObject = Long.parseLong(request.getParameter(sFormPrefix + "lIdReferenceObject"));
        } catch(Exception e){}
        this.sValue = request.getParameter(sFormPrefix + "sValue");
        this.sIdReferenceObjectString = request.getParameter(sFormPrefix + "sIdReferenceObjectString");
    }

    public static Vector<ObjectLocalization> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectLocalization item = new ObjectLocalization();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<ObjectLocalization> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectLocalization item = new ObjectLocalization();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<ObjectLocalization> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectLocalization item = new ObjectLocalization();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<ObjectLocalization> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        ObjectLocalization item = new ObjectLocalization();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
        return "object_localization_"+this.lId;
    }

    public long getIdLanguage() {return this.lIdLanguage;}
    public void setIdLanguage(long lIdLanguage) {this.lIdLanguage = lIdLanguage;}

    public long getIdTypeObject() {return this.lIdTypeObject;}
    public void setIdTypeObject(long lIdTypeObject) {this.lIdTypeObject = lIdTypeObject;}

    public long getIdReferenceObject() {return this.lIdReferenceObject;}
    public void setIdReferenceObject(long lIdReferenceObject) {this.lIdReferenceObject = lIdReferenceObject;}

    public String getIdReferenceObjectString() {return this.sIdReferenceObjectString;}
    public void setIdReferenceObjectString(String sIdReferenceObjectString) {this.sIdReferenceObjectString = sIdReferenceObjectString;}

    public String getValue() {return this.sValue;}
    public void setValue(String sValue) {this.sValue = sValue;}

	public void setValueWithEncoding(String value) throws UnsupportedEncodingException {
		this.sValue = value;
		if(this.sValue != null)
		{
			this.sValue = new String(this.sValue.getBytes(this.sDecoding),this.sEncoding);
		}
	}
    
    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdLanguage", this.lIdLanguage);
        item.put("lIdTypeObject", this.lIdTypeObject);
        item.put("lIdReferenceObject", this.lIdReferenceObject);
        item.put("sIdReferenceObjectString", this.sIdReferenceObjectString);
        item.put("sValue", this.sValue);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        ObjectLocalization item = getObjectLocalization(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (ObjectLocalization item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdLanguage = item.getLong("lIdLanguage");
        } catch(Exception e){}
        try {
            this.lIdTypeObject = item.getLong("lIdTypeObject");
        } catch(Exception e){}
        try {
            this.lIdReferenceObject = item.getLong("lIdReferenceObject");
        } catch(Exception e){}
        try {
            this.sIdReferenceObjectString = item.getString("sIdReferenceObjectString");
        } catch(Exception e){}
        try {
            this.sValue = item.getString("sValue");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            ObjectLocalization item = null;
            try{
                item = ObjectLocalization.getObjectLocalization(data.getLong("lId"));
            } catch(Exception e){
                item = new ObjectLocalization();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }

    public static Map<String, String>[] getLocalizationArrayLabel() 
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
		Connection conn = ConnectionManager.getConnection();
    	try {
        	return getLocalizationArrayLabel(conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    }   
    
    @SuppressWarnings("unchecked")
	public static Map<String, String>[] getLocalizationArrayLabel(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		int iMaxLanguage = 0;
    	
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		/**
		 * Create the matrix
		 */
		Map<String, String>[] matrix  
			= new Map [iMaxLanguage + 1];
		
		
		for (Language lang : vLanguage) {
			matrix[(int)lang.lId]
				= Collections.synchronizedMap(new HashMap<String, String>());
		}
		
		return matrix;
	}

    public static Vector<ObjectLocalization> getAllFromIdObjectType(
    		long iAbstractBeanIdObjectType,
    		Connection conn)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	ObjectLocalization ot = new ObjectLocalization();
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(iAbstractBeanIdObjectType));
		ot.bUseHttpPrevent = false;
		ot.bUseEmbeddedConnection = true;
		ot.connEmbeddedConnection = conn;
		
		return
			 ot.getAllWithWhereAndOrderByClause(" WHERE id_type_object=?", "", vParam);

	
		
    }
    
    public static Vector<Long> getAllReferenceFromIdObjectType(
    		long iAbstractBeanIdObjectType,
    		Connection conn)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	ObjectLocalization ot = new ObjectLocalization();
		String sSqlQuery = "SELECT DISTINCT id_reference_object " 
    			+ " FROM "+ ot.TABLE_NAME
    			+ " WHERE id_type_object=" + iAbstractBeanIdObjectType
    			+ " ORDER BY id_reference_object";
    	
    	return ConnectionManager.getVectorLongResult(sSqlQuery, conn);
    }

    public static Vector<String> getAllReferenceStringFromIdObjectType(
    		long iAbstractBeanIdObjectType,
    		Connection conn)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	ObjectLocalization ot = new ObjectLocalization();
		String sSqlQuery = "SELECT DISTINCT id_reference_object_string " 
				+ " FROM "+ ot.TABLE_NAME
    			+ " WHERE id_type_object=" + iAbstractBeanIdObjectType
    			+ " ORDER BY id_reference_object_string";
    	
    	return ConnectionManager.getVectorStringResult(sSqlQuery, conn);
    }

    
    @SuppressWarnings("unchecked")
	public static Map<String, String>[] generateLocalizationMatrixString(
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
		
		Vector<ObjectLocalization> vItem 
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
		for (ObjectLocalization item : vItem) {
			matrix[(int)item.lIdLanguage]
				.put(item.sIdReferenceObjectString, item.getValue());
		}
		
		return matrix;
	}
    
    @SuppressWarnings("unchecked")
	public static Map<String, ObjectLocalization>[] generateObjectLocalizationString(
			long lIdTypeObject,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		
		int iMaxLanguage = 0;
		
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		Vector<ObjectLocalization> vItem 
			= getAllFromIdObjectType(lIdTypeObject, conn);
		
		
		/**
		 * Create the matrix
		 */
		Map<String, ObjectLocalization>[] matrix  
			= new Map [iMaxLanguage + 1];
		
		for (Language lang : vLanguage) {
			matrix[(int)lang.lId]
				= Collections.synchronizedMap(new HashMap<String, ObjectLocalization>());
		}

		/**
		 * Populate the matrix
		 */
		for (ObjectLocalization item : vItem) {
			matrix[(int)item.lIdLanguage]
				.put(item.sIdReferenceObjectString, item);
		}
		
		return matrix;
	}

	public static ObjectLocalization[][] generateObjectLocalization(
			long lIdTypeObject,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		
		int iMaxLanguage = 0;
		
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		Vector<ObjectLocalization> vItem 
			= getAllFromIdObjectType(lIdTypeObject, conn);
		
		int iMaxIndex = 0;
		
		for (ObjectLocalization item : vItem) {
			if(item.getIdReferenceObject() > iMaxIndex )
				iMaxIndex = (int)item.getIdReferenceObject() ;
		}

		/**
		 * Create the matrix
		 */
		ObjectLocalization[][] matrix  
			= new ObjectLocalization
				 [iMaxLanguage + 1]
				 [iMaxIndex + 1];
		

		/**
		 * Populate the matrix
		 */
		for (ObjectLocalization item : vItem) {
			matrix
				[(int)item.lIdLanguage]
				[(int)item.lIdReferenceObject] = item;
			
			/*System.out.println("" + item.lIdLanguage 
					+ " " + item.lIdReferenceObject
					+ " = " + item.getValue()
					);
			*/
		}
		
		return matrix;
		
	}
    
	public static String[][] generateLocalizationMatrix(
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
		
		Vector<ObjectLocalization> vItem 
			= getAllFromIdObjectType(bean.iAbstractBeanIdObjectType, conn);
		
		@SuppressWarnings("unused")
		ObjectLocalization ot = new ObjectLocalization();
		
		
		int iMaxIndex = 0;
		
		for (ObjectLocalization item : vItem) {
			if(item.getIdReferenceObject() > iMaxIndex )
				iMaxIndex = (int)item.getIdReferenceObject() ;
		}

		/**
		 * Create the matrix
		 */
		String[][] matrix  
			= new String
				 [iMaxLanguage + 1]
				 [iMaxIndex + 1];
		

		/**
		 * Populate the matrix
		 */
		for (ObjectLocalization item : vItem) {
			matrix
				[(int)item.lIdLanguage]
				[(int)item.lIdReferenceObject] = item.getValue();
			
			/*System.out.println("" + item.lIdLanguage 
					+ " " + item.lIdReferenceObject
					+ " = " + item.getValue()
					);
			*/
		}
		
		return matrix;
		
	}
	

	public static void displayMatrixOnConsole(
			Connection conn,
			String[][] sarrLocalization)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		Vector<Language> vLanguage = Language.getAllStatic(conn);

		for (Language lang : vLanguage) {
			System.out.print( lang.getName() +  " ");;
		}
		System.out.println();

		for (int k = 1; k < sarrLocalization[0].length ; k++) {
			System.out.print(  k + ":" );
			for (int i = 1; i <= vLanguage.size(); i++) {
				if(sarrLocalization[i][k] != null )
				{
					System.out.print(  sarrLocalization[i][k] + " ");
				} else {
					System.out.print(  "- ");
				}
			}
			System.out.println();
		}
	}
	
	/**
	 * 
	 * 
	 * @param conn
	 * @param sarrLocalization
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	
	public static void displayMatrixOnConsole(
			Connection conn,
			Map<String, String>[] sarrLocalization)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		Vector<Language> vLanguage = Language.getAllStatic(conn);

		for (Language lang : vLanguage) {
			System.out.print( lang.getName() +  " ");;
		}
		System.out.println();

		/**
		 * We take the first map in French
		 */
		Map<String, String> map = sarrLocalization[1];
		
		for (Iterator<String> iter=map.keySet().iterator(); iter.hasNext(); ) 
		{
			String sKey = (String) iter.next();
			System.out.println(sKey + ": ");
			if(sKey == null) continue;
			for (int i = 1; i <= vLanguage.size(); i++) 
			{
				Map<String, String> item = sarrLocalization[i];
				String sValue = (String) item.get(sKey);
				if(sValue != null )
				{
					System.out.print(  sValue + " ");
				} else {
					System.out.print(  "- ");
				}
			}
			System.out.println();
		}
	}
	
}
