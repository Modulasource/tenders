/*
* Mt Software - France 2010, tous droits réservés
* Contact : contact@mtsoftware.fr - http://www.mtsoftware.fr
*/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CodeNafEtat extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

    protected String sName;

    public static Vector<CodeNafEtat> m_vCodeNafEtat = null;
    
    public static int VALIDE=1;
    public static int OBSOLETE=2;

    public CodeNafEtat() {
        init();
    }

    public CodeNafEtat(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "code_naf_etat";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " name";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.sName = "";

    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vCodeNafEtat = getAllStatic();
    }

    public Vector<CodeNafEtat> getItemMemory() {
        return m_vCodeNafEtat;
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory();
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, preventStore(this.sName));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sName = preventLoad(rs.getString(++i));
    }

    public static CodeNafEtat getCodeNafEtat(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        CodeNafEtat item = new CodeNafEtat(lId);
        item.load();
        return item;
    }

    public static CodeNafEtat getCodeNafEtatMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (CodeNafEtat item : getAllStaticMemory()) {
            if (item.getId()==lId) return item;
        }
        throw new CoinDatabaseLoadException("" + lId, "static");
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
    }

    public static Vector<CodeNafEtat> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CodeNafEtat item = new CodeNafEtat();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CodeNafEtat> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CodeNafEtat item = new CodeNafEtat();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CodeNafEtat> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CodeNafEtat item = new CodeNafEtat();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<CodeNafEtat> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new CodeNafEtat());
        return m_vCodeNafEtat;
    }

    public static Vector<CodeNafEtat> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<CodeNafEtat> vResult = new Vector<CodeNafEtat>();
        /*for (CodeNafEtat item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<CodeNafEtat> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CodeNafEtat item = new CodeNafEtat();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {return this.sName;}
    public void setName(String sName) {this.sName = sName;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("sName", this.sName);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        CodeNafEtat item = getCodeNafEtat(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (CodeNafEtat item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.sName = item.getString("sName");
        } catch(Exception e){}
    }

    public static long storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static long storeFromJSONObject(JSONObject data) {
        try {
            CodeNafEtat item = null;
            try{
                item = CodeNafEtat.getCodeNafEtat(data.getLong("lId"));
            } catch(Exception e){
                item = new CodeNafEtat();
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
