
/*
* MT SOFTWARE - France 2009, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import org.coin.db.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class DelegationObjectType extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

    protected String sName;
    protected String sDescription;

    public static Vector<DelegationObjectType> m_vDelegationObjectType = null;
    
    public static final int READ = 1;
    public static final int WRITE = 2;
    public static final int EXECUTE = 3;

    public DelegationObjectType() {
        init();
    }

    public DelegationObjectType(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "delegation_object_type";
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
        m_vDelegationObjectType = getAllStatic();
    }

    public Vector<DelegationObjectType> getItemMemory() {
        return m_vDelegationObjectType;
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

    public static DelegationObjectType getDelegationObjectType(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        DelegationObjectType item = new DelegationObjectType(lId);
        item.load();
        return item;
    }

    public static DelegationObjectType getDelegationObjectTypeMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (DelegationObjectType item : getAllStaticMemory()) {
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

    public static Vector<DelegationObjectType> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObjectType item = new DelegationObjectType();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationObjectType> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObjectType item = new DelegationObjectType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationObjectType> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObjectType item = new DelegationObjectType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<DelegationObjectType> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new DelegationObjectType());
        return m_vDelegationObjectType;
    }

    public static Vector<DelegationObjectType> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<DelegationObjectType> vResult = new Vector<DelegationObjectType>();
        /*for (DelegationObjectType item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<DelegationObjectType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObjectType item = new DelegationObjectType();
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
        DelegationObjectType item = getDelegationObjectTypeMemory(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (DelegationObjectType item:getAllStaticMemory()) items.put(item.toJSONObject());
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
            DelegationObjectType item = null;
            try{
                item = DelegationObjectType.getDelegationObjectTypeMemory(data.getLong("lId"));
            } catch(Exception e){
                item = new DelegationObjectType();
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
