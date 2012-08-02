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
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBeanComparator;
import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.db.ObjectLocalization;
import org.coin.localization.Language;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


/**
 * @author julien
 * @version last updated: 05/08/2005
 */

public class PersonnePhysiqueCivilite extends CoinDatabaseAbstractBeanMemory 
{
	private static final long serialVersionUID = 1L;

	public static final int UNDEFINED = 0;
	public static final int MONSIEUR = 1;
	public static final int MADAME = 2;
	public static final int MADEMOISELLE = 3;
	public static final int EMPTY = 4;
	
	protected String sLibelle;
	protected String sShortLabel;
	protected String sReferenceExterne;
	
	
	public static Vector<PersonnePhysiqueCivilite> m_vCivMemory = null;
	public static Vector<PersonnePhysiqueCivilite> m_unprevent_vCivMemory = null; 
	 
	protected static String[][] s_sarrLocalization;
	
	public void init() {
        super.TABLE_NAME = "personne_physique_civilite";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " libelle,"
                + " short_libelle,"
                + " reference_externe";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
        super.iAbstractBeanIdObjectType = ObjectType.CIVILITE;
        
        this.sLibelle = "";
        this.sShortLabel = "";
        this.sReferenceExterne = "";
    }
	
    public PersonnePhysiqueCivilite() {
    	init();
    }
    
    public PersonnePhysiqueCivilite(String sName) {
    	init();
        this.sLibelle = sName;
    }
    
    public PersonnePhysiqueCivilite(int iId) {
    	init();
        this.lId = iId;
    }
    
    public PersonnePhysiqueCivilite(int iId, String sName) {
    	init();
        this.lId = iId;
        this.sLibelle = sName;
    }
    
    public PersonnePhysiqueCivilite(int iId, String sName,boolean bUseHttpPrevent) {
    	init();
        this.lId = iId;
        this.sLibelle = sName;
		this.bUseHttpPrevent = bUseHttpPrevent;
	}

    public void populateMemory() throws NamingException, SQLException, 
    InstantiationException, IllegalAccessException
    {
    	if(this.bUseEmbeddedConnection)
    	{
    		m_vCivMemory = getAllStatic(true, this.connEmbeddedConnection);
    		m_unprevent_vCivMemory = getAllStatic(false, this.connEmbeddedConnection);
    	} else {
    		m_vCivMemory = getAllStatic(true);
    		m_unprevent_vCivMemory = getAllStatic(false);			
    	}
    }
    
	public Vector<PersonnePhysiqueCivilite> getItemMemory() {
		return (this.bUseHttpPrevent?m_vCivMemory:m_unprevent_vCivMemory);
	}

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
    	return (Vector<T>) getAllStaticMemory();
    }
    
    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, preventStore(this.sLibelle));
        ps.setString(++i, preventStore(this.sShortLabel));
        ps.setString(++i, preventStore(this.sReferenceExterne));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sLibelle = preventLoad(rs.getString(++i));
        this.sShortLabel = preventLoad(rs.getString(++i));
        this.sReferenceExterne = preventLoad(rs.getString(++i));
    }

    public static String getPersonnePhysiqueCiviliteName(int iId) 
    throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	PersonnePhysiqueCivilite ppCivilite = new PersonnePhysiqueCivilite(iId);
    	ppCivilite.load();
    	return ppCivilite.getName();
    }
    
	public static Vector<PersonnePhysiqueCivilite> getAllStatic(boolean bUseHttpPrevent) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	return item.getAll();
    }
	
	
	public static Vector<PersonnePhysiqueCivilite> getAllStatic(
			boolean bUseHttpPrevent,
			Connection conn)
	throws SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	return item.getAll(conn);
    }
	
    public static Vector<PersonnePhysiqueCivilite> getAllPersonnePhysiqueCivilite() 
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite();
		return item.getAll();
	}
    
    public static PersonnePhysiqueCivilite getPersonnePhysiqueCivilite(int iId) 
    throws CoinDatabaseLoadException, SQLException, NamingException
	{
    	PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite(iId);
    	item.load();
		return item;
	}
    
    public static PersonnePhysiqueCivilite getPersonnePhysiqueCivilite(int iId, boolean bUseHttpPrevent, long lIdLang) 
    throws CoinDatabaseLoadException, SQLException, NamingException
	{
    	PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite(iId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.setAbstractBeanLocalization(lIdLang);
    	item.load();
		return item;
	}
    
    public static PersonnePhysiqueCivilite getPersonnePhysiqueCivilite(
    		int iId,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite(iId);
    	item.bUseHttpPrevent=bUseHttpPrevent;
    	item.load(conn);
		return item;
	}
    
   
	
	public static Vector<PersonnePhysiqueCivilite> getAllStaticMemory(boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	reloadMemoryStatic(item);
    	return item.getItemMemory();
    }
	
	public static Vector<PersonnePhysiqueCivilite> getAllStaticMemory(
			boolean bUseHttpPrevent, 
			Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		PersonnePhysiqueCivilite item = new PersonnePhysiqueCivilite();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.bUseEmbeddedConnection = true;
    	item.connEmbeddedConnection = conn;
    	reloadMemoryStatic(item);
    	return item.getItemMemory();
    }
    
	public static Vector<PersonnePhysiqueCivilite> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getAllStaticMemory(true);
    }
    
    public static PersonnePhysiqueCivilite getPersonnePhysiqueCiviliteMemory(
    		long iId,
    		boolean bUseHttpPrevent) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	Connection conn = null;
    	try {
    		conn = ConnectionManager.getConnection();
    		return getPersonnePhysiqueCiviliteMemory(iId, bUseHttpPrevent, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
    	
    }

    public static PersonnePhysiqueCivilite getPersonnePhysiqueCiviliteMemory(
    		long iId,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	Vector<PersonnePhysiqueCivilite> vItems = getAllStaticMemory(bUseHttpPrevent, conn);
    	for (PersonnePhysiqueCivilite item : vItems) {
        	if(item.getId()==iId) return item;
		}

    	throw new CoinDatabaseLoadException("" + iId, "getPersonnePhysiqueCiviliteMemory");
    }
    
    public static PersonnePhysiqueCivilite getPersonnePhysiqueCiviliteMemory(
    		long iId) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	return getPersonnePhysiqueCiviliteMemory(iId,true);
    }
    
    public static String getPersonnePhysiqueCiviliteNameMemory(int iId,boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getPersonnePhysiqueCiviliteMemory(iId,bUseHttpPrevent).getName();
    }
    public static String getPersonnePhysiqueCiviliteNameMemory(int iId)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
    	return getPersonnePhysiqueCiviliteNameMemory(iId,true);
    }
    
    public static Vector<PersonnePhysiqueCivilite> getAllStaticMemory(boolean bUseLocalisation,long lIdLanguage)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        if(!bUseLocalisation || lIdLanguage == 0)
        	return getAllStaticMemory();
        else{
        	Vector<PersonnePhysiqueCivilite> vBeans = new PersonnePhysiqueCivilite().getAllMemoryLocalized(lIdLanguage);
        	if(bUseLocalisation)
    		{
    			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING));
    		}
        	return vBeans;
        }
        	
    }
    public String getLocalizedName(Connection conn) {
    	s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
		return s_sarrLocalization[this.iAbstractBeanIdLanguage][(int)this.lId];
    }

    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrix(this, conn);
	}
    
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sLibelle;
    		return s;
    	}
        return this.sLibelle;
    }
    
    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sLibelle = request.getParameter(sFormPrefix + "sLibelle");
        } catch(Exception e){}
        try {
            this.sShortLabel = request.getParameter(sFormPrefix + "sShortLabel");
        } catch(Exception e){}
        try {
            this.sReferenceExterne = request.getParameter(sFormPrefix + "sReferenceExterne");
        } catch(Exception e){}
    }
    
    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("sId", this.sId);
        item.put("sLibelle", this.getName());
        item.put("sShortLabel", this.sShortLabel);
        item.put("sReferenceExterne", this.sReferenceExterne);
        
        item.put("data", this.sId);
        item.put("value", this.getName());
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        PersonnePhysiqueCivilite item = getPersonnePhysiqueCiviliteMemory(lId);
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
        for (PersonnePhysiqueCivilite item:getAllStaticMemory(bUseLocalization,lIdLanguage)) {
        	items.put(item.toJSONObject());
        }
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.sLibelle = item.getString("sLibelle");
        } catch(Exception e){}
        try {
            this.sShortLabel = item.getString("sShortLabel");
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
        	PersonnePhysiqueCivilite item = null;
            try{
                item = PersonnePhysiqueCivilite.getPersonnePhysiqueCiviliteMemory(data.getLong("lId"));
            } catch(Exception e){
                item = new PersonnePhysiqueCivilite();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public static void main(String[] args)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
		RemoteControlServiceConnection a = new RemoteControlServiceConnection(
				"jdbc:mysql://serveur8.matamore.com:3306/veolia_dev?","dba_account", "dba_account" );
		Connection conn = a.getConnexionMySQL();

		PersonnePhysiqueCivilite item = PersonnePhysiqueCivilite.getPersonnePhysiqueCivilite(1,false,conn);
		
		
		item.bUseEmbeddedConnection=true;
		item.connEmbeddedConnection=conn;
		item.bPropagateEmbeddedConnection=true;
		
		item.setAbstractBeanIdLanguage(Language.LANG_ENGLISH);
		System.out.println(item.getName());
		System.out.println(item.getLocalizedName(conn));

		ObjectLocalization.displayMatrixOnConsole(conn, s_sarrLocalization);

		item.bUseLocalization=true;
		System.out.println(item.getAllInHtmlSelect());
		
		ConnectionManager.closeConnection(conn);

	}

	public String getReferenceExterne() {
		return sReferenceExterne;
	}

	public void setReferenceExterne(String referenceExterne) {
		sReferenceExterne = referenceExterne;
	}
}
