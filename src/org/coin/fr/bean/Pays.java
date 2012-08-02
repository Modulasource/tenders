/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.bean.ObjectType;
import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseAbstractBeanComparator;
import org.coin.db.CoinDatabaseAbstractBeanHtmlUtil;
import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.db.ObjectLocalization;
import org.coin.localization.Language;
import org.coin.util.Outils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/** Cette classe permet de gérer la liste des pays
 * @author Julien RENIER
 */
public class Pays extends CoinDatabaseAbstractBeanMemory {    
    
    private static final long serialVersionUID = 1L;
    public static final String FRANCE = "FRA";
    protected static Map<String,String>[] s_sarrLocalization;
   
    protected String sLibelle;
    protected String sIso3166Alpha2;
    protected String sReferenceExterne;

    public static Vector<Pays> m_vPays = null;

    public Pays() {
        init();
    }

    public Pays(String sId) {
        init();
        this.sId = sId;
    }
    
    public Pays(String sId, String sName) {
    	init();
        this.sId = sId;
        this.sLibelle = sName;
    }
    
	public Pays(String sId, String sName,boolean bUseHttpPrevent) {
		init();
        this.sId = sId;
        this.sLibelle = sName;
		this.bUseHttpPrevent = bUseHttpPrevent;
	}

    public void init() {
        super.TABLE_NAME = "pays";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " libelle,"
                + " iso_3166_alpha_2,"
                + " reference_externe";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
        super.iAbstractBeanIdObjectType = ObjectType.PAYS;
        
        this.sId = "FRA";
        this.sLibelle = "";
        this.sIso3166Alpha2 = "";
        this.sReferenceExterne = "";
        this.bAutoIncrement = false;
        this.PRIMARY_KEY_TYPE = CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING;
    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vPays = this.getAll();
    }

    public Vector<Pays> getItemMemory() {
        return m_vPays;
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory(this);
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, preventStore(this.sLibelle));
        ps.setString(++i, preventStore(this.sIso3166Alpha2));
        ps.setString(++i, preventStore(this.sReferenceExterne));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sLibelle = preventLoad(rs.getString(++i));
        this.sIso3166Alpha2 = preventLoad(rs.getString(++i));
        this.sReferenceExterne = preventLoad(rs.getString(++i));
    }

    public static Pays getPays(String sId) throws CoinDatabaseLoadException, SQLException, NamingException {
        Pays item = new Pays(sId);
        item.load();
        return item;
    }
    
    public static Pays getPays(
    		String sId,  
    		boolean bUseHttpPrevent, 
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	Pays pays = new Pays(sId);
    	pays.bUseHttpPrevent = bUseHttpPrevent;
    	pays.load(conn);
    	
    	return pays;
    }
    
    public static String getPaysName(String sId) throws CoinDatabaseLoadException, SQLException, NamingException {
    	return getPaysName(sId, true);
    }
    public static String getPaysName(String sId, boolean bUseHttpPrevent) throws CoinDatabaseLoadException, SQLException, NamingException {
    	Pays pays = new Pays(sId);
    	pays.bUseHttpPrevent = bUseHttpPrevent;
    	pays.load();
    	return pays.getName();
    }
    public static String getPaysName(String sId,  boolean bUseHttpPrevent, Connection conn) throws CoinDatabaseLoadException, SQLException, NamingException {
    	Pays pays = new Pays(sId);
    	pays.bUseHttpPrevent = bUseHttpPrevent;
    	pays.load(conn);
    	return pays.getName();
    }

    public static String getPaysNameMemory(String sId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	return getPaysMemory(sId).getName();
    }
    
    public static Pays getPaysMemory(String sId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (Pays item : getAllStaticMemory()) {
            if (item.getIdString().equalsIgnoreCase(sId)) return item;
        }
        throw new CoinDatabaseLoadException("" + sId, "getPaysMemory");
    }
    
    public static Pays getPaysMemory(
    		String sId, 
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        for (Pays item : getAllStaticMemory(bUseHttpPrevent, conn)) {
            if (item.getIdString().equalsIgnoreCase(sId)) return item;
        }
        throw new CoinDatabaseLoadException("" + sId, "getPaysMemory");
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sLibelle = request.getParameter(sFormPrefix + "sLibelle");
        } catch(Exception e){}
        try {
            this.sIso3166Alpha2 = request.getParameter(sFormPrefix + "sIso3166Alpha2");
        } catch(Exception e){}
        try {
            this.sReferenceExterne = request.getParameter(sFormPrefix + "sReferenceExterne");
        } catch(Exception e){}
    }

    public static Vector<Pays> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Pays item = new Pays();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<Pays> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Pays item = new Pays();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME
        + " ORDER BY libelle";
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<Pays> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Pays item = new Pays();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }
    
    public static Vector<Pays> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	Pays item = new Pays();
    	return getAllStaticMemory(item);
    }

    public static Vector<Pays> getAllStaticMemory(Pays item)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        reloadMemoryStatic(item);
        return m_vPays;
    }
    
    public static Vector<Pays> getAllStaticOptionalMemory(Pays item)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	if(!item.bUseLocalization || item.iAbstractBeanIdLanguage == 0){
    		return getAllStaticMemory(item);
    	}
        else{
        	Vector<Pays> vBeans = item.getAllMemoryLocalized(item.iAbstractBeanIdLanguage);
        	if(item.bUseLocalization)
    		{
    			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING));
    		}
        	return vBeans;
        }
    }
    public static Vector<Pays> getAllStaticMemory(boolean bUseLocalisation,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	Pays item = new Pays();
    	item.bUseLocalization = bUseLocalisation;
    	item.iAbstractBeanIdLanguage = (int)lIdLanguage;
    	return getAllStaticOptionalMemory(item);
    }

    public static Vector<Pays> getAllStaticMemory(
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	Pays item = new Pays();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.bUseEmbeddedConnection = true;
    	item.connEmbeddedConnection = conn;
    	return getAllStaticMemory(item);
    }

    
    public static Vector<Pays> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Pays item = new Pays();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sLibelle;
    		return s;
    	}
        return this.sLibelle;
    }

    public String getLibelle() {return this.sLibelle;}
    public void setLibelle(String sLibelle) {this.sLibelle = sLibelle;}

    public String getIso3166Alpha2() {return this.sIso3166Alpha2;}
    public void setIso3166Alpha2(String sIso3166Alpha2) {this.sIso3166Alpha2 = sIso3166Alpha2;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("sId", this.sId);
        item.put("sLibelle", this.getName());
        item.put("sIso3166Alpha2", this.sIso3166Alpha2);
        item.put("sReferenceExterne", this.sReferenceExterne);
        
        item.put("data", this.sId);
        item.put("value", this.getName());
        return item;
    }

    public static JSONObject getJSONObject(String sId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        Pays item = getPaysMemory(sId);
        JSONObject data = item.toJSONObject();
        return data;
    }
    
    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        return getJSONArray(false, 0);
    }
    public static JSONArray getJSONArray(Language language) 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        return getJSONArray(language.getId());
    }
    public static JSONArray getJSONArray(long lIdLanguage) 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        return getJSONArray(true, lIdLanguage);
    }
    public static JSONArray getJSONArray(boolean bUseLocalization,long lIdLanguage) 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (Pays item:getAllStaticMemory(bUseLocalization,lIdLanguage)) {
        	items.put(item.toJSONObject());
        }
        return items;
    }
    public static JSONArray getJSONArray(boolean bUseLocalization,long lIdLanguage,boolean bUseFilter) 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        
        String sFilterList = "";
        if(bUseFilter)
        	sFilterList = Configuration.getConfigurationValueMemory("server.country.list", "");
        
        for (Pays item:getAllStaticMemory(bUseLocalization,lIdLanguage)) {
        	if(bUseFilter && !sFilterList.contains(item.getIdString()))
            {
                continue;
            }else{
            	items.put(item.toJSONObject());
            }	
        }
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.sLibelle = item.getString("sLibelle");
        } catch(Exception e){}
        try {
            this.sIso3166Alpha2 = item.getString("sIso3166Alpha2");
        } catch(Exception e){}
        try {
            this.sReferenceExterne = item.getString("sReferenceExterne");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            Pays item = null;
            try{
                item = Pays.getPaysMemory(data.getString("lId"));
            } catch(Exception e){
                item = new Pays();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    @SuppressWarnings("unchecked")
	public static String getPaysHTMLComboList(String sId, String sIdListe) 
    throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	if(Outils.isNullOrBlank(sId))
    		sId = FRANCE;
    	
    	return CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect(sIdListe,1,(Vector)getAllStaticMemory(),sId);
	}
    
    
    
    @SuppressWarnings("unchecked")
	public static String getPaysHTMLComboList(String sId) 
    throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	if(Outils.isNullOrBlank(sId))
    		sId = FRANCE;

		return CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect("sIdPays",1,(Vector)getAllStaticMemory(),sId);
	}
    
    @SuppressWarnings("unchecked")
	public static String getPaysHTMLComboList() 
    throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
    	return CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect("sIdPays",1,(Vector)getAllStaticMemory(),FRANCE);
	}

    @SuppressWarnings("unchecked")
	public String getHTMLComboList(String sFormSelectName, int iSize, Vector vEnum,boolean bAddUndefined) throws SQLException, NamingException
	{
    	return CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect(sFormSelectName,iSize,vEnum,this.sId,"",bAddUndefined,bAddUndefined);
	}

    
    public String getLocalizedName(Connection conn)
	{
    	s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
		return s_sarrLocalization[this.iAbstractBeanIdLanguage].get(this.sId);
	}

    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrixString(this, conn);
	}
	
	public String getReferenceExterne() {
		return sReferenceExterne;
	}

	public void setReferenceExterne(String referenceExterne) {
		sReferenceExterne = referenceExterne;
	}
    
    
    /**
     * Test du multilangues
     * 
     * @param args
     * @throws CoinDatabaseLoadException
     * @throws SQLException
     * @throws NamingException
     * @throws InstantiationException
     * @throws IllegalAccessException
     */
    public static void main(String[] args)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
		RemoteControlServiceConnection a = new RemoteControlServiceConnection(
				"jdbc:mysql://serveur8.matamore.com:3306/veolia_dev?","dba_account", "dba_account" );
		Connection conn = a.getConnexionMySQL();

		Pays item = Pays.getPays("BEL",false,conn);
		item.bUseEmbeddedConnection=true;
		item.connEmbeddedConnection=conn;
		item.setAbstractBeanIdLanguage(Language.LANG_FRENCH);

		System.out.println(item.getName());
		System.out.println(item.getLocalizedName(conn));
		
		item.setAbstractBeanIdLanguage(Language.LANG_ENGLISH);
		System.out.println(item.getName());
		System.out.println(item.getLocalizedName(conn));

		item.bUseLocalization = true;
		System.out.println(item.getName());
		System.out.println(item.getLocalizedName(conn));
		
		//System.out.println(getPaysHTMLComboList()); ;
		System.out.println( item.getAllInHtmlSelect());
		
		//ObjectLocalization.displayMatrixOnConsole(conn, item.sarrLocalization);
		
		ConnectionManager.closeConnection(conn);

	}

    public static Pays getOrNewPaysFromName(
			String sName,
			Vector<Pays> vPays) 
	{
		for (Pays pays : vPays) {
			if(Outils.removeAllSpaces(pays.getName()).equalsIgnoreCase(Outils.removeAllSpaces(sName)))
			{
				return pays;
			}
		}
		
		return new Pays();
	}
}

