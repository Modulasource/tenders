package org.coin.fr.bean;

import org.coin.bean.ObjectType;
import org.coin.db.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class OrganisationServiceState extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;
    
    public static final int TYPE_ACTIVE = 1;
    public static final int TYPE_ARCHIVED = 2;

    protected String sName;
    
    protected static String[][] s_sarrLocalization;

    public OrganisationServiceState() {
        init();
    }

    public OrganisationServiceState(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "organisation_service_state";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " name";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
        this.iAbstractBeanIdObjectType = ObjectType.ORGANISATION_SERVICE_STATE;
        super.lId = 0;
        this.sName = "";

    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, preventStore(this.sName));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sName = preventLoad(rs.getString(++i));
    }

    public static OrganisationServiceState getOrganisationServiceState(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        OrganisationServiceState item = new OrganisationServiceState(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
    }

    public static Vector<OrganisationServiceState> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationServiceState item = new OrganisationServiceState();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationServiceState> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationServiceState item = new OrganisationServiceState();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationServiceState> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationServiceState item = new OrganisationServiceState();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<OrganisationServiceState> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationServiceState item = new OrganisationServiceState();
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
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        OrganisationServiceState item = getOrganisationServiceState(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (OrganisationServiceState item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }
    
    public static JSONArray getJSONArray(long lIdLanguage) 
    throws Exception {
     JSONArray items = new JSONArray();
     for (OrganisationServiceState item:getAllStatic()) {
       item.setAbstractBeanLocalization(lIdLanguage);
       items.put(item.toJSONObject());
     }
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
            OrganisationServiceState item = null;
            try{
                item = OrganisationServiceState.getOrganisationServiceState(data.getLong("lId"));
            } catch(Exception e){
                item = new OrganisationServiceState();
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
