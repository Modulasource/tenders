/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.bean ;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ObjectLocalization;
import org.coin.localization.Language;
import org.coin.util.Enumerator;
import org.json.JSONArray;
import org.json.JSONException;

/** Cette classe permet de gérer les statuts des utilisateurs
 * @author Robert Xavier Montori
 */
public class UserStatus extends Enumerator implements Serializable{    

	private static final long serialVersionUID = 1L;
	public static final int INVALIDE = 1;
	public static final int VALIDE = 2;
	public static final int EN_ATTENTE_DE_VALIDATION = 3;
	public static final int BLOQUE = 4;
	public static final int ADRESSE_MAIL_INVALIDE = 5;
	
	protected static String[][] s_sarrLocalization;
	
	public void setConstantes(){
        super.TABLE_NAME = "coin_user_status";
        super.FIELD_ID_NAME = "id_coin_user_status";
        super.FIELD_NAME_NAME = "	name";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
        
        this.iAbstractBeanIdObjectType = ObjectType.USER_STATUS;
    }
    
    public UserStatus() {
        super();
        setConstantes();
    }
    
    public UserStatus(String sName) {
        super(sName);
        setConstantes();
    }
    
    public UserStatus(int iId) {
        super(iId);
        setConstantes();
    }
    
    public UserStatus(int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }
    
	public UserStatus(int iId, String sName,boolean bUseHttpPrevent) {
		super(iId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName)
	{
		return getAll_onNewItem(iId,sName,true);
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent)
	{
		return new UserStatus(iId, sName,bUseHttpPrevent);
	}
	
    public static String getUserStatusName(int iId, int iIdLang) 
    throws CoinDatabaseLoadException, SQLException, NamingException  {
    	UserStatus item = new UserStatus(iId);
    	item.setAbstractBeanLocalization(iIdLang);
    	item.load();
    	return item.getName();
    }

    public static String getUserStatusName(int iId) 
    throws CoinDatabaseLoadException, SQLException, NamingException  {
    	UserStatus item = new UserStatus(iId);
    	item.load();
    	return item.getName();
    }
    
    public static String getUserStatusName(
    		int iId,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException  {
    	UserStatus item = new UserStatus(iId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load(conn);
    	return item.getName();
    }
    
    public static String getUserStatusName(
    		int iId,
    		boolean bUseHttpPrevent,
    		Connection conn,
    		Language language) 
    throws CoinDatabaseLoadException, SQLException, NamingException  {
    	UserStatus item = new UserStatus(iId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load(conn);
    	item.setAbstractBeanLocalization(language);
    	return item.getName();
    }

    public static UserStatus getUserStatus(int iId) throws Exception {
		UserStatus status = new UserStatus(iId);
		status.load();
		return status; 
	}
    
    public String getLocalizedName(Connection conn) {
    	s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
		return s_sarrLocalization[this.iAbstractBeanIdLanguage][(int)this.lId];
    }
    
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sName;
    		return s;
    	}
    	
    	
        return this.sName;
    }
    
    /**
     * TODO Optimize it !
     * 
     * @return
     * @throws JSONException
     * @throws InstantiationException
     * @throws IllegalAccessException
     * @throws NamingException
     * @throws SQLException
     * @throws CoinDatabaseLoadException
     */
    public static JSONArray getJSONArray() 
    throws JSONException, InstantiationException, IllegalAccessException, NamingException,
    SQLException, CoinDatabaseLoadException 
    {
        JSONArray items = new JSONArray();
        for (UserStatus item: getAllStatic()) items.put(item.toJSONObject());
        return items;
    }
    
    public static Vector<UserStatus> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserStatus item = new UserStatus();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }
    
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrix(this, conn);
	}
}

