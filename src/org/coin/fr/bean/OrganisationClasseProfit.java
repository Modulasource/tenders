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

public class OrganisationClasseProfit extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

    public static int ORG_CP_DEBITEUR_PRIVE_PHYS = 1;
    public static int ORG_CP_DEBITEUR_ETRANGER = 2;
    public static int ORG_CP_DEBITEUR_PRIVE_MORALE = 3;
    public static int ORG_CP_ETAT = 4;
    public static int ORG_CP_REGION = 5;
    public static int ORG_CP_DEPARTEMENT = 6;
    public static int ORG_CP_GPT_COLLECTIVITES = 7;
    public static int ORG_CP_COMMUNE = 8;
    public static int ORG_CP_AUTRES_ORG_PUBLICS = 9;
    public static int ORG_CP_ETAB_PUBLIC_SANTE = 10;
    
    protected String sLibelle;
    protected String sReferenceBoamp;

    public static Vector<OrganisationClasseProfit> m_vOrganisationClasseProfit = null;

    public OrganisationClasseProfit() {
        init();
    }

    public OrganisationClasseProfit(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "organisation_classe_profit";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " libelle,"
                + " reference_boamp";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.sLibelle = "";
        this.sReferenceBoamp = "";

    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vOrganisationClasseProfit = getAllStatic();
    }

    public Vector<OrganisationClasseProfit> getItemMemory() {
        return m_vOrganisationClasseProfit;
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory();
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, preventStore(this.sLibelle));
        ps.setString(++i, preventStore(this.sReferenceBoamp));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sLibelle = preventLoad(rs.getString(++i));
        this.sReferenceBoamp = preventLoad(rs.getString(++i));
    }

    public static OrganisationClasseProfit getOrganisationClasseProfit(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
        OrganisationClasseProfit item = new OrganisationClasseProfit(lId);
        item.load();
        return item;
    }

    public static OrganisationClasseProfit getOrganisationClasseProfitMemory(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (OrganisationClasseProfit item : getAllStaticMemory()) {
            if (item.getId()==lId) return item;
        }
        throw new CoinDatabaseLoadException("" + lId, "static");
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sLibelle = request.getParameter(sFormPrefix + "sLibelle");
        } catch(Exception e){}
        try {
            this.sReferenceBoamp = request.getParameter(sFormPrefix + "sReferenceBoamp");
        } catch(Exception e){}
    }

    public static Vector<OrganisationClasseProfit> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationClasseProfit item = new OrganisationClasseProfit();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationClasseProfit> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationClasseProfit item = new OrganisationClasseProfit();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<OrganisationClasseProfit> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationClasseProfit item = new OrganisationClasseProfit();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<OrganisationClasseProfit> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(new OrganisationClasseProfit());
        return m_vOrganisationClasseProfit;
    }

    public static Vector<OrganisationClasseProfit> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<OrganisationClasseProfit> vResult = new Vector<OrganisationClasseProfit>();
        /*for (OrganisationClasseProfit item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<OrganisationClasseProfit> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        OrganisationClasseProfit item = new OrganisationClasseProfit();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(m_vOrganisationClasseProfit==null));
    		if(s == null) return this.sLibelle;
    		return s;
    	}
        return this.sLibelle;
    }

    public String getLibelle() {return this.sLibelle;}
    public void setLibelle(String sLibelle) {this.sLibelle = sLibelle;}

    public String getReferenceBoamp() {return this.sReferenceBoamp;}
    public void setReferenceBoamp(String sReferenceBoamp) {this.sReferenceBoamp = sReferenceBoamp;}

    public static String getOrganisationClasseProfitName(int iId)  {
    	OrganisationClasseProfit  ocp = new OrganisationClasseProfit(iId);
    	try {
    		ocp.load();
	    	return ocp.getLibelle();
		} catch (Exception e) {}

		return "";
    }
    
    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("sLibelle", this.sLibelle);
        item.put("sReferenceBoamp", this.sReferenceBoamp);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        OrganisationClasseProfit item = getOrganisationClasseProfit(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (OrganisationClasseProfit item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.sLibelle = item.getString("sLibelle");
        } catch(Exception e){}
        try {
            this.sReferenceBoamp = item.getString("sReferenceBoamp");
        } catch(Exception e){}
    }

    public static long storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static long storeFromJSONObject(JSONObject data) {
        try {
            OrganisationClasseProfit item = null;
            try{
                item = OrganisationClasseProfit.getOrganisationClasseProfit(data.getLong("lId"));
            } catch(Exception e){
                item = new OrganisationClasseProfit();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return item.getId();
        } catch(Exception e){
            return 0;
        }
    }
    
    
    public static String getOrgClasseProfitHTMLComboList(int iId) throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	OrganisationClasseProfit orgClasseProfit = new OrganisationClasseProfit(iId);
		return orgClasseProfit.getOrgClasseProfitHTMLComboList("iIdOrgClasseProfit",1);
	}
    
    public static String getOrgClasseProfitHTMLComboList() throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	OrganisationClasseProfit orgClasseProfit = new OrganisationClasseProfit();
		return orgClasseProfit.getOrgClasseProfitHTMLComboList("iIdOrgClasseProfit",1);
	}

	public String getOrgClasseProfitHTMLComboList(String sFormSelectName, int iSize) throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
		String sListe = "";
		String sSelected = "selected=\"selected\"";
		
		sListe += "<select name=\""+ sFormSelectName +"\" id=\""+ sFormSelectName +"\" size=\""+iSize+"\">\n";
		if(this.lId <= 0)
			sListe += "<option value=\""+ (this.lId) +"\" "+ sSelected +">Indéfini\n";
		Vector<OrganisationClasseProfit> vOrgClasseProfit = getAllStatic();
		for (int i = 0; i < vOrgClasseProfit.size(); i++) 
		{
			OrganisationClasseProfit orgClasseProfit = vOrgClasseProfit.get(i);
			sListe += "<option value=\""+ orgClasseProfit.getId() +"\" "+ ((orgClasseProfit.getId()==this.lId)?sSelected:"") +">"+ orgClasseProfit.getLibelle() +"\n";
		}
		sListe += "</select>";
		
		return sListe;
	}

}
