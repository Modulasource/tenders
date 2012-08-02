/*
* Mt Software - France 2010, tous droits réservés
* Contact : contact@mtsoftware.fr - http://www.mtsoftware.fr
*/

package org.coin.fr.bean;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.db.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class MultimediaParameter extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;
    
    protected long lIdCoinMultimedia;
    protected String sName;
    protected String sValue;

    public static final String PARAM_RATIO = "ratio";
    public static final String PARAM_OFFSET_X = "xoffset";
    public static final String PARAM_OFFSET_Y = "yoffset";

    public MultimediaParameter() {
        init();
    }

    public MultimediaParameter(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "coin_multimedia_parameter";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_coin_multimedia,"
                + " name,"
                + " value";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdCoinMultimedia = 0;
        this.sName = "";
        this.sValue = "";

    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdCoinMultimedia);
        ps.setString(++i, preventStore(this.sName));
        ps.setString(++i, preventStore(this.sValue));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdCoinMultimedia = rs.getLong(++i);
        this.sName = preventLoad(rs.getString(++i));
        this.sValue = preventLoad(rs.getString(++i));
    }

    public static MultimediaParameter getMultimediaParameter(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        MultimediaParameter item = new MultimediaParameter(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdCoinMultimedia = Long.parseLong(request.getParameter(sFormPrefix + "lIdCoinMultimedia"));
        } catch(Exception e){}
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
        try {
            this.sValue = request.getParameter(sFormPrefix + "sValue");
        } catch(Exception e){}
    }

    public static Vector<MultimediaParameter> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        MultimediaParameter item = new MultimediaParameter();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<MultimediaParameter> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        MultimediaParameter item = new MultimediaParameter();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<MultimediaParameter> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        MultimediaParameter item = new MultimediaParameter();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<MultimediaParameter> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        MultimediaParameter item = new MultimediaParameter();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    public long getIdCoinMultimedia() {return this.lIdCoinMultimedia;}
    public void setIdCoinMultimedia(long lIdCoinMultimedia) {this.lIdCoinMultimedia = lIdCoinMultimedia;}

    @Override
    public String getName() {return this.sName;}
    public void setName(String sName) {this.sName = sName;}

    public String getValue() {return this.sValue;}
    public void setValue(String sValue) {this.sValue = sValue;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdCoinMultimedia", this.lIdCoinMultimedia);
        item.put("sName", this.sName);
        item.put("sValue", this.sValue);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        MultimediaParameter item = getMultimediaParameter(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (MultimediaParameter item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdCoinMultimedia = item.getLong("lIdCoinMultimedia");
        } catch(Exception e){}
        try {
            this.sName = item.getString("sName");
        } catch(Exception e){}
        try {
            this.sValue = item.getString("sValue");
        } catch(Exception e){}
    }

    public static long storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static long storeFromJSONObject(JSONObject data) {
        try {
            MultimediaParameter item = null;
            try{
                item = MultimediaParameter.getMultimediaParameter(data.getLong("lId"));
            } catch(Exception e){
                item = new MultimediaParameter();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return item.getId();
        } catch(Exception e){
            return 0;
        }
    }
    
    public static Vector <MultimediaParameter> getAllFromMultimedia (Multimedia multimedia, Connection connection)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	MultimediaParameter item = new MultimediaParameter ();
    	item.setEmbeddedConnection (connection);
    	item.setUseEmbeddedConnection (true);
    	
    	Vector <Object> vParams = new Vector <Object> ();
    	vParams.add (new Long (multimedia.getId()));
    	
    	return item.getAllWithWhereAndOrderByClause(
    			"where id_coin_multimedia=?",
    			"order by id_coin_multimedia_parameter",
    			vParams);
    }
    
    public static Vector <MultimediaParameter> getAllFromMultimedia (Multimedia multimedia, String name, Connection connection)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	MultimediaParameter item = new MultimediaParameter ();
    	item.setEmbeddedConnection (connection);
    	item.setUseEmbeddedConnection (true);
    	
    	Vector <Object> vParams = new Vector <Object> ();
    	vParams.add (new Long (multimedia.getId()));
    	vParams.add (name);
    	
    	return item.getAllWithWhereAndOrderByClause(
    			"where id_coin_multimedia=? and name=?",
    			"order by id_coin_multimedia_parameter",
    			vParams);
    }
    
    public static void removeAllFromMultimedia (Multimedia multimedia, Connection connection)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	for (MultimediaParameter parameter : getAllFromMultimedia(multimedia, connection))
    		parameter.remove (connection);
    }
    
    public static MultimediaParameter getMultimediaParameter (Multimedia multimedia, String sName, Connection connection)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	Vector <MultimediaParameter> vParams = getAllFromMultimedia (multimedia, sName, connection);
    	switch (vParams.size()){
    		case 1:
    			return vParams.get(0);
    		
    		case 0:
    			throw new CoinDatabaseLoadException ("The parameter " + sName + " does not exist for the multimedia with id=" + multimedia.getId(), "");
    		
    		default:
    			throw new CoinDatabaseLoadException ("Multiple occurences for the parameter " + sName + " with multimedia id=" + multimedia.getId (), "");
    	}
    }
    
    public static String getMultimediaParameterValue (Multimedia multimedia, String sName, Connection connection)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return getMultimediaParameter (multimedia, sName, connection).getValue ();
    }
    
    public static String getMultimediaParameterValueOptional (Multimedia multimedia, String sName, Connection connection, String defaultValue)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	try {
    		return getMultimediaParameterValue (multimedia, sName, connection);
    	} catch (CoinDatabaseLoadException e){
    		return defaultValue;
    	}
    }
    
    public static String getMultimediaParameterValueOptional (Multimedia multimedia, String sName, Connection connection)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return getMultimediaParameterValueOptional (multimedia, sName, connection, "");
    }
    
    public static int getMultimediaParameterValueOptionalInt(Multimedia multimedia, String sName, int iDefaultValue, Connection connection) 
	{
		try {
			return Integer.parseInt(
					getMultimediaParameterValue(multimedia, sName, connection));
		} catch (Exception e) {
			return iDefaultValue;
		}
	}
    
    public static void updateValue (Multimedia multimedia, String sName, String sValue, Connection connection)
    throws CoinDatabaseStoreException, SQLException, NamingException, InstantiationException, IllegalAccessException,
    CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException
    {
    	try {
    		 MultimediaParameter parameter = MultimediaParameter.getMultimediaParameter(multimedia, sName, connection);
    		 if ((parameter.getValue() == null && sValue != null) || (parameter.getValue () != null && !parameter.equals(sValue))){
    			 parameter.setValue (sValue);
    			 parameter.store (connection);
    		 }
    	} catch (CoinDatabaseLoadException e){
    		MultimediaParameter parameter = new MultimediaParameter ();
    		parameter.setIdCoinMultimedia(multimedia.getId());
    		parameter.setName(sName);
    		parameter.setValue(sValue);
    		parameter.create(connection);
    	}
    }
    
    
    /** Test **/
    
    public static void print (Object object){
    	System.out.println (object);
    }
    
    public static void main (String [] args) throws Exception {
    	/** Tucma connection **/
    	String host = "192.168.0.2";
    	String user = "dba_account";
    	String password = "dba_account";
    	Connection connection = new RemoteControlServiceConnection(
				"jdbc:mysql://" + host + ":3306/modula_test?",
				user,
				password).getConnexionMySQL();
    	
    	try {
	    	Multimedia multimedia = Multimedia.getMultimedia (287, false, connection);
	    	
	    	/*Vector <MultimediaParameter> vParameters = MultimediaParameter.getAllFromMultimedia (multimedia, connection);
	    	for (MultimediaParameter parameter : vParameters)
	    		print (parameter.getName());
	    	
	    	MultimediaParameter.removeAllFromMultimedia (multimedia, connection);*/
	    	
	    	MultimediaParameter parameter = MultimediaParameter.getMultimediaParameter (multimedia, "ratio", connection);
	    	print (parameter.getName () + "=" + parameter.getValue ());
	    	print (parameter.toJSONObject());
	    	
	    	print ("Ratio=" + MultimediaParameter.getMultimediaParameterValueOptional (multimedia, "ratio", connection, "1.0"));
	    	
	    	print (multimedia.getName());
	    	
    	} finally {
    		connection.close ();
    	}
    }
}
