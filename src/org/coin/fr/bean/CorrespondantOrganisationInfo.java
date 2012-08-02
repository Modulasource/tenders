
/*
* Studio Matamore - France 2007, tous droits réservés
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

public class CorrespondantOrganisationInfo extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdAdresse;
    protected long lIdCorrespondantOrganisation;
    protected String sNom;
    protected String sTelephone;
    protected String sPoste;
    protected String sFax;
    protected String sSiteWeb;
    protected String sEmail;

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdAdresse);
        ps.setLong(++i, this.lIdCorrespondantOrganisation);
        ps.setString(++i, preventStore(this.sNom));
        ps.setString(++i,preventStore( this.sTelephone));
        ps.setString(++i, preventStore(this.sPoste));
        ps.setString(++i, preventStore(this.sFax));
        ps.setString(++i, preventStore(this.sSiteWeb));
        ps.setString(++i, preventStore(this.sEmail));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdAdresse = rs.getLong(++i);
        this.lIdCorrespondantOrganisation = rs.getLong(++i);
        this.sNom = preventLoad(rs.getString(++i));
        this.sTelephone = preventLoad(rs.getString(++i));
        this.sPoste = preventLoad(rs.getString(++i));
        this.sFax = preventLoad(rs.getString(++i));
        this.sSiteWeb = preventLoad(rs.getString(++i));
        this.sEmail = preventLoad(rs.getString(++i));
    }

    public CorrespondantOrganisationInfo() {
        init();
    }

    public CorrespondantOrganisationInfo(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "correspondant_organisation_info";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_adresse,"
                + " id_correspondant_organisation,"
                + " nom,"
                + " telephone,"
                + " poste,"
                + " fax,"
                + " site_web,"
                + " email";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdAdresse = 0;
        this.lIdCorrespondantOrganisation = 0;
        this.sNom = "";
        this.sTelephone = "";
        this.sPoste = "";
        this.sFax = "";
        this.sSiteWeb = "";
        this.sEmail = "";
    }

    public static CorrespondantOrganisationInfo getCorrespondantOrganisationInfo(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException 
    {
        CorrespondantOrganisationInfo item = new CorrespondantOrganisationInfo(lId);
        item.load();
        return item;
    }

    
    public static CorrespondantOrganisationInfo getOrNewCorrespondantOrganisationInfoFromIdCorrespondantOrganisation(
    		long lIdCorrespondantOrganisation,
    		boolean bCreateItem)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, 
    IllegalAccessException, CoinDatabaseCreateException, CoinDatabaseDuplicateException 
    {
    	CorrespondantOrganisationInfo co = null;
    	try {
    		co = CorrespondantOrganisationInfo
    			.getCorrespondantOrganisationInfoFromIdCorrespondantOrganisation(lIdCorrespondantOrganisation);
    	} catch (CoinDatabaseLoadException e) {
    		co = new CorrespondantOrganisationInfo();
    		co.setIdCorrespondantOrganisation(lIdCorrespondantOrganisation);
    		if(bCreateItem) co.create();
    	}
		return co;
    }
    
    public static CorrespondantOrganisationInfo getOrNewCorrespondantOrganisationInfoFromIdCorrespondantOrganisation(
    		long lIdCorrespondantOrganisation,
    		boolean bCreateItem,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, 
    IllegalAccessException, CoinDatabaseCreateException, CoinDatabaseDuplicateException 
    {
    	CorrespondantOrganisationInfo co = null;
    	try {
    		co = CorrespondantOrganisationInfo
    			.getCorrespondantOrganisationInfoFromIdCorrespondantOrganisation(
    					lIdCorrespondantOrganisation,
    					bUseHttpPrevent,
    					conn);
    	} catch (CoinDatabaseLoadException e) {
    		co = new CorrespondantOrganisationInfo();
    		co.setIdCorrespondantOrganisation(lIdCorrespondantOrganisation);
    		co.bUseHttpPrevent = bUseHttpPrevent;
    		if(bCreateItem) co.create(conn);
    	}
		return co;
    }
    
    
    public static CorrespondantOrganisationInfo getCorrespondantOrganisationInfoFromIdCorrespondantOrganisation(long lIdCorrespondantOrganisation)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException 
    {
        CorrespondantOrganisationInfo item = new CorrespondantOrganisationInfo();
        return (CorrespondantOrganisationInfo) item.getAbstractBeanWithWhereAndOrderByClause(
        		" WHERE id_correspondant_organisation=" + lIdCorrespondantOrganisation, "");
    }
    
    public static CorrespondantOrganisationInfo getCorrespondantOrganisationInfoFromIdCorrespondantOrganisation(
    		long lIdCorrespondantOrganisation,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException 
    {
        CorrespondantOrganisationInfo item = new CorrespondantOrganisationInfo();
        item.bUseEmbeddedConnection = true;
        item.connEmbeddedConnection = conn;
        item.bUseHttpPrevent = bUseHttpPrevent;
        
        
        return (CorrespondantOrganisationInfo) item.getAbstractBeanWithWhereAndOrderByClause(
        		" WHERE id_correspondant_organisation=" + lIdCorrespondantOrganisation, "");
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdAdresse = Long.parseLong(request.getParameter(sFormPrefix + "lIdAdresse"));
        } catch(Exception e){}
        try {
            this.lIdCorrespondantOrganisation = Long.parseLong(request.getParameter(sFormPrefix + "lIdCorrespondantOrganisation"));
        } catch(Exception e){}
        try {
            this.sNom = request.getParameter(sFormPrefix + "sNom");
        } catch(Exception e){}
        try {
            this.sTelephone = request.getParameter(sFormPrefix + "sTelephone");
        } catch(Exception e){}
        try {
            this.sPoste = request.getParameter(sFormPrefix + "sPoste");
        } catch(Exception e){}
        try {
            this.sFax = request.getParameter(sFormPrefix + "sFax");
        } catch(Exception e){}
        try {
            this.sSiteWeb = request.getParameter(sFormPrefix + "sSiteWeb");
        } catch(Exception e){}
        try {
            this.sEmail = request.getParameter(sFormPrefix + "sEmail");
        } catch(Exception e){}
    }

    public static Vector<CorrespondantOrganisationInfo> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisationInfo item = new CorrespondantOrganisationInfo();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CorrespondantOrganisationInfo> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisationInfo item = new CorrespondantOrganisationInfo();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CorrespondantOrganisationInfo> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisationInfo item = new CorrespondantOrganisationInfo();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    @SuppressWarnings("unchecked")
    public static Vector<CorrespondantOrganisationInfo> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisationInfo item = new CorrespondantOrganisationInfo();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
    }

    @Override
    public String getName() {
        return "correspondant_organisation_info_"+this.lId;
    }

    public long getIdAdresse() {return this.lIdAdresse;}
    public void setIdAdresse(long lIdAdresse) {this.lIdAdresse = lIdAdresse;}

    public long getIdCorrespondantOrganisation() {return this.lIdCorrespondantOrganisation;}
    public void setIdCorrespondantOrganisation(long lIdCorrespondantOrganisation) {this.lIdCorrespondantOrganisation = lIdCorrespondantOrganisation;}

    public String getNom() {return this.sNom;}
    public void setNom(String sNom) {this.sNom = sNom;}

    public String getTelephone() {return this.sTelephone;}
    public void setTelephone(String sTelephone) {this.sTelephone = sTelephone;}

    public String getPoste() {return this.sPoste;}
    public void setPoste(String sPoste) {this.sPoste = sPoste;}

    public String getFax() {return this.sFax;}
    public void setFax(String sFax) {this.sFax = sFax;}

    public String getSiteWeb() {return this.sSiteWeb;}
    public void setSiteWeb(String sSiteWeb) {this.sSiteWeb = sSiteWeb;}

    public String getEmail() {return this.sEmail;}
    public void setEmail(String sEmail) {this.sEmail = sEmail;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdAdresse", this.lIdAdresse);
        item.put("lIdCorrespondantOrganisation", this.lIdCorrespondantOrganisation);
        item.put("sNom", this.sNom);
        item.put("sTelephone", this.sTelephone);
        item.put("sPoste", this.sPoste);
        item.put("sFax", this.sFax);
        item.put("sSiteWeb", this.sSiteWeb);
        item.put("sEmail", this.sEmail);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws Exception {
        CorrespondantOrganisationInfo item = getCorrespondantOrganisationInfo(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws Exception {
        JSONArray items = new JSONArray();
        for (CorrespondantOrganisationInfo item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) throws Exception {
        try {
            this.lIdAdresse = item.getLong("lIdAdresse");
        } catch(Exception e){}
        try {
            this.lIdCorrespondantOrganisation = item.getLong("lIdCorrespondantOrganisation");
        } catch(Exception e){}
        try {
            this.sNom = item.getString("sNom");
        } catch(Exception e){}
        try {
            this.sTelephone = item.getString("sTelephone");
        } catch(Exception e){}
        try {
            this.sPoste = item.getString("sPoste");
        } catch(Exception e){}
        try {
            this.sFax = item.getString("sFax");
        } catch(Exception e){}
        try {
            this.sSiteWeb = item.getString("sSiteWeb");
        } catch(Exception e){}
        try {
            this.sEmail = item.getString("sEmail");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws Exception {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) throws Exception {
        try {
            CorrespondantOrganisationInfo item = null;
            try{
                item = CorrespondantOrganisationInfo.getCorrespondantOrganisationInfo(data.getLong("lId"));
            } catch(Exception e){
                item = new CorrespondantOrganisationInfo();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }

}
