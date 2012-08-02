package org.coin.bean;


/*
* Studio Matamore - France 2009, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

import org.coin.db.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class CoinUserAccessModuleType extends CoinDatabaseAbstractBeanMemory {

	public static final int TYPE_MODULA = 1;
	public static final int TYPE_LDAP = 2;
	public static final int TYPE_CERTIFICATE = 3;
	
    private static final long serialVersionUID = 1L;

    protected String sName;
    protected String sDescription;

    public static Vector<CoinUserAccessModuleType> m_vCoinUserAccessModuleType = null;

    public CoinUserAccessModuleType() {
        init();
    }

    public CoinUserAccessModuleType(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "coin_user_access_module_type";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " name,"
                + " description";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.sName = "";
        this.sDescription = "";

    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vCoinUserAccessModuleType = getAllStatic();
    }

    public Vector<CoinUserAccessModuleType> getItemMemory() {
        return m_vCoinUserAccessModuleType;
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory();
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, preventStore(this.sName));
        ps.setString(++i, preventStore(this.sDescription));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sName = preventLoad(rs.getString(++i));
        this.sDescription = preventLoad(rs.getString(++i));
    }

    public static CoinUserAccessModuleType getCoinUserAccessModuleType(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        CoinUserAccessModuleType item = new CoinUserAccessModuleType(lId);
        item.load();
        return item;
    }

    public static CoinUserAccessModuleType getCoinUserAccessModuleTypeMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (CoinUserAccessModuleType item : getAllStaticMemory()) {
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

    public static Vector<CoinUserAccessModuleType> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserAccessModuleType item = new CoinUserAccessModuleType();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CoinUserAccessModuleType> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserAccessModuleType item = new CoinUserAccessModuleType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CoinUserAccessModuleType> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserAccessModuleType item = new CoinUserAccessModuleType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<CoinUserAccessModuleType> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new CoinUserAccessModuleType());
        return m_vCoinUserAccessModuleType;
    }

    public static Vector<CoinUserAccessModuleType> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<CoinUserAccessModuleType> vResult = new Vector<CoinUserAccessModuleType>();
        /*for (CoinUserAccessModuleType item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<CoinUserAccessModuleType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserAccessModuleType item = new CoinUserAccessModuleType();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {return this.sName;}
    public void setName(String sName) {this.sName = sName;}

    public String getDescription() {return this.sDescription;}
    public void setDescription(String sDescription) {this.sDescription = sDescription;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("sName", this.sName);
        item.put("sDescription", this.sDescription);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        CoinUserAccessModuleType item = getCoinUserAccessModuleType(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (CoinUserAccessModuleType item:getAllStatic()) items.put(item.toJSONObject());
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

    public static long storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static long storeFromJSONObject(JSONObject data) {
        try {
            CoinUserAccessModuleType item = null;
            try{
                item = CoinUserAccessModuleType.getCoinUserAccessModuleType(data.getLong("lId"));
            } catch(Exception e){
                item = new CoinUserAccessModuleType();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return item.getId();
        } catch(Exception e){
            return 0;
        }
    }

}

