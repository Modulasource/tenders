
/*
* Mt Software - France 2009, tous droits réservés
* Contact : contact@mtsoftware.fr - http://www.mtsoftware.fr
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

public class DelegationObject extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdTypeObject;
    protected long lIdDelegationObjectType;
    protected long lIdDelegation;
    protected long lIdReferenceObject;

    public DelegationObject() {
        init();
    }

    public DelegationObject(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "delegation_object";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_type_object,"
                + " id_delegation_object_type,"
                + " id_delegation,"
                + " id_reference_object";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdTypeObject = 0;
        this.lIdDelegationObjectType = 0;
        this.lIdDelegation = 0;
        this.lIdReferenceObject = 0;

    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdTypeObject);
        ps.setLong(++i, this.lIdDelegationObjectType);
        ps.setLong(++i, this.lIdDelegation);
        ps.setLong(++i, this.lIdReferenceObject);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdTypeObject = rs.getLong(++i);
        this.lIdDelegationObjectType = rs.getLong(++i);
        this.lIdDelegation = rs.getLong(++i);
        this.lIdReferenceObject = rs.getLong(++i);
    }

    public static DelegationObject getDelegationObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        DelegationObject item = new DelegationObject(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdTypeObject = Long.parseLong(request.getParameter(sFormPrefix + "lIdTypeObject"));
        } catch(Exception e){}
        try {
            this.lIdDelegationObjectType = Long.parseLong(request.getParameter(sFormPrefix + "lIdDelegationObjectType"));
        } catch(Exception e){}
        try {
            this.lIdDelegation = Long.parseLong(request.getParameter(sFormPrefix + "lIdDelegation"));
        } catch(Exception e){}
        try {
            this.lIdReferenceObject = Long.parseLong(request.getParameter(sFormPrefix + "lIdReferenceObject"));
        } catch(Exception e){}
    }

    public static Vector<DelegationObject> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObject item = new DelegationObject();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationObject> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObject item = new DelegationObject();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<DelegationObject> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObject item = new DelegationObject();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }
    
    public static Vector<DelegationObject> getAllFromDelegation(long lIdDelegation,boolean bUseHttpPrevent, Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObject item = new DelegationObject();
        item.bUseHttpPrevent = bUseHttpPrevent;
        item.setAbstractBeanConnexion(conn);
        Vector<Object> vParams = new Vector<Object>();
        vParams.add(new Long(lIdDelegation));
        return item.getAllWithWhereAndOrderByClause("", "WHERE id_delegation=?", "", vParams);
    }
    
    public static int countDelegationObjectByDelegateOwner(long lIdDelegation
    		, int lIdTypeObjet
    		, long lIdReferenceObject) 
    throws InstantiationException, IllegalAccessException, NamingException, 
    SQLException{    
    	
    	return getDelegationObjectByDelegateOwner(lIdDelegation
    			, lIdTypeObjet
    			, lIdReferenceObject).size();
    }    
    
    public static Vector<DelegationObject> getDelegationObjectByDelegateOwner(long lIdDelegation
    		, int iIdObjetType
    		, long lIdReferenceObject) 
    throws InstantiationException, IllegalAccessException, NamingException, 
    SQLException{
    	
    	/**
    	 * TODO see also,
    	 * id_delegation_type : "Pour ordre", "Lecture", "Pour approbation" ???  
    	 */    	 
    	return getAllWithWhereAndOrderByClauseStatic(" WHERE id_delegation = "+lIdDelegation
    			+" AND id_type_object = "+iIdObjetType
    			+" AND id_reference_object = "+lIdReferenceObject
    			,"");
    }


    public static Vector<DelegationObject> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        DelegationObject item = new DelegationObject();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
        return "delegation_object_"+this.lId;
    }

    public long getIdTypeObject() {return this.lIdTypeObject;}
    public void setIdTypeObject(long lIdTypeObject) {this.lIdTypeObject = lIdTypeObject;}

    public long getIdDelegationObjectType() {return this.lIdDelegationObjectType;}
    public void setIdDelegationObjectType(long lIdDelegationObjectType) {this.lIdDelegationObjectType = lIdDelegationObjectType;}

    public long getIdDelegation() {return this.lIdDelegation;}
    public void setIdDelegation(long lIdDelegation) {this.lIdDelegation = lIdDelegation;}

    public long getIdReferenceObject() {return this.lIdReferenceObject;}
    public void setIdReferenceObject(long lIdReferenceObject) {this.lIdReferenceObject = lIdReferenceObject;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdTypeObject", this.lIdTypeObject);
        item.put("lIdDelegationObjectType", this.lIdDelegationObjectType);
        item.put("lIdDelegation", this.lIdDelegation);
        item.put("lIdReferenceObject", this.lIdReferenceObject);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        DelegationObject item = getDelegationObject(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (DelegationObject item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdTypeObject = item.getLong("lIdTypeObject");
        } catch(Exception e){}
        try {
            this.lIdDelegationObjectType = item.getLong("lIdDelegationObjectType");
        } catch(Exception e){}
        try {
            this.lIdDelegation = item.getLong("lIdDelegation");
        } catch(Exception e){}
        try {
            this.lIdReferenceObject = item.getLong("lIdReferenceObject");
        } catch(Exception e){}
    }

    public static long storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static long storeFromJSONObject(JSONObject data) {
        try {
            DelegationObject item = null;
            try{
                item = DelegationObject.getDelegationObject(data.getLong("lId"));
            } catch(Exception e){
                item = new DelegationObject();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return item.getId();
        } catch(Exception e){
            return 0;
        }
    }
    
    public static void removeAllFromDelegation(long lIdDelegation,Connection conn) throws SQLException, NamingException{
    	new DelegationObject().remove(" WHERE id_delegation =  "+lIdDelegation,conn);
    }

}
