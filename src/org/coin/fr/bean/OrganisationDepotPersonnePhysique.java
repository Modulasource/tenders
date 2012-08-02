/*
* Studio Matamore - France 2007, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import org.coin.db.*;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

@RemoteProxy
public class OrganisationDepotPersonnePhysique extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdPersonnePhysique;
    protected long lIdOrganisationDepot;

    public OrganisationDepotPersonnePhysique() {
        init();
    }

    public OrganisationDepotPersonnePhysique(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "organisation_depot_personne_physique";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_personne_physique,"
                + " id_organisation_depot";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdPersonnePhysique = 0;
        this.lIdOrganisationDepot = 0;
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdPersonnePhysique);
        ps.setLong(++i, this.lIdOrganisationDepot);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdPersonnePhysique = rs.getLong(++i);
        this.lIdOrganisationDepot = rs.getLong(++i);
    }

    public static OrganisationDepotPersonnePhysique getOrganisationDepotPersonnePhysique(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdPersonnePhysique = Long.parseLong(request.getParameter(sFormPrefix + "lIdPersonnePhysique"));
        } catch(Exception e){}
        try {
            this.lIdOrganisationDepot = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisationDepot"));
        } catch(Exception e){}
    }

    public static Vector<OrganisationDepotPersonnePhysique> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique();
        return getAllWithSqlQuery(sSQLQuery, item);
    }
    
	public static Vector<OrganisationDepotPersonnePhysique> getAllFromDepot(long iIdOrganisationDepot) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Long(iIdOrganisationDepot));
		String sWhereClause = " WHERE id_organisation_depot=?";
		return getAllWithWhereClause(sWhereClause, vParams);
	}

	public static Vector<OrganisationDepotPersonnePhysique> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique();		
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}
	
    public static Vector<OrganisationDepotPersonnePhysique> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationDepotPersonnePhysique> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<OrganisationDepotPersonnePhysique> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
        return "organisation_depot_personne_physique_"+this.lId;
    }

    public long getIdPersonnePhysique() {return this.lIdPersonnePhysique;}
    public void setIdPersonnePhysique(long lIdPersonnePhysique) {this.lIdPersonnePhysique = lIdPersonnePhysique;}

    public long getIdOrganisationDepot() {return this.lIdOrganisationDepot;}
    public void setIdOrganisationDepot(long lIdOrganisationDepot) {this.lIdOrganisationDepot = lIdOrganisationDepot;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdPersonnePhysique", this.lIdPersonnePhysique);
        item.put("lIdOrganisationDepot", this.lIdOrganisationDepot);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException {
        OrganisationDepotPersonnePhysique item = getOrganisationDepotPersonnePhysique(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONArray items = new JSONArray();
        for (OrganisationDepotPersonnePhysique item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdPersonnePhysique = item.getLong("lIdPersonnePhysique");
        } catch(Exception e){}
        try {
            this.lIdOrganisationDepot = item.getLong("lIdOrganisationDepot");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            OrganisationDepotPersonnePhysique item = null;
            try{
                item = OrganisationDepotPersonnePhysique.getOrganisationDepotPersonnePhysique(data.getLong("lId"));
            } catch(Exception e){
                item = new OrganisationDepotPersonnePhysique();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public static Vector<OrganisationDepotPersonnePhysique> getAllFromIdPersonnePhysiqueAndDepot(
    		long lIdPP,
    		long lIdOrganisationDepot)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique();
        Vector<Object> vParams = new  Vector<Object>();
        vParams.add(new Long(lIdPP));
        vParams.add(new Long(lIdOrganisationDepot));
        return item.getAllWithWhereAndOrderByClause(" WHERE id_personne_physique=? AND id_organisation_depot=? ", "", vParams);
    }
    
    @RemoteMethod
    public static void notExistItem(long lIdPP,long lIdOrganisationDepot) throws Exception{
    	Vector<OrganisationDepotPersonnePhysique> vItem = getAllFromIdPersonnePhysiqueAndDepot(lIdPP,lIdOrganisationDepot);
    	if(vItem.size()>0)
    		throw new Exception("this person already associated");
    }
    
    public static void removeFromDepot(long lIdDepot) throws SQLException, NamingException{
    	new OrganisationDepotPersonnePhysique().remove(" WHERE id_organisation_depot="+lIdDepot);
    }
}

