
/*
* Studio Matamore - France 2008, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.ConnectionManager;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@RemoteProxy
public class PersonnePhysiqueParametre extends CoinDatabaseAbstractBean {

	/**
	 * to increment only if there is a modification in the DWR interface
	 */
	public static final String AJAX_VERSION = "1.0.0";

    private static final long serialVersionUID = 1L;

    protected long lIdPersonnePhysique;
    protected String sName;
    protected String sValue;

    public static final String PARAM_MAIN_SIGNATURE = "multimedia.signature.main.id" ;
    public static final String PARAM_RECEIVE_MAIL_NOTIFICATION= "receive.mail.notification" ;
    public static final String PARAM_ADDITIONAL_EMAIL_ADDRESS = "additional.email.address";
    public static final String PARAM_RECEIVE_MAIL_NOTIFICATION_LOGGED= "receive.mail.notification.logged" ;
    public static final String PARAM_AUTO_RELOAD = "paraph.folder.auto.reload";
    public static final String PARAM_INTERNAL_CIRCUIT = "paraph.folder.create.internal.circuit";
    public static final String PARAM_NOTIFICATION_BOX = "paraph.folder.notification.box";
    
    @Deprecated
    public static final String PARAM_SIGNATURE = "multimedia.signature." ;
    
    public PersonnePhysiqueParametre() {
        init();
    }

    public PersonnePhysiqueParametre(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "personne_physique_parametre";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_personne_physique,"
                + " name,"
                + " value";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdPersonnePhysique = 0;
        this.sName = "";
        this.sValue = "";

    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdPersonnePhysique);
        ps.setString(++i, preventStore(this.sName));
        ps.setString(++i, preventStore(this.sValue));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdPersonnePhysique = rs.getLong(++i);
        this.sName = preventLoad(rs.getString(++i));
        this.sValue = preventLoad(rs.getString(++i));
    }

    public static PersonnePhysiqueParametre getPersonnePhysiqueParametre(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        PersonnePhysiqueParametre item = new PersonnePhysiqueParametre(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdPersonnePhysique = Long.parseLong(request.getParameter(sFormPrefix + "lIdPersonnePhysique"));
        } catch(Exception e){}
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
        try {
            this.sValue = request.getParameter(sFormPrefix + "sValue");
        } catch(Exception e){}
    }

    public static Vector<PersonnePhysiqueParametre> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        PersonnePhysiqueParametre item = new PersonnePhysiqueParametre();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<PersonnePhysiqueParametre> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        PersonnePhysiqueParametre item = new PersonnePhysiqueParametre();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<PersonnePhysiqueParametre> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        PersonnePhysiqueParametre item = new PersonnePhysiqueParametre();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<PersonnePhysiqueParametre> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        PersonnePhysiqueParametre item = new PersonnePhysiqueParametre();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    public long getIdPersonnePhysique() {return this.lIdPersonnePhysique;}
    public void setIdPersonnePhysique(long lIdPersonnePhysique) {this.lIdPersonnePhysique = lIdPersonnePhysique;}

    @Override
    public String getName() {return this.sName;}
    public void setName(String sName) {this.sName = sName;}

    public String getValue() {return this.sValue;}
    public void setValue(String sValue) {this.sValue = sValue;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdPersonnePhysique", this.lIdPersonnePhysique);
        item.put("sName", this.sName);
        item.put("sValue", this.sValue);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        PersonnePhysiqueParametre item = getPersonnePhysiqueParametre(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (PersonnePhysiqueParametre item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdPersonnePhysique = item.getLong("lIdPersonnePhysique");
        } catch(Exception e){}
        try {
            this.sName = item.getString("sName");
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
            PersonnePhysiqueParametre item = null;
            try{
                item = PersonnePhysiqueParametre.getPersonnePhysiqueParametre(data.getLong("lId"));
            } catch(Exception e){
                item = new PersonnePhysiqueParametre();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }

    
    
    

	public static int incrementIntValue(
			long lIdPersonnePhysique, 
			String sParamName,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException,
	NamingException, CoinDatabaseStoreException 
	{
		PersonnePhysiqueParametre param = 
			PersonnePhysiqueParametre.getPersonnePhysiqueParametre(
					lIdPersonnePhysique, 
					sParamName ,
					conn);
			
		int iValue = Integer.parseInt(param.getValue()); 
		iValue++;
		
		param.setValue("" + iValue);
		param.store(conn);
		
		return iValue;
	}
	
	public static int incrementIntValue(long lIdPersonnePhysique, String sParamName)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException,
	NamingException, CoinDatabaseStoreException
	{
		Connection conn = ConnectionManager.getConnection();
		try{
			return incrementIntValue(
					lIdPersonnePhysique, 
					sParamName,
					conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	@RemoteMethod
	public static void updateValue(
			long lIdPersonnePhysique, 
			String sParamName, 
			String sParamValue)
	throws CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, 
	SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseStoreException
	{
		Connection conn = ConnectionManager.getConnection();
		try{
			updateValue(
					lIdPersonnePhysique, 
					sParamName, 
					sParamValue, 
					conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		
	}

	@RemoteMethod
	public static void removeById(
			long lId)
	throws CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, 
	SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseStoreException
	{
		PersonnePhysiqueParametre param = new PersonnePhysiqueParametre();
		param.remove(lId);
	}

	
	@RemoteMethod
	public static void removeByNameAndValue(
			long lIdPersonnePhysique, 
			String sParamName, 
			String sParamValue)
	throws CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, 
	SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseStoreException
	{
		Connection conn = ConnectionManager.getConnection();
		try{
			removeByNameAndValue(
					lIdPersonnePhysique, 
					sParamName, 
					sParamValue, 
					conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		
	}

	

	public static void removeByNameAndValue(
			long lIdPersonnePhysique, 
			String sParamName, 
			String sParamValue,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, 
	NamingException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseStoreException
	{
		PersonnePhysiqueParametre param = 
			PersonnePhysiqueParametre.getPersonnePhysiqueParametre(
					lIdPersonnePhysique, 
					sParamName,
					sParamValue,
					conn );
		param.remove(conn);
	}
	
	
	public static void updateValue(
			long lIdPersonnePhysique, 
			String sParamName, 
			String sParamValue,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, 
	NamingException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseStoreException
	{
		try{
			PersonnePhysiqueParametre param = 
				PersonnePhysiqueParametre.getPersonnePhysiqueParametre(
						lIdPersonnePhysique, 
						sParamName,
						conn );
			
			/**
			 * update only if the value is not equal
			 */
			if(!param.getValue().equals(sParamValue)){
				param.setValue(sParamValue);
				param.store(conn);
			}
		}catch(CoinDatabaseLoadException ce){
			PersonnePhysiqueParametre param = new PersonnePhysiqueParametre();
			
			param.setName(sParamName);
			param.setValue(sParamValue);
			param.setIdPersonnePhysique(lIdPersonnePhysique);
			param.create(conn);
		}
	}
	
	public static void updateValues(
			long lIdPersonnePhysique, 
			String sParamName, 
			ArrayList<String> sParamValues)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseCreateException, CoinDatabaseDuplicateException
	{
		updateValues(
				lIdPersonnePhysique, 
				sParamName, 
				sParamValues, 
				false,
				null);
	}
	
	public static void updateValues(
			long lIdPersonnePhysique, 
			String sParamName, 
			ArrayList<String> sParamValues,
			boolean bUseEmbeddedConnection,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException,
	NamingException, CoinDatabaseCreateException, CoinDatabaseDuplicateException
	{
		Vector<PersonnePhysiqueParametre> vParam
			= PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(
					lIdPersonnePhysique,
					sParamName,
					bUseEmbeddedConnection,
					conn);
		
		/** CREATE ITEMS */
		for(String sParamValue : sParamValues){
			boolean bParamExist = false;
			for(PersonnePhysiqueParametre param : vParam){
				if(param.getValue() != null && sParamValue != null
				&& param.getValue().equalsIgnoreCase(sParamValue)){
					bParamExist = true;
				}
			}
			if(!bParamExist){
				PersonnePhysiqueParametre param = new PersonnePhysiqueParametre();
				
				param.bUseEmbeddedConnection = bUseEmbeddedConnection;
				param.connEmbeddedConnection = conn;
				
				param.setName(sParamName);
				param.setValue(sParamValue);
				param.setIdPersonnePhysique(lIdPersonnePhysique);
				param.create();
			}
		}
		
		/** REMOVE OLD ITEMS */
		for(PersonnePhysiqueParametre param : vParam){
			boolean bParamExist = false;
			for(String sParamValue : sParamValues){
				if(param.getValue().equalsIgnoreCase(sParamValue)){
					bParamExist = true;
				}
			}
			if(!bParamExist){
				param.bUseEmbeddedConnection = bUseEmbeddedConnection;
				param.connEmbeddedConnection = conn;
				param.remove();
			}
		}
	}
	
	public static Vector<PersonnePhysiqueParametre> getAllFromIdPersonnePhysique(long lIdPersonnePhysique) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllFromIdPersonnePhysique(lIdPersonnePhysique, false, null);
	}
	
	public static Vector<PersonnePhysiqueParametre> getAllFromIdPersonnePhysique(
			long lIdPersonnePhysique,
			boolean bUseEmbeddedConnection,
			Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllFromIdPersonnePhysique(
				lIdPersonnePhysique, 
				true, 
				bUseEmbeddedConnection, 
				conn);
	}

	public static Vector<PersonnePhysiqueParametre> getAllFromIdPersonnePhysique(
			long lIdPersonnePhysique,
			boolean bUseHttpPrevent,
			boolean bUseEmbeddedConnection,
			Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysiqueParametre item = new PersonnePhysiqueParametre ();
		if(bUseEmbeddedConnection && conn != null){
			item.bUseEmbeddedConnection = bUseEmbeddedConnection;
			item.connEmbeddedConnection = conn;
		}
		item.bUseHttpPrevent = bUseHttpPrevent;
		
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(lIdPersonnePhysique));
		
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_personne_physique = ?",
				 " ORDER BY name",
				 vParam);
		
	}	
	
	public static Vector<PersonnePhysiqueParametre> getAllFromIdPersonnePhysique(long lIdPersonnePhysique,String sParamName) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllFromIdPersonnePhysique(lIdPersonnePhysique,sParamName, false, null);
	}
	
	public static Vector<PersonnePhysiqueParametre> getAllFromIdPersonnePhysique(long lIdPersonnePhysique,String sParamName,boolean bUseHttpPrevent) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllFromIdPersonnePhysique(lIdPersonnePhysique,sParamName,bUseHttpPrevent, false, null);
	}
	
	public static Vector<PersonnePhysiqueParametre> getAllFromIdPersonnePhysique(
			long lIdPersonnePhysique,
			String sParamName,
			boolean bUseEmbeddedConnection,
			Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllFromIdPersonnePhysique(
				lIdPersonnePhysique, 
				sParamName, 
				true, 
				bUseEmbeddedConnection, 
				conn);
	}
	
	public static Vector<PersonnePhysiqueParametre> getAllFromIdPersonnePhysique(
			long lIdPersonnePhysique,
			String sParamName,
			boolean bUseHttpPrevent,
			boolean bUseEmbeddedConnection,
			Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		PersonnePhysiqueParametre item = new PersonnePhysiqueParametre ();
		if(bUseEmbeddedConnection && conn != null){
			item.bUseEmbeddedConnection = bUseEmbeddedConnection;
			item.connEmbeddedConnection = conn;
		}
		item.bUseHttpPrevent = bUseHttpPrevent;
		Vector<Object> vParam = new Vector<Object>();
		vParam.add(new Long(lIdPersonnePhysique));
		vParam.add(sParamName);
		
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_personne_physique = ?"
				+" AND name = ?",
				"",
				vParam);
		
	}

	
	public static String getPersonnePhysiqueParametreValueOptional(
			long lIdPersonnePhysique, 
			String sName,
			Connection conn) 
	{
		return getPersonnePhysiqueParametreValueOptional(lIdPersonnePhysique, sName, "", conn);
	}	


	public static boolean isTrue(
			long lIdPersonnePhysique, 
			String sName) 
	{
		String sValue = getPersonnePhysiqueParametreValueOptional(lIdPersonnePhysique, sName, "");
		return sValue.equals("true");
	}
	
	
	public static boolean isTrue(
			long lIdPersonnePhysique, 
			String sName,
			Connection conn) 
	{
		String sValue = getPersonnePhysiqueParametreValueOptional(lIdPersonnePhysique, sName, "", conn);
		return sValue.equals("true");
	}	

	
	public static boolean isEnabled(
			long lIdPersonnePhysique, 
			String sName) throws SQLException, NamingException 
	{
		Connection conn = ConnectionManager.getConnection(); 
		String sValue = null;
		try{
			sValue = getPersonnePhysiqueParametreValueOptional(lIdPersonnePhysique, sName, "", conn);
			return sValue.equals("enabled");
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}	
	
	public static boolean isEnabled(
			long lIdPersonnePhysique, 
			String sName,
			Connection conn) 
	{
		try {
			return isEnabled(true, lIdPersonnePhysique, sName, conn);
		} catch (Exception e) {
			return false;
		}
	}	

	public static boolean isEnabled(
			boolean bOptional,
			long lIdPersonnePhysique,
			String sName,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException 
	{
		String sValue = null;
		if(bOptional) {
			sValue = getPersonnePhysiqueParametreValueOptional(lIdPersonnePhysique, sName, "", conn);
		} else {
			sValue = getPersonnePhysiqueParametreValue(lIdPersonnePhysique, sName, conn);
		}
		return sValue.equals("enabled");
	}	

	
	public static boolean isEnabled(
			long lIdPersonnePhysique, 
			String sName,
			boolean bDefaultValue,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException, NamingException 
	{
		try {
			String sValue = getPersonnePhysiqueParametreValue(lIdPersonnePhysique, sName,conn);			
			return sValue.equals("enabled");
		} catch (CoinDatabaseLoadException e) {			
			return bDefaultValue;
		}
	}	
	
	public static String getPersonnePhysiqueParametreValueOptional(
			long lIdPersonnePhysique, 
			String sName ,
			String sDefaultValue ,
			Connection conn) 
	{
		try {
			return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, conn ).getValue();
		} catch (Exception e) {
			return sDefaultValue;
		}
	}

	public static int getPersonnePhysiqueParametreValueOptionalInteger(
			long lIdPersonnePhysique, 
			String sName ,
			int iDefaultValue ,
			Connection conn) 
	{
		try {
			return Integer.parseInt(
					getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, conn ).getValue());
		} catch (Exception e) {
			return iDefaultValue;
		}
	}

	public static long getPersonnePhysiqueParametreValueOptionalLong(
			long lIdPersonnePhysique, 
			String sName ,
			int iDefaultValue ,
			Connection conn) 
	{
		try {
			return Long.parseLong(
					getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, conn ).getValue());
		} catch (Exception e) {
			return iDefaultValue;
		}
	}


	public static double getPersonnePhysiqueParametreValueOptionalDouble(
			long lIdPersonnePhysique, 
			String sName ,
			double dDefaultValue ,
			Connection conn) 
	{
		try {
			return Double.parseDouble(
					getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, conn ).getValue());
		} catch (Exception e) {
			return dDefaultValue;
		}
	}
	
	public static float getPersonnePhysiqueParametreValueOptionalFloat(
			long lIdPersonnePhysique, 
			String sName ,
			float fDefaultValue ,
			Connection conn) 
	{
		try {
			return Float.parseFloat(
					getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, conn ).getValue());
		} catch (Exception e) {
			return fDefaultValue;
		}
	}
	
	public static String getPersonnePhysiqueParametreValueOptional(long lIdPersonnePhysique, String sName ) 
	{
		return getPersonnePhysiqueParametreValueOptional(lIdPersonnePhysique, sName, "");
	}	

	public static String getPersonnePhysiqueParametreValueOptional(
			long lIdPersonnePhysique, 
			String sName,
			String sDefaultValue ) 
	{
		try {
			return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName ).getValue();
			
		} catch (Exception e) {
			return sDefaultValue;
		}
	}
	
	public static long getPersonnePhysiqueParametreLongValueOptional(
			long lIdPersonnePhysique, 
			String sName,
			long lDefaultValue,
			Vector<PersonnePhysiqueParametre> vItems) 
	{
    	try {
        	String sValue = getPersonnePhysiqueParametreValueOptional(
        			lIdPersonnePhysique, 
        			sName, 
        			""+lDefaultValue, 
        			vItems);
    		return Long.parseLong(sValue);
    	} catch (Exception e) {}
    	return lDefaultValue;
	}
	
	public static String getPersonnePhysiqueParametreValueOptional(
			long lIdPersonnePhysique, 
			String sName,
			String sDefaultValue,
			Vector<PersonnePhysiqueParametre> vItems) 
	{
		try {
			return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName,vItems ).getValue();
		} catch (Exception e) {
			return sDefaultValue;
		}
	}

	public static String getPersonnePhysiqueParametreValue(long lIdPersonnePhysique, String sName ) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException  {
		Connection conn = ConnectionManager.getDataSource().getConnection(); 
		
		try {
			return getPersonnePhysiqueParametreValue(lIdPersonnePhysique, sName, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}		
	}	
	
	public static String getPersonnePhysiqueParametreValue(long lIdPersonnePhysique, String sName, String sDefaultValue) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException  {
		Connection conn = ConnectionManager.getDataSource().getConnection(); 
		
		try {
			return getPersonnePhysiqueParametreValue(lIdPersonnePhysique, sName,sDefaultValue, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}		
	}	
	
	public static String getPersonnePhysiqueParametreValue(
			long lIdPersonnePhysique, 
			String sName , 
			String sDefaultValue,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException 
	{
		try{return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName,conn ).getValue();}
		catch(CoinDatabaseLoadException ce){return sDefaultValue;}
	}		
	
	public static String getPersonnePhysiqueParametreValue(
			long lIdPersonnePhysique, 
			String sName , 
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException 
	{
		return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName,conn ).getValue();
	}		
	
	public static PersonnePhysiqueParametre getPersonnePhysiqueParametre(long lIdPersonnePhysique, String sName, Vector<PersonnePhysiqueParametre> vItem) throws CoinDatabaseLoadException {
		for(PersonnePhysiqueParametre item : vItem){
			if(item.getIdPersonnePhysique() == lIdPersonnePhysique
					&& item.getName().equalsIgnoreCase(sName))
				return item;
		}
		throw new CoinDatabaseLoadException(sName,"param "+sName+" not found for lIdPersonnePhysique="+lIdPersonnePhysique);
	}
	public static Vector<PersonnePhysiqueParametre> getAllPersonnePhysiqueParametre(long lIdPersonnePhysique, String sName, Vector<PersonnePhysiqueParametre> vItem) {
		Vector<PersonnePhysiqueParametre> vItemReturn = new Vector<PersonnePhysiqueParametre>();
		for(PersonnePhysiqueParametre item : vItem){
			if(item.getIdPersonnePhysique() == lIdPersonnePhysique
					&& item.getName().equalsIgnoreCase(sName))
				vItemReturn.add(item);
		}
		return vItemReturn;
	}

	public static PersonnePhysiqueParametre getPersonnePhysiqueParametre(long lIdPersonnePhysique, String sName ) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException
	{
		Connection conn = ConnectionManager.getConnection(); 
		
		try {
			return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}		
	
	}

	public static PersonnePhysiqueParametre getPersonnePhysiqueParametre(
			long lIdPersonnePhysique, 
			String sName, 
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException 
	{
		return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, null, conn);
	}
	
	public static PersonnePhysiqueParametre getPersonnePhysiqueParametre(
			long lIdPersonnePhysique, 
			String sName, 
			String sValue, 
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException 
	{
		PersonnePhysiqueParametre item = new PersonnePhysiqueParametre ();
		
		if(conn != null){
			item.bUseEmbeddedConnection = true;
			item.connEmbeddedConnection = conn;
		}
		
		Vector<Object> vParams = new Vector<Object>();
		vParams.add(new Long(lIdPersonnePhysique));
		vParams.add(sName);
		if(sValue != null) vParams.add(sValue);
		item.bUseHttpPrevent = false;
		Vector<PersonnePhysiqueParametre> vexp 
			=  item.getAllWithWhereAndOrderByClause(
				" WHERE id_personne_physique=?" 
				+ " AND name=? "
				+ (sValue==null?"":" AND value=? "),
				" ORDER BY name",
				vParams);
		
		if (vexp.size() >0 ) 
		{
			return vexp.get(0);
		}
		CoinDatabaseLoadException ee 
		= new CoinDatabaseLoadException ("Le paramètre '"
				+sName + "' est indéfini pour l'iIdPersonnePhysique = " + lIdPersonnePhysique, "");
		throw (ee);

	}	

	public static Vector<PersonnePhysiqueParametre> getAllStartWith(
			String sStartWith) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, 
	IllegalAccessException 
	{
		PersonnePhysiqueParametre item = new PersonnePhysiqueParametre ();
		
		return item.getAllWithWhereAndOrderByClause(
			 " WHERE name LIKE '" + Outils.addLikeSlashes(sStartWith) + "%' ",
			 " ORDER BY name" );
	}

	
	public static Vector<PersonnePhysiqueParametre> getAllStartWith(
			long lIdIndividual,
			String sStartWith,
			Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, 
	IllegalAccessException 
	{
		PersonnePhysiqueParametre item = new PersonnePhysiqueParametre ();
		Vector<Object> vItem = new Vector<Object>();
		vItem.add(new Long(lIdIndividual));
		vItem.add(sStartWith + "%");
		
		
		item.bUseHttpPrevent = false;
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		
		return item.getAllWithWhereAndOrderByClause(
			 " WHERE id_personne_physique=? AND name LIKE ? ",
			 " ORDER BY name",
			 vItem);
	}

	
	public static PersonnePhysiqueParametre getOrCreatePersonnePhysiqueParametre(
    		long lIdPersonnePhysique,
    		String sName)
    throws SQLException, NamingException, CoinDatabaseDuplicateException,
    InstantiationException, IllegalAccessException, CoinDatabaseCreateException, CoinDatabaseLoadException 
    {
    	Connection conn = null;
    	try {
    		conn = ConnectionManager.getConnection();
        	return getOrCreatePersonnePhysiqueParametre(lIdPersonnePhysique, sName, false, conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    }
    
    public static PersonnePhysiqueParametre getOrCreatePersonnePhysiqueParametre(
    		long lIdPersonnePhysique,
    		String sName,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws SQLException, NamingException, CoinDatabaseDuplicateException,
    InstantiationException, IllegalAccessException, CoinDatabaseCreateException, CoinDatabaseLoadException 
    {
    	try {
			return getPersonnePhysiqueParametre(lIdPersonnePhysique, sName, conn);
		} catch (CoinDatabaseLoadException e) {
			PersonnePhysiqueParametre item = new PersonnePhysiqueParametre();
			item.setIdPersonnePhysique(lIdPersonnePhysique);
			item.setName(sName);
			item.bUseHttpPrevent = bUseHttpPrevent ;
			item.create(conn);
			return item;
		}
    }
 
    
    public static long getMainSignatureForPersonnePhysique(
    		long lIdPersonnePhysique,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException, 
    InstantiationException, IllegalAccessException, CoinDatabaseStoreException
    {
    	return getPersonnePhysiqueParametreValueOptionalInteger(
    			lIdPersonnePhysique, 
    			PARAM_MAIN_SIGNATURE, 
    			-1, 
    			conn);
    }
    
    public static void setMainSignatureForPersonnePhysique(
    		long lIdPersonnePhysique,
    		long lIdSignature) 
    throws CoinDatabaseLoadException, SQLException, NamingException, 
	InstantiationException, IllegalAccessException, CoinDatabaseStoreException, 
	CoinDatabaseCreateException, CoinDatabaseDuplicateException
    {
    	updateValue(lIdPersonnePhysique, PARAM_MAIN_SIGNATURE, "" + lIdSignature);
	}

    public static void removeMainSignatureForPersonnePhysique(
    		long lIdPersonnePhysique) 
    throws CoinDatabaseLoadException, SQLException, NamingException, 
	InstantiationException, IllegalAccessException, CoinDatabaseStoreException, 
	CoinDatabaseCreateException, CoinDatabaseDuplicateException
    {
    	PersonnePhysiqueParametre item = new PersonnePhysiqueParametre();
    	item.remove(
    			" WHERE id_personne_physique=" + lIdPersonnePhysique 
				+ " AND name='" + PARAM_MAIN_SIGNATURE + "' ");
	}
    
    public static Vector <String> getPersonnePhysiqueParametreValues (long lIdPersonnePhysique, String sName, Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	Vector <String> vValues = new Vector <String> ();
    	for (PersonnePhysiqueParametre parameter : getAllFromIdPersonnePhysique (lIdPersonnePhysique, sName, false, conn))
    		if (parameter.getValue() != null)
    			vValues.add(parameter.getValue ());
    	return vValues;
    }
    
    public static Vector <String> getPersonnePhysiqueParametreValues (long lIdPersonnePhysique, String sName)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
    {
    	Vector <String> vValues;
    	Connection conn = ConnectionManager.getConnection ();
    	try {
    		vValues = getPersonnePhysiqueParametreValues(lIdPersonnePhysique, sName, conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    	return vValues;
    }
    
    public static boolean isInternalCircuitParameterEnabled(long lIdPersonnePhysique) throws SQLException, NamingException
    {
    	boolean bParamCreateInternalCircuitEnabled = false;
    	
    	bParamCreateInternalCircuitEnabled 
			= PersonnePhysiqueParametre.isEnabled(
					lIdPersonnePhysique, 
					PersonnePhysiqueParametre.PARAM_INTERNAL_CIRCUIT);
		
		return bParamCreateInternalCircuitEnabled;
    }
    
    public static boolean isNotificationEnabled (long lIdPersonnePhysique, Connection conn)
    throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException
    {
    	/**
    	 * TODO: use non-static functions to determinate if the parameter is "enabled" / "disabled" and "true" / "false".
    	 */
    	if (PersonnePhysiqueParametre.getPersonnePhysiqueParametreValue (lIdPersonnePhysique, PARAM_NOTIFICATION_BOX, null, conn) == null)
    		return OrganisationParametre.isEnabled (PersonnePhysique.getPersonnePhysique (lIdPersonnePhysique).getIdOrganisation(), PARAM_NOTIFICATION_BOX, true, conn);
    	else
    		return PersonnePhysiqueParametre.isEnabled (lIdPersonnePhysique, PARAM_NOTIFICATION_BOX, true, conn); 
    }
    
    public static boolean isNotificationEnabled (long lIdPersonnePhysique)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
    {
    	Connection conn = ConnectionManager.getConnection ();
    	try {
    		return isNotificationEnabled(lIdPersonnePhysique, conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    }

    
    public static double getValuePersonOrOrganization(
    		long lIdPerson,
    		String sName,
    		double dDefaultValue,
    		Connection conn)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return Double.parseDouble(
    		getValuePersonOrOrganization(lIdPerson, sName, ""+dDefaultValue, conn));
	}
    
    public static boolean getValuePersonOrOrganization(
    		long lIdPerson,
    		long lIdOrganization,
    		String sName,
    		boolean bDefaultValue,
    		Connection conn)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return Boolean.parseBoolean(
    		getValuePersonOrOrganization(lIdPerson, lIdOrganization, sName, ""+bDefaultValue, conn));
	}
	
    public static String getValuePersonOrOrganization(
    		long lIdPerson,
    		String sName,
    		String sDefaultValue,
    		Connection conn)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	try {
	    	return getValuePersonOrOrganization(lIdPerson, sName, conn);
    	} catch (Exception e) {
    		return sDefaultValue;
		}
	}
    
    public static String getValuePersonOrOrganization(
    		long lIdPerson,
    		String sName,
    		Connection conn)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
		PersonnePhysique person = PersonnePhysique.getPersonnePhysique(lIdPerson, false, conn);
    	return getValuePersonOrOrganization(lIdPerson, person.getIdOrganisation(), sName, conn);
    }

    public static String getValuePersonOrOrganization(
    		long lIdPerson,
    		long lIdOrganization,
    		String sName,
    		Connection conn)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return getValuePersonOrOrganization(lIdPerson, lIdOrganization, sName, null, conn);
    }
    
    public static String getValuePersonOrOrganization(
    		long lIdPerson,
    		long lIdOrganization,
    		String sName,
    		String sDefaultValue,
    		Connection conn) throws SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseLoadException
    {
    	try {
    		return getPersonnePhysiqueParametreValue(lIdPerson, sName, conn);
    	} catch (CoinDatabaseLoadException e) {
    		try{
    			return OrganisationParametre.getOrganisationParametreValue(lIdOrganization, sName, conn);
    		}catch(CoinDatabaseLoadException e1){
    			if(sDefaultValue == null) throw e1;
    			else return sDefaultValue;
    		}
		}
    }

}
