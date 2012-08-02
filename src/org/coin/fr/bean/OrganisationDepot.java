/*
* Studio Matamore - France 2007, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBeanTimeStamped;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseRemoveException;
import org.coin.util.Outils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class OrganisationDepot extends CoinDatabaseAbstractBeanTimeStamped {

    private static final long serialVersionUID = 1L;

    protected long lIdAdresse;
    protected long lIdOrganisation;
    protected long lIdOrganisationDepotType;
    protected String sName;
    protected String sReference;
    protected String sEmail;
    protected String sPhone;
    protected String sFax;

    protected static Map<String,String>[] s_sarrLocalizationLabel;

    public OrganisationDepot() {
        init();
    }

    public OrganisationDepot(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "organisation_depot";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
        		" id_organisation_depot_type,"
                + " id_adresse,"
                + " id_organisation,"
                + " name,"
                + " date_creation,"
                + " date_modification,"
                + " reference,"
                + " email,"
                + " phone,"
                + " fax";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
		super.iAbstractBeanIdObjectType = ObjectType.ORGANISATION_DEPOT;

        super.lId = 0;
        this.lIdOrganisationDepotType = 0;
        this.lIdAdresse = 0;
        this.lIdOrganisation = 0;
        this.sName = "";
        super.tsDateCreation = null;
        super.tsDateModification = null;
        this.sReference = "";
        this.sEmail = "";
        this.sPhone = "";
        this.sFax = "";
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdOrganisationDepotType);
        ps.setLong(++i, this.lIdAdresse);
        ps.setLong(++i, this.lIdOrganisation);
        ps.setString(++i, preventStore(this.sName));
        ps.setTimestamp(++i, super.tsDateCreation);
        ps.setTimestamp(++i, super.tsDateModification);
        ps.setString(++i, preventStore(this.sReference));
        ps.setString(++i, preventStore(this.sEmail));
        ps.setString(++i, preventStore(this.sPhone));
        ps.setString(++i, preventStore(this.sFax));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdOrganisationDepotType = rs.getLong(++i);
        this.lIdAdresse = rs.getLong(++i);
        this.lIdOrganisation = rs.getLong(++i);
        this.sName = preventLoad(rs.getString(++i));
        super.tsDateCreation = rs.getTimestamp(++i);
        super.tsDateModification = rs.getTimestamp(++i);
        this.sReference = preventLoad(rs.getString(++i));
        this.sEmail = preventLoad(rs.getString(++i));
        this.sPhone = preventLoad(rs.getString(++i));
        this.sFax = preventLoad(rs.getString(++i));
    }

    public static OrganisationDepot getOrganisationDepot(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        OrganisationDepot item = new OrganisationDepot(lId);
        item.load();
        return item;
    }
    
	public static OrganisationDepot getOrganisationDepot (
			long lId, 
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		OrganisationDepot item = new OrganisationDepot (lId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load(conn);
   		return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
        	this.lIdOrganisationDepotType = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisationDepotType"));
        } catch(Exception e){}
    	try {
            this.lIdAdresse = Long.parseLong(request.getParameter(sFormPrefix + "lIdAdresse"));
        } catch(Exception e){}
        try {
            this.lIdOrganisation = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisation"));
        } catch(Exception e){}
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
        try {
            this.sReference = request.getParameter(sFormPrefix + "sReference");
        } catch(Exception e){}
        try {
            this.sEmail = request.getParameter(sFormPrefix + "sEmail");
        } catch(Exception e){}
        try {
            this.sPhone = request.getParameter(sFormPrefix + "sPhone");
        } catch(Exception e){}
        try {
            this.sFax = request.getParameter(sFormPrefix + "sFax");
        } catch(Exception e){}
    }

    public static Vector<OrganisationDepot> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepot item = new OrganisationDepot();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationDepot> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepot item = new OrganisationDepot();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY name";
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationDepot> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepot item = new OrganisationDepot();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY name";
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }
    
    public static Vector<OrganisationDepot> getAllStatic(
    		boolean bUseHttpPrevent)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepot item = new OrganisationDepot();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY name";
        item.bUseHttpPrevent=bUseHttpPrevent;
        return getAllWithSqlQuery(sSQLQuery, item);
    }
    
    public static Vector<OrganisationDepot> getAllStatic(
    		boolean bUseHttpPrevent, 
    		Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepot item = new OrganisationDepot();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY name";
        item.bUseHttpPrevent=bUseHttpPrevent;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }


    public static Vector<OrganisationDepot> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationDepot item = new OrganisationDepot();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }
    
	public static Vector<OrganisationDepot> getAllFromIdOrganisation(long iIdOrganisation) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Long(iIdOrganisation));
		String sWhereClause = " WHERE id_organisation=?";
		return getAllWithWhereClause(sWhereClause, vParams);
	}
    
	public static Vector<OrganisationDepot> getAllFromIdOrganisation(
			long iIdOrganisation,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		OrganisationDepot item = new OrganisationDepot();
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent;
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Long(iIdOrganisation));
		String sWhereClause = " WHERE id_organisation=?";
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}
	
	public static Vector<OrganisationDepot> getAllFromIdOrganisation(
			long iIdOrganisation,
			Vector<OrganisationDepot> vOrganisationDepot) 
	{
		Vector<OrganisationDepot> vFilter = new Vector<OrganisationDepot>();
		for (OrganisationDepot organisationDepot : vOrganisationDepot) {
			if(organisationDepot.getIdOrganisation() == iIdOrganisation)
			{
				vFilter.add(organisationDepot);
			}
		}
		
		return vFilter;
	}
	
	public static OrganisationDepot getOrNewOrganisationDepotFromName(
			String sName,
			Vector<OrganisationDepot> vOrganisationDepot) 
	{
		for (OrganisationDepot organisationDepot : vOrganisationDepot) {
			if(Outils.removeAllSpaces(organisationDepot.getName()).equalsIgnoreCase(Outils.removeAllSpaces(sName)))
			{
				return organisationDepot;
			}
		}
		
		return new OrganisationDepot();
	}
	
	public static Vector<OrganisationDepot> getAllWithWhereClause(
			String sWhereClause,
			Vector<Object> vParams) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		OrganisationDepot item = new OrganisationDepot();		
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", vParams);
	}
	
	public long getIdOrganisationDepotType() {return this.lIdOrganisationDepotType;}
	public void setIdOrganisationDepotType(long lIdOrganisationDepotType) {this.lIdOrganisationDepotType = lIdOrganisationDepotType;}

    public long getIdAdresse() {return this.lIdAdresse;}
    public void setIdAdresse(long lIdAdresse) {this.lIdAdresse = lIdAdresse;}

    public long getIdOrganisation() {return this.lIdOrganisation;}
    public void setIdOrganisation(long lIdOrganisation) {this.lIdOrganisation = lIdOrganisation;}

    @Override
    public String getName() {return this.sName;}
    public void setName(String sName) {this.sName = sName;}

    public String getReference() {return this.sReference;}
    public void setReference(String sReference) {this.sReference = sReference;}

    public String getEmail() {return this.sEmail;}
    public void setEmail(String sEmail) {this.sEmail = sEmail;}

    public String getPhone() {return this.sPhone;}
    public void setPhone(String sPhone) {this.sPhone = sPhone;}

    public String getFax() {return this.sFax;}
    public void setFax(String sFax) {this.sFax = sFax;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdOrganisationDepotType", this.lIdOrganisationDepotType);
        item.put("lIdAdresse", this.lIdAdresse);
        item.put("lIdOrganisation", this.lIdOrganisation);
        item.put("sName", this.sName);
        item.put("tsDateCreation", super.tsDateCreation);
        item.put("tsDateModification", super.tsDateModification);
        item.put("sReference", this.sReference);
        item.put("sEmail", this.sEmail);
        item.put("sPhone", this.sPhone);
        item.put("sFax", this.sFax);
        
        item.put("data", this.lId);
        item.put("value", this.sName);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException {
        OrganisationDepot item = getOrganisationDepot(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONArray items = new JSONArray();
        for (OrganisationDepot item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }
    
    public static JSONArray getJSONArrayFromOrganisation(long lId) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (OrganisationDepot item:getAllFromIdOrganisation(lId)) items.put(item.toJSONObject());
        return items;
    }
    
    public static JSONArray getJSONArrayFromOrganisation(long lId, Vector<OrganisationDepot> v) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        return getJSONArrayFromOrganisation(lId, v, false);
    }
    
    public static JSONArray getJSONArrayFromOrganisation(long lId, Vector<OrganisationDepot> v,boolean bAddBlankValue) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        if(bAddBlankValue){
        	JSONObject blank = new JSONObject();
        	blank.put("data", 0);
        	blank.put("value", "");
        	items.put(blank);
        }
        for (OrganisationDepot item:v){
        	if(item.getIdOrganisation()==lId)
        		items.put(item.toJSONObject());
        }
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
    	try {
    		this.lIdOrganisationDepotType = item.getLong("lIdOrganisationDepotType");
    	} catch(Exception e){}
        try {
            this.lIdAdresse = item.getLong("lIdAdresse");
        } catch(Exception e){}
        try {
            this.lIdOrganisation = item.getLong("lIdOrganisation");
        } catch(Exception e){}
        try {
            this.sName = item.getString("sName");
        } catch(Exception e){}
        try {
            this.sReference = item.getString("sReference");
        } catch(Exception e){}
        try {
            this.sEmail = item.getString("sEmail");
        } catch(Exception e){}
        try {
            this.sPhone = item.getString("sPhone");
        } catch(Exception e){}
        try {
            this.sFax = item.getString("sFax");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            OrganisationDepot item = null;
            try{
                item = OrganisationDepot.getOrganisationDepot(data.getLong("lId"));
            } catch(Exception e){
                item = new OrganisationDepot();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public void removeWithObjectAttached() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseRemoveException
	{
    	OrganisationDepotPersonnePhysique.removeFromDepot(this.lId);
    	this.remove();
	}

	public String getNameLabel() {
		return getLocalizedLabel("sName");
	}

	public String getPhoneLabel() {
		return getLocalizedLabel("sPhone");
	}

	public String getIdAdresseLabel() {
		return getLocalizedLabel("lIdAdresse");
	}
	
	public String getIdOrganisationLabel() {
		return getLocalizedLabel("lIdOrganisation");
	}
	
	public String getIdOrganisationDepotTypeLabel() {
		return getLocalizedLabel("lIdOrganisationDepotType");
	}
	
	public String getReferenceLabel() {
		return getLocalizedLabel("sReference");
	}
	
	public String getFaxLabel() {
		return getLocalizedLabel("sFax");
	}
	
	public String getEmailLabel() {
		return getLocalizedLabel("sEmail");
	}

	public String getLocalizedLabel(String sFieldName) {
		s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel);
		return s_sarrLocalizationLabel[this.iAbstractBeanIdLanguage].get(sFieldName);
	}
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel, true);
	}
	
}

