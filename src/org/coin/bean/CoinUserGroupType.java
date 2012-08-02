
/*
* Studio Matamore - France 2009, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.bean;

import org.coin.db.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class CoinUserGroupType extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

	public static final int TYPE_HABILITATE = 1;
	public static final int TYPE_MANAGEABLE = 2;
	
    protected String sName;
    protected String sDescription;

    public static Vector<CoinUserGroupType> m_vCoinUserGroupType = null;

    public CoinUserGroupType() {
        init();
    }

    public CoinUserGroupType(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "coin_user_group_type";
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
        m_vCoinUserGroupType = getAllStatic();
    }

    public Vector<CoinUserGroupType> getItemMemory() {
        return m_vCoinUserGroupType;
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

    public static CoinUserGroupType getCoinUserGroupType(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        CoinUserGroupType item = new CoinUserGroupType(lId);
        item.load();
        return item;
    }

    public static CoinUserGroupType getCoinUserGroupTypeMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (CoinUserGroupType item : getAllStaticMemory()) {
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

    public static Vector<CoinUserGroupType> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserGroupType item = new CoinUserGroupType();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CoinUserGroupType> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserGroupType item = new CoinUserGroupType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CoinUserGroupType> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserGroupType item = new CoinUserGroupType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<CoinUserGroupType> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new CoinUserGroupType());
        return m_vCoinUserGroupType;
    }

    public static Vector<CoinUserGroupType> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<CoinUserGroupType> vResult = new Vector<CoinUserGroupType>();
        /*for (CoinUserGroupType item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<CoinUserGroupType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CoinUserGroupType item = new CoinUserGroupType();
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
        CoinUserGroupType item = getCoinUserGroupType(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (CoinUserGroupType item:getAllStatic()) items.put(item.toJSONObject());
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
            CoinUserGroupType item = null;
            try{
                item = CoinUserGroupType.getCoinUserGroupType(data.getLong("lId"));
            } catch(Exception e){
                item = new CoinUserGroupType();
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

