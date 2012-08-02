/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/


package org.coin.bean;

import java.net.URL;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import modula.TypeObjetModula;
import mt.common.addressbook.ldap.AddressBookLdapConnector;

import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseAbstractBeanTimeStamped;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
import org.coin.fr.bean.Organisation;
import org.coin.fr.bean.PersonnePhysique;
import org.coin.fr.bean.PersonnePhysiqueParametre;
import org.coin.fr.bean.mail.MailType;
import org.coin.ldap.LdapConnection;
import org.coin.mail.Courrier;
import org.coin.mail.Mail;
import org.coin.mail.mailtype.MailUser;
import org.coin.security.DwrSession;
import org.coin.security.MD5;
import org.coin.security.Password;
import org.coin.security.PreventSqlInjection;
import org.coin.security.SecureString;
import org.coin.util.BasicDom;
import org.coin.util.HttpUtil;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

@RemoteProxy
public class User extends CoinDatabaseAbstractBeanTimeStamped {
	private static final long serialVersionUID = 1L;

	protected String sLogin;
	protected String sPassword;
	protected String sKey;
	protected int iIdUserType;
	protected int iIdUserStatus;
	protected int iIdIndividual;
	protected int iIdColor;
	protected String sPath;
	protected Timestamp tsDateExpiration;
	protected Timestamp tsDateLastAccess;
	protected long lIdCoinUserAccessModuleType;
	
	/** non stocké en base de données */
	protected int iTentative;

	public static final int LOGON_ERR_EMPTY_LOGIN = 0;
	public static final int LOGON_ERR_EMPTY_PASSWORD = 1;
	public static final int LOGON_ERR_UNKNOW_LOGIN = 2;
	public static final int LOGON_ERR_BAD_PASSWORD  = 3;
	public static final int LOGON_ERR_DESACTIVATED_LOGIN = 4;
	public static final int LOGON_OK = 5;
	public static final int LOGON_ERR_BLOCKED = 6;
	public static final int LOGON_ERR_ACCOUNT_EXPIRED = 7;
	public static final int LOGON_ERR_ACCOUNT_UNAUTHORIZED = 8;
	 
	public static final int NO_ID_USER = -1;
	public static final int ID_CRON_USER = 2;
	public static final int ID_SYST_USER = 1;

	public boolean isLogged;
	
	public Organisation oContextOrganisation;
	public PersonnePhysique oContextoPersonnePhysique;
	
	public String sNewLogin = "";
	public String sNewPassword = "";
	public String sPasswordNoMD5 = "";

    protected static Map<String,String>[] s_sarrLocalizationLabel;

	/**
	 * Cette méthode initialise les champs de la classe User
	 *
	 */
	public void init()
	{
		super.TABLE_NAME = "coin_user";
		super.FIELD_ID_NAME = "id_coin_user";

		super.SELECT_FIELDS_NAME =
			 " id_individual,"
			+ " id_coin_user_status,"
			+ " id_coin_user_type,"
			+ " id_coin_user_color,"
			+ " login,"
			+ " coin_user_path,"
			+ " password,"
			+ " user_key,"
			+ " date_creation,"
			+ " date_derniere_modification,"
			+ " date_expiration,"
			+ " date_last_access,"
			+ " id_coin_user_access_module_type"
			;

		
		super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length ; 
		super.iAbstractBeanIdObjectType = ObjectType.USER;
		
		super.lId = 0;
		this.iIdColor = 0;
		this.iIdIndividual = 0;
		this.iIdUserStatus = 0;
		this.iIdUserType = 0;
		this.sLogin = "";
		this.sPassword = "";
		this.isLogged = false;
		this.sPath = "";
		this.sKey = "";
		this.tsDateExpiration = null;
		this.tsDateLastAccess = null;
		this.lIdCoinUserAccessModuleType = 0;
	}
	
	
	public User()
	{
		init();	
		//this.ds = ;
	}

	public User(
			int iIdUser,
			String sLogin,
			String sPassword,
			int iIdUserType,
			int iIdUserStatus,
			int iIdIndividual,
			String sPath)
	{
		init();
		this.lId = iIdUser;
	}

	public User( 
		String sLogin,
		String sPassword,
		int iIdUserType,
		int iIdUserStatus,
		int iIdIndividual,
		String sPath)
	{
		init();
		
		this.sLogin = sLogin;
		this.sPassword = sPassword;
		this.iIdUserType = iIdUserType;
		this.iIdUserStatus = iIdUserStatus;
		this.iIdIndividual = iIdIndividual;
		this.sPath = sPath;
	}
	
	public User(int iIdUser) {
		init();
		this.lId = iIdUser;
	}
	
	public static User getUser(int iIdUser) throws CoinDatabaseLoadException, SQLException, NamingException {
		User user = new User(iIdUser);
		user.load();
		return user; 
	}
	
	public static User getUser(int iIdUser, Connection conn) throws CoinDatabaseLoadException, SQLException, NamingException {
		User user = new User(iIdUser);
		user.load(conn);
		return user; 
	}
	
	public static User getUser(int iIdUser, boolean bUseHttpPrevent, Connection conn) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		User user = new User(iIdUser);
		user.bUseHttpPrevent = bUseHttpPrevent ;
		user.load(conn);
		return user; 
	}
	
	public static Vector<User> getAllStatic() 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		User user = new User();
		return user.getAll();
	}

	public static Vector<User> getAllStatic(
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		User user = new User();
		return user.getAll(conn);
	}

	
	public void setIsLogged(boolean b) { this.isLogged = b; }
	public void setIdUser(int iIdUser) { this.lId = iIdUser; }
	public void setIdIndividual(int iIdIndividual) { this.iIdIndividual = iIdIndividual; }
	public void setIdUserStatus(int iIdUserStatus) { this.iIdUserStatus = iIdUserStatus; }
	public void setIdUserType(int iIdUserType) { this.iIdUserType = iIdUserType; }
	public void setLogin(String sLogin) { this.sLogin = sLogin; }
	public void setPassword(String sPassword ) { this.sPassword = sPassword; }
	public void setPath(String sPath) { this.sPath = sPath; }
	public void setDateExpiration(Timestamp tsDateExpiration) { this.tsDateExpiration = tsDateExpiration; }
	public void setKey(String key) { this.sKey = key; }
	public void setIdCoinUserAccessModuleType(long lIdCoinUserAccessModuleType) { this.lIdCoinUserAccessModuleType = lIdCoinUserAccessModuleType; }

	public int getIdUser() { return (int)this.lId; }
	public int getIdIndividual() { return this.iIdIndividual; }
	public int getIdUserType() { return this.iIdUserType; }
	public String getPath() { return this.sPath; }
	public int getIdUserStatus() { return this.iIdUserStatus; }
	public String getLogin() { return this.sLogin; }
	public String getPassword() { return this.sPassword; }
	public boolean getIsLogged() { return this.isLogged; }
	public Timestamp getDateExpiration() { return this.tsDateExpiration; }
	public Timestamp getDateLastAccess() { return this.tsDateLastAccess; }
	public String getKey() { return this.sKey; }
	public long getIdCoinUserAccessModuleType() { return this.lIdCoinUserAccessModuleType; }
	
	
	public static boolean isUserWithLogin(String sLogin) 
	throws SQLException, NamingException, CoinDatabaseLoadException 
	{
		Connection conn = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			return  isUserWithLogin(sLogin, conn) ;
		} finally {
			ConnectionManager.closeConnection(conn);
		}

	}

	public static boolean isUserWithLogin(
			String sLogin, 
			Vector<User> vUserTotal ) 
	throws SQLException, NamingException, CoinDatabaseLoadException
	{
		boolean bExist = false;
		for (User user : vUserTotal) {
			if(user.sLogin.equalsIgnoreCase(sLogin))  return true;
		}
		
		return bExist;
	}
	
	
	public static boolean isUserWithLogin(String sLogin, Connection conn) 
	throws SQLException, NamingException, CoinDatabaseLoadException
	{
		int nbRows = 0;
		User item = new User();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sLogin);
		
		String sSqlQuery = "SELECT COUNT(*) FROM " + item.TABLE_NAME 
					+ " WHERE login LIKE ?";

		nbRows = ConnectionManager.getCountInt(sSqlQuery, vParams, conn);
	
		return (nbRows>0);
	}

	public static int getIdFromLogin(
			String sLogin) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		return getIdFromLogin(sLogin, true);
	}
	
	public static int getIdFromLogin(
			String sLogin, 
			boolean bCheckEmailIndividual) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return getIdFromLogin(sLogin, bCheckEmailIndividual, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public static int getIdFromLogin(
			String sLogin, 
			boolean bCheckEmailIndividual,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		int iIdUser = NO_ID_USER ;
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(PreventSqlInjection.cleanEmail(sLogin));
		
		User item = new User();
		String sSQLQuery 
			=	item.getAllSelect()
			+ " WHERE login=? ";

		item.bUseHttpPrevent = false;
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		
		Vector<User> v = item.getAllWithSqlQuery(sSQLQuery,vParams);
		if(v.size() != 0 )
		{
			iIdUser = v.get(0).getIdUser();
		} else {
			if(bCheckEmailIndividual){
				sSQLQuery 
				=	item.getAllSelect("usr.") + ", personne_physique pp"
				+ " WHERE usr.id_individual=pp.id_personne_physique "
				+ " AND pp.email=? ";
				
				
				v = item.getAllWithSqlQuery(sSQLQuery,vParams);
				if(v.size() != 0 )
				{
					iIdUser = v.get(0).getIdUser();
				}
			}
			
		}
		return iIdUser;
	
	}

	public int logon(String sLogin, String sPassword)
	throws CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException, CoinDatabaseStoreException 
	{
		int iRetCode = logonControl(sLogin, sPassword);
		if(iRetCode != LOGON_OK)
			return iRetCode;


		// Analyse du mot de passe
		if (!Password.checkPassword(sPassword, this.getPassword())) {
			return LOGON_ERR_BAD_PASSWORD;
		}
		
		if (this.iIdUserStatus != UserStatus.VALIDE) {
			return LOGON_ERR_DESACTIVATED_LOGIN;
		}

		// Vérification statut
		if (this.iIdUserStatus == UserStatus.VALIDE) {
			// Statut valide
			// On passe le témoin isLogged à true
			storeLastAccess();
			this.isLogged = true;
		}

		return LOGON_OK;
	}
	
	public void storeLastAccess() throws SQLException, NamingException, CoinDatabaseStoreException {
		this.tsDateLastAccess = new Timestamp(System.currentTimeMillis());
		super.store();
	}
	
	public int logonSecure(String sLogin, String sCryptogramme,String sMotCache) 
	throws CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException, CoinDatabaseStoreException 
	{
		
		int iRetCode = logonControl(sLogin, sCryptogramme);
		if(iRetCode != LOGON_OK)
			return iRetCode;

		iRetCode = logonAuthenticate(sCryptogramme, sMotCache);
		if(iRetCode != LOGON_OK)
			return iRetCode;

		return LOGON_OK;
	}

	public int logonAuthenticate(String sCryptogramme, String sMotCache) 
	throws SQLException, NamingException, CoinDatabaseStoreException 
	{
		// Analyse du mot de passe
		// TODO : SHA-256
		//String sCryptogrammeActuel = org.coin.security.SHA2.getEncodedString256(this.getPassword()+sMotCache);
		String sCryptogrammeActuel = org.coin.security.MD5.getEncodedString(this.getPassword()+sMotCache);
		if (!sCryptogramme.equals(sCryptogrammeActuel)) {
			return LOGON_ERR_BAD_PASSWORD;
		}
		
		if (this.iIdUserStatus != UserStatus.VALIDE) {
			return LOGON_ERR_DESACTIVATED_LOGIN;
		}

		//Vérification statut
		if (this.iIdUserStatus == UserStatus.VALIDE) {
			// Statut valide
			// On passe le témoin isLogged à true
			storeLastAccess();
			this.isLogged = true;
		}
		
		return LOGON_OK;
	}	

	public int logonControl(
			String sLogin, 
			String sCryptogramme) 
	throws NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseLoadException 
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return logonControl(sLogin, sCryptogramme, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public int logonControl(
			String sLogin, 
			String sCryptogramme,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseLoadException 
	{
		if (sLogin == null) {
			return LOGON_ERR_EMPTY_LOGIN ;
		}
		if (sCryptogramme == null) {
			return LOGON_ERR_EMPTY_PASSWORD ;
		}

		// Recherche du login
		int idUser = getIdFromLogin(sLogin, true, conn);
		if (idUser == NO_ID_USER ) {
			return LOGON_ERR_UNKNOW_LOGIN;
		}
		this.lId = idUser;
		this.bUseHttpPrevent = false;
		load(conn);

		
		/**
		 * Control expiration date of the account
		 */
		long lTimeCurrent = System.currentTimeMillis();
		if( this.tsDateExpiration != null
		&& this.tsDateExpiration.getTime() < lTimeCurrent )
		{
			return LOGON_ERR_ACCOUNT_EXPIRED;
		}
		
		return LOGON_OK;
	}
	
	public int logonSecurePublisher(String sLogin, String sCryptogramme,String sMotCache) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseStoreException {
		
		int iRetCode = logonControl(sLogin, sCryptogramme);
		if(iRetCode != LOGON_OK)
			return iRetCode;

		if(this.iIdUserType != UserType.TYPE_CANDIDAT)
		{
			/**
			 * now we can go as admin on the publisher
			 */
			if(this.iIdUserType != UserType.TYPE_ADMINISTRATEUR){
				return LOGON_ERR_UNKNOW_LOGIN;
			} 
		}
		
		return logonAuthenticate(sCryptogramme, sMotCache);
	}

	public int logonSecureDesk(
			String sLogin, 
			String sCryptogramme,
			String sMotCache) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseStoreException 
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return logonSecureDesk(sLogin, sCryptogramme, sMotCache, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}

	public static String getLogonSecureDeskUrl(
			String rootPath,
			String sLogin,
			Connection conn) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException, CoinDatabaseLoadException,
	CoinDatabaseDuplicateException, NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		User user = User.getUserFromLogin(sLogin, false, conn);
		return getLogonSecureDeskUrl(rootPath, user.getId());
	}
	
	
	public static String getLogonSecureDeskUrl(
			String rootPath,
			long lIdUser)
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException
	{
		return getLogonSecureDeskUrl(rootPath, lIdUser, false);
	}
	
	public static String getLogonSecureDeskUrl(
			String rootPath,
			long lIdUser,
			boolean bAsSuperUser) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException
	{
		return 
			rootPath + "desk/logon.jsp"
			 + "?aaa=" + SecureString.getSecureString(
					 "" + System.currentTimeMillis()
					 + ":" + lIdUser
					 + ":" + bAsSuperUser );
	}

	
	public int logonSecureDesk(
			String sLogin, 
			String sCryptogramme,
			String sMotCache,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseStoreException 
	{
		int iRetCode = logonControl(sLogin, sCryptogramme, conn);
		if(iRetCode != LOGON_OK)
			return iRetCode;
	
		if(this.lIdCoinUserAccessModuleType == CoinUserAccessModuleType.TYPE_LDAP)
		{
			PersonnePhysique pp = PersonnePhysique.getPersonnePhysique(iIdIndividual, false, conn);
			AddressBookLdapConnector ldap = new AddressBookLdapConnector(ObjectType.ORGANISATION, pp.getIdOrganisation());
			ldap.init(conn);
			
			/*
			String sLdapURL 
				= OrganisationParametre
					.getOrganisationParametreValue(
							pp.getIdOrganisation(), 
							"ldap.url",
							conn);

			String sName 
				= OrganisationParametre
					.getOrganisationParametreValue(
							pp.getIdOrganisation(), 
							"ldap.search.base",
							conn);
	
			 */
			
			String sLdapCnUser = null;
			
			try {
				sLdapCnUser = PersonnePhysiqueParametre.getPersonnePhysiqueParametreValue(
						pp.getIdPersonnePhysique(), 
						"ldap.cn",
						conn);
			} catch (Exception e) {
				//e.printStackTrace();
			}
			
			if(sLdapCnUser == null)
			{
				/**
				 * let's try with the search process
				 * 
				 */
				sLdapCnUser = ldap.getUserCn(sLogin);
			}
			
			if(sLdapCnUser == null)
			{
				/**
				 * not found in the LDAP
				 */
				return LOGON_ERR_BAD_PASSWORD;
			}
			
			boolean bLogged 
				= LdapConnection.logon(
						ldap.ldapURL, 
						sLdapCnUser + "," + ldap.searchBase, 
						sCryptogramme);
			
			if(bLogged) {
				this.isLogged = true;
				return LOGON_OK;
			}
			
		} else {
			if(this.iIdUserType != UserType.TYPE_CANDIDAT)
			{
				return logonAuthenticate(sCryptogramme, sMotCache);
			}
		}
		
		return LOGON_ERR_BAD_PASSWORD;
	}

	
	public void logout() {
		init();
	}
	
	public static User getUserFromIdIndividual(int iIdIndividual) 
	throws CoinDatabaseLoadException, NamingException, SQLException,
	InstantiationException, IllegalAccessException  {
		return getUserFromIdIndividual((long)iIdIndividual);
	}
	
	public static User getUserFromIdIndividual(long lIdIndividual) 
	throws CoinDatabaseLoadException, NamingException, SQLException,
	InstantiationException, IllegalAccessException  {
		User item = new User();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Long(lIdIndividual));
		String sSQLQuery 
			=	item.getAllSelect()
			+ " WHERE id_individual=?";
		
		Vector<User> v = item.getAllWithSqlQuery(sSQLQuery, vParams);
		if(v.size() == 0 )
		{
			throw new CoinDatabaseLoadException("" + lIdIndividual, sSQLQuery);
		}
		
		return v.get(0);
	}

	public static User getUserFromEmailIndividual(
			String sEmail) 
	throws CoinDatabaseLoadException, CoinDatabaseDuplicateException, NamingException, 
	SQLException, InstantiationException, IllegalAccessException
	 {
		User item = new User();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sEmail);
		String sSqlQuery 
			=	item.getAllSelect("user.")+", personne_physique pp"
			+ " WHERE user.id_individual=pp.id_personne_physique"
			+ " AND pp.email = ?";

		return  (User) item.getAbstractBean(sSqlQuery, vParams,true);
	
	}
	
	public static User getUserFromIdIndividual(
			long lIdIndividual,
			boolean bUseHttpPrevent,
			Connection conn)
	throws CoinDatabaseLoadException, NamingException, SQLException,
	InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException 
	 {
		User item = new User();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Long(lIdIndividual));
		String sSqlQuery 
			=	item.getAllSelect()
			+ " WHERE id_individual=?" ;

		item.bUseHttpPrevent = bUseHttpPrevent;
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection	 = conn;
		
		return  (User) item.getAbstractBean(sSqlQuery, vParams,true);
	
	}
	
	public static User getUserFromIdIndividual(
			long lIdIndividual,
			Vector<User> vUser)
	throws CoinDatabaseLoadException{
		for(User item : vUser){
			if(lIdIndividual == item.getIdIndividual())
				return item;
		}
		throw new CoinDatabaseLoadException("le user correspondant à la personne id="+lIdIndividual+" est inconnu","");
	}

	public static Vector<User> getAllUserFromLoginLike(String sLogin)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		Connection conn = ConnectionManager.getConnection();
		try {
			User item = new User();
			Vector<Object> vParam = new Vector<Object>();
			vParam.add("%" + sLogin + "%");
			return item.getAllWithWhereAndOrderByClause(
					"WHERE login LIKE ? ", 
					"", 
					vParam);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
	}

	
	public static Vector<User> getAllUserFromLogin(String sLogin)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		Connection conn = ConnectionManager.getDataSource().getConnection();
		Vector<User> vUser = null;
		try {
			vUser = getAllUserFromLogin(sLogin, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
		return vUser;
	}
	
	public static Vector<User> getAllUserFromLogin(String sLogin,Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		User item = new User();
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(PreventSqlInjection.cleanEmail(sLogin));
		
		String sSQLQuery 
			=	item.getAllSelect()
			+ " WHERE login=?";

		return item.getAllWithSqlQuery(sSQLQuery, vParams);
	}
	
	
	public static Vector<User> getAllUserFromLogin(
			String sLogin,
			Vector<User> vUserTotal)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Vector<User> vUserSelected = new Vector<User> ();
		
		for (User user : vUserTotal) {
			if(sLogin.equals(user.getLogin()))
			{
				vUserSelected.add(user );
			}
		}
		
		return vUserSelected;
	}

	public static User getUserFromLogin(
			String sLogin,
			boolean bUseHttpPrevent ,
			Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, 
	CoinDatabaseLoadException, CoinDatabaseDuplicateException
	{
		User item = new User();
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;
		item.bUseHttpPrevent = bUseHttpPrevent ;
		
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(sLogin);
		
		return (User) item.getAbstractBeanWithWhereAndOrderByClause(
				" WHERE login=?", 
				"", 
				vParams,
				true);
	}
	
	
	
	public static User getUserFromLogin(String sLogin)
	throws CoinDatabaseLoadException, NamingException, SQLException,
		InstantiationException, IllegalAccessException{
		Vector<User> v = getAllUserFromLogin(sLogin);
		if(v.size() == 0 )
		{
			throw new CoinDatabaseLoadException("pas de user avec le login :" + sLogin, "");
		}
		return v.get(0);
	}

	public static int getIdUserFromIdIndividual(int iIdIndividual) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getIdUserFromIdIndividual((long) iIdIndividual);
	}
	
	public static int getIdUserFromIdIndividual(long iIdIndividual) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException {
		User item = new User();
		Vector<Object> vParams = new Vector<Object>(); 
		vParams.add(new Long(iIdIndividual));
		String sSQLQuery 
			=	item.getAllSelect()
		    + " WHERE id_individual=?";
	
		Vector<User> v = item.getAllWithSqlQuery(sSQLQuery, vParams);
		if(v.size() == 0 )
		{
			throw new CoinDatabaseLoadException("" + iIdIndividual, sSQLQuery);
		}
		return v.get(0).getIdUser();

	}
	
	
	public Organisation getOrganisation() throws CoinDatabaseLoadException, SQLException, NamingException{
		PersonnePhysique personneLogueePP = PersonnePhysique.getPersonnePhysique(this.getIdIndividual());
		Organisation orgUserLog = Organisation.getOrganisation(personneLogueePP.getIdOrganisation());
		return orgUserLog;
	}

	
	public static void sendMailActivationUserFromDeskOrganisation(
			User user,
			PersonnePhysique personne,
			Organisation organisation,
			int iIdMailType,
			Mail mail,
			HttpServletRequest request,
			Connection conn
			) 
	throws CoinDatabaseLoadException, SQLException, NamingException, Exception 
	{
		MailType mailType = MailType.getMailTypeMemory(iIdMailType,false);
		Courrier courrier = new Courrier();  
		courrier.setIdObject(personne.getIdPersonnePhysique());
		courrier.setIdObjectType(TypeObjetModula.PERSONNE_PHYSIQUE);
		String sDestinataire = "";
		try{
			sDestinataire = Configuration.getConfigurationValueMemory("email.user.create.default");
		}catch(Exception e){}
		
		if (sDestinataire.equalsIgnoreCase("")) sDestinataire = personne.getEmail();
		
		courrier.setTo(sDestinataire);
		courrier.setDateStockage(new Timestamp(System.currentTimeMillis()));
		courrier.setDateEnvoiPrevu(new Timestamp(System.currentTimeMillis()));
		courrier.setSend(false);
		String sObjet = mailType.getObjetType();

		String contenuMail = mailType.getContenuType();
		contenuMail = Outils.replaceAll(contenuMail, "[civilite_personne]", personne.getCivilitePrenomNom());
		contenuMail = Outils.replaceAll(contenuMail, "[nom_organisation]", organisation.getRaisonSociale());
		
		URL oURLServletValiderCGU = HttpUtil.getUrlWithProtocolAndPort(
				request.getContextPath()+"publisher_portail/public/pagesStatics/infoslegales.jsp?view=limited",
				request); 
		
		
		contenuMail = Outils.replaceAll(contenuMail, "[url_CGU]", oURLServletValiderCGU.toExternalForm());
		courrier.setSubject(sObjet);
		courrier.setMessage(contenuMail);
		MailUser.replaceUrlValidationUserAccount(user,"create", request, courrier);
		courrier.create(conn);
		
		mail.computeFromCourrier(courrier);
		if(mail.send(conn)){
			courrier.setSend(true);
			courrier.setDateEnvoiEffectif(new Timestamp(System.currentTimeMillis()));
			courrier.store(conn);
		}
	}
	
	public void changeLoginFromForm(
			HttpServletRequest request,
			HttpServletResponse response,
			String sLogin, 
			int iIdMailType, 
			Mail mail) 
	throws CoinDatabaseLoadException, SQLException, NamingException, Exception 
	
	{
		boolean bLinkEmailAndLogin = Configuration.isEnabledMemory("individual.email.link.logon", true);
	
		if(!User.isUserWithLogin(sLogin)) 
		{
			if(bLinkEmailAndLogin?(!PersonnePhysique.isPersonnesPhysiquesWithEmail(sLogin)):true)
			{
				try
				{
					Connection conn = ConnectionManager.getConnection();
					boolean bEnvoiMail = false;
					if(this.iIdUserStatus == UserStatus.VALIDE 
					|| this.iIdUserStatus == UserStatus.EN_ATTENTE_DE_VALIDATION)
					{
						this.iIdUserStatus = UserStatus.EN_ATTENTE_DE_VALIDATION;
						this.setKey(Password.computeCryptogramMD5(Integer.toString(this.getIdUser())));
						bEnvoiMail = true;
					}
					
					this.sLogin = sLogin;
					this.store(conn);
	
					PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(this.iIdIndividual, false, conn);
					personne.setAbstractBeanLocalization(this);
					
					if(bLinkEmailAndLogin )
					{
						personne.setEmail(sLogin);
						personne.store(conn);
					}
	
					if(bEnvoiMail)
					{
						//MAIL
						MailType mailType = MailType.getMailTypeMemory(iIdMailType,false);
						
						
						Courrier courrier = Courrier.newCourrierCron(mailType);
						
						MailUser.populateCourrierPersonnePhysiqueWithObjectAttached(
								courrier, 
								personne,
								conn);
						
						
						MailUser.replaceUrlValidationUserAccount(this, "store", request, courrier);
						try{
							courrier.send(mail, conn);
						} catch (Exception e) {
							e.printStackTrace();
						}					
						ConnectionManager.closeConnection(conn);
					}
				}
				catch(Exception e){throw new Exception("Changement de login non effectué");}
			}
			else
			{
				throw new Exception("Changement de login non effectué - l'adresse email existe deja pour une personne physique");
			}
		}
		else
			throw new Exception("Changement de login non effectué - le login existe déjà");
	}


	@Override
	public String getName() { return this.sLogin; }

	public void setFromForm(HttpServletRequest request, String sFormPrefix) 
	throws SQLException, NamingException {
	}

	public void setFromResultSet(ResultSet rs) throws SQLException {

		
		int i = 0;
		this.iIdIndividual = rs.getInt(++i);
		this.iIdUserStatus = rs.getInt(++i);
		this.iIdUserType = rs.getInt(++i);
		this.iIdColor = rs.getInt(++i);
		this.sLogin = preventLoad(rs.getString(++i));
		this.sPath = preventLoad(rs.getString(++i));
		this.sPassword = preventLoad(rs.getString(++i));
		this.sKey = preventLoad(rs.getString(++i));
		super.tsDateCreation = rs.getTimestamp(++i);
		super.tsDateModification = rs.getTimestamp(++i);
		this.tsDateExpiration = rs.getTimestamp(++i);
		this.tsDateLastAccess = rs.getTimestamp(++i);
		this.lIdCoinUserAccessModuleType = rs.getLong(++i);
	}

	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		int i = 0;
		ps.setInt(++i, this.iIdIndividual);
		ps.setInt(++i, this.iIdUserStatus);
		ps.setInt(++i, this.iIdUserType);
		ps.setInt(++i, this.iIdColor);
		ps.setString(++i, preventStore(this.sLogin));
		ps.setString(++i, preventStore(this.sPath));
		ps.setString(++i, preventStore(this.sPassword));
		ps.setString(++i, preventStore(this.sKey));
		ps.setTimestamp(++i, super.tsDateCreation);
		ps.setTimestamp(++i, super.tsDateModification);
		ps.setTimestamp(++i, this.tsDateExpiration);
		ps.setTimestamp(++i, this.tsDateLastAccess);
		ps.setLong(++i, this.lIdCoinUserAccessModuleType);
	}
	
	
	

	public String getIdIndividualLabel() {
		return getLocalizedLabel("iIdIndividual");
	}	

	public String getIdUserStatusLabel() {
		return getLocalizedLabel("iIdUserType");
	}	

	public String getIdUserTypeLabel() {
		return getLocalizedLabel("iIdUserType");
	}	

	public String getLoginLabel() {
		return getLocalizedLabel("sLogin");
	}	

	public String getPathLabel() {
		return getLocalizedLabel("sPath");
	}	
	
	public String getPasswordLabel() {
		return getLocalizedLabel("sPassword");
	}
		
	public String getKeyLabel() {
		return getLocalizedLabel("sKey");
	}
	
	public String getDateExpirationLabel() {
		return getLocalizedLabel("tsDateExpiration");
	}
	
	public String getDateLastAccessLabel() {
		return getLocalizedLabel("tsDateLastAccess");
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
    
    public static User loadFromJSONObject(JSONObject data) {
        User item = null;
        try{
            item = User.getUser((int)data.getLong("lId"));
        } catch(Exception e){
            item = new User();
        }
        item.setFromJSONObject(data);
        return item;
    }
    
    public void setFromJSONObject(JSONObject item) {
    	try {
            this.iIdIndividual = item.getInt("iIdIndividual");
        } catch(Exception e){}
        try {
            this.iIdUserStatus = item.getInt("iIdUserStatus");
        } catch(Exception e){}
        try {
            this.iIdUserType = item.getInt("iIdUserType");
        } catch(Exception e){}
        try {
            this.iIdColor = item.getInt("iIdColor");
        } catch(Exception e){}
        try {
            this.sLogin = item.getString("sLogin");
        } catch(Exception e){}
        try {
            this.sPath = item.getString("sPath");
        } catch(Exception e){}
        try {
            this.sPassword = item.getString("sPassword");
        } catch(Exception e){}
        try {
            this.sKey = item.getString("sKey");
        } catch(Exception e){}
        try {
            this.tsDateCreation = item.getTimestamp("tsDateCreation");
        } catch(Exception e){}
        try {
            this.tsDateModification = item.getTimestamp("tsDateModification");
        } catch(Exception e){}
        try {
            this.tsDateExpiration = item.getTimestamp("tsDateExpiration");
        } catch(Exception e){}
        try {
            this.tsDateLastAccess = item.getTimestamp("tsDateLastAccess");
        } catch(Exception e){}
        try {
            this.lIdCoinUserAccessModuleType = item.getLong("lIdCoinUserAccessModuleType");
        } catch(Exception e){}
    }
    
	public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("iIdIndividual",this.iIdIndividual);
		item.put("iIdUserStatus",this.iIdUserStatus);
		item.put("iIdUserType",this.iIdUserType);
		item.put("iIdColor",this.iIdColor);
		item.put("sLogin", this.sLogin);
		item.put("sPath", this.sPath);
		item.put("sPassword", this.sPassword);
		item.put("sKey", this.sKey);
		item.put("tsDateCreation", this.tsDateCreation);
		item.put("tsDateModification", this.tsDateModification);
		item.put("tsDateExpiration", this.tsDateExpiration);
		item.put("tsDateLastAccess", this.tsDateLastAccess);
		item.put("lIdCoinUserAccessModuleType", this.lIdCoinUserAccessModuleType);
		return item;
	}
	
	public static void updateAllInactiveFromNotOrganisation(CoinDatabaseWhereClause wc_org,Connection conn)
	throws SQLException
	{
    	User item = new User();
    	String sSQLUpdate = CoinDatabaseUtil.getSqlUpdateClassicJoin(
    			item.TABLE_NAME,
    			"personne_physique,organisation",
    			item.TABLE_NAME+".id_coin_user_status="+UserStatus.INVALIDE)+
        " WHERE "+item.TABLE_NAME+".id_individual = personne_physique.id_personne_physique"+
        " AND personne_physique.id_organisation = organisation.id_organisation"+
        " AND organisation.reference_externe IS NOT NULL"+
        " AND TRIM(organisation.reference_externe) <> ''"+
        " AND "+wc_org.generateWhereNotClause("organisation.reference_externe");
    	
    	ConnectionManager.executeUpdate(sSQLUpdate, conn);
    }
	
	public static void updateAllActiveFromOrganisation(long lIdOrganisation,Connection conn) 
	throws SQLException
	{
    	User item = new User();
    	String sSQLUpdate = CoinDatabaseUtil.getSqlUpdateClassicJoin(
    			item.TABLE_NAME,
    			"personne_physique",
    			item.TABLE_NAME+".id_coin_user_status="+UserStatus.VALIDE)+
        " WHERE "+item.TABLE_NAME+".id_individual = personne_physique.id_personne_physique"+
        " AND personne_physique.id_organisation = "+lIdOrganisation;
    	
    	ConnectionManager.executeUpdate(sSQLUpdate, conn);
    }
	
	
	public static void updateAllInactiveFromOrganisation(long lIdOrganisation,Connection conn) throws SQLException{
    	User item = new User();
    	String sSQLUpdate = CoinDatabaseUtil.getSqlUpdateClassicJoin(
    			item.TABLE_NAME,
    			"personne_physique,organisation",
    			item.TABLE_NAME+".id_coin_user_status="+UserStatus.INVALIDE)+
        " WHERE "+item.TABLE_NAME+".id_individual = personne_physique.id_personne_physique"+
        " AND personne_physique.id_organisation = "+lIdOrganisation;
    	
    	ConnectionManager.executeUpdate(sSQLUpdate, conn);
    }
	
	public static void updateAllInactiveFromNotPersonne(CoinDatabaseWhereClause wc_pp,Connection conn) throws SQLException{
    	User item = new User();
    	String sSQLUpdate = CoinDatabaseUtil.getSqlUpdateClassicJoin(
    			item.TABLE_NAME,
    			"personne_physique",
    			item.TABLE_NAME+".id_coin_user_status="+UserStatus.INVALIDE)+
        " WHERE "+item.TABLE_NAME+".id_individual = personne_physique.id_personne_physique"+
        " AND personne_physique.reference_externe IS NOT NULL"+
        " AND TRIM(personne_physique.reference_externe) <> ''"+
        " AND "+wc_pp.generateWhereNotClause("personne_physique.reference_externe");
    	
    	ConnectionManager.executeUpdate(sSQLUpdate, conn);
    }
	
	public void deserialize (Node node){
		try{this.sLogin = BasicDom.getChildNodeValueByNodeName(node, "login");}
		catch(SAXException e){}
		try{this.sPassword = MD5.getEncodedString(BasicDom.getChildNodeValueByNodeName(node, "password"));}
		catch(SAXException e){}
		try{this.sPassword = BasicDom.getChildNodeValueByNodeName(node, "passwordMD5");}
		catch(SAXException e){}
		try{this.iIdUserStatus = new Double(BasicDom.getChildNodeValueDoubleByNodeName(node, "status")).intValue();}
		catch(SAXException e){}
		try{
			this.tsDateExpiration = BasicDom.getChildNodeValueXmlDateStampByNodeName(node, "dateExpiration") ;
			if(this.tsDateExpiration == null) this.tsDateExpiration = BasicDom.getChildNodeValueXmlDateStampFrenchByNodeName(node, "dateExpiration");
		} catch(SAXException e){}
		try{
			this.tsDateLastAccess = BasicDom.getChildNodeValueXmlDateStampByNodeName(node, "tsDateLastAccess") ;
			if(this.tsDateLastAccess == null) this.tsDateLastAccess = BasicDom.getChildNodeValueXmlDateStampFrenchByNodeName(node, "tsDateLastAccess");
		} catch(SAXException e){}
		
	}
	
	public static User synchronize(
			Node node, 
			Vector<User> vUserTotal, 
			long lIdPersonne,
			Connection conn) 
	throws SAXException, CoinDatabaseDuplicateException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException, CoinDatabaseCreateException, 
	CoinDatabaseLoadException, CoinDatabaseStoreException, CloneNotSupportedException
	{
		String sLogin = BasicDom.getChildNodeValueByNodeName(node, "login");

		if(sLogin == null || sLogin.equals("")){
	    	  throw new CoinDatabaseStoreException(
		    	 		"User.synchronize() login cannot be null : ", sLogin);

		}
		
		/**
		 * Login could be email or number
		 */
		if(!Outils.isEmailValide(sLogin)) {
			/**
			 * or is number ?
			 */
			try{
				Long.parseLong(sLogin);
			} catch (NumberFormatException e) {
				
				/**
				 * try alphanum + "." + "_" + "-"
				 */
			    if (!sLogin.matches("[A-Za-z0-9-_\\.]+"))
			    {
			    	CoinDatabaseStoreException ce = new CoinDatabaseStoreException(
							"User.synchronize()  invalid login : '" + sLogin 
							+ "' could be only an email address or a number or alphanum value", sLogin);
			    	System.out.println(ce.getMessage());
			    	throw ce;
			    } else {
			    	
			    	/*
			    	  throw new CoinDatabaseStoreException(
			    	 		"User.synchronize()  VALID login : '" + sLogin 
							+ "' ", sLogin);
			    	*/
			    }
			}
		} else {
		}
		
		
		User user = null;
		boolean bExistUser = false;		
		if(vUserTotal != null){
			bExistUser = User.isUserWithLogin(sLogin, vUserTotal);
		} else{
			bExistUser = User.isUserWithLogin(sLogin, conn);
		}
		
		try{
			if(vUserTotal == null) {
				user = getUserFromIdIndividual((int)lIdPersonne, false, conn);
			} else {
				/**
				 * TODO_AG #BUG_AG_IMPORT_CA_1#  BUG WORK ARROUND , sometimes the id 
				 * lIdPersonne is not found in the vUserTotal 
				 */
				try{
					user = getUserFromIdIndividual(lIdPersonne, vUserTotal);
				}catch(CoinDatabaseLoadException e){
					user = getUserFromIdIndividual((int)lIdPersonne, false, conn);
				}
			}

			/** 
			 * si le user existe deja avec ce login et que ce n'est pas ce user 
			 */
			if(bExistUser && !user.getLogin().equalsIgnoreCase(sLogin)){
				throw new CoinDatabaseDuplicateException(
						"user "+sLogin+" already exists and different from login="
						+ user.getLogin()
						+ " and idPP=" + lIdPersonne ,"");
			}
		
			/**
			 * if objects are equals don't update !
			 */
			User userTmp = (User) user.clone();
			userTmp.deserialize(node);
			if(!userTmp.equals(user)){
				user.deserialize(node);
				user.store(conn);
			}
		}catch(CoinDatabaseLoadException e){
			
			/** si le user existe deja avec ce login */
			if(bExistUser)
				throw new CoinDatabaseDuplicateException("user "+sLogin
						+ " and idPP=" + lIdPersonne
						+" already exists : " + e.getMessage(),"");
			
			user = new User();
			user.deserialize(node);
			user.create(conn);
		}

		return user;
	}

	@Override
	public boolean equals(Object obj) 
	{
		User item = (User) obj;
		boolean bEquals = true;

		/**
		 * don't verify ID
		 */
		
		if(!this.sLogin.equals(item.sLogin)) bEquals = false;
		if(!this.sPassword.equals(item.sPassword)) bEquals = false;
		if(!this.sKey.equals(item.sKey)) bEquals = false;
		if(this.iIdUserType != item.iIdUserType) bEquals = false;
		if(this.iIdUserStatus != item.iIdUserStatus) bEquals = false;
		if(this.iIdIndividual != item.iIdIndividual) bEquals = false;
		if(this.iIdColor != item.iIdColor) bEquals = false;
		if(!this.sPath.equals(item.sPath)) bEquals = false;

		if(bEquals ){
			bEquals = Outils.equalsTimestamp(this.tsDateExpiration, item.tsDateExpiration);
		}
		
		if(bEquals ){
			bEquals = Outils.equalsTimestamp(this.tsDateLastAccess, item.tsDateLastAccess);
		}
		if(this.lIdCoinUserAccessModuleType != item.lIdCoinUserAccessModuleType) bEquals = false;
		
		return bEquals;
	}
	
	@Override
	protected Object clone() 
	throws CloneNotSupportedException 
	{
		User item = new User();

		item.lId = this.lId;
		item.sLogin = this.sLogin;
		item.sPassword = this.sPassword;
		item.sKey = this.sKey;
		item.iIdUserType = this.iIdUserType;
		item.iIdUserStatus = this.iIdUserStatus;
		item.iIdIndividual = this.iIdIndividual;
		item.iIdColor = this.iIdColor;
		item.sPath = this.sPath;
		item.tsDateExpiration = this.tsDateExpiration;
		item.tsDateLastAccess = this.tsDateLastAccess;
		item.lIdCoinUserAccessModuleType = this.lIdCoinUserAccessModuleType;

		return item;
	}
	
	@RemoteMethod
    public static Map<String,Object> login(String sLogin, String sPwd) throws Exception {
		Map<String,Object> map = new HashMap<String,Object>();
		
		User user = DwrSession.getUser();
		HttpSession session = DwrSession.getSession();
		int iCode = user.logonSecure(sLogin, sPwd, session.getAttribute("sMotCache").toString());
		
		UserHabilitation userHab = (UserHabilitation)session.getAttribute("sessionUserHabilitation");
		userHab.setHabilitations(user.getIdUser(), true);
		
		
		map.put("lIdUserType", user.getIdUserType());
		map.put("lIdPersonnePhysique", user.getIdIndividual());
		map.put("iCode", iCode);
		
		return map;
	}
	
}