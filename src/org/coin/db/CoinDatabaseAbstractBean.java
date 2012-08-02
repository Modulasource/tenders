package org.coin.db;

import java.io.Serializable;
import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.Map;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.perf.Mesure;
import org.coin.localization.Language;
import org.coin.security.PreventInjection;
import org.json.JSONException;
import org.json.JSONObject;
/**
 * @author d.keller
 * @version $Id: CoinDatabaseAbstractBean.java,v 1.121 2009/04/01 10:58:53 julien.renier Exp $
 *
 */
public abstract class CoinDatabaseAbstractBean implements Serializable, CoinDatabaseInterface{
	private static final long serialVersionUID = 1L;

	public final static boolean DEFAULT_PREVENT_INJECTION = true;
	
	/** to retrieve external reference instead of name */
	public boolean bUseExternalReference = false;
	
	/**
	 * to switch to localized bean.
	 * for each class you need to provide this parameter :
	 * 
	 * for PRIMARY_KEY_TYPE_LONG
	 *   public static String [][]s_sarrLocalization; 
	 * 
	 * for PRIMARY_KEY_TYPE_STRING
	 *   protected static Map<String,String>[] s_sarrLocalization;
	 *   
	 */
	public boolean bUseLocalization = false;
	public int iAbstractBeanIdLanguage;
	
	public void setAbstractBeanLocalization(
			Language language) 
	{
		this.bUseLocalization = true;
		this.iAbstractBeanIdLanguage = (int)language.getId();
	}
	
	public void setAbstractBeanLocalization(
			long lIdLanguage) 
	{
		this.bUseLocalization = true;
		this.iAbstractBeanIdLanguage = (int)lIdLanguage;
	}
	
	public void setAbstractBeanLocalization(
			CoinDatabaseAbstractBean item) 
	{
		this.bUseLocalization = item.bUseLocalization;
		this.iAbstractBeanIdLanguage = item.iAbstractBeanIdLanguage;
	}
	
	public void setAbstractBeanConnexion(
			CoinDatabaseAbstractBean item) 
	{
		this.bUseHttpPrevent= item.bUseHttpPrevent;
		
		this.bUseEmbeddedConnection = item.bUseEmbeddedConnection;
		this.connEmbeddedConnection = item.connEmbeddedConnection;
		this.bPropagateEmbeddedConnection = item.bPropagateEmbeddedConnection;
	}
	
	public void setAbstractBeanConnexion(
			Connection conn) throws SQLException 
	{
		if(conn != null && !conn.isClosed()){
			this.bUseEmbeddedConnection = true;
			this.connEmbeddedConnection = conn;
		}
	}
	
	public void setAbstractBeanLocalizationAndConnexion(
			CoinDatabaseAbstractBean item) 
	{
		setAbstractBeanLocalization(item);
		setAbstractBeanConnexion(item);
	}
	
	
	public void updateLocalization() 
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{

		Connection conn = this.getConnection();
		try {
			updateLocalization( conn);
		}  finally{
			this.releaseConnection(conn);	
		}
	}
	
	
	/**
	 * to override
	 */
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
	}

	public Map<String,String>[]  getLocalizationLabel(
			Map<String,String>[] sarrLocalizationLabel) {
		return getLocalizationLabel(sarrLocalizationLabel, false);
	}
	
	public Map<String,String>[]  getLocalizationLabel(
			Map<String,String>[] sarrLocalizationLabel,
			boolean bForceReload) {
		
		if(sarrLocalizationLabel != null && !bForceReload) return sarrLocalizationLabel;
		
		try{
			Connection conn = this.getConnection();
			try {
				sarrLocalizationLabel 
					= ObjectAttributeLocalization
						.generateAttributeLocalizationMatrixString(this.iAbstractBeanIdObjectType, conn);
			
			} finally{
				this.releaseConnection(conn);	
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return sarrLocalizationLabel; 
	}
    
	
	/**
	 * Object type of the bean
	 * @see ObjectType
	 */
	protected int iAbstractBeanIdObjectType;

	
	
	/**
	 *  true : table is in AUTO INCREMENT 
	 *  false : table is normal mode
	 */
	protected boolean bAutoIncrement = true;
	
	/** 
	 * Petite feinte pour SQL Server. Il faut ajouter avant et apres le insert les commadne suivantes :
	 *  
	 * 
	   	SET IDENTITY_INSERT table_xxx ON
		INSERT INTO table_xxx (a, b, .. ) VALUES (?, ?)
		SET IDENTITY_INSERT table_xxx OFF
		
	 * @see http://sqlpro.developpez.com/cours/sqlserver/transactsql/#L2.6
	 * 
	 * 
	 	CREATE TABLE client
		(id_client INTEGER IDENTITY NOT NULL PRIMARY KEY,
		 client_name VARCHAR(32))
		
		SET IDENTITY_INSERT client ON
		
		INSERT INTO client (id_client, client_name) VALUES (325, 'DUPONT')
		INSERT INTO client (id_client, client_name) VALUES (987, 'MARTIN')
		
		SET IDENTITY_INSERT client OFF
		
		INSERT INTO client (id_client, client_name) VALUES (512, 'LEVY')
		=> Serveur: Msg 544, Niveau 16, État 1, Ligne 1
		Impossible d'insérer une valeur explicite dans la colonne identité de la table 'client' 
		quand IDENTITY_INSERT est défini à OFF.
	 * 
	 */
	protected boolean bIsAutoIncrementTable = true;

	/**
	 * sous MySql il y a un bug de m.. il ne fait plus le fetch des rows une à une
	 * http://dev.mysql.com/doc/refman/5.0/en/connector-j-reference-implementation-notes.html
	 * 
	 * il faut remplacer 
	 * stmt = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
              java.sql.ResultSet.CONCUR_READ_ONLY);
	 * 
	 * par
	 * 
	 * stmt = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
              java.sql.ResultSet.CONCUR_READ_ONLY);
		stmt.setFetchSize(Integer.MIN_VALUE);
	 *
	 * mais cela crée des autres pbs comme celui ci:
	 * Streaming result set com.mysql.jdbc.RowDataDynamic@1c74f37 is still active.
	 * No statements may be issued when any streaming result sets are open and in use on a given connection. 
	 * Ensure that you have called .close() on any active streaming result sets before attempting more queries.
	 * 
	 * il faudra peut-etre forcer ce type de valeur dans le load().
	 * 
	 * pour le moment on peut passer par 2 conn différentes, l'une pour le long SELECT, l'autre pour les updates
	 * 
	 */
	//public boolean bForceStreamingResultset = false;
	
	/** Type de cle primaire Integer = 1 */
	public static final int PRIMARY_KEY_TYPE_INTEGER = 1;
	/** Type de cle primaire Long = 2 */
	public static final int PRIMARY_KEY_TYPE_LONG = 2;
	/** Type de cle primaire String = 3 */
	public static final int PRIMARY_KEY_TYPE_STRING = 3;

	public static boolean TRACE_QUERY_STORE_IN_DB = false;
	public static String  TRACE_QUERY_STORE_IN_DB_PARAM = "";
	public static boolean TRACE_QUERY = false;
	public static boolean TRACE_STACK = false;

	/** Type de cle primare : par defaut elle est en long **/
	protected int PRIMARY_KEY_TYPE = PRIMARY_KEY_TYPE_LONG ;

	public int getPrimaryKeyType()
	{
		return PRIMARY_KEY_TYPE ;
	}

	/**
	 * Ces champs doivent être instancie dans la methode init() 
	 */
	public String TABLE_NAME ;
	public String FIELD_ID_NAME ;
	/**
	 *  il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
	 */
	public int SELECT_FIELDS_NAME_SIZE ; 
	public String SELECT_FIELDS_NAME ;

	protected String sSqlCreateRequest;
	protected boolean bSqlCreateRequestBuild;

	/** ici l'id est un long */
	protected long lId;
	/** ici l'id est un long */
	protected String sId;

	/** nom du champ dans le formulaire HTML : ce n'est pas encore utilise ... a voir */
	public String sHtmlFormFieldName ;

	/**
	 * SECURITY : activer ou desactiver le PreventLoad
	 */
	public boolean bUseHttpPrevent = true;

	/**
	 * Permet de desactiver tous les filtres sur les champs
	 */
	public boolean bUseFieldValueFilter = true;

	/**
	 * 
	 * @param sData
	 * @return
	 */

	public String preventLoad(String sData) {
		if(this.bUseFieldValueFilter )
			return PreventInjection.preventLoad(sData,this.bUseHttpPrevent);

		return sData;
	}

	/**
	 * 
	 * @param sData
	 * @return
	 */
	public String preventStore(String sData) {
		if(this.bUseFieldValueFilter )
			return PreventInjection.preventStore(sData,this.bUseHttpPrevent);

		return sData;
	}


	/**
	 * 
	 * @param sData
	 * @return
	 */
	public String preventXml(String sData) {
		if(this.bUseFieldValueFilter )
			return PreventInjection.preventXML(sData);

		return sData;
	}
	
	/**
	 * 
	 * @param sData
	 * @return
	 */
	public String preventForJavascript(String sData) {
		return preventForJavascript(sData, true);
	}
	/**
	 * 
	 * @param sData
	 * @param bUseNl2Br
	 * @return
	 */
	public String preventForJavascript(String sData, boolean bUseNl2Br) {
		if(this.bUseFieldValueFilter )
			return PreventInjection.preventForJavascript(sData,this.bUseHttpPrevent, bUseNl2Br);
		return sData;
	}

	/**
	 * Pour la connexion embarquee : la connexion
	 */
	public Connection connEmbeddedConnection = null;
	/**
	 * Pour la connexion embarquee : le boolean
	 */
	public boolean bUseEmbeddedConnection = false;
	
	/**
	 * to enable the propagation of the connection of the created objects during 
	 * a getAll() operation
	 */
	public boolean bPropagateEmbeddedConnection = false;

	public void setAbstractBeanIdLanguage(long ldLanguage) {
		this.iAbstractBeanIdLanguage = (int)ldLanguage;
	}
	
	public void setAbstractBeanIdLanguage(int idLanguage) {
		this.iAbstractBeanIdLanguage = idLanguage;
	}
	
	public void setAbstractBeanIdObjectType(int idObjectType) {
		this.iAbstractBeanIdObjectType = idObjectType;
	}
	
	public int getAbstractBeanIdLanguage() {
		return this.iAbstractBeanIdLanguage;
	}
	
	public int getAbstractBeanIdObjectType() {
		return this.iAbstractBeanIdObjectType;
	}
	
	/**
	 * 
	 * @param sSqlQuery
	 */
	public final void traceQuery(String sSqlQuery)
	{
		traceQueryStatic(sSqlQuery, this);
	}

	/**
	 * 
	 * @param sSqlQuery
	 */
	public static final void traceQueryStatic(String sSqlQuery)
	{
		traceQueryStatic(sSqlQuery, null);
	}

	/**
	 * 
	 * @param sSqlQuery
	 * @param item
	 */
	public static final void traceQueryStatic(String sSqlQuery, CoinDatabaseAbstractBean item)
	{

		if(CoinDatabaseAbstractBean.TRACE_QUERY)
		{
			System.out.println("<traceQuery>\n" +  sSqlQuery );
			String sClassName = null;

			if(item != null ) {
				sClassName = item.getClass().getName();
				if(item.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG
						|| item.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER)
					sClassName += " id=" + item.getId() ;
				else sClassName += " idString=" + item.getIdString();
			}
			else sClassName = "inconnue";

			Exception e = new Exception("Fausse Exception pour afficher l'etat de la pile. Classe : " + sClassName);

			if(CoinDatabaseAbstractBean.TRACE_STACK)
			{
				System.out.println("\n<traceStack>\n");
				e.printStackTrace();
				System.out.println("\n</traceStack>\n");

			}

			if(CoinDatabaseAbstractBean.TRACE_QUERY_STORE_IN_DB)
			{
				System.out.println("\n<queryStoreInDatabase  value='true' />\n");
				Mesure mesure = new Mesure ();
				mesure.setMesureName("TRACE_QUERY_STORE_IN_DB");
				mesure.setParameters(TRACE_QUERY_STORE_IN_DB_PARAM);
				mesure.setUrlRequested(sSqlQuery);
				mesure.setException(e);
				mesure.bUseHttpPrevent = item.bUseHttpPrevent ; 
				mesure.bUseEmbeddedConnection = item.bUseEmbeddedConnection; 
				mesure.connEmbeddedConnection = item.connEmbeddedConnection ; 
				try {
					mesure.create();
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
			System.out.println("\n</traceQuery>\n");
		}

	}

	/*
	public ArrayList<HashMap<String,String>> variables = null;
	public abstract void populateVariables();
	public ArrayList<HashMap<String,String>> getVariables() {
		if(this.variables == null) 
		{
			this.getVariables();
		} 
		return this.variables;
	}
	 */
	/**
	 * @param sAlias
	 * @return ajoute l'alias devant les champs ; 
	 * exemple : "titi, tata,tutu,    toto" retourne "alias.titi, alias.tata,alias.tutu,     alias.toto" 
	 */
	public String getSelectFieldsName(String sAlias)
	{
		return this.SELECT_FIELDS_NAME.replaceAll(
				"(^|[ ,]*)([a-zA-Z0-9_-]*[a-zA-Z0-9])($|[ ,]*)",
				"$1" + sAlias + "$2$3"
		);
	}

	/**
	 * @param sAlias
	 * @param sFieldsName
	 * @return ajoute l'alias devant les champs ;
	 * exemple : "titi, tata,tutu,    toto" retourne "alias.titi, alias.tata,alias.tutu,     alias.toto"
	 */
	public static String getSelectFieldsName(String sFieldsName, String sAlias)
	{
		return sFieldsName.replaceAll(
				"(^|[ ,]*)([a-zA-Z0-9_-]*[a-zA-Z0-9])($|[ ,]*)",
				"$1" + sAlias + "$2$3"
		);
	}
	
	public static String getSelectFieldsName(String sFieldsName, String sAlias, String sAliasColumnPrefix)
	{
		return sFieldsName.replaceAll(
				"(^|[ ,]*)([a-zA-Z0-9_-]*[a-zA-Z0-9])($|[ ,]*)",
				"$1" + sAlias + "$2 as "+sAliasColumnPrefix+"$2$3"
		);
	}

	public void setAutoIncrement(boolean autoIncrement) {
		this.bAutoIncrement = autoIncrement;
	}	
	public boolean isAutoIncrement() {
		return this.bAutoIncrement;
	}
	/**
	 * Methode ajoutant un enregistrement dans la table adresse
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws CoinDatabaseLoadException 
	 * @throws DatabaseDuplicateException 
	 * @throws DatabaseLoadException 
	 * @throws Exception 
	 */
	public void create() 
	throws CoinDatabaseCreateException, SQLException, NamingException, 
	CoinDatabaseDuplicateException, CoinDatabaseLoadException 
	{

		Connection conn = this.getConnection();
		try {
			create( conn);
		}  finally{
			this.releaseConnection(conn);	
		}
	}

	/**
	 * 
	 * @return
	 */
	private final String getPrimaryKeyValue()
	{
		String  sIdValue  = "";
		if ((this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER )
				|| (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG))
		{
			sIdValue   = "" + this.lId;
		}

		if (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_STRING)
		{
			sIdValue   = "\'" + this.sId.replaceAll("\'", "\'\'") + "\'";
		}

		return sIdValue;
	}

	/**
	 * Methode renvoyant la requete SQL de creation d'un item en bdd
	 * @return String
	 */
	public String getSQLCreateRequest()
	{
		String  sIdValue = "NULL";
		String sPostQuery = "";
		String sFieldId = this.FIELD_ID_NAME + ", ";
		boolean bAddFirstCommaToValueList = true;

		if(this.bAutoIncrement)
		{
			if(this.bSqlCreateRequestBuild)
				return this.sSqlCreateRequest;

			switch (ConnectionManager.getDbType()) {
			case ConnectionManager.DBTYPE_ORACLE:
				sIdValue   = "seq_"+ this.TABLE_NAME +".nextval";			
				break;

			case ConnectionManager.DBTYPE_MYSQL:
				sIdValue = "NULL";
				break;

			case ConnectionManager.DBTYPE_SQL_SERVER:
				bAddFirstCommaToValueList = false;
				sIdValue = "";
				sFieldId = "";
				sPostQuery = ";SELECT @@IDENTITY";
				break;

			default:
				sIdValue = "NULL";
			}

		}
		else
		{
			sIdValue = getPrimaryKeyValue();
		}

		String sSqlQuery= "INSERT INTO " + this.TABLE_NAME + " ( "
		+ sFieldId
		+ this.SELECT_FIELDS_NAME
		+ " ) VALUES ("+ sIdValue +" ";

		for (int i = 0; i < this.SELECT_FIELDS_NAME_SIZE; i++) {
			boolean bAddComma = true;
			if(!bAddFirstCommaToValueList && i == 0) 
			{
				bAddComma = false;
			}

			sSqlQuery += (bAddComma?",":"") + "? ";
		}
		sSqlQuery += " )" 
			+ sPostQuery;

		this.sSqlCreateRequest = sSqlQuery ;
		this.bSqlCreateRequestBuild = true;

		return sSqlQuery;
	}

	public void update()
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException, SQLException, NamingException, CoinDatabaseStoreException 
	{
		Connection conn = this.getConnection();
		try {
			update( conn);
		}  finally{
			this.releaseConnection(conn);	
		}
	}
	
	public void update(Connection conn )
	throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException, 
	SQLException, NamingException, CoinDatabaseStoreException 
	{
		if (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER
		|| this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG)
		{
			if(this.lId>0)
			{
				store(conn);
			} else {
				create(conn);
			}
		} else if (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_STRING) {
			if(this.sId != null && !this.sId.equals(""))
			{
				store(conn);
			} else {
				create(conn);
			}
		}
	}
	
	/**
	 * Methode ajoutant un enregistrement dans la table adresse
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws NamingException 
	 * @throws DatabaseDuplicateException 
	 * @throws DatabaseLoadException 
	 * @throws Exception 
	 */
	public void create(Connection conn ) 
	throws CoinDatabaseCreateException, SQLException, 
	CoinDatabaseDuplicateException, CoinDatabaseLoadException, NamingException {

		/*String  sIdValue = "NULL";

		if(this.bAutoIncrement)
		{
			if(DBTYPE == ConnectionManager.DBTYPE_ORACLE)
				sIdValue   = "seq_"+ this.TABLE_NAME +".nextval";
			else
				sIdValue = "NULL";
		}
		else
		{
			sIdValue   = "" + this.lId;
		}*/

		String sSqlQuery = getSQLCreateRequest();

		traceQuery(sSqlQuery);

		Statement stat = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			if(ConnectionManager.getDbType() == ConnectionManager.DBTYPE_SQL_SERVER 
			&& this.bAutoIncrement)
			{
				/**
				 * Ici c'est particulier il faut avoir l'option Indentity et faire une double requête
				 * @see http://support.microsoft.com/kb/313130/fr
				 */
				
				CallableStatement callstmt = conn.prepareCall(sSqlQuery);
				setPreparedStatement(callstmt);
				callstmt.execute();
	
				int iUpdCount = callstmt.getUpdateCount();
				boolean bMoreResults = true;
				
				while (bMoreResults || iUpdCount!=-1)
				{			
					rs = callstmt.getResultSet();
	
					//Use the following if using the batch statement instead of the stored procedure
					//if rs is not null, we know we can get the results from the SELECT @@IDENTITY
	
					if (rs != null)
					{
						rs.next();
						this.lId = rs.getLong(1);
					}
	
					//get the next resultset, if there is one
					//this call also implicitly closes the previously obtained ResultSet
					bMoreResults = callstmt.getMoreResults();
					iUpdCount = callstmt.getUpdateCount();
				}
				
				callstmt.close();
				//return ;
			} else if(ConnectionManager.getDbType() == ConnectionManager.DBTYPE_SQL_SERVER
			&& (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER || this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG)
			&& this.bIsAutoIncrementTable )
			{
				try{
					sSqlQuery = "SET IDENTITY_INSERT " + this.TABLE_NAME + " ON " 
						+ sSqlQuery
						+ " SET IDENTITY_INSERT " + this.TABLE_NAME + " OFF " ;
					
					CallableStatement callstmt = conn.prepareCall(sSqlQuery);
					setPreparedStatement(callstmt);
					callstmt.execute();
					callstmt.close();
					//return ;
				} catch (Exception e ){
					throw new CoinDatabaseCreateException(e.getMessage(), sSqlQuery );
				}
				
			} else {
			
				stat = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
						java.sql.ResultSet.CONCUR_UPDATABLE);
				ps = (stat.getConnection()).prepareStatement(sSqlQuery);
				setPreparedStatement(ps);
				//ps = PreventInjection.setSecurePreparedStatement(ps, this.variables, this);	
				ps.executeUpdate();
	
				if(ConnectionManager.getDbType() == ConnectionManager.DBTYPE_MYSQL)
				{
					if(this.bAutoIncrement)
					{
						rs = stat.executeQuery("SELECT LAST_INSERT_ID()");
						if (rs.next()) 
						{
							if ((this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER )
									|| (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG))
							{
								this.lId= rs.getInt(1);
							}else{
								throw new CoinDatabaseCreateException("this object have not a numeric primary key and can't be auto incremented", sSqlQuery );
							}
						}
						else 
						{
							throw new CoinDatabaseCreateException(sSqlQuery );
						}
					}
				}
			}
		}
		finally 
		{
			ConnectionManager.closeConnection(rs,stat,ps);
			this.onAfterCreate(conn);
		}
	}

	/**
	 * Methode supprimant l'enregistrement identifie par id dans la table adresse
	 * @param id - identifiant de l'enregistrement a supprimer
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public void remove(int id) throws SQLException, NamingException {
		String sSqlQuery = "DELETE FROM " + this.TABLE_NAME + " WHERE " 
		+ this.FIELD_ID_NAME +"='"+ id + "'";

		ConnectionManager.executeUpdate(sSqlQuery);
	}

	/**
	 * 
	 * @param id
	 * @throws SQLException
	 * @throws NamingException
	 */
	public void remove(long id) throws SQLException, NamingException {

		String sSqlQuery = "DELETE FROM " + this.TABLE_NAME + " WHERE " 
		+ this.FIELD_ID_NAME +"='"+ id + "'";

		ConnectionManager.executeUpdate(sSqlQuery);
	}

	/**
	 * 
	 * @param sId
	 * @throws SQLException
	 * @throws NamingException
	 */
	public void removeFromPK(String sId) throws SQLException, NamingException {
		Connection conn = this.getConnection();
		try {
			removeFromPK(sId, conn);
		} finally{
			this.releaseConnection(conn);	
		}
	}

	/**
	 * 
	 * @param sId
	 * @param conn
	 * @throws SQLException
	 * @throws NamingException 
	 * @throws NamingException
	 */
	protected void removeFromPK(String sId, Connection conn) throws SQLException, NamingException {
		String sSqlQuery = "DELETE FROM " + this.TABLE_NAME + " WHERE "
		+ this.FIELD_ID_NAME +"="+ sId ;

		ConnectionManager.executeUpdate(sSqlQuery, conn);
	}



	/**
	 * 
	 * @param sWhereClause
	 * @throws SQLException
	 * @throws NamingException
	 */
	public void remove(String sWhereClause) throws SQLException, NamingException {
		String sSqlQuery 
		= "DELETE FROM " + this.TABLE_NAME + " "
		+ sWhereClause ;

		ConnectionManager.executeUpdate(sSqlQuery);
	}

	/**
	 * 
	 * @param sTable
	 * @param sWhereClause
	 * @throws SQLException
	 * @throws NamingException
	 */
	public void remove(String sTable , String sWhereClause) throws SQLException, NamingException {
		String sSqlQuery 
		= "DELETE "+this.TABLE_NAME +sTable+" FROM " + this.TABLE_NAME + " "
		+ sWhereClause ;
		ConnectionManager.executeUpdate(sSqlQuery);
	}
	
	/**
	 * 
	 * @param sTable
	 * @param sWhereClause
	 * @throws SQLException
	 * @throws NamingException
	 */
	public void remove(String sTable , String sWhereClause, Connection conn) throws SQLException, NamingException {
		String sSqlQuery 
		= "DELETE "+this.TABLE_NAME +sTable+" FROM " + this.TABLE_NAME + " "
		+ sWhereClause ;
		ConnectionManager.executeUpdate(sSqlQuery,conn);
	}

	/**
	 * 
	 * @param sWhereClause
	 * @param conn
	 * @throws SQLException
	 * @throws NamingException 
	 * @throws NamingException
	 */
	public void remove(String sWhereClause, Connection conn) throws SQLException, NamingException {
		String sSqlQuery 
		= "DELETE FROM " + this.TABLE_NAME + " "
		+ sWhereClause ;

		ConnectionManager.executeUpdate(sSqlQuery, conn);
	}

	/**
	 * Methode supprimant l'enregistrement associe a l'objet Adresse
	 * dans la table adresse
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public void remove() throws SQLException, NamingException {
		Connection conn = this.getConnection();
		try {
			remove(conn);
		} finally{
			this.releaseConnection(conn);	
		}
	}



	/**
	 * Methode supprimant l'enregistrement associe e l'objet Adresse
	 * dans la table adresse
	 * @throws SQLException
	 * @throws NamingException 
	 * @throws NamingException
	 */
	public void remove(Connection conn) throws SQLException, NamingException {
		this.removeFromPK(getPrimaryKeyValue(), conn);
		this.onAfterRemove(conn);
	}

	/**
	 * Methode renvoyant la requete SQL de store d'un item en bdd
	 * Elle utilise un Full PreparedStatment pour augmenter la rapidite de traitement
	 * @return String
	 */
	public String getSQLStoreRequest()
	{
		String sSQLQuery =	"UPDATE " + this.TABLE_NAME
		+ " SET "
		+ this.SELECT_FIELDS_NAME.replaceAll(",", "=?,") + "=?"
		//+ " WHERE " + this.FIELD_ID_NAME + "=" + getPrimaryKeyValue();
		+ " WHERE " + this.FIELD_ID_NAME + "=?";

		return sSQLQuery;
	}


	/**
	 * Met a jour la base avec les donnees de l'objet 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws CoinDatabaseStoreException 
	 */
	public void store() throws SQLException, NamingException, CoinDatabaseStoreException {
		Connection conn = this.getConnection();
		try {
			store(conn);
		} finally{
			this.releaseConnection(conn);		
		}

	}

	public void setPreparedStatementPrimaryKey(PreparedStatement ps, int iIndex) throws SQLException {
		if ((this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER )
				|| (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG))
		{
			ps.setLong(iIndex, this.lId);
		}

		if (this.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_STRING)
		{
			ps.setString(iIndex, this.sId);
		}
	}

	/**
	 * Met a jour la base avec les donnees de l'objet 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws NamingException 
	 */
	public void store(Connection conn) throws SQLException, NamingException,CoinDatabaseStoreException {
		
		String sSQLQuery =	getSQLStoreRequest();

		traceQuery(sSQLQuery);

		Statement stat = null;
		PreparedStatement ps = null;

		try {
			stat = conn.createStatement();
			ps = (stat.getConnection()).prepareStatement(sSQLQuery);
			setPreparedStatement (ps);
			setPreparedStatementPrimaryKey(ps, this.SELECT_FIELDS_NAME_SIZE + 1);
			//ps = PreventInjection.setSecurePreparedStatement(ps, this.variables, this);
			ps.executeUpdate();
			
			this.onAfterStore(conn);
			
		} finally {
			ConnectionManager.closeConnection(ps);
			ConnectionManager.closeConnection(stat);
		}
		
	}
	

	
	
//	/**
//	 * Return true if this object is historizable
//	 * @return
//	 * @throws NamingException
//	 * @throws SQLException
//	 */
//	protected boolean isHistorizable() throws NamingException, SQLException{
//		Connection conn = this.getConnection();
//		boolean result = false;
//		try {
//			isHistorizable(conn);
//		} finally{
//			this.releaseConnection(conn);
//		}
//		return result;
//	}
//	
//	/**
//	 * Return true if this object is historizable
//	 * @param conn
//	 * @return
//	 */
//	protected boolean isHistorizable(Connection conn){
//		return false;
//	}

	/**
	 * 
	 */
	public void load() throws SQLException, CoinDatabaseLoadException, NamingException 
	{
		Connection conn = this.getConnection();

		try {
			load(conn);
		} finally{
			this.releaseConnection(conn);		
		}
	}

	/**
	 * Methode renvoyant la requete SQL de load d'un item en bdd
	 * @return String
	 */
	public String getSQLLoadRequest()
	{
		String sSqlQuery =
			"SELECT "
			+ this.SELECT_FIELDS_NAME
			+ " FROM " + this.TABLE_NAME
			//+ " WHERE " + this.FIELD_ID_NAME + " = " + getPrimaryKeyValue();
			+ " WHERE " + this.FIELD_ID_NAME + "=?";

		return sSqlQuery;
	}

	/**
	 * Methode renvoyant la requete SQL de load d'un item en bdd
	 * @return String
	 */
	public String getAllSelect()
	{
		String sSqlQuery =
			"SELECT "
			+ this.SELECT_FIELDS_NAME + "," + this.FIELD_ID_NAME
			+ " FROM " + this.TABLE_NAME;

		return sSqlQuery;
	}

	/**
	 * 
	 * @param sAlias
	 * @return
	 */
	public String getAllSelect(String sAlias)
	{
		String sSqlQuery = "";
		if(isNullOrBlank(sAlias)){
			sSqlQuery = getAllSelect();
		}else{
			sSqlQuery =
				"SELECT "
				+ getSelectFieldsName(this.SELECT_FIELDS_NAME,sAlias) + ","+sAlias + this.FIELD_ID_NAME
				+ " FROM " + this.TABLE_NAME + " "+sAlias.substring(0,sAlias.length()-1);
		}
		
		return sSqlQuery;
	}
	
    public static final boolean isNullOrBlank(String sValue)
    {
    	if( sValue == null 
    	|| sValue.equalsIgnoreCase("") 
    	|| sValue.equalsIgnoreCase("null")
    	|| sValue.equalsIgnoreCase("undefined"))
    		return true;
    	
    	return false;
    }

	/**
	 * 
	 * @param sAlias
	 * @return
	 */
	public String getAllSelectDistinct(String sAlias)
	{
		String sSqlQuery =
			"SELECT DISTINCT "
			+ getSelectFieldsName(this.SELECT_FIELDS_NAME,sAlias) + ","+sAlias + this.FIELD_ID_NAME
			+ " FROM " + this.TABLE_NAME + " "+sAlias.substring(0,sAlias.length()-1);

		return sSqlQuery;
	}


	/**
	 * Recherche l'objet en base de donnees et charge les champs 
	 * @throws NamingException 
	 * @throws DatabaseLoadException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public void load(Connection conn) throws  CoinDatabaseLoadException, SQLException, NamingException {
		String sSqlQuery = getSQLLoadRequest();

		traceQuery(sSqlQuery);

		Statement stat = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			stat = conn.createStatement();
			ps = (stat.getConnection()).prepareStatement(sSqlQuery );
			setPreparedStatementPrimaryKey(ps, 1);
			rs = ps.executeQuery();

			if(rs.next()) {
				setFromResultSet(rs);
				onAfterLoad(conn);
			}
			else
			{
				throw new CoinDatabaseLoadException( getPrimaryKeyValue(), sSqlQuery);
			}
		}
		finally 
		{
			ConnectionManager.closeConnection(rs,stat);
		}
	}
	
	/**
	 * nothing to do
	 * @param conn
	 */
	protected void onAfterCreate(Connection conn) {
		//Nothing to do
	}
	
	/**
	 * nothing to do
	 * @param conn
	 */
	protected void onAfterLoad(Connection conn) {
		//Nothing to do
	}
	
	/**
	 * nothing to do
	 */
	protected void onAfterStore(Connection conn) {
		//Nothing to do
	}
	
	/**
	 * nothing to do
	 */
	protected void onAfterRemove(Connection conn) {
		//Nothing to do
	}

	/**
	 * 
	 * @param id
	 */
	public void setId(long id) {
		this.lId = id;
	}

	/**
	 * 
	 * @param id
	 */
	public void setId(int id) {
		this.lId = id;
	}

	/**
	 * 
	 * @return
	 */
	public long getId() {
		return this.lId;
	}

	/**
	 * Ici on ne peut pas malheureusement pas choisir la sortie pour le cast
	 * @return
	 */
	public String  getIdString() {
		return this.sId;
	}
	
	public String getIdToString() {
		if(this.getPrimaryKeyType()==PRIMARY_KEY_TYPE_INTEGER
		|| this.getPrimaryKeyType()==PRIMARY_KEY_TYPE_LONG)
			return ""+this.getId();
		else if(this.getPrimaryKeyType()==PRIMARY_KEY_TYPE_STRING)
			return this.sId;
		return null;
	}

	/**
	 * 
	 * @param sId
	 */
	public void setId(String sId) {
		this.sId = sId;
	}

	/**
	 * 
	 * @param <T>
	 * @param objTypeToLoad
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static <T> Vector<T> getAll(CoinDatabaseAbstractBean objTypeToLoad) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Connection conn = objTypeToLoad.getConnection();
		Vector v = null;
		try {
			v = getAll(objTypeToLoad, conn);
		} finally{
			objTypeToLoad.releaseConnection(conn);	
		}
		return v;
	}


	/**
	 * 
	 * @param <T>
	 * @param conn
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public  <T> Vector<T > getAll( Connection conn) 
	throws InstantiationException, IllegalAccessException, SQLException { 
		return getAll(this, conn);
	}

	/**
	 * Return all elements corresponding of the bean in the table 
	 * 
	 * @param <T>
	 * @param sSQLQuery
	 * @param objTypeToLoad
	 * @param conn
	 * @return un vecteur contenant tout les elements specifie par la requette
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static <T> Vector<T> getAll(CoinDatabaseAbstractBean objTypeToLoad, Connection conn) 
	throws InstantiationException, IllegalAccessException, SQLException { 
		String sSqlQuery
		= "SELECT " + objTypeToLoad.SELECT_FIELDS_NAME + ", " + objTypeToLoad.FIELD_ID_NAME
		+ " FROM " + objTypeToLoad.TABLE_NAME;

		return getAllWithSqlQuery(sSqlQuery,objTypeToLoad, conn );
	}


	/**
	 * Recupere l'objet en base ou en cree en memoire un nouveau via un new()
	 * 
	 * @param lId id recherche en base de donnees
	 * @param item classe heritant de CoinDatabaseAbstractBean
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws CoinDatabaseCreateException
	 * @throws CoinDatabaseDuplicateException
	 * @throws CoinDatabaseLoadException
	 */
	public static CoinDatabaseAbstractBean getOrNewAbstractBean(
			long lId, 
			CoinDatabaseAbstractBean item) 
	throws SQLException, NamingException, CoinDatabaseCreateException, 
	CoinDatabaseDuplicateException, CoinDatabaseLoadException 
	{

		return getOrNewAbstractBean(lId, item, false); 
	}

	/**
	 * Recupere l'objet en base ou en cree en memoire un nouveau via un new()
	 * 
	 * @param lId id recherche en base de donnees
	 * @param item classe heritant de CoinDatabaseAbstractBean
	 * @param bCreate si vrai alors l'objet est cree en base de donnees lorsqu'il n'exite pas
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws CoinDatabaseCreateException
	 * @throws CoinDatabaseDuplicateException
	 * @throws CoinDatabaseLoadException
	 */
	public static CoinDatabaseAbstractBean getOrNewAbstractBean(
			long lId, 
			CoinDatabaseAbstractBean item, 
			boolean bCreate) 
	throws SQLException, NamingException, CoinDatabaseCreateException, 
	CoinDatabaseDuplicateException, CoinDatabaseLoadException 
	{
		try {
			item.setId(lId);
			item.load();
		} catch (CoinDatabaseLoadException e) {
			if(bCreate) item.create();
		}
		return item; 
	}

	/**
	 * 
	 * @param <T>
	 * @param sSQLQuery
	 * @param objTypeToLoad
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static <T> Vector<T> getAllWithSqlQuery(
			String sSQLQuery, 
			CoinDatabaseAbstractBean objTypeToLoad) 
			throws InstantiationException, IllegalAccessException, NamingException, SQLException 
			{
		Connection conn = objTypeToLoad.getConnection();
		Vector v = null;
		try {
			v = getAllWithSqlQuery(sSQLQuery, objTypeToLoad, conn);
		} finally{
			objTypeToLoad.releaseConnection(conn);	
		}
		return v;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static <T> Vector<T> getAllWithSqlQuery(
			String sSQLQuery, 
			Vector<Object> vParams,
			CoinDatabaseAbstractBean objTypeToLoad) 
			throws InstantiationException, IllegalAccessException, NamingException, SQLException 
			{
		Connection conn = objTypeToLoad.getConnection();
		Vector v = null;
		try {
			v = getAllWithSqlQuery(sSQLQuery, objTypeToLoad, vParams, conn);
		} finally{
			objTypeToLoad.releaseConnection(conn);	
		}
		return v;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static <T> Vector<T> getAllWithSqlQuery(
			String sSQLQuery, 
			Vector<Object> vParams,
			CoinDatabaseAbstractBean objTypeToLoad,
			Connection conn) 
			throws InstantiationException, IllegalAccessException, NamingException, SQLException 
			{
		Vector v = null;
		try {
			v = getAllWithSqlQuery(sSQLQuery, objTypeToLoad, vParams, conn);
		} finally{
			objTypeToLoad.releaseConnection(conn);	
		}
		return v;
	}	
	
	public static void setAllWithSqlQueryPreparedStatement(
			PreparedStatement ps,
			Vector<Object> vParams) 
	throws SQLException 
	{
		setAllWithSqlQueryPreparedStatement(ps, 0, vParams);
	}
	
	public static void setAllWithSqlQueryPreparedStatement(
			PreparedStatement ps,
			int iOffset,
			Vector<Object> vParams) 
	throws SQLException 
	{

		if(vParams == null ) return;

		for (int i = 0; i < vParams.size(); i++) {
			Object param = vParams.get(i);
			int j= iOffset + i+1;
			if (param instanceof String) {
				String paramValue = (String) param;
				ps.setString(j,paramValue);
			} else if (param instanceof Integer) {
				Integer paramValue = (Integer) param;
				ps.setInt(j, paramValue);		
			} else if (param instanceof Long) {
				Long paramValue = (Long) param;
				ps.setLong(j, paramValue);		
			} else if (param instanceof Timestamp) {
				Timestamp paramValue = (Timestamp) param;
				ps.setTimestamp(j, paramValue);		
			} else if (param instanceof byte[]) {
				byte[] paramValue = (byte[]) param;
				ps.setBytes(j, paramValue);		
			} else if (param instanceof Byte) {
				byte paramValue = (Byte) param;
				ps.setByte(j, paramValue);		
			} else if (param instanceof Boolean) {
				Boolean paramValue = (Boolean) param;
				ps.setBoolean(j, paramValue);		
			} else if (param instanceof Double) {
				Double paramValue = (Double) param;
				ps.setDouble(j, paramValue);		
			} else if (param instanceof Float) {
				Float paramValue = (Float) param;
				ps.setFloat(j, paramValue);		
			} else if (param instanceof Array) {
				Array paramValue = (Array) param;
				ps.setArray(j, paramValue);		
			}

		}

	}

	public static <T> Vector<T> getAllWithSqlQuery(
			String sSQLQuery, 
			CoinDatabaseAbstractBean objTypeToLoad, 
			Connection conn) 
			throws InstantiationException, IllegalAccessException, SQLException 
	{
		return getAllWithSqlQuery(sSQLQuery, objTypeToLoad, null, conn);

	}
	/**
	 * 
	 * @param <T>
	 * @param sSQLQuery
	 * @param objTypeToLoad
	 * @param conn
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	public static <T> Vector<T> getAllWithSqlQuery(
			String sSQLQuery, 
			CoinDatabaseAbstractBean objTypeToLoad, 
			Vector<Object> vParams,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, SQLException { 
		Vector<T> vResult = new Vector<T>();
		Statement stat = null;
		ResultSet rs = null;
		PreparedStatement ps = null;
		traceQueryStatic(sSQLQuery, objTypeToLoad);

		try {
			ps = conn.prepareStatement(sSQLQuery);
			setAllWithSqlQueryPreparedStatement (ps, vParams);
			rs = ps.executeQuery();

			while (rs.next()) 
			{				
				CoinDatabaseAbstractBean item = objTypeToLoad.getClass().newInstance();
				item.bUseHttpPrevent = objTypeToLoad.bUseHttpPrevent;
				item.setFromResultSet(rs);
				if ((item.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER )
						|| (item.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG))
				{
					item.lId = rs.getLong(item.SELECT_FIELDS_NAME_SIZE + 1);
				}

				if (item.PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_STRING)
				{
					item.sId = rs.getString(item.SELECT_FIELDS_NAME_SIZE + 1);
				}
				/**
				 * copy parameters 
				 */
				item.bUseLocalization  =objTypeToLoad.bUseLocalization ;
				if (objTypeToLoad.bPropagateEmbeddedConnection)
				{
					item.bUseEmbeddedConnection =objTypeToLoad.bUseEmbeddedConnection ;
					item.connEmbeddedConnection =objTypeToLoad.connEmbeddedConnection ;
				}
				item.iAbstractBeanIdLanguage = objTypeToLoad.iAbstractBeanIdLanguage ;
				item.iAbstractBeanIdObjectType = objTypeToLoad.iAbstractBeanIdObjectType ;
				
				vResult.add((T) item);
				
				item.onAfterLoad(conn);
			}
		}
		finally 
		{
			ConnectionManager.closeConnection(rs,stat);
		}
		
		return vResult;
	}

	/**
	 * 
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseLoadException 
	 */
	public long getCount() 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		return getCount("");
	}

	/**
	 * 
	 * @param sFieldClause
	 * @param sWhereClause
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseLoadException 
	 */
	public long getCount(String sFieldClause, String sWhereClause) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		Connection conn = this.getConnection();
		long lCount = 0;
		try {
			lCount = getCount(conn, sFieldClause, sWhereClause);
		} finally {
			this.releaseConnection(conn);	
		}
		return lCount;
	}
	
	
	public long getCount(String sFieldClause, String sWhereClause,Vector<Object> vParams ) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		Connection conn = this.getConnection();
		long lCount = 0;
		try {
			lCount = getCount(conn, sFieldClause, sWhereClause, vParams);
		} finally {
			this.releaseConnection(conn);	
		}
		return lCount;
	}


	/**
	 * 
	 * @param sWhereClause
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseLoadException 
	 */
	public long getCount(String sWhereClause) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		Connection conn = this.getConnection();
		long lCount = 0;
		try {
			lCount = getCount(conn, sWhereClause);
		} finally{
			this.releaseConnection(conn);	
		}
		return lCount;
	}
	
	/**
	 * 
	 * @param sWhereClause
	 * @param vParams
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseLoadException
	 */
	public long getCount(String sWhereClause,Vector<Object> vParams) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		Connection conn = this.getConnection();
		long lCount = 0;
		try {
			lCount = getCount(conn, sWhereClause,vParams);
		} finally{
			this.releaseConnection(conn);	
		}
		return lCount;
	}

	/**
	 * 
	 * @param sField
	 * @param sWhereClause
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public float getSum(String sField,String sWhereClause) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		Connection conn = this.getConnection();
		float fSum = 0;
		try {
			fSum = getSum(conn,sField, sWhereClause);
		} finally{
			this.releaseConnection(conn);	
		}
		return fSum;
	}

	/**
	 * 
	 * @param conn
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 * @throws NamingException 
	 * @throws CoinDatabaseLoadException 
	 */
	public long getCount(Connection conn) 
	throws InstantiationException, IllegalAccessException, SQLException, CoinDatabaseLoadException, NamingException {
		return getCount(conn,"");
	}

	/**
	 * 
	 * @param conn
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public float getSum(Connection conn) throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getSum(conn,this.FIELD_ID_NAME,"");
	}

	/**
	 * 
	 * @param conn
	 * @param sFieldClause
	 * @param sWhereClause
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 * @throws CoinDatabaseLoadException 
	 */
	public long getCount(Connection conn,String sFieldClause, String sWhereClause)
	throws InstantiationException, IllegalAccessException, NamingException,
	SQLException, CoinDatabaseLoadException 
	{
		String sSQLQuery = "SELECT COUNT("+sFieldClause+") FROM "+this.TABLE_NAME
		+ sWhereClause;

		return ConnectionManager.getLongValueFromSqlQuery(sSQLQuery, conn);	
	}
	
	public long getCount(Connection conn,String sFieldClause, String sWhereClause, Vector<Object> vParams)
	throws InstantiationException, IllegalAccessException, NamingException,
	SQLException, CoinDatabaseLoadException 
	{
		String sSQLQuery = "SELECT COUNT("+sFieldClause+") FROM "+this.TABLE_NAME
		+ sWhereClause;

		return ConnectionManager.getLongValueFromSqlQuery(sSQLQuery,vParams, conn);	
	}

	/**
	 * 
	 * @param sFieldClause
	 * @param sWhereClause
	 * @param sGroupByClause
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public long[][] getCount(String sFieldClause, String sWhereClause, String sGroupByClause) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		Connection conn = ConnectionManager.getDataSource().getConnection();
		long[][] tResult = null;
		try {
			tResult = getCount(conn, sFieldClause, sWhereClause,sGroupByClause);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		return tResult;
	}

	/**
	 * 
	 * @param conn
	 * @param sFieldClause
	 * @param sWhereClause
	 * @param sGroupByClause
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public long[][] getCount(Connection conn,String sFieldClause, String sWhereClause, String sGroupByClause) throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		long[][] tResult = null;
		Vector<Long> vId = new Vector<Long>();
		Vector<Long> vCount = new Vector<Long>();

		Statement stat = null;
		ResultSet rs = null;
		String sSQLQuery = "SELECT "+sGroupByClause+", COUNT("+sFieldClause+") FROM "+this.TABLE_NAME
		+ sWhereClause
		+ " GROUP BY "+sGroupByClause;
		traceQuery(sSQLQuery);

		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);

			// Recup resultat
			while (rs.next()){
				vId.add(new Long(rs.getLong(1)));
				vCount.add(new Long(rs.getLong(2)));
			}
			// insertion dans tableau
			tResult = new long[vId.size()][2];
			for(int i=0; i<vId.size(); i++){
				tResult[i][0] = vId.get(i);
				tResult[i][1] = vCount.get(i);
			}
		}finally	{
			ConnectionManager.closeConnection(rs,stat);
		}

		return tResult;
	}

	/**
	 * 
	 * @param conn
	 * @param sWhereClause
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 * @throws NamingException 
	 * @throws CoinDatabaseLoadException 
	 */
	public long getCount(Connection conn, String sWhereClause) 
	throws InstantiationException, IllegalAccessException, SQLException, 
	CoinDatabaseLoadException, NamingException 
	{
		String sSQLQuery = "SELECT COUNT(*) FROM "+this.TABLE_NAME
		+ " "+sWhereClause;

		return ConnectionManager.getLongValueFromSqlQuery(sSQLQuery, conn);	
	}
	
	/**
	 * 
	 * @param conn
	 * @param sWhereClause
	 * @param vParams
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws SQLException
	 * @throws CoinDatabaseLoadException
	 * @throws NamingException
	 */
	public long getCount(Connection conn, String sWhereClause,Vector<Object> vParams ) 
	throws InstantiationException, IllegalAccessException, SQLException, 
	CoinDatabaseLoadException, NamingException 
	{
		String sSQLQuery = "SELECT COUNT(*) FROM "+this.TABLE_NAME
		+ " "+sWhereClause;

		return ConnectionManager.getLongValueFromSqlQuery(sSQLQuery,vParams, conn);	
	}

	/**
	 * 
	 * @param conn
	 * @param sField
	 * @param sWhereClause
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public float getSum(Connection conn, String sField, String sWhereClause) 
	throws InstantiationException, IllegalAccessException, SQLException {
		float fSum = 0;
		Statement stat = null;
		ResultSet rs = null;
		String sSQLQuery = "SELECT SUM("+sField+") FROM "+this.TABLE_NAME
		+ sWhereClause;

		traceQuery(sSQLQuery);

		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);

			while (rs.next())
			{
				fSum = rs.getFloat(1);
			}
		}
		finally
		{
			ConnectionManager.closeConnection(rs,stat);
		}
		return fSum;
	}


	/**
	 * Recupere la connexion embarquee, sinon va chercher la connexion dans le contexte Tomcat
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 */
	public Connection getConnection()
	throws NamingException, SQLException
	{		
		boolean bIsEmbeddedConnectionValid = true;
		if(this.bUseEmbeddedConnection 
				&& (this.connEmbeddedConnection==null
				|| this.connEmbeddedConnection.isClosed())){
			bIsEmbeddedConnectionValid = false;
			System.out.println("WARNING : "+this.TABLE_NAME+" (id "+this.getPrimaryKeyValue()+") Embedded Connection is not valid");
		}
			
		if(this.bUseEmbeddedConnection 
				&& bIsEmbeddedConnectionValid)
			return this.connEmbeddedConnection;

		return ConnectionManager.getDataSource().getConnection();
	}


	/**
	 * referme la connexion si elle n'embarquee, sinon va chercher la connexion dans le contexte Tomcat
	 * @return
	 * @throws SQLException 
	 * @throws NamingException
	 * @throws SQLException
	 */
	public void closeEmbeddedConnection(Connection conn) 
	throws SQLException 
	{
		ConnectionManager.closeConnection(this.connEmbeddedConnection);	
	}

	/**
	 * 
	 * @param connEmbeddedConnection
	 */
	public void setEmbeddedConnection(Connection connEmbeddedConnection) {
		this.connEmbeddedConnection = connEmbeddedConnection;
	}

	/**
	 * 
	 * @return
	 */
	public Connection getConnEmbeddedConnection() {
		return this.connEmbeddedConnection;
	}

	/**
	 * 
	 * @param useEmbeddedConnection
	 */
	public void setUseEmbeddedConnection(boolean useEmbeddedConnection) {
		this.bUseEmbeddedConnection = useEmbeddedConnection;
	}

	/**
	 * 
	 * @return
	 */
	public boolean isUseEmbeddedConnection() {
		return this.bUseEmbeddedConnection;
	}

	/**
	 * Referme la connexion si elle n'est pas embarquee
	 * @return
	 * @throws SQLException 
	 * @throws NamingException
	 * @throws SQLException
	 */
	public void releaseConnection(Connection conn) 
	throws SQLException 
	{
		if(!this.bUseEmbeddedConnection)
			ConnectionManager.closeConnection(conn);	
	}

	/**
	 * 
	 * @param <T>
	 * @param sSQLQuery
	 * @param objTypeToLoad
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static <T> Vector<T> getAll(String sSQLQuery,CoinDatabaseAbstractBean objTypeToLoad) throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		Connection conn = objTypeToLoad.getConnection();
		Vector v = null;
		try {
			v = getAll(sSQLQuery,objTypeToLoad, conn);
		} finally{
			objTypeToLoad.releaseConnection(conn);	
		}
		return v;
	}

	/**
	 * 
	 * @param <T>
	 * @param sSQLQuery
	 * @param objTypeToLoad
	 * @param conn
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public static <T> Vector<T> getAll(
			String sSQLQuery, 
			CoinDatabaseAbstractBean objTypeToLoad, 
			Connection conn) 
	throws InstantiationException, IllegalAccessException, SQLException {
		return getAllWithSqlQuery(sSQLQuery, objTypeToLoad, conn);
	}

	/**
	 * 
	 */
	public <T> Vector<T> getAllWithSqlQuery(
			String sSqlquery, 
			Connection conn) 
	throws SQLException, InstantiationException, IllegalAccessException {
		return getAllWithSqlQuery(sSqlquery, this, conn);
	}

	/**
	 * 
	 */
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithSqlQuery(sSqlquery,this);
	}


	/**
	 * 
	 */
	public <T> Vector<T> getAllWithSqlQuery(
			String sSqlquery,
			Vector<Object> vParams) 
			throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithSqlQuery(sSqlquery,vParams,this);
	}

	public <T> Vector<T> getAllWithSqlQuery(
			String sSqlquery,
			Vector<Object> vParams,
			Connection conn) 
			throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithSqlQuery(sSqlquery,vParams,this,conn);
	}
	
	
	/**
	 * 
	 * @param <T>
	 * @param sWhereClause
	 * @param sOrderByClause
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public <T> Vector<T> getAllWithWhereAndOrderByClause(
			String sWhereClause, 
			String sOrderByClause) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		String sSqlQuery
		= this.getAllSelect() 
		+ " "+sWhereClause
		+ " "+sOrderByClause;
		return getAllWithSqlQuery(sSqlQuery);
	}
	
	public <T> Vector<T> getAllWithWhereAndOrderByClause(
			String sAlias,
			String sWhereClause, 
			String sOrderByClause,
			Vector<Object> vParams) 
			throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		String sSqlQuery
		= this.getAllSelect(sAlias) 
		+ " "+sWhereClause
		+ " "+sOrderByClause;
		return getAllWithSqlQuery(
				sSqlQuery,
				vParams);
	}
		
	public <T> Vector<T> getAllWithWhereAndOrderByClause(
			String sAlias,
			String sWhereClause, 
			String sOrderByClause,
			Vector<Object> vParams,
			Connection conn) 
			throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		String sSqlQuery
		= this.getAllSelect(sAlias) 
		+ " "+sWhereClause
		+ " "+sOrderByClause;
		return getAllWithSqlQuery(
				sSqlQuery,
				vParams,
				conn);
	}
	

	public <T> Vector<T> getAllWithWhereAndOrderByClause(
			String sWhereClause, 
			String sOrderByClause,
			Vector<Object> vParams) 
			throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereAndOrderByClause("", sWhereClause, sOrderByClause, vParams);
	}
	
	public <T> Vector<T> getAllWithWhereAndOrderByClause(
			String sWhereClause, 
			String sOrderByClause,
			Vector<Object> vParams,
			Connection conn) 
			throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereAndOrderByClause("", sWhereClause, sOrderByClause, vParams, conn);
	}

	/**
	 * 
	 * @param sSqlQuery
	 * @return
	 * @throws CoinDatabaseLoadException
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseDuplicateException 
	 */
	public CoinDatabaseAbstractBean getAbstractBean(
			String sSqlQuery) 
	throws CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException 
	{
		return getAbstractBean(sSqlQuery, true);
	}

	/**
	 * 
	 * @param sSqlQuery
	 * @param bOnlyOneOccurenceExpected
	 * @return
	 * @throws CoinDatabaseLoadException
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseDuplicateException 
	 */
	public CoinDatabaseAbstractBean getAbstractBean(
			String sSqlQuery,
			boolean bOnlyOneOccurenceExpected) 
	throws CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException 
	{
		return getAbstractBean(sSqlQuery, this, bOnlyOneOccurenceExpected);
	}

	public CoinDatabaseAbstractBean getAbstractBean(
			String sSqlQuery,
			Vector<Object> vParams,
			boolean bOnlyOneOccurenceExpected) 
	throws CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException, CoinDatabaseDuplicateException 
	{
		return getAbstractBean(sSqlQuery, vParams, this, bOnlyOneOccurenceExpected);
	}

	public static CoinDatabaseAbstractBean getAbstractBean(
			String sSqlQuery,
			CoinDatabaseAbstractBean objTypeToLoad,
			boolean bOnlyOneOccurenceExpected) 
	throws NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{
		return getAbstractBean(sSqlQuery, null, objTypeToLoad, bOnlyOneOccurenceExpected);		
	}

	/**
	 * 
	 * @param sSqlQuery
	 * @param objTypeToLoad
	 * @param bOnlyOneOccurenceExpected
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseLoadException
	 * @throws CoinDatabaseDuplicateException 
	 */
	@SuppressWarnings("rawtypes")
	public static CoinDatabaseAbstractBean getAbstractBean(
			String sSqlQuery,
			Vector<Object> vParams,
			CoinDatabaseAbstractBean objTypeToLoad,
			boolean bOnlyOneOccurenceExpected) 
	throws NamingException, SQLException, InstantiationException, 
	IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{
		Vector v = getAllWithSqlQuery(sSqlQuery, vParams, objTypeToLoad);

		if(bOnlyOneOccurenceExpected)
		{
			if(v.size() == 0)
			{
				throw new CoinDatabaseLoadException(
						"No element for :\n<QUERY>\n" +sSqlQuery + "\n</QUERY>", sSqlQuery);
			}

			if(v.size() != 1)
			{
				throw new CoinDatabaseDuplicateException(
						"Only 1 element expected for (" + v.size() 
						+ " elements found) :\n<QUERY>\n" + sSqlQuery + "\n</QUERY>", 
						sSqlQuery);
			}
		}

		if(v.size() == 0)
		{
			throw new CoinDatabaseLoadException(
					"No element for :\n<QUERY>\n" +sSqlQuery + "\n</QUERY>", sSqlQuery);
		}


		return (CoinDatabaseAbstractBean) v.firstElement();

	}

	/**
	 * 
	 * @param sWhereClause
	 * @param sOrderByClause
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseLoadException
	 * @throws CoinDatabaseDuplicateException 
	 */
	public CoinDatabaseAbstractBean getAbstractBeanWithWhereAndOrderByClause(
			String sWhereClause, 
			String sOrderByClause) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{
		return getAbstractBeanWithWhereAndOrderByClause(
				sWhereClause, 
				sOrderByClause,
				true); 
	}

	/**
	 * 
	 * @param sWhereClause
	 * @param sOrderByClause
	 * @param bOnlyOneOccurenceExpected
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws CoinDatabaseLoadException
	 * @throws CoinDatabaseDuplicateException 
	 */
	public CoinDatabaseAbstractBean getAbstractBeanWithWhereAndOrderByClause(
			String sWhereClause, 
			String sOrderByClause,
			boolean bOnlyOneOccurenceExpected) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{
		String sSqlQuery
		= this.getAllSelect() 
		+ " "+sWhereClause
		+ " "+sOrderByClause;

		return getAbstractBean(sSqlQuery, bOnlyOneOccurenceExpected);
	}
	
	public CoinDatabaseAbstractBean getAbstractBeanWithWhereAndOrderByClause(
			String sAlias,
			String sWhereClause, 
			String sOrderByClause,
			Vector<Object> vParams,
			boolean bOnlyOneOccurenceExpected) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{
		String sSqlQuery
		= this.getAllSelect(sAlias) 
		+ " "+sWhereClause
		+ " "+sOrderByClause;

		return getAbstractBean(sSqlQuery, vParams, bOnlyOneOccurenceExpected);
	}

	public CoinDatabaseAbstractBean getAbstractBeanWithWhereAndOrderByClause(
			String sWhereClause, 
			String sOrderByClause,
			Vector<Object> vParams,
			boolean bOnlyOneOccurenceExpected) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException 
	{
		return getAbstractBeanWithWhereAndOrderByClause("", sWhereClause, sOrderByClause, vParams, bOnlyOneOccurenceExpected);
	}

	/**
	 * 
	 * @param <T>
	 * @param sWhereClause
	 * @param sOrderByClause
	 * @param conn
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public <T> Vector<T> getAllWithWhereAndOrderByClause(
			String sWhereClause, 
			String sOrderByClause,
			Connection conn) 
	throws SQLException, InstantiationException, IllegalAccessException 
	{
		String sSqlQuery
		= "SELECT " + this.SELECT_FIELDS_NAME + ", " + this.FIELD_ID_NAME
		+ " FROM " + this.TABLE_NAME
		+ " "+sWhereClause
		+ " "+sOrderByClause;
		return getAllWithSqlQuery(sSqlQuery,conn);
	}
	
	public <T> Vector<T> getAllWithWhereAndOrderByClause(
			String sAlias,
			String sWhereClause, 
			String sOrderByClause,
			Connection conn) 
			throws SQLException, InstantiationException, IllegalAccessException {
		String sSqlQuery = getAllSelect(sAlias)
		+ " "+sWhereClause
		+ " "+sOrderByClause;
		return getAllWithSqlQuery(sSqlQuery,conn);
	}


	/*  public static <T extends CoinDatabaseAbstractBean > Object getBean(long lId) throws Exception {
	 T item = new <T extends CoinDatabaseAbstractBean >();
	 item.iId = lId;
	 item .load();
	 return item ;
	 }
	 */

	/**
	 * 
	 */
	public abstract String getName();
	public void setName(String sName){};
	/**
	 * 
	 * @return NULL if not found
	 */
	public String getLocalizedName()
	{
		return getLocalizedName(false);
	}
	
	public String getLocalizedNameWithMatrix(Object sarrLocalization)
	{
		return getLocalizedName(!(sarrLocalization==null));
	}
	
	public String getLocalizedName(boolean bMatrixPopulated)
	{
		Connection conn = null;
		String sLocalizedName = null;
		try {			
			if(!bMatrixPopulated) conn = getConnection();			
			sLocalizedName = getLocalizedName(conn);
			
		} catch (Exception e) {
			//System.out.println("Missing traduction for table "+this.TABLE_NAME+" (id:"+this.lId+")");			
			//e.printStackTrace();
		} finally {
			try {
				releaseConnection(conn);
				
			} catch (SQLException e) {
		
			}
		}
		/**
		 * return the name if the localisation was not found
		 */
		return sLocalizedName;
	}
	

	/**
	 * To override !
	 * @param conn
	 * @return
	 */
	public String getLocalizedName(Connection conn) {
		return getName();
	}

	/**
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * 
	 */
	public String getLocalizedName(String[][] sarrTranslation)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		return sarrTranslation[this.iAbstractBeanIdLanguage][(int)this.lId];
	}
	
	public String[][] getLocalizationMatrixOptional(
			String[][] sarrLocalization,
			Connection conn) 
	{
		try {
			return getLocalizationMatrix(sarrLocalization, false, conn);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public String[][] getLocalizationMatrix(
			String[][] sarrLocalization) 
	{
		Connection conn = null;
		String[][] ret = null;
		try {
			if(sarrLocalization==null) conn = getConnection();
			ret =  getLocalizationMatrix(sarrLocalization, false, conn);
		} catch (Exception e) {
		} finally {
			try {
				releaseConnection(conn);
			} catch (SQLException e) {
			}
		}
		/**
		 * return the name if the localisation was not found
		 */
		return ret;
	}
	
	
	
	
	public String[][] getLocalizationMatrix(
			String[][] sarrLocalization,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		return getLocalizationMatrix(sarrLocalization, false, conn);
	}
	
	public String[][] getLocalizationMatrix(
			String[][] sarrLocalization,
			boolean bForceReload,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		if(!bForceReload && sarrLocalization != null) return sarrLocalization;
		return ObjectLocalization.generateLocalizationMatrix(this, conn);
	}

	public Map<String,String>[] getLocalizationMatrix(
			Map<String, String>[] sarrLocalization,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		return getLocalizationMatrix(sarrLocalization, false, conn);
	}
	
	public Map<String, String>[] getLocalizationMatrixOptional(
			Map<String, String>[] sarrLocalization,
			Connection conn) 
	{
		try {
			return getLocalizationMatrix(sarrLocalization, false, conn);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public Map<String,String>[] getLocalizationMatrix(
			Map<String, String>[] sarrLocalization,
			boolean bForceReload,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		if(!bForceReload && sarrLocalization != null) return sarrLocalization;
		return ObjectLocalization.generateLocalizationMatrixString(this, conn);
	}

	
	
	
	/**
	 * 
	 */
	public <T>Vector<T> getAll()
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return  CoinDatabaseAbstractBean.getAll(this);
	}

	/**
	 * 
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect()
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(this.sHtmlFormFieldName );
	}
	
	/**
	 * 
	 * @param sFormSelectName
	 * @param sStyle
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect(String sFormSelectName,String sStyle)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(sFormSelectName, 1, sStyle);
	}

	/**
	 * 
	 * @param sFormSelectName
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect(String sFormSelectName)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(sFormSelectName, 1, "");
	}


	/**
	 * 
	 * @param sFormSelectName
	 * @param bUndefined
	 * @param bForceUndefinedValue
	 * @param sWhereClause
	 * @param sOrderByClause
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect(String sFormSelectName,
			boolean bUndefined,
			boolean bForceUndefinedValue,
			String sWhereClause,
			String sOrderByClause)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(
				sFormSelectName, 
				1, 
				"",
				bUndefined,  
				bForceUndefinedValue, 
				sWhereClause, 
				sOrderByClause);
	}

	/**
	 * 
	 * @param sFormSelectName
	 * @param bUndefined
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect(
			String sFormSelectName,
			boolean bUndefined)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(sFormSelectName, 1, "",bUndefined, false, "", "");
	}

	/**
	 * 
	 * @param sFormSelectName
	 * @param bUndefined
	 * @param bForceUndefinedValue
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect(
			String sFormSelectName,
			boolean bUndefined,
			boolean bForceUndefinedValue)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(sFormSelectName, 1, "",bUndefined, bForceUndefinedValue, "", "");
	}

	
	public String getAllInHtmlSelect(
			String sFormSelectName,
			int iSize, String sStyle,
			boolean bUndefined,
			boolean bForceUndefinedValue,
			String sWhereClause,
			String sOrderByClause)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(
				sFormSelectName, 
				iSize, 
				sStyle, 
				bUndefined, 
				bForceUndefinedValue, 
				sWhereClause, 
				sOrderByClause, 
				CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING);
	}
	
	/**
	 * 
	 * @param sFormSelectName
	 * @param iSize
	 * @param sStyle
	 * @param bUndefined
	 * @param bForceUndefinedValue
	 * @param sWhereClause
	 * @param sOrderByClause
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect(
			String sFormSelectName,
			int iSize, String sStyle,
			boolean bUndefined,
			boolean bForceUndefinedValue,
			String sWhereClause,
			String sOrderByClause,
			int iLocalizationOrderBy)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		Vector<CoinDatabaseAbstractBean> vBeans = getAllWithWhereAndOrderByClause( sWhereClause, sOrderByClause);
		
		if(this.bUseLocalization == true)
		{
			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator(iLocalizationOrderBy));
		}
		
		if(PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_INTEGER
				|| PRIMARY_KEY_TYPE == PRIMARY_KEY_TYPE_LONG )
			return CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect(
					sFormSelectName, 
					iSize, 
					vBeans, 
					this.lId, 
					sStyle,
					bUndefined, 
					bForceUndefinedValue);

		return CoinDatabaseAbstractBeanHtmlUtil.
		getHtmlSelect(
				sFormSelectName, 
				iSize, 
				vBeans, 
				this.sId, 
				sStyle,
				bUndefined,
				bForceUndefinedValue);
	}

	/**
	 * 
	 * @param sFormSelectName
	 * @param iSize
	 * @param sStyle
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlSelect(String sFormSelectName, int iSize, String sStyle)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllInHtmlSelect(sFormSelectName, iSize, sStyle,false,false,"","");
	}

	/**
	 * 
	 * @param sFormSelectName
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlInputRadio(String sFormSelectName)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		Vector<CoinDatabaseAbstractBean> vBeans = getAll();
		if(this.bUseLocalization == true)
		{
			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator());
		}
		
		return CoinDatabaseAbstractBeanHtmlUtil.getHtmlInputRadio(sFormSelectName, vBeans, this.lId);

	}

	/**
	 * 
	 * @param sFormSelectName
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public String getAllInHtmlInputCheckbox(String sFormSelectName)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		Vector<CoinDatabaseAbstractBean> vBeans = getAll();
		if(this.bUseLocalization == true)
		{
			Collections.sort( vBeans , new CoinDatabaseAbstractBeanComparator());
		}
		
		return CoinDatabaseAbstractBeanHtmlUtil.getHtmlInputCheckbox(sFormSelectName, vBeans, this.lId);

	}


	/**
	 * Return CoinDatabaseAbstractBean from Id without connection to database
	 */
	@SuppressWarnings({ "rawtypes" })
	public static CoinDatabaseAbstractBean getCoinDatabaseAbstractBeanFromId(
			long lId,
			Vector vBeans)
	throws CoinDatabaseLoadException
	{
		StringBuffer sbDebug = new StringBuffer("");

		for (int i = 0; i < vBeans.size(); i++) {
			CoinDatabaseAbstractBean item= (CoinDatabaseAbstractBean)vBeans.get(i);
			if(item.lId == lId) return item;
			sbDebug.append(" " + item.lId );
		}

		String sError = "error : " + lId + " not in " + sbDebug.toString();
		throw new CoinDatabaseLoadException(sError, "static");
	}

	/**
	 * Return CoinDatabaseAbstractBean from Id without connection to database
	 */
	@SuppressWarnings("rawtypes")
	public static CoinDatabaseAbstractBean getCoinDatabaseAbstractBeanFromIdString(
			String sId,
			Vector vBeans)
	throws CoinDatabaseLoadException
	{
		StringBuffer sbDebug = new StringBuffer("");

		for (int i = 0; i < vBeans.size(); i++) {
			CoinDatabaseAbstractBean item= (CoinDatabaseAbstractBean)vBeans.get(i);
			if(item.sId.equals(sId) ) return item;
			sbDebug.append(" " + item.sId );
		}

		String sError = "error : " + sId + " not in " + sbDebug.toString();
		throw new CoinDatabaseLoadException(sError, "static");
	}

	@SuppressWarnings("rawtypes") 
	public static CoinDatabaseAbstractBean getCoinDatabaseAbstractBeanFromName(
			String sName,
			Vector vBeans)
	throws CoinDatabaseLoadException
	{
		StringBuffer sbDebug = new StringBuffer("");

		for (int i = 0; i < vBeans.size(); i++) {
			CoinDatabaseAbstractBean item= (CoinDatabaseAbstractBean)vBeans.get(i);
			if(item.getName().equals(sName) ) return item;
			sbDebug.append(" \"" + item.getName() + "\"");
		}

		String sError = "error : \"" + sName + "\" not in " + sbDebug.toString();
		throw new CoinDatabaseLoadException(sError, "static");
	}


	/**
	 * 
	 * @param request
	 * @param sFieldName
	 * @param lDefaultValue
	 * @return
	 */
	public static long getLongFromHtmlForm(HttpServletRequest request, String sFieldName, long lDefaultValue)
	{
		if(request.getParameter(sFieldName) != null )
		{
			return Long.parseLong(request.getParameter(sFieldName));
		}
		return lDefaultValue;
	}

	/**
	 * @throws JSONException
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws CoinDatabaseLoadException 
	 */
	public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
		JSONObject item = new JSONObject();
		return item;
	}

	@Override
    public String toString() {
    	StringBuilder sb = new StringBuilder("id=");
    	sb.append(this.getId());
		return sb.toString();
    }
	
	@Override
	public boolean equals(Object obj) {
		boolean result = false;
		if( obj instanceof CoinDatabaseAbstractBean ){
			CoinDatabaseAbstractBean otherBean = (CoinDatabaseAbstractBean) obj;
			if( this.getAbstractBeanIdObjectType() == otherBean.getAbstractBeanIdObjectType() ){
				try{
					result = (this.getIdToString().equals(otherBean.getIdToString()));
				}catch(NullPointerException npe){}
			}
		}
		return result;
	}
}