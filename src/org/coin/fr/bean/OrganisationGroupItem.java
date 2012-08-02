
/*
* Studio Matamore - France 2007, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBeanTimeStamped;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@RemoteProxy
public class OrganisationGroupItem extends CoinDatabaseAbstractBeanTimeStamped {

    private static final long serialVersionUID = 1L;

    protected long lIdOrganisation;
    protected long lIdOrganisationGroup;

    public OrganisationGroupItem() {
        init();
    }

    public OrganisationGroupItem(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "organisation_group_item";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_organisation,"
                + " id_organisation_group,"
                + " date_creation,"
                + " date_modification";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdOrganisation = 0;
        this.lIdOrganisationGroup = 0;
        super.tsDateCreation = null;
        super.tsDateModification = null;
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdOrganisation);
        ps.setLong(++i, this.lIdOrganisationGroup);
        ps.setTimestamp(++i, super.tsDateCreation);
        ps.setTimestamp(++i, super.tsDateModification);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdOrganisation = rs.getLong(++i);
        this.lIdOrganisationGroup = rs.getLong(++i);
        super.tsDateCreation = rs.getTimestamp(++i);
        super.tsDateModification = rs.getTimestamp(++i);
    }

    public static OrganisationGroupItem getOrganisationGroupItem(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        OrganisationGroupItem item = new OrganisationGroupItem(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdOrganisation = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisation"));
        } catch(Exception e){}
        try {
            this.lIdOrganisationGroup = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisationGroup"));
        } catch(Exception e){}
    }

 
    public static Vector<OrganisationGroupItem> getAllFromIdOrganisationGroup(
    		long lIdOrganisationGroup)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationGroupItem item = new OrganisationGroupItem();
        Vector<Object> vParams = new  Vector<Object>();
        vParams.add(new Long(lIdOrganisationGroup));
        return item.getAllWithWhereAndOrderByClause(" WHERE id_organisation_group=? ", "", vParams);
    }
    
    public static Vector<OrganisationGroupItem> getAllFromIdOrganisationAndGroup(
    		long lIdOrganisation,
    		long lIdOrganisationGroup)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationGroupItem item = new OrganisationGroupItem();
        Vector<Object> vParams = new  Vector<Object>();
        vParams.add(new Long(lIdOrganisation));
        vParams.add(new Long(lIdOrganisationGroup));
        return item.getAllWithWhereAndOrderByClause(" WHERE id_organisation=? AND id_organisation_group=? ", "", vParams);
    }
    
    
    public static Vector<OrganisationGroupItem> getAllFromIdOrganisationAndGroup(
    		long lIdOrganisation,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationGroupItem item = new OrganisationGroupItem();
        Vector<Object> vParams = new  Vector<Object>();
        vParams.add(new Long(lIdOrganisation));
        item.bUseHttpPrevent = bUseHttpPrevent;
        item.bUseEmbeddedConnection = true;
        item.connEmbeddedConnection = conn;
        return item.getAllWithWhereAndOrderByClause(" WHERE id_organisation=? ", "", vParams);
    }
    

    @Override
    public String getName() {
        try {
			return OrganisationGroup.getOrganisationGroup(this.lIdOrganisationGroup).getName();
		} catch (Exception e) {
			return "";
		}
    }

    public long getIdOrganisation() {return this.lIdOrganisation;}
    public void setIdOrganisation(long lIdOrganisation) {this.lIdOrganisation = lIdOrganisation;}

    public long getIdOrganisationGroup() {return this.lIdOrganisationGroup;}
    public void setIdOrganisationGroup(long lIdOrganisationGroup) {this.lIdOrganisationGroup = lIdOrganisationGroup;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdOrganisation", this.lIdOrganisation);
        item.put("lIdOrganisationGroup", this.lIdOrganisationGroup);
        item.put("tsDateCreation", super.tsDateCreation);
        item.put("tsDateModification", super.tsDateModification);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException {
        OrganisationGroupItem item = getOrganisationGroupItem(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONArray items = new JSONArray();
        Vector<OrganisationGroupItem> v = new OrganisationGroupItem().getAll();
        for (OrganisationGroupItem item: v ) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdOrganisation = item.getLong("lIdOrganisation");
        } catch(Exception e){}
        try {
            this.lIdOrganisationGroup = item.getLong("lIdOrganisationGroup");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            OrganisationGroupItem item = null;
            try{
                item = OrganisationGroupItem.getOrganisationGroupItem(data.getLong("lId"));
            } catch(Exception e){
                item = new OrganisationGroupItem();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public static void createFromCountryAndType(long lIdOrganisationGroup, int iIdOrganisationType) throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException, CoinDatabaseCreateException, CoinDatabaseDuplicateException{
    	OrganisationGroup group = OrganisationGroup.getOrganisationGroup(lIdOrganisationGroup);
    	Vector<OrganisationGroupItem> vItems = OrganisationGroupItem.getAllFromIdOrganisationGroup(lIdOrganisationGroup);
    	Vector<Organisation> vBusinessUnit = Organisation.getAllOrganisationFromTypeAndCountry(iIdOrganisationType,group.getIdPays());
    	
    	
    	for(Organisation bu : vBusinessUnit){
    		boolean bExist = false;
    		for(OrganisationGroupItem item : vItems){
    			if(item.getIdOrganisation() == bu.getId()){
    				bExist = true;
    				break;
    			}
    		}
    		if(!bExist){
    			OrganisationGroupItem newItem = new OrganisationGroupItem();
    			newItem.setIdOrganisation(bu.getId());
    			newItem.setIdOrganisationGroup(lIdOrganisationGroup);
    			newItem.create();
    		}
    	}
    }
    
    @RemoteMethod
    public static void notExistItem(long lIdOrganisation,long lIdOrganisationGroup) throws Exception{
    	Vector<OrganisationGroupItem> vItem = getAllFromIdOrganisationAndGroup(lIdOrganisation,lIdOrganisationGroup);
    	if(vItem.size()>0)
    		throw new Exception("this business unit already associated");
    }
    
    public static void removeAllFromOrganisation(long lIdOrganisation) throws SQLException, NamingException{
    	Connection conn = ConnectionManager.getConnection();
    	try {
    		removeAllFromOrganisation(lIdOrganisation, conn);
    	} finally {
    		ConnectionManager.closeConnection(conn);
    	}
    }
    public static void removeAllFromOrganisation(long lIdOrganisation,Connection conn) throws SQLException, NamingException{
    	new OrganisationGroupItem().remove(" WHERE id_organisation =  "+lIdOrganisation,conn);
    }

	public static Vector<OrganisationGroupItem> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		OrganisationGroupItem item = new OrganisationGroupItem();		
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}
}
