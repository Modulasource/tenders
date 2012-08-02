package org.coin.fr.bean;
	
/*
* Mt Software - France 2010, tous droits réservés
* Contact : contact@mtsoftware.fr - http://www.mtsoftware.fr
*/


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.UserHabilitation;
import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class OrganisationDepotType extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

    protected String sName;
    protected String sDescription;
    
    public final static int TYPE_BUS = 1;
    public final static int TYPE_TRAIN = 2;

    public static Vector<OrganisationDepotType> m_vOrganisationDepotType = null;

    public OrganisationDepotType() {
        init();
    }

    public OrganisationDepotType(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "organisation_depot_type";
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
        m_vOrganisationDepotType = getAllStatic();
    }

    public Vector<OrganisationDepotType> getItemMemory() {
        return m_vOrganisationDepotType;
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

    public static OrganisationDepotType getOrganisationDepotType(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        OrganisationDepotType item = new OrganisationDepotType(lId);
        item.load();
        return item;
    }

    public static OrganisationDepotType getOrganisationDepotTypeMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (OrganisationDepotType item : getAllStaticMemory()) {
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

    public static Vector<OrganisationDepotType> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotType item = new OrganisationDepotType();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationDepotType> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotType item = new OrganisationDepotType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationDepotType> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotType item = new OrganisationDepotType();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<OrganisationDepotType> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new OrganisationDepotType());
        return m_vOrganisationDepotType;
    }

    public static Vector<OrganisationDepotType> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<OrganisationDepotType> vResult = new Vector<OrganisationDepotType>();
        /*for (OrganisationDepotType item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<OrganisationDepotType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotType item = new OrganisationDepotType();
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
        OrganisationDepotType item = getOrganisationDepotType(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (OrganisationDepotType item:getAllStaticMemory()) items.put(item.toJSONObject());
        return items;
    }
    
    public static JSONArray getJSONArrayHabilitate(
    		UserHabilitation sessionUserHabilitation) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, JSONException{
    	JSONArray items = new JSONArray();
    	for (OrganisationDepotType item:getAllStaticMemory()){
    		if(sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-TYPE-"+item.getId())){
    			items.put(item.toJSONObject());
    		}
    	}
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
            OrganisationDepotType item = null;
            try{
                item = OrganisationDepotType.getOrganisationDepotType(data.getLong("lId"));
            } catch(Exception e){
                item = new OrganisationDepotType();
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
	
		
